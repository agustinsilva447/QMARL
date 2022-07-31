--Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Command: generate_target bd_f74c.bd
--Design : bd_f74c
--Purpose: IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_f74c is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe7 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of bd_f74c : entity is "bd_f74c,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=bd_f74c,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=SBD,synth_mode=Global}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of bd_f74c : entity is "design_1_system_ila_0_3.hwdef";
end bd_f74c;

architecture STRUCTURE of bd_f74c is
  component bd_f74c_ila_lib_0 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe7 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  end component bd_f74c_ila_lib_0;
  signal clk_1 : STD_LOGIC;
  signal probe0_1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal probe1_1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal probe2_1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal probe3_1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal probe4_1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal probe5_1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal probe6_1 : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal probe7_1 : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal probe8_1 : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal probe9_1 : STD_LOGIC_VECTOR ( 15 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 CLK.CLK CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN design_1_processing_system7_0_2_FCLK_CLK0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
begin
  clk_1 <= clk;
  probe0_1(3 downto 0) <= probe0(3 downto 0);
  probe1_1(3 downto 0) <= probe1(3 downto 0);
  probe2_1(3 downto 0) <= probe2(3 downto 0);
  probe3_1(3 downto 0) <= probe3(3 downto 0);
  probe4_1(3 downto 0) <= probe4(3 downto 0);
  probe5_1(3 downto 0) <= probe5(3 downto 0);
  probe6_1(15 downto 0) <= probe6(15 downto 0);
  probe7_1(15 downto 0) <= probe7(15 downto 0);
  probe8_1(15 downto 0) <= probe8(15 downto 0);
  probe9_1(15 downto 0) <= probe9(15 downto 0);
ila_lib: component bd_f74c_ila_lib_0
     port map (
      clk => clk_1,
      probe0(3 downto 0) => probe0_1(3 downto 0),
      probe1(3 downto 0) => probe1_1(3 downto 0),
      probe2(3 downto 0) => probe2_1(3 downto 0),
      probe3(3 downto 0) => probe3_1(3 downto 0),
      probe4(3 downto 0) => probe4_1(3 downto 0),
      probe5(3 downto 0) => probe5_1(3 downto 0),
      probe6(15 downto 0) => probe6_1(15 downto 0),
      probe7(15 downto 0) => probe7_1(15 downto 0),
      probe8(15 downto 0) => probe8_1(15 downto 0),
      probe9(15 downto 0) => probe9_1(15 downto 0)
    );
end STRUCTURE;
