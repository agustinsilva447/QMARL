--------------------------------------------------------------------------------
-- fsm_cmd
--
-- This FSM reads the command placed in BASE_ADDR. When '1' is asserted on start
-- it loads the command in an internal register of the unit. The load is 
-- performed reading BASE_ADDR and the 3 next positions.
-- The command must have the following form: (BUS_ADDR_WIDTH=32 widths are used 
-- as an example)
--
--                   HIGH          | LOW
-- BASE_ADDR    :          SRC_ADDRESS(32)
-- BASE_ADDR +1 :          DST_ADDRESS(32)
-- BASE_ADDR +2 :    SRC_INCR(16) | DST_INCR(16)
-- BASE_ADDR +3 :          MOVE_SIZE(32)

-- Authors: E. Marchi - M. Cervetto
-- Revision: 0.1 -- initial
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.memmv_params.all;

entity fsm_cmd is
  generic (
    DATA_WIDTH : natural                           := CMD_DATA_WIDTH;
    ADDR_WIDTH : natural                           := CMD_ADDR_WIDTH;
    BASE_ADDR  : std_logic_vector(CMD_ADDR_WIDTH - 1 downto 0) := (others => '0')
    );
  port (
    clk : in std_logic;
    rst : in std_logic;

    -- commblock side
    start   : in  std_logic;
    din     : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    address : out std_logic_vector(ADDR_WIDTH - 1 downto 0);
    rd_en   : out std_logic;

    -- move side
    start_move  : out std_logic;
    
    -- instruction
    source_addr : out std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
    dest_addr   : out std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
    source_incr : out std_logic_vector(BUS_ADDR_WIDTH/2 - 1 downto 0);
    dest_incr   : out std_logic_vector(BUS_ADDR_WIDTH/2 - 1 downto 0);
    move_size   : out std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0)
    );
end entity;

architecture fsm of fsm_cmd is

  type state is (IDLE, FETCH_SRC, FETCH_DST, FETCH_INCR, FETCH_SIZE, FETCH_DONE);
  signal state_next, state_reg : state;

  signal wr_register : std_logic_vector(3 downto 0);

  signal dma_instr : dma_instr_type;
  
begin

-- FSM register
  process(clk)
  begin

    if clk = '1' and clk'event then
      if rst = '1' then
        state_reg <= IDLE;
      else
        state_reg <= state_next;
      end if;
    end if;
  end process;

-- transition logic

  process(state_reg, start)

  begin

    state_next <= state_reg;

    case state_reg is

      when IDLE =>
        if (start = '1') then
          state_next <= FETCH_SRC;
        end if;

      when FETCH_SRC =>
        state_next <= FETCH_DST;

      when FETCH_DST =>
        state_next <= FETCH_INCR;

      when FETCH_INCR =>
        state_next <= FETCH_SIZE;

      when FETCH_SIZE =>
        state_next <= FETCH_DONE;

      when FETCH_DONE =>
        state_next <= IDLE;

    end case;
  end process;


-- Mealy output logic
  process(state_reg, start)

  begin
    start_move  <= '0';
    wr_register <= "0000";
    address     <= (others => '0');
    rd_en       <= '0';

    case state_reg is

      when IDLE =>
        if (start = '1') then
          address <= BASE_ADDR;
          rd_en   <= '1';
        end if;

      when FETCH_SRC =>
        address        <= std_logic_vector(unsigned(BASE_ADDR) + to_unsigned(1, ADDR_WIDTH));
        rd_en          <= '1';
        wr_register(0) <= '1';

      when FETCH_DST =>
        address        <= std_logic_vector(unsigned(BASE_ADDR) + to_unsigned(2, ADDR_WIDTH));
        rd_en          <= '1';
        wr_register(1) <= '1';

      when FETCH_INCR =>
        address        <= std_logic_vector(unsigned(BASE_ADDR) + to_unsigned(3, ADDR_WIDTH));
        rd_en          <= '1';
        wr_register(2) <= '1';

      when FETCH_SIZE =>
        wr_register(3) <= '1';

      when FETCH_DONE =>
        start_move <= '1';

    end case;
  end process;

-- register command parameters
  process(clk)
  begin

    if clk = '1' and clk'event then
      if rst = '1' then
        dma_instr.source_addr <= (others => '0');
        dma_instr.dest_addr   <= (others => '0');
        dma_instr.source_incr <= (others => '0');
        dma_instr.dest_incr   <= (others => '0');
        dma_instr.move_size   <= (others => '0');
      else
        case wr_register is
          when "0001" =>
            dma_instr.source_addr <= din;

          when "0010" =>
            dma_instr.dest_addr <= din;

          when "0100" =>
            dma_instr.source_incr <= din(DATA_WIDTH - 1 downto DATA_WIDTH/2);
            dma_instr.dest_incr   <= din(DATA_WIDTH/2 -1 downto 0);

          when "1000" =>
            dma_instr.move_size <= din;

          when others =>

        end case;
      end if;
    end if;
  end process;

  source_addr <= dma_instr.source_addr;
  dest_addr   <= dma_instr.dest_addr;
  source_incr <= dma_instr.source_incr;
  dest_incr   <= dma_instr.dest_incr;
  move_size   <= dma_instr.move_size;

end architecture;
