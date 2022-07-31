-- (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: www.ictp.it:user:comblock:2.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_comblock_0_2 IS
  PORT (
    reg0_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    reg1_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    reg2_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    reg3_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    reg0_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    reg1_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    reg2_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    reg3_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    reg4_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    reg5_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    axil_aclk : IN STD_LOGIC;
    axil_aresetn : IN STD_LOGIC;
    axil_awaddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    axil_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    axil_awvalid : IN STD_LOGIC;
    axil_awready : OUT STD_LOGIC;
    axil_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    axil_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    axil_wvalid : IN STD_LOGIC;
    axil_wready : OUT STD_LOGIC;
    axil_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    axil_bvalid : OUT STD_LOGIC;
    axil_bready : IN STD_LOGIC;
    axil_araddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    axil_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    axil_arvalid : IN STD_LOGIC;
    axil_arready : OUT STD_LOGIC;
    axil_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axil_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    axil_rvalid : OUT STD_LOGIC;
    axil_rready : IN STD_LOGIC
  );
END design_1_comblock_0_2;

ARCHITECTURE design_1_comblock_0_2_arch OF design_1_comblock_0_2 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_comblock_0_2_arch: ARCHITECTURE IS "yes";
  COMPONENT axi_comblock IS
    GENERIC (
      REGS_IN_ENA : BOOLEAN;
      REGS_IN_DWIDTH : INTEGER;
      REGS_IN_DEPTH : INTEGER;
      REGS_OUT_ENA : BOOLEAN;
      REGS_OUT_DWIDTH : INTEGER;
      REGS_OUT_DEPTH : INTEGER;
      DRAM_IO_ENA : BOOLEAN;
      DRAM_IO_DWIDTH : INTEGER;
      DRAM_IO_AWIDTH : INTEGER;
      DRAM_IO_DEPTH : INTEGER;
      FIFO_IN_ENA : BOOLEAN;
      FIFO_IN_DWIDTH : INTEGER;
      FIFO_IN_DEPTH : INTEGER;
      FIFO_IN_AFOFFSET : INTEGER;
      FIFO_IN_AEOFFSET : INTEGER;
      FIFO_OUT_ENA : BOOLEAN;
      FIFO_OUT_DWIDTH : INTEGER;
      FIFO_OUT_DEPTH : INTEGER;
      FIFO_OUT_AFOFFSET : INTEGER;
      FIFO_OUT_AEOFFSET : INTEGER;
      C_AXIF_ID_WIDTH : INTEGER; -- Width of ID for for write address, write data, read address and read data
      C_AXIF_AWUSER_WIDTH : INTEGER;
      C_AXIF_ARUSER_WIDTH : INTEGER;
      C_AXIF_WUSER_WIDTH : INTEGER;
      C_AXIF_RUSER_WIDTH : INTEGER;
      C_AXIF_BUSER_WIDTH : INTEGER
    );
    PORT (
      reg0_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg1_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg2_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg3_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg4_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg5_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg6_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg7_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg8_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg9_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg10_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg11_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg12_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg13_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg14_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg15_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      reg0_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg1_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg2_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg3_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg4_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg5_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg6_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg7_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg8_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg9_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg10_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg11_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg12_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg13_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg14_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      reg15_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      ram_clk_i : IN STD_LOGIC;
      ram_we_i : IN STD_LOGIC;
      ram_addr_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      ram_data_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      ram_data_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      fifo_clk_i : IN STD_LOGIC;
      fifo_clear_i : IN STD_LOGIC;
      fifo_we_i : IN STD_LOGIC;
      fifo_data_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      fifo_full_o : OUT STD_LOGIC;
      fifo_afull_o : OUT STD_LOGIC;
      fifo_overflow_o : OUT STD_LOGIC;
      fifo_re_i : IN STD_LOGIC;
      fifo_data_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      fifo_valid_o : OUT STD_LOGIC;
      fifo_empty_o : OUT STD_LOGIC;
      fifo_aempty_o : OUT STD_LOGIC;
      fifo_underflow_o : OUT STD_LOGIC;
      axil_aclk : IN STD_LOGIC;
      axil_aresetn : IN STD_LOGIC;
      axil_awaddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      axil_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      axil_awvalid : IN STD_LOGIC;
      axil_awready : OUT STD_LOGIC;
      axil_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      axil_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      axil_wvalid : IN STD_LOGIC;
      axil_wready : OUT STD_LOGIC;
      axil_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      axil_bvalid : OUT STD_LOGIC;
      axil_bready : IN STD_LOGIC;
      axil_araddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      axil_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      axil_arvalid : IN STD_LOGIC;
      axil_arready : OUT STD_LOGIC;
      axil_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      axil_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      axil_rvalid : OUT STD_LOGIC;
      axil_rready : IN STD_LOGIC;
      axif_aclk : IN STD_LOGIC;
      axif_aresetn : IN STD_LOGIC;
      axif_awid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      axif_awaddr : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
      axif_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      axif_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      axif_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      axif_awlock : IN STD_LOGIC;
      axif_awcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      axif_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      axif_awqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      axif_awregion : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      axif_awuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      axif_awvalid : IN STD_LOGIC;
      axif_awready : OUT STD_LOGIC;
      axif_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      axif_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      axif_wlast : IN STD_LOGIC;
      axif_wuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      axif_wvalid : IN STD_LOGIC;
      axif_wready : OUT STD_LOGIC;
      axif_bid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      axif_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      axif_buser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      axif_bvalid : OUT STD_LOGIC;
      axif_bready : IN STD_LOGIC;
      axif_arid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      axif_araddr : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
      axif_arlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      axif_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      axif_arburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      axif_arlock : IN STD_LOGIC;
      axif_arcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      axif_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      axif_arqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      axif_arregion : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      axif_aruser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      axif_arvalid : IN STD_LOGIC;
      axif_arready : OUT STD_LOGIC;
      axif_rid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      axif_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      axif_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      axif_rlast : OUT STD_LOGIC;
      axif_ruser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      axif_rvalid : OUT STD_LOGIC;
      axif_rready : IN STD_LOGIC
    );
  END COMPONENT axi_comblock;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF design_1_comblock_0_2_arch: ARCHITECTURE IS "axi_comblock,Vivado 2021.2";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF design_1_comblock_0_2_arch : ARCHITECTURE IS "design_1_comblock_0_2,axi_comblock,{}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF design_1_comblock_0_2_arch: ARCHITECTURE IS "package_project";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF axil_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF axil_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_rresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF axil_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF axil_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF axil_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_arprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL ARPROT";
  ATTRIBUTE X_INTERFACE_INFO OF axil_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF axil_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF axil_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF axil_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF axil_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF axil_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF axil_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF axil_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL AWPROT";
  ATTRIBUTE X_INTERFACE_PARAMETER OF axil_awaddr: SIGNAL IS "XIL_INTERFACENAME AXIL, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 8, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_2_FCLK_CLK0, NUM_READ_THREADS 4," & 
" NUM_WRITE_THREADS 4, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF axil_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 AXIL AWADDR";
  ATTRIBUTE X_INTERFACE_PARAMETER OF axil_aresetn: SIGNAL IS "XIL_INTERFACENAME axil_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF axil_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 axil_aresetn RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF axil_aclk: SIGNAL IS "XIL_INTERFACENAME axil_aclk, ASSOCIATED_RESET axil_aresetn, ASSOCIATED_BUSIF AXIL, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_2_FCLK_CLK0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF axil_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 axil_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF reg5_o: SIGNAL IS "ictp:user:OREGS:1.0 OUT_REGS reg5_o";
  ATTRIBUTE X_INTERFACE_INFO OF reg4_o: SIGNAL IS "ictp:user:OREGS:1.0 OUT_REGS reg4_o";
  ATTRIBUTE X_INTERFACE_INFO OF reg3_o: SIGNAL IS "ictp:user:OREGS:1.0 OUT_REGS reg3_o";
  ATTRIBUTE X_INTERFACE_INFO OF reg2_o: SIGNAL IS "ictp:user:OREGS:1.0 OUT_REGS reg2_o";
  ATTRIBUTE X_INTERFACE_INFO OF reg1_o: SIGNAL IS "ictp:user:OREGS:1.0 OUT_REGS reg1_o";
  ATTRIBUTE X_INTERFACE_INFO OF reg0_o: SIGNAL IS "ictp:user:OREGS:1.0 OUT_REGS reg0_o";
  ATTRIBUTE X_INTERFACE_INFO OF reg3_i: SIGNAL IS "ictp:user:IREGS:1.0 IN_REGS reg3_i";
  ATTRIBUTE X_INTERFACE_INFO OF reg2_i: SIGNAL IS "ictp:user:IREGS:1.0 IN_REGS reg2_i";
  ATTRIBUTE X_INTERFACE_INFO OF reg1_i: SIGNAL IS "ictp:user:IREGS:1.0 IN_REGS reg1_i";
  ATTRIBUTE X_INTERFACE_INFO OF reg0_i: SIGNAL IS "ictp:user:IREGS:1.0 IN_REGS reg0_i";
BEGIN
  U0 : axi_comblock
    GENERIC MAP (
      REGS_IN_ENA => true,
      REGS_IN_DWIDTH => 16,
      REGS_IN_DEPTH => 4,
      REGS_OUT_ENA => true,
      REGS_OUT_DWIDTH => 4,
      REGS_OUT_DEPTH => 6,
      DRAM_IO_ENA => false,
      DRAM_IO_DWIDTH => 16,
      DRAM_IO_AWIDTH => 16,
      DRAM_IO_DEPTH => 0,
      FIFO_IN_ENA => false,
      FIFO_IN_DWIDTH => 16,
      FIFO_IN_DEPTH => 1024,
      FIFO_IN_AFOFFSET => 1,
      FIFO_IN_AEOFFSET => 1,
      FIFO_OUT_ENA => false,
      FIFO_OUT_DWIDTH => 16,
      FIFO_OUT_DEPTH => 1024,
      FIFO_OUT_AFOFFSET => 1,
      FIFO_OUT_AEOFFSET => 1,
      C_AXIF_ID_WIDTH => 1,
      C_AXIF_AWUSER_WIDTH => 1,
      C_AXIF_ARUSER_WIDTH => 1,
      C_AXIF_WUSER_WIDTH => 1,
      C_AXIF_RUSER_WIDTH => 1,
      C_AXIF_BUSER_WIDTH => 1
    )
    PORT MAP (
      reg0_i => reg0_i,
      reg1_i => reg1_i,
      reg2_i => reg2_i,
      reg3_i => reg3_i,
      reg4_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg5_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg6_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg7_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg8_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg9_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg10_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg11_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg12_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg13_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg14_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg15_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      reg0_o => reg0_o,
      reg1_o => reg1_o,
      reg2_o => reg2_o,
      reg3_o => reg3_o,
      reg4_o => reg4_o,
      reg5_o => reg5_o,
      ram_clk_i => '0',
      ram_we_i => '0',
      ram_addr_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      ram_data_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      fifo_clk_i => '0',
      fifo_clear_i => '0',
      fifo_we_i => '0',
      fifo_data_i => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 16)),
      fifo_re_i => '0',
      axil_aclk => axil_aclk,
      axil_aresetn => axil_aresetn,
      axil_awaddr => axil_awaddr,
      axil_awprot => axil_awprot,
      axil_awvalid => axil_awvalid,
      axil_awready => axil_awready,
      axil_wdata => axil_wdata,
      axil_wstrb => axil_wstrb,
      axil_wvalid => axil_wvalid,
      axil_wready => axil_wready,
      axil_bresp => axil_bresp,
      axil_bvalid => axil_bvalid,
      axil_bready => axil_bready,
      axil_araddr => axil_araddr,
      axil_arprot => axil_arprot,
      axil_arvalid => axil_arvalid,
      axil_arready => axil_arready,
      axil_rdata => axil_rdata,
      axil_rresp => axil_rresp,
      axil_rvalid => axil_rvalid,
      axil_rready => axil_rready,
      axif_aclk => '0',
      axif_aresetn => '1',
      axif_awid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      axif_awaddr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 18)),
      axif_awlen => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      axif_awsize => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      axif_awburst => STD_LOGIC_VECTOR(TO_UNSIGNED(1, 2)),
      axif_awlock => '0',
      axif_awcache => STD_LOGIC_VECTOR(TO_UNSIGNED(3, 4)),
      axif_awprot => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      axif_awqos => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axif_awregion => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axif_awuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      axif_awvalid => '0',
      axif_wdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      axif_wstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(1, 4)),
      axif_wlast => '0',
      axif_wuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      axif_wvalid => '0',
      axif_bready => '0',
      axif_arid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      axif_araddr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 18)),
      axif_arlen => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      axif_arsize => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      axif_arburst => STD_LOGIC_VECTOR(TO_UNSIGNED(1, 2)),
      axif_arlock => '0',
      axif_arcache => STD_LOGIC_VECTOR(TO_UNSIGNED(3, 4)),
      axif_arprot => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      axif_arqos => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axif_arregion => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axif_aruser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      axif_arvalid => '0',
      axif_rready => '0'
    );
END design_1_comblock_0_2_arch;
