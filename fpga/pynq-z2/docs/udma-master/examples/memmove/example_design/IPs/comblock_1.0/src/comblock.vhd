library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library FPGALIB;
use FPGALIB.mems.all;

entity comblock is
   generic (
      ENABLE_DRAM               : boolean:=TRUE;
      ENABLE_FIFO_FPGA_TO_PROC  : boolean:=TRUE;
      ENABLE_FIFO_PROC_TO_FPGA  : boolean:=FALSE;
      REGS_DATA_WIDTH           : integer:=32;
      DRAM_DATA_WIDTH           : integer:=32;
      DRAM_ADDR_WIDTH           : integer:=16;
      DRAM_DEPTH                : integer:=0;
      FIFO_DATA_WIDTH           : integer:=16;
      FIFO_DEPTH                : integer:=1024;
      FIFO_AFULLOFFSET          : integer:=1;
      FIFO_AEMPTYOFFSET         : integer:=1
   );
   port (
      -- regs side a
      a_reg0_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg1_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg2_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg3_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg4_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg5_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg6_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg7_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg8_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg9_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg0_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg1_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg2_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg3_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg4_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg5_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg6_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg7_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg8_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      a_reg9_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      -- regs side b
      b_reg0_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg1_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg2_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg3_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg4_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg5_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg6_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg7_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg8_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg9_i           :  in std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg0_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg1_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg2_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg3_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg4_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg5_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg6_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg7_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg8_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      b_reg9_o           : out std_logic_vector(REGS_DATA_WIDTH-1 downto 0);
      -- true dual ram side a
      a_ram_clk_i        :  in std_logic;
      a_ram_we_i         :  in std_logic;
      a_ram_addr_i       :  in std_logic_vector(DRAM_ADDR_WIDTH-1 downto 0);
      a_ram_data_i       :  in std_logic_vector(DRAM_DATA_WIDTH-1 downto 0);
      a_ram_data_o       : out std_logic_vector(DRAM_DATA_WIDTH-1 downto 0);
      -- true dual ram side b
      b_ram_clk_i        :  in std_logic;
      b_ram_we_i         :  in std_logic;
      b_ram_addr_i       :  in std_logic_vector(DRAM_ADDR_WIDTH-1 downto 0);
      b_ram_data_i       :  in std_logic_vector(DRAM_DATA_WIDTH-1 downto 0);
      b_ram_data_o       : out std_logic_vector(DRAM_DATA_WIDTH-1 downto 0);
      -- fifo1 side a
      a_fifo1_clk_i      :  in std_logic;
      a_fifo1_clear_i    :  in std_logic;
      a_fifo1_we_i       :  in std_logic;
      a_fifo1_data_i     :  in std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
      a_fifo1_full_o     : out std_logic;
      a_fifo1_afull_o    : out std_logic;
      a_fifo1_overflow_o : out std_logic;
      -- fifo1 side b
      b_fifo1_clk_i      :  in std_logic;
      b_fifo1_clear_i    :  in std_logic;
      b_fifo1_re_i       :  in std_logic;
      b_fifo1_data_o     : out std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
      -- fifo2 side a
      a_fifo2_clk_i      :  in std_logic;
      a_fifo2_clear_i    :  in std_logic;
      a_fifo2_re_i       :  in std_logic;
      a_fifo2_data_o     : out std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
      a_fifo2_empty_o    : out std_logic;
      a_fifo2_aempty_o   : out std_logic;
      a_fifo2_underflow_o: out std_logic;
      -- fifo2 side b
      b_fifo2_clk_i      :  in std_logic;
      b_fifo2_clear_i    :  in std_logic;
      b_fifo2_we_i       :  in std_logic;
      b_fifo2_data_i     :  in std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
      -- fifo shared status
      b_fifo_stat_o      : out std_logic_vector(5 downto 0)
   );
end comblock;

architecture Structural of comblock is

begin

   b_reg0_o <= a_reg0_i;
   b_reg1_o <= a_reg1_i;
   b_reg2_o <= a_reg2_i;
   b_reg3_o <= a_reg3_i;
   b_reg4_o <= a_reg4_i;
   b_reg5_o <= a_reg5_i;
   b_reg6_o <= a_reg6_i;
   b_reg7_o <= a_reg7_i;
   b_reg8_o <= a_reg8_i;
   b_reg9_o <= a_reg9_i;

   a_reg0_o <= b_reg0_i;
   a_reg1_o <= b_reg1_i;
   a_reg2_o <= b_reg2_i;
   a_reg3_o <= b_reg3_i;
   a_reg4_o <= b_reg4_i;
   a_reg5_o <= b_reg5_i;
   a_reg6_o <= b_reg6_i;
   a_reg7_o <= b_reg7_i;
   a_reg8_o <= b_reg8_i;
   a_reg9_o <= b_reg9_i;

   dram_g : if ENABLE_DRAM generate
      truedualram_i: TrueDualPortRAM
      generic map (
         AWIDTH   => DRAM_ADDR_WIDTH,
         DWIDTH   => DRAM_DATA_WIDTH,
         DEPTH    => DRAM_DEPTH
      )
      port map (
         clk1_i   => a_ram_clk_i,
         clk2_i   => b_ram_clk_i,
         wen1_i   => a_ram_we_i,
         wen2_i   => b_ram_we_i,
         addr1_i  => a_ram_addr_i,
         addr2_i  => b_ram_addr_i,
         data1_i  => a_ram_data_i,
         data2_i  => b_ram_data_i,
         data1_o  => a_ram_data_o,
         data2_o  => b_ram_data_o
      );
   end generate;

   fifo_ftp_g : if ENABLE_FIFO_FPGA_TO_PROC generate
      fifo1_i: FIFO
      generic map (
         DWIDTH       => FIFO_DATA_WIDTH,
         DEPTH        => FIFO_DEPTH,
         AEMPTYOFFSET => FIFO_AEMPTYOFFSET,
         AFULLOFFSET  => FIFO_AFULLOFFSET
      )
      port map (
         -- write side
         wr_clk_i     => a_fifo1_clk_i,
         wr_rst_i     => a_fifo1_clear_i,
         wr_en_i      => a_fifo1_we_i,
         data_i       => a_fifo1_data_i,
         full_o       => a_fifo1_full_o,
         afull_o      => a_fifo1_afull_o,
         overflow_o   => a_fifo1_overflow_o,
         -- read side
         rd_clk_i     => b_fifo1_clk_i,
         rd_rst_i     => b_fifo1_clear_i,
         rd_en_i      => b_fifo1_re_i,
         data_o       => b_fifo1_data_o,
         empty_o      => b_fifo_stat_o(0),
         aempty_o     => b_fifo_stat_o(1),
         underflow_o  => b_fifo_stat_o(2),
         valid_o      => open
      );
   end generate;

   fifo_p2g_g : if ENABLE_FIFO_PROC_TO_FPGA generate
      fifo2_i: FIFO
      generic map (
         DWIDTH       => FIFO_DATA_WIDTH,
         DEPTH        => FIFO_DEPTH,
         AEMPTYOFFSET => FIFO_AEMPTYOFFSET,
         AFULLOFFSET  => FIFO_AFULLOFFSET
      )
      port map (
         -- write side
         wr_clk_i     => b_fifo2_clk_i,
         wr_rst_i     => b_fifo2_clear_i,
         wr_en_i      => b_fifo2_we_i,
         data_i       => b_fifo2_data_i,
         full_o       => b_fifo_stat_o(3),
         afull_o      => b_fifo_stat_o(4),
         overflow_o   => b_fifo_stat_o(5),
         -- read side
         rd_clk_i     => a_fifo2_clk_i,
         rd_rst_i     => a_fifo2_clear_i,
         rd_en_i      => a_fifo2_re_i,
         data_o       => a_fifo2_data_o,
         empty_o      => a_fifo2_empty_o,
         aempty_o     => a_fifo2_aempty_o,
         underflow_o  => a_fifo2_underflow_o,
         valid_o      => open
      );
   end generate;

end Structural;