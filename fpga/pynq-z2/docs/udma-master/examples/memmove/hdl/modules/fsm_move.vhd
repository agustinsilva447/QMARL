--------------------------------------------------------------------------------
-- fsm_move
--
-- This FSM makes the memory payload movement. It receives the DMA instruction 
-- and the execution begins when start is asserted. 
-- The operation progress can be monitored with busy and done signals.
-- Contains an internal FIFO for temporary storage. 
--
-- The execution of a DMA instruction is performed in 3 phases:
-- READ data from source memory
-- WAIT for data to arrive and keep READING 
-- When internal FIFO contains the requested data, begin transfer to destination
--
-- 
-- TODO: move size > 1024 words
--
-- Authors: E. Marchi - M. Cervetto
-- Revision: 0.1 -- initial
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.memmv_params.all;

entity fsm_move is
  generic (
    DATA_WIDTH : natural := BUS_DATA_WIDTH;
    ADDR_WIDTH : natural := BUS_ADDR_WIDTH
    );
  port (
    clk : in std_logic;
    rst : in std_logic;

    -- fabric side
    address : out std_logic_vector(ADDR_WIDTH - 1 downto 0);
    -- read signals
    rd_rq   : out std_logic;
    wr_en   : in  std_logic;
    din     : in  std_logic_vector(DATA_WIDTH - 1 downto 0);

    --write signals
    dv      : out std_logic;
    dout    : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    
    -- instruction side
    start       : in  std_logic;
    
    source_addr : in std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
    dest_addr   : in std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
    source_incr : in std_logic_vector(BUS_ADDR_WIDTH/2 - 1 downto 0);
    dest_incr   : in std_logic_vector(BUS_ADDR_WIDTH/2 - 1 downto 0);
    move_size   : in std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
    -- Status flags
    busy        : out std_logic;
    done        : out std_logic
    );
end entity;

architecture fsm of fsm_move is

  component incoming_data_fifo
    port (
      clk        : in  std_logic;
      srst       : in  std_logic;
      din        : in  std_logic_vector(31 downto 0);
      wr_en      : in  std_logic;
      rd_en      : in  std_logic;
      dout       : out std_logic_vector(31 downto 0);
      full       : out std_logic;
      empty      : out std_logic;
      valid      : out std_logic;
      data_count : out std_logic_vector(9 downto 0)
      );
  end component;

  type state is (IDLE, READ_SRC, WAIT_DATA, WRITE_DST);
  signal state_next, state_reg : state;
  type count_mode_type is (ZERO, INCR, HOLD);
  signal count_mode            : count_mode_type;

  signal incr_address     : std_logic;
  signal address_reg      : unsigned(ADDR_WIDTH - 1 downto 0);
  signal address_next     : unsigned(ADDR_WIDTH - 1 downto 0);
  signal address_base     : unsigned(ADDR_WIDTH - 1 downto 0);
  signal count            : unsigned(ADDR_WIDTH - 1 downto 0);
  signal max_addr_reached : std_logic;
  signal step             : std_logic_vector(ADDR_WIDTH/2 - 1 downto 0);
  signal done_int         : std_logic;

  signal rd_fifo        : std_logic;
  signal chunk_received : std_logic;
  signal fifo_count     : std_logic_vector(9 downto 0);

  signal dma_instr : dma_instr_type;

begin

  dma_instr.source_addr <= source_addr;
  dma_instr.dest_addr <= dest_addr;
  dma_instr.source_incr <= source_incr;
  dma_instr.dest_incr <= dest_incr;
  dma_instr.move_size <= move_size;
  
-- FSM register
  process(clk)
  begin
    if clk = '1' and clk'event then
      if rst = '1' then
        state_reg <= IDLE;
        done      <= '0';
      else
        state_reg <= state_next;
        done      <= done_int;
      end if;
    end if;
  end process;

-- transition logic

  process(state_reg, start, max_addr_reached, chunk_received)

  begin

    state_next <= state_reg;

    case state_reg is

      when IDLE =>
        if (start = '1') then
          state_next <= READ_SRC;
        end if;

      when READ_SRC =>
        if (max_addr_reached = '1') then
          state_next <= WAIT_DATA;
        end if;


      when WAIT_DATA =>
        if (chunk_received = '1') then
          state_next <= WRITE_DST;
        end if;

      when WRITE_DST =>
        if (max_addr_reached = '1') then
          state_next <= IDLE;
        end if;

    end case;
  end process;


-- Mealy output logic
  process(state_reg, start, max_addr_reached, dma_instr, chunk_received)

  begin
    incr_address <= '0';
    step         <= (others => '0');
    rd_rq        <= '0';
    busy         <= '1';
    done_int     <= '0';
    address_base <= unsigned(dma_instr.source_addr);
    count_mode   <= HOLD;
    rd_fifo      <= '0';

    case state_reg is

      when IDLE =>
        busy <= '0';
        if (start = '1') then
          busy         <= '1';
          rd_rq        <= '1';
          incr_address <= '1';
          step         <= dma_instr.source_incr;
          count_mode   <= INCR;
        end if;

      when READ_SRC =>
        count_mode   <= INCR;
        rd_rq        <= '1';
        incr_address <= '1';
        step         <= dma_instr.source_incr;

        if (max_addr_reached = '1') then
          count_mode   <= ZERO;
          incr_address <= '0';
        end if;


      when WAIT_DATA =>
        if (chunk_received = '1') then
          address_base <= unsigned(dma_instr.dest_addr);
          step         <= dma_instr.dest_incr;
          rd_fifo      <= '1';
        end if;

      when WRITE_DST =>
        step         <= dma_instr.dest_incr;
        rd_fifo      <= '1';
        incr_address <= '1';
        count_mode   <= INCR;
        if (max_addr_reached = '1') then
          count_mode <= ZERO;
          incr_address <= '0';
          rd_fifo      <= '0';
          done_int     <= '1';
        end if;


    end case;
  end process;

-- address incrementer
  process(clk)
  begin
    if clk = '1' and clk'event then
      if rst = '1' then
        address_reg <= (others => '0');
      elsif(incr_address = '1') then
        address_reg <= address_next;
      else
        address_reg <= address_base;
      end if;
    end if;
  end process;


  address_next <= address_reg + unsigned(step);
  address      <= std_logic_vector(address_reg);

-- counter
  process(clk)
  begin
    if clk = '1' and clk'event then
      if rst = '1' then
        count <= (others => '0');
      else
        case count_mode is
          when ZERO => count <= x"00000000";
          when INCR => count <= count + 1;
          when HOLD => count <= count;
        end case;
      end if;
    end if;
  end process;

  max_addr_reached <= '1' when count = (unsigned(dma_instr.move_size) - 1) else '0';

  incoming_data_fifo_0 : incoming_data_fifo
    port map (
      clk        => clk,
      srst       => rst,
      din        => din,
      wr_en      => wr_en,
      rd_en      => rd_fifo,
      dout       => dout,
      full       => open,
      empty      => open,
      valid      => dv,
      data_count => fifo_count
      );

  chunk_received <= '1' when fifo_count = dma_instr.move_size(9 downto 0) else '0';

end architecture;
