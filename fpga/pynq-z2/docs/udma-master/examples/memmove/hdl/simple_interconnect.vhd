------------------------------------------------------------------------------------
-- simple_interconnect
--
--
--
-- Autor: E. Marchi - M. Cervetto
-- Revisión: 0.1 -- inicial
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity simple_interconnect is
  generic(
    -- master
    DATA_WIDTH : natural                           := 32;
    ADDR_WIDTH : natural                           := 32;
    -- slaves
    S1_BASE_ADDR  : std_logic_vector := x"00001000";
    S1_LAST_ADDR  : std_logic_vector  := x"000013FF";
    S1_ADDR_WIDTH : natural := 10;
    S1_DATA_WIDTH : natural := 32;

    S2_BASE_ADDR  : std_logic_vector := x"00002000";
    S2_LAST_ADDR  : std_logic_vector := x"00002000";
    S2_ADDR_WIDTH : natural := 0;
    S2_DATA_WIDTH : natural := 32;

    S3_BASE_ADDR  : std_logic_vector := x"00000000";
    S3_LAST_ADDR  : std_logic_vector := x"00000000";
    S3_ADDR_WIDTH : natural := 0;
    S3_DATA_WIDTH : natural := 32;

    S4_BASE_ADDR  : std_logic_vector := x"10000000";
    S4_LAST_ADDR  : std_logic_vector := x"10000000";
    S4_ADDR_WIDTH : natural := 0;
    S4_DATA_WIDTH : natural := 32
  );
  port(
    -- master port
    addr_m  : in std_logic_vector(ADDR_WIDTH -1 downto 0);
    din_m   : in std_logic_vector(DATA_WIDTH -1 downto 0);
    wr_en_m : in std_logic;
    rd_rq_m : in std_logic;

    dout_m  : out std_logic_vector(DATA_WIDTH -1 downto 0);
    dv_m    : out std_logic;

    -- Slaves ports
    -- Slave 1
    addr_s1 : out std_logic_vector(S1_ADDR_WIDTH -1 downto 0);
    en_s1   : out std_logic;
    dout_s1 : out std_logic_vector(S1_DATA_WIDTH -1 downto 0);
    dv_s1   : out std_logic;
    din_s1  : in std_logic_vector(S1_DATA_WIDTH -1 downto 0);
    we_s1   : in std_logic;

    -- slave 2
    addr_s2 : out std_logic_vector(S2_ADDR_WIDTH -1 downto 0);
    en_s2   : out std_logic;
    dout_s2 : out std_logic_vector(S2_DATA_WIDTH -1 downto 0);
    dv_s2   : out std_logic;
    din_s2  : in std_logic_vector(S2_DATA_WIDTH -1 downto 0);
    we_s2   : in std_logic;

    -- Slave 3
    addr_s3 : out std_logic_vector(S3_ADDR_WIDTH -1 downto 0);
    en_s3   : out std_logic;
    dout_s3 : out std_logic_vector(S3_DATA_WIDTH -1 downto 0);
    dv_s3   : out std_logic;
    din_s3  : in std_logic_vector(S3_DATA_WIDTH -1 downto 0);
    we_s3   : in std_logic;

    -- Slave 4
    addr_s4 : out std_logic_vector(S4_ADDR_WIDTH -1 downto 0);
    en_s4   : out std_logic;
    dout_s4 : out std_logic_vector(S4_DATA_WIDTH -1 downto 0);
    dv_s4   : out std_logic;
    din_s4  : in std_logic_vector(S4_DATA_WIDTH -1 downto 0);
    we_s4   : in std_logic
  );
end entity;


architecture mux of simple_interconnect is

signal sel : std_logic_vector(3 downto 0);

begin

sel(0) <= '1' when addr_m >= S1_BASE_ADDR and addr_m <= S1_LAST_ADDR else '0';
sel(1) <= '1' when addr_m >= S2_BASE_ADDR and addr_m <= S2_LAST_ADDR else '0';
sel(2) <= '1' when addr_m >= S3_BASE_ADDR and addr_m <= S3_LAST_ADDR else '0';
sel(3) <= '1' when addr_m >= S4_BASE_ADDR and addr_m <= S4_LAST_ADDR else '0';

dout_s1 <= din_m;
dout_s2 <= din_m;
dout_s3 <= din_m;
dout_s4 <= din_m;

process(sel,addr_m,rd_rq_m,
        din_s1,we_s1,
        din_s2,we_s2,
        din_s3,we_s3,
        din_s4,we_s4)
begin

  addr_s1 <= (others => '0');
  addr_s2 <= (others => '0');
  addr_s3 <= (others => '0');
  addr_s4 <= (others => '0');

  en_s1 <= '0';
  en_s2 <= '0';
  en_s3 <= '0';
  en_s4 <= '0';

  dout_m  <= (others => '0');
  dv_m    <= '0';

  case sel is
    when "0001" =>
      addr_s1 <= addr_m(S1_ADDR_WIDTH -1 downto 0);
      en_s1   <= rd_rq_m;
      dv_s1   <= wr_en_m;
      dout_m  <= din_s1;
      dv_m    <= we_s1;

    when "0010" =>
      addr_s2 <= addr_m(S2_ADDR_WIDTH -1 downto 0);
      en_s2   <= rd_rq_m;
      dv_s2   <= wr_en_m;
      dout_m  <= din_s2;
      dv_m    <= we_s2;

    when "0100" =>
      addr_s3 <= addr_m(S3_ADDR_WIDTH -1 downto 0);
      en_s3   <= rd_rq_m;
      dv_s3   <= wr_en_m;
      dout_m  <= din_s3;
      dv_m    <= we_s3;

    when "1000" =>
      addr_s4 <= addr_m(S4_ADDR_WIDTH -1 downto 0);
      en_s4   <= rd_rq_m;
      dv_s4   <= wr_en_m;
      dout_m  <= din_s4;
      dv_m    <= we_s4;

    when others =>
  end case;

end process;


end architecture;
