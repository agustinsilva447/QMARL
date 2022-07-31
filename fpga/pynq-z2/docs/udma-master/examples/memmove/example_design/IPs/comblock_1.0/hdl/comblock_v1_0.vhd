library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comblock_v1_0 is
	generic (
		-- Users to add parameters here
        C_ENABLE_DRAM               : boolean:=TRUE;
        C_ENABLE_FIFO_FPGA_TO_PROC  : boolean:=TRUE;
        C_ENABLE_FIFO_PROC_TO_FPGA  : boolean:=FALSE;
        C_REGS_DATA_WIDTH           : integer:=32;
        C_DRAM_DATA_WIDTH           : integer:=32;
        C_DRAM_ADDR_WIDTH           : integer:=16;
        C_DRAM_DEPTH                : integer:=0;
        C_FIFO_DATA_WIDTH           : integer:=16;
        C_FIFO_DEPTH                : integer:=1024;
        C_FIFO_AFULLOFFSET          : integer:=1;
        C_FIFO_AEMPTYOFFSET         : integer:=1;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 6;

		-- Parameters of Axi Slave Bus Interface S01_AXI
		C_S01_AXI_ID_WIDTH	    : integer	:= 1;
		C_S01_AXI_DATA_WIDTH	: integer	:= 32;
		C_S01_AXI_ADDR_WIDTH	: integer	:= 18;
		C_S01_AXI_AWUSER_WIDTH	: integer	:= 0;
		C_S01_AXI_ARUSER_WIDTH	: integer	:= 0;
		C_S01_AXI_WUSER_WIDTH	: integer	:= 0;
		C_S01_AXI_RUSER_WIDTH	: integer	:= 0;
		C_S01_AXI_BUSER_WIDTH	: integer	:= 0;

		-- Parameters of Axi Slave Bus Interface S02_AXI
		C_S02_AXI_ID_WIDTH	: integer	:= 1;
		C_S02_AXI_DATA_WIDTH	: integer	:= 32;
		C_S02_AXI_ADDR_WIDTH	: integer	:= 3;
		C_S02_AXI_AWUSER_WIDTH	: integer	:= 0;
		C_S02_AXI_ARUSER_WIDTH	: integer	:= 0;
		C_S02_AXI_WUSER_WIDTH	: integer	:= 0;
		C_S02_AXI_RUSER_WIDTH	: integer	:= 0;
		C_S02_AXI_BUSER_WIDTH	: integer	:= 0
	);
	port (
		-- Users to add ports here
		-- regs
		reg0_i		:  in std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg1_i		:  in std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg2_i		:  in std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg3_i		:  in std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg4_i		:  in std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg5_i		:  in std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg6_i		:  in std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg7_i		:  in std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg8_i		:  in std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg9_i		:  in std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg0_o		: out std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg1_o		: out std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg2_o		: out std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg3_o		: out std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg4_o		: out std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg5_o		: out std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg6_o		: out std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg7_o		: out std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg8_o		: out std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		reg9_o		: out std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0):=(others => '0');
		-- true dual ram
		ram_clk_i	:  in std_logic:='0';
		ram_we_i	:  in std_logic:='0';
		ram_addr_i	:  in std_logic_vector(C_DRAM_ADDR_WIDTH-1 downto 0):=(others => '0');
		ram_data_i	:  in std_logic_vector(C_DRAM_DATA_WIDTH-1 downto 0):=(others => '0');
		ram_data_o	: out std_logic_vector(C_DRAM_DATA_WIDTH-1 downto 0);
		-- fifo
		fifo_clk_i	:  in std_logic:='0';
		fifo_clear_i:  in std_logic:='0';
		fifo_we_i	:  in std_logic:='0';
		fifo_data_i	:  in std_logic_vector(C_FIFO_DATA_WIDTH-1 downto 0):=(others => '0');
		fifo_full_o	: out std_logic;
		fifo_afull_o    : out std_logic;
        fifo_overflow_o : out std_logic;
		fifo_re_i   :  in std_logic:='0';
        fifo_data_o : out std_logic_vector(C_FIFO_DATA_WIDTH-1 downto 0);
        fifo_empty_o: out std_logic;
        fifo_aempty_o   : out std_logic;
        fifo_underflow_o: out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic;

		-- Ports of Axi Slave Bus Interface S01_AXI
		s01_axi_aclk	: in std_logic;
		s01_axi_aresetn	: in std_logic;
		s01_axi_awid	: in std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
		s01_axi_awaddr	: in std_logic_vector(C_S01_AXI_ADDR_WIDTH-1 downto 0);
		s01_axi_awlen	: in std_logic_vector(7 downto 0);
		s01_axi_awsize	: in std_logic_vector(2 downto 0);
		s01_axi_awburst	: in std_logic_vector(1 downto 0);
		s01_axi_awlock	: in std_logic;
		s01_axi_awcache	: in std_logic_vector(3 downto 0);
		s01_axi_awprot	: in std_logic_vector(2 downto 0);
		s01_axi_awqos	: in std_logic_vector(3 downto 0);
		s01_axi_awregion	: in std_logic_vector(3 downto 0);
		s01_axi_awuser	: in std_logic_vector(C_S01_AXI_AWUSER_WIDTH-1 downto 0);
		s01_axi_awvalid	: in std_logic;
		s01_axi_awready	: out std_logic;
		s01_axi_wdata	: in std_logic_vector(C_S01_AXI_DATA_WIDTH-1 downto 0);
		s01_axi_wstrb	: in std_logic_vector((C_S01_AXI_DATA_WIDTH/8)-1 downto 0);
		s01_axi_wlast	: in std_logic;
		s01_axi_wuser	: in std_logic_vector(C_S01_AXI_WUSER_WIDTH-1 downto 0);
		s01_axi_wvalid	: in std_logic;
		s01_axi_wready	: out std_logic;
		s01_axi_bid	: out std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
		s01_axi_bresp	: out std_logic_vector(1 downto 0);
		s01_axi_buser	: out std_logic_vector(C_S01_AXI_BUSER_WIDTH-1 downto 0);
		s01_axi_bvalid	: out std_logic;
		s01_axi_bready	: in std_logic;
		s01_axi_arid	: in std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
		s01_axi_araddr	: in std_logic_vector(C_S01_AXI_ADDR_WIDTH-1 downto 0);
		s01_axi_arlen	: in std_logic_vector(7 downto 0);
		s01_axi_arsize	: in std_logic_vector(2 downto 0);
		s01_axi_arburst	: in std_logic_vector(1 downto 0);
		s01_axi_arlock	: in std_logic;
		s01_axi_arcache	: in std_logic_vector(3 downto 0);
		s01_axi_arprot	: in std_logic_vector(2 downto 0);
		s01_axi_arqos	: in std_logic_vector(3 downto 0);
		s01_axi_arregion	: in std_logic_vector(3 downto 0);
		s01_axi_aruser	: in std_logic_vector(C_S01_AXI_ARUSER_WIDTH-1 downto 0);
		s01_axi_arvalid	: in std_logic;
		s01_axi_arready	: out std_logic;
		s01_axi_rid	: out std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
		s01_axi_rdata	: out std_logic_vector(C_S01_AXI_DATA_WIDTH-1 downto 0);
		s01_axi_rresp	: out std_logic_vector(1 downto 0);
		s01_axi_rlast	: out std_logic;
		s01_axi_ruser	: out std_logic_vector(C_S01_AXI_RUSER_WIDTH-1 downto 0);
		s01_axi_rvalid	: out std_logic;
		s01_axi_rready	: in std_logic;

		-- Ports of Axi Slave Bus Interface S02_AXI
		s02_axi_aclk	: in std_logic;
		s02_axi_aresetn	: in std_logic;
		s02_axi_awid	: in std_logic_vector(C_S02_AXI_ID_WIDTH-1 downto 0);
		s02_axi_awaddr	: in std_logic_vector(C_S02_AXI_ADDR_WIDTH-1 downto 0);
		s02_axi_awlen	: in std_logic_vector(7 downto 0);
		s02_axi_awsize	: in std_logic_vector(2 downto 0);
		s02_axi_awburst	: in std_logic_vector(1 downto 0);
		s02_axi_awlock	: in std_logic;
		s02_axi_awcache	: in std_logic_vector(3 downto 0);
		s02_axi_awprot	: in std_logic_vector(2 downto 0);
		s02_axi_awqos	: in std_logic_vector(3 downto 0);
		s02_axi_awregion	: in std_logic_vector(3 downto 0);
		s02_axi_awuser	: in std_logic_vector(C_S02_AXI_AWUSER_WIDTH-1 downto 0);
		s02_axi_awvalid	: in std_logic;
		s02_axi_awready	: out std_logic;
		s02_axi_wdata	: in std_logic_vector(C_S02_AXI_DATA_WIDTH-1 downto 0);
		s02_axi_wstrb	: in std_logic_vector((C_S02_AXI_DATA_WIDTH/8)-1 downto 0);
		s02_axi_wlast	: in std_logic;
		s02_axi_wuser	: in std_logic_vector(C_S02_AXI_WUSER_WIDTH-1 downto 0);
		s02_axi_wvalid	: in std_logic;
		s02_axi_wready	: out std_logic;
		s02_axi_bid	: out std_logic_vector(C_S02_AXI_ID_WIDTH-1 downto 0);
		s02_axi_bresp	: out std_logic_vector(1 downto 0);
		s02_axi_buser	: out std_logic_vector(C_S02_AXI_BUSER_WIDTH-1 downto 0);
		s02_axi_bvalid	: out std_logic;
		s02_axi_bready	: in std_logic;
		s02_axi_arid	: in std_logic_vector(C_S02_AXI_ID_WIDTH-1 downto 0);
		s02_axi_araddr	: in std_logic_vector(C_S02_AXI_ADDR_WIDTH-1 downto 0);
		s02_axi_arlen	: in std_logic_vector(7 downto 0);
		s02_axi_arsize	: in std_logic_vector(2 downto 0);
		s02_axi_arburst	: in std_logic_vector(1 downto 0);
		s02_axi_arlock	: in std_logic;
		s02_axi_arcache	: in std_logic_vector(3 downto 0);
		s02_axi_arprot	: in std_logic_vector(2 downto 0);
		s02_axi_arqos	: in std_logic_vector(3 downto 0);
		s02_axi_arregion	: in std_logic_vector(3 downto 0);
		s02_axi_aruser	: in std_logic_vector(C_S02_AXI_ARUSER_WIDTH-1 downto 0);
		s02_axi_arvalid	: in std_logic;
		s02_axi_arready	: out std_logic;
		s02_axi_rid	: out std_logic_vector(C_S02_AXI_ID_WIDTH-1 downto 0);
		s02_axi_rdata	: out std_logic_vector(C_S02_AXI_DATA_WIDTH-1 downto 0);
		s02_axi_rresp	: out std_logic_vector(1 downto 0);
		s02_axi_rlast	: out std_logic;
		s02_axi_ruser	: out std_logic_vector(C_S02_AXI_RUSER_WIDTH-1 downto 0);
		s02_axi_rvalid	: out std_logic;
		s02_axi_rready	: in std_logic
	);
end comblock_v1_0;

architecture arch_imp of comblock_v1_0 is
   -- c2a : comblock to axi
   -- a2c : axi to comblock
   signal reg0_c2a, reg0_a2c : std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0);
   signal reg1_c2a, reg1_a2c : std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0);
   signal reg2_c2a, reg2_a2c : std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0);
   signal reg3_c2a, reg3_a2c : std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0);
   signal reg4_c2a, reg4_a2c : std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0);
   signal reg5_c2a, reg5_a2c : std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0);
   signal reg6_c2a, reg6_a2c : std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0);
   signal reg7_c2a, reg7_a2c : std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0);
   signal reg8_c2a, reg8_a2c : std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0);
   signal reg9_c2a, reg9_a2c : std_logic_vector(C_REGS_DATA_WIDTH-1 downto 0);

   signal ram_we_a2c     : std_logic;
   signal ram_addr_a2c   : std_logic_vector(C_DRAM_ADDR_WIDTH-1 downto 0);
   signal ram_data_a2c   : std_logic_vector(C_DRAM_DATA_WIDTH-1 downto 0);
   signal ram_data_c2a   : std_logic_vector(C_DRAM_DATA_WIDTH-1 downto 0);
   
   signal fifo_re_a2c    : std_logic;
   signal fifo_data_c2a  : std_logic_vector(C_FIFO_DATA_WIDTH-1 downto 0);
   signal fifo_we_a2c    : std_logic;
   signal fifo_data_a2c  : std_logic_vector(C_FIFO_DATA_WIDTH-1 downto 0);
   signal fifo_clear_a2c : std_logic;
   signal fifo_stat_c2a  : std_logic_vector(5 downto 0);
begin

comblock_v1_0_S00_AXI_inst : entity work.comblock_v1_0_S00_AXI
	generic map (
	    C_REGS_DATA_WIDTH   => C_REGS_DATA_WIDTH,
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		reg0_i		=> reg0_c2a,
		reg1_i		=> reg1_c2a,
		reg2_i		=> reg2_c2a,
		reg3_i		=> reg3_c2a,
		reg4_i		=> reg4_c2a,
		reg5_i		=> reg5_c2a,
		reg6_i		=> reg6_c2a,
		reg7_i		=> reg7_c2a,
		reg8_i		=> reg8_c2a,
		reg9_i		=> reg9_c2a,
		reg0_o		=> reg0_a2c,
		reg1_o		=> reg1_a2c,
		reg2_o		=> reg2_a2c,
		reg3_o		=> reg3_a2c,
		reg4_o		=> reg4_a2c,
		reg5_o		=> reg5_a2c,
		reg6_o		=> reg6_a2c,
		reg7_o		=> reg7_a2c,
		reg8_o		=> reg8_a2c,
		reg9_o		=> reg9_a2c,
		--
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

comblock_v1_0_S01_AXI_inst : entity work.comblock_v1_0_S01_AXI
	generic map (
	    C_DRAM_DATA_WIDTH   => C_DRAM_DATA_WIDTH,
        C_DRAM_ADDR_WIDTH   => C_DRAM_ADDR_WIDTH,
		C_S_AXI_ID_WIDTH	=> C_S01_AXI_ID_WIDTH,
		C_S_AXI_DATA_WIDTH	=> C_S01_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S01_AXI_ADDR_WIDTH,
		C_S_AXI_AWUSER_WIDTH=> C_S01_AXI_AWUSER_WIDTH,
		C_S_AXI_ARUSER_WIDTH=> C_S01_AXI_ARUSER_WIDTH,
		C_S_AXI_WUSER_WIDTH	=> C_S01_AXI_WUSER_WIDTH,
		C_S_AXI_RUSER_WIDTH	=> C_S01_AXI_RUSER_WIDTH,
		C_S_AXI_BUSER_WIDTH	=> C_S01_AXI_BUSER_WIDTH
	)
	port map (
		ram_we_o	=> ram_we_a2c,
		ram_addr_o	=> ram_addr_a2c,
		ram_data_o	=> ram_data_a2c,
		ram_data_i	=> ram_data_c2a,
		--
		S_AXI_ACLK	=> s01_axi_aclk,
		S_AXI_ARESETN	=> s01_axi_aresetn,
		S_AXI_AWID	=> s01_axi_awid,
		S_AXI_AWADDR	=> s01_axi_awaddr,
		S_AXI_AWLEN	=> s01_axi_awlen,
		S_AXI_AWSIZE	=> s01_axi_awsize,
		S_AXI_AWBURST	=> s01_axi_awburst,
		S_AXI_AWLOCK	=> s01_axi_awlock,
		S_AXI_AWCACHE	=> s01_axi_awcache,
		S_AXI_AWPROT	=> s01_axi_awprot,
		S_AXI_AWQOS	=> s01_axi_awqos,
		S_AXI_AWREGION	=> s01_axi_awregion,
		S_AXI_AWUSER	=> s01_axi_awuser,
		S_AXI_AWVALID	=> s01_axi_awvalid,
		S_AXI_AWREADY	=> s01_axi_awready,
		S_AXI_WDATA	=> s01_axi_wdata,
		S_AXI_WSTRB	=> s01_axi_wstrb,
		S_AXI_WLAST	=> s01_axi_wlast,
		S_AXI_WUSER	=> s01_axi_wuser,
		S_AXI_WVALID	=> s01_axi_wvalid,
		S_AXI_WREADY	=> s01_axi_wready,
		S_AXI_BID	=> s01_axi_bid,
		S_AXI_BRESP	=> s01_axi_bresp,
		S_AXI_BUSER	=> s01_axi_buser,
		S_AXI_BVALID	=> s01_axi_bvalid,
		S_AXI_BREADY	=> s01_axi_bready,
		S_AXI_ARID	=> s01_axi_arid,
		S_AXI_ARADDR	=> s01_axi_araddr,
		S_AXI_ARLEN	=> s01_axi_arlen,
		S_AXI_ARSIZE	=> s01_axi_arsize,
		S_AXI_ARBURST	=> s01_axi_arburst,
		S_AXI_ARLOCK	=> s01_axi_arlock,
		S_AXI_ARCACHE	=> s01_axi_arcache,
		S_AXI_ARPROT	=> s01_axi_arprot,
		S_AXI_ARQOS	=> s01_axi_arqos,
		S_AXI_ARREGION	=> s01_axi_arregion,
		S_AXI_ARUSER	=> s01_axi_aruser,
		S_AXI_ARVALID	=> s01_axi_arvalid,
		S_AXI_ARREADY	=> s01_axi_arready,
		S_AXI_RID	=> s01_axi_rid,
		S_AXI_RDATA	=> s01_axi_rdata,
		S_AXI_RRESP	=> s01_axi_rresp,
		S_AXI_RLAST	=> s01_axi_rlast,
		S_AXI_RUSER	=> s01_axi_ruser,
		S_AXI_RVALID	=> s01_axi_rvalid,
		S_AXI_RREADY	=> s01_axi_rready
	);

comblock_v1_0_S02_AXI_inst : entity work.comblock_v1_0_S02_AXI
	generic map (
	    C_FIFO_DATA_WIDTH   => C_FIFO_DATA_WIDTH,
		C_S_AXI_ID_WIDTH	=> C_S02_AXI_ID_WIDTH,
		C_S_AXI_DATA_WIDTH	=> C_S02_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S02_AXI_ADDR_WIDTH,
		C_S_AXI_AWUSER_WIDTH	=> C_S02_AXI_AWUSER_WIDTH,
		C_S_AXI_ARUSER_WIDTH	=> C_S02_AXI_ARUSER_WIDTH,
		C_S_AXI_WUSER_WIDTH	=> C_S02_AXI_WUSER_WIDTH,
		C_S_AXI_RUSER_WIDTH	=> C_S02_AXI_RUSER_WIDTH,
		C_S_AXI_BUSER_WIDTH	=> C_S02_AXI_BUSER_WIDTH
	)
	port map (
		fifo_re_o	=> fifo_re_a2c,
		fifo_data_i	=> fifo_data_c2a,
		fifo_we_o	=> fifo_we_a2c,
        fifo_data_o => fifo_data_a2c,
        fifo_stat_i => fifo_stat_c2a,
		--
		S_AXI_ACLK	=> s02_axi_aclk,
		S_AXI_ARESETN	=> s02_axi_aresetn,
		S_AXI_AWID	=> s02_axi_awid,
		S_AXI_AWADDR	=> s02_axi_awaddr,
		S_AXI_AWLEN	=> s02_axi_awlen,
		S_AXI_AWSIZE	=> s02_axi_awsize,
		S_AXI_AWBURST	=> s02_axi_awburst,
		S_AXI_AWLOCK	=> s02_axi_awlock,
		S_AXI_AWCACHE	=> s02_axi_awcache,
		S_AXI_AWPROT	=> s02_axi_awprot,
		S_AXI_AWQOS	=> s02_axi_awqos,
		S_AXI_AWREGION	=> s02_axi_awregion,
		S_AXI_AWUSER	=> s02_axi_awuser,
		S_AXI_AWVALID	=> s02_axi_awvalid,
		S_AXI_AWREADY	=> s02_axi_awready,
		S_AXI_WDATA	=> s02_axi_wdata,
		S_AXI_WSTRB	=> s02_axi_wstrb,
		S_AXI_WLAST	=> s02_axi_wlast,
		S_AXI_WUSER	=> s02_axi_wuser,
		S_AXI_WVALID	=> s02_axi_wvalid,
		S_AXI_WREADY	=> s02_axi_wready,
		S_AXI_BID	=> s02_axi_bid,
		S_AXI_BRESP	=> s02_axi_bresp,
		S_AXI_BUSER	=> s02_axi_buser,
		S_AXI_BVALID	=> s02_axi_bvalid,
		S_AXI_BREADY	=> s02_axi_bready,
		S_AXI_ARID	=> s02_axi_arid,
		S_AXI_ARADDR	=> s02_axi_araddr,
		S_AXI_ARLEN	=> s02_axi_arlen,
		S_AXI_ARSIZE	=> s02_axi_arsize,
		S_AXI_ARBURST	=> s02_axi_arburst,
		S_AXI_ARLOCK	=> s02_axi_arlock,
		S_AXI_ARCACHE	=> s02_axi_arcache,
		S_AXI_ARPROT	=> s02_axi_arprot,
		S_AXI_ARQOS	=> s02_axi_arqos,
		S_AXI_ARREGION	=> s02_axi_arregion,
		S_AXI_ARUSER	=> s02_axi_aruser,
		S_AXI_ARVALID	=> s02_axi_arvalid,
		S_AXI_ARREADY	=> s02_axi_arready,
		S_AXI_RID	=> s02_axi_rid,
		S_AXI_RDATA	=> s02_axi_rdata,
		S_AXI_RRESP	=> s02_axi_rresp,
		S_AXI_RLAST	=> s02_axi_rlast,
		S_AXI_RUSER	=> s02_axi_ruser,
		S_AXI_RVALID	=> s02_axi_rvalid,
		S_AXI_RREADY	=> s02_axi_rready
	);

comblock_i: entity work.comblock
    generic map (
        ENABLE_DRAM                 => C_ENABLE_DRAM,
        ENABLE_FIFO_FPGA_TO_PROC    => C_ENABLE_FIFO_FPGA_TO_PROC,
        ENABLE_FIFO_PROC_TO_FPGA    => C_ENABLE_FIFO_PROC_TO_FPGA,
        REGS_DATA_WIDTH             => C_REGS_DATA_WIDTH,
        DRAM_DATA_WIDTH             => C_DRAM_DATA_WIDTH,
        DRAM_ADDR_WIDTH             => C_DRAM_ADDR_WIDTH,
        DRAM_DEPTH                  => C_DRAM_DEPTH,
        FIFO_DATA_WIDTH             => C_FIFO_DATA_WIDTH,
        FIFO_DEPTH                  => C_FIFO_DEPTH,
        FIFO_AFULLOFFSET            => C_FIFO_AFULLOFFSET,
        FIFO_AEMPTYOFFSET           => C_FIFO_AEMPTYOFFSET
   )
   port map (
      -- regs side a
      a_reg0_i          => reg0_i,
      a_reg1_i          => reg1_i,
      a_reg2_i          => reg2_i,
      a_reg3_i          => reg3_i,
      a_reg4_i          => reg4_i,
      a_reg5_i          => reg5_i,
      a_reg6_i          => reg6_i,
      a_reg7_i          => reg7_i,
      a_reg8_i          => reg8_i,
      a_reg9_i          => reg9_i,
      a_reg0_o          => reg0_o,
      a_reg1_o          => reg1_o,
      a_reg2_o          => reg2_o,
      a_reg3_o          => reg3_o,
      a_reg4_o          => reg4_o,
      a_reg5_o          => reg5_o,
      a_reg6_o          => reg6_o,
      a_reg7_o          => reg7_o,
      a_reg8_o          => reg8_o,
      a_reg9_o          => reg9_o,
      -- regs side b
      b_reg0_i          => reg0_a2c,
      b_reg1_i          => reg1_a2c,
      b_reg2_i          => reg2_a2c,
      b_reg3_i          => reg3_a2c,
      b_reg4_i          => reg4_a2c,
      b_reg5_i          => reg5_a2c,
      b_reg6_i          => reg6_a2c,
      b_reg7_i          => reg7_a2c,
      b_reg8_i          => reg8_a2c,
      b_reg9_i          => reg9_a2c,
      b_reg0_o          => reg0_c2a,
      b_reg1_o          => reg1_c2a,
      b_reg2_o          => reg2_c2a,
      b_reg3_o          => reg3_c2a,
      b_reg4_o          => reg4_c2a,
      b_reg5_o          => reg5_c2a,
      b_reg6_o          => reg6_c2a,
      b_reg7_o          => reg7_c2a,
      b_reg8_o          => reg8_c2a,
      b_reg9_o          => reg9_c2a,
      -- true dual ram side a
      a_ram_clk_i       => ram_clk_i,
      a_ram_we_i        => ram_we_i,
      a_ram_addr_i      => ram_addr_i,
      a_ram_data_i      => ram_data_i,
      a_ram_data_o      => ram_data_o,
      -- true dual ram side b
      b_ram_clk_i       => s01_axi_aclk,
      b_ram_we_i        => ram_we_a2c,
      b_ram_addr_i      => ram_addr_a2c,
      b_ram_data_i      => ram_data_a2c,
      b_ram_data_o      => ram_data_c2a,
      -- fifo1 side a
      a_fifo1_clk_i     => fifo_clk_i,
      a_fifo1_clear_i   => fifo_clear_i,
      a_fifo1_we_i      => fifo_we_i,
      a_fifo1_data_i    => fifo_data_i,
      a_fifo1_full_o    => fifo_full_o,
      a_fifo1_afull_o   => fifo_afull_o,
      a_fifo1_overflow_o=> fifo_overflow_o,
      -- fifo1 side b
      b_fifo1_clk_i     => s02_axi_aclk,
      b_fifo1_clear_i   => fifo_clear_a2c,
      b_fifo1_re_i      => fifo_re_a2c,
      b_fifo1_data_o    => fifo_data_c2a,
      -- fifo2 side a
      a_fifo2_clk_i     => fifo_clk_i,
      a_fifo2_clear_i   => fifo_clear_i,
      a_fifo2_re_i      => fifo_re_i,
      a_fifo2_data_o    => fifo_data_o,
      a_fifo2_empty_o   => fifo_empty_o,
      a_fifo2_aempty_o   => fifo_aempty_o, 
      a_fifo2_underflow_o=> fifo_underflow_o,
      -- fifo2 side b
      b_fifo2_clk_i     => s02_axi_aclk,
      b_fifo2_clear_i   => fifo_clear_a2c,
      b_fifo2_we_i      => fifo_we_a2c,
      b_fifo2_data_i    => fifo_data_a2c,
      -- fifo shared status
      b_fifo_stat_o     => fifo_stat_c2a
   );

   fifo_clear_a2c <= not s02_axi_aresetn;

end arch_imp;
