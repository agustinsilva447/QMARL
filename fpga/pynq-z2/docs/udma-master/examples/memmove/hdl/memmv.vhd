--------------------------------------------------------------------------------
--* memmv.vhd
--* @brief A module that executes a UDMA instruction for data moving within 
-- a system.--
--
-- Memory mover. It executes a DMA instruction to move memory from source to
-- destination. 
-- The parameters of the system are controlled by tweaking memmv_params
--
-- When start is asserted, the DMA command is fetched from CMD_BASE_ADDR. View 
-- the fsm_cmd help for further details. Then the move is performed by fsm_move
-- on the fabric side. View the fsm_move help for further details.
-- 
-- The progress of a DMA execution can be monitored with done and busy flags.
--
--* @author E. Marchi, M. Cervetto
--* @version 0.1 -- Initial
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.memmv_params.all;

entity memmv is
      port (
        clk : in std_logic;
        rst : in std_logic;

        -- slave side
        --* Start parsing command when setted
        start     : in  std_logic;
        --* Command data input
        cmd_in    : in  std_logic_vector(CMD_DATA_WIDTH - 1 downto 0);
        --* Address from where the command is read
        cmd_addr  : out std_logic_vector(CMD_ADDR_WIDTH - 1 downto 0);
        --* Outs '1' in order to read command
        cmd_fetch : out std_logic;

        -- master side
        --* Write enable input for peripheral
        wr_en   : in  std_logic;
        --* Data input for peripheral
        din     : in  std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
        --* Data valid for peripheral
        dv      : out std_logic;
        --* Data output for peipheral
        dout    : out std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
        --* Address output for reading/writing data from/to peripheral
        address : out std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
        --* Read request output
        rd_rq   : out std_logic;

        --+ Status flags
        busy        : out std_logic;
        done        : out std_logic

);
end entity;

architecture structural of memmv is

    component fsm_cmd is
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
      end component;

      component fsm_move is
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
      end component;


    signal start_move  : std_logic;

    signal source_addr : std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
    signal dest_addr   : std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);
    signal source_incr : std_logic_vector(BUS_ADDR_WIDTH/2 - 1 downto 0);
    signal dest_incr   : std_logic_vector(BUS_ADDR_WIDTH/2 - 1 downto 0);
    signal move_size   : std_logic_vector(BUS_ADDR_WIDTH - 1 downto 0);

begin

  fsm_cmd_01: fsm_cmd
      port map(
        clk => clk,
        rst => rst,

        -- commblock side
        start   => start,
        din     => cmd_in,
        address => cmd_addr,
        rd_en   => cmd_fetch,

        -- move side
        start_move  => start_move,
        source_addr => source_addr,
        dest_addr   => dest_addr,
        source_incr => source_incr,
        dest_incr   => dest_incr,
        move_size   => move_size
        );

    fsm_move_01: fsm_move
      port map(
        clk => clk,
        rst => rst,

        -- fabric side
        wr_en   => wr_en,
        din     => din,
        dv      => dv,
        dout    => dout,
        address => address,
        rd_rq   => rd_rq,

        -- instruction side
        start       => start_move,
        source_addr => source_addr,
        dest_addr   => dest_addr,
        source_incr => source_incr,
        dest_incr   => dest_incr,
        move_size   => move_size,
        -- Status flags
        busy        => busy,
        done        => done
        );

end architecture;
