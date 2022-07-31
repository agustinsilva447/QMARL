# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "C_REGS_DATA_WIDTH"
  set C_ENABLE_DRAM [ipgui::add_param $IPINST -name "C_ENABLE_DRAM"]
  set_property tooltip {Enables the use of the True Dual Port RAM} ${C_ENABLE_DRAM}
  ipgui::add_param $IPINST -name "C_DRAM_DATA_WIDTH"
  ipgui::add_param $IPINST -name "C_DRAM_ADDR_WIDTH"
  set C_DRAM_DEPTH [ipgui::add_param $IPINST -name "C_DRAM_DEPTH"]
  set_property tooltip {0 for max DEPTH according to Address width} ${C_DRAM_DEPTH}
  set C_ENABLE_FIFO_FPGA_TO_PROC [ipgui::add_param $IPINST -name "C_ENABLE_FIFO_FPGA_TO_PROC"]
  set_property tooltip {Enables the FIFO with direction from the FPGA to the PROC} ${C_ENABLE_FIFO_FPGA_TO_PROC}
  set C_ENABLE_FIFO_PROC_TO_FPGA [ipgui::add_param $IPINST -name "C_ENABLE_FIFO_PROC_TO_FPGA"]
  set_property tooltip {Enables the FIFO with direction from the PROC to the FPGA} ${C_ENABLE_FIFO_PROC_TO_FPGA}
  ipgui::add_param $IPINST -name "C_FIFO_DATA_WIDTH"
  ipgui::add_param $IPINST -name "C_FIFO_DEPTH"
  set C_FIFO_AEMPTYOFFSET [ipgui::add_param $IPINST -name "C_FIFO_AEMPTYOFFSET"]
  set_property tooltip {Programmable FIFO Almost Empty Offset} ${C_FIFO_AEMPTYOFFSET}
  set C_FIFO_AFULLOFFSET [ipgui::add_param $IPINST -name "C_FIFO_AFULLOFFSET"]
  set_property tooltip {Programmable FIFO Almost Full Offset} ${C_FIFO_AFULLOFFSET}

}

proc update_PARAM_VALUE.C_DRAM_ADDR_WIDTH { PARAM_VALUE.C_DRAM_ADDR_WIDTH } {
	# Procedure called to update C_DRAM_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DRAM_ADDR_WIDTH { PARAM_VALUE.C_DRAM_ADDR_WIDTH } {
	# Procedure called to validate C_DRAM_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_DRAM_DATA_WIDTH { PARAM_VALUE.C_DRAM_DATA_WIDTH } {
	# Procedure called to update C_DRAM_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DRAM_DATA_WIDTH { PARAM_VALUE.C_DRAM_DATA_WIDTH } {
	# Procedure called to validate C_DRAM_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_DRAM_DEPTH { PARAM_VALUE.C_DRAM_DEPTH } {
	# Procedure called to update C_DRAM_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DRAM_DEPTH { PARAM_VALUE.C_DRAM_DEPTH } {
	# Procedure called to validate C_DRAM_DEPTH
	return true
}

proc update_PARAM_VALUE.C_ENABLE_DRAM { PARAM_VALUE.C_ENABLE_DRAM } {
	# Procedure called to update C_ENABLE_DRAM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_DRAM { PARAM_VALUE.C_ENABLE_DRAM } {
	# Procedure called to validate C_ENABLE_DRAM
	return true
}

proc update_PARAM_VALUE.C_ENABLE_FIFO_FPGA_TO_PROC { PARAM_VALUE.C_ENABLE_FIFO_FPGA_TO_PROC } {
	# Procedure called to update C_ENABLE_FIFO_FPGA_TO_PROC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_FIFO_FPGA_TO_PROC { PARAM_VALUE.C_ENABLE_FIFO_FPGA_TO_PROC } {
	# Procedure called to validate C_ENABLE_FIFO_FPGA_TO_PROC
	return true
}

proc update_PARAM_VALUE.C_ENABLE_FIFO_PROC_TO_FPGA { PARAM_VALUE.C_ENABLE_FIFO_PROC_TO_FPGA } {
	# Procedure called to update C_ENABLE_FIFO_PROC_TO_FPGA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_FIFO_PROC_TO_FPGA { PARAM_VALUE.C_ENABLE_FIFO_PROC_TO_FPGA } {
	# Procedure called to validate C_ENABLE_FIFO_PROC_TO_FPGA
	return true
}

proc update_PARAM_VALUE.C_FIFO_AEMPTYOFFSET { PARAM_VALUE.C_FIFO_AEMPTYOFFSET } {
	# Procedure called to update C_FIFO_AEMPTYOFFSET when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_FIFO_AEMPTYOFFSET { PARAM_VALUE.C_FIFO_AEMPTYOFFSET } {
	# Procedure called to validate C_FIFO_AEMPTYOFFSET
	return true
}

proc update_PARAM_VALUE.C_FIFO_AFULLOFFSET { PARAM_VALUE.C_FIFO_AFULLOFFSET } {
	# Procedure called to update C_FIFO_AFULLOFFSET when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_FIFO_AFULLOFFSET { PARAM_VALUE.C_FIFO_AFULLOFFSET } {
	# Procedure called to validate C_FIFO_AFULLOFFSET
	return true
}

proc update_PARAM_VALUE.C_FIFO_DATA_WIDTH { PARAM_VALUE.C_FIFO_DATA_WIDTH } {
	# Procedure called to update C_FIFO_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_FIFO_DATA_WIDTH { PARAM_VALUE.C_FIFO_DATA_WIDTH } {
	# Procedure called to validate C_FIFO_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_FIFO_DEPTH { PARAM_VALUE.C_FIFO_DEPTH } {
	# Procedure called to update C_FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_FIFO_DEPTH { PARAM_VALUE.C_FIFO_DEPTH } {
	# Procedure called to validate C_FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.C_REGS_DATA_WIDTH { PARAM_VALUE.C_REGS_DATA_WIDTH } {
	# Procedure called to update C_REGS_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_REGS_DATA_WIDTH { PARAM_VALUE.C_REGS_DATA_WIDTH } {
	# Procedure called to validate C_REGS_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXI_ADDR_WIDTH { PARAM_VALUE.C_S01_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S01_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXI_ADDR_WIDTH { PARAM_VALUE.C_S01_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S01_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXI_DATA_WIDTH { PARAM_VALUE.C_S01_AXI_DATA_WIDTH } {
	# Procedure called to update C_S01_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXI_DATA_WIDTH { PARAM_VALUE.C_S01_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S01_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S02_AXI_DATA_WIDTH { PARAM_VALUE.C_S02_AXI_DATA_WIDTH } {
	# Procedure called to update C_S02_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXI_DATA_WIDTH { PARAM_VALUE.C_S02_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S02_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_S01_AXI_ID_WIDTH { PARAM_VALUE.C_S01_AXI_ID_WIDTH } {
	# Procedure called to update C_S01_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXI_ID_WIDTH { PARAM_VALUE.C_S01_AXI_ID_WIDTH } {
	# Procedure called to validate C_S01_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXI_AWUSER_WIDTH { PARAM_VALUE.C_S01_AXI_AWUSER_WIDTH } {
	# Procedure called to update C_S01_AXI_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXI_AWUSER_WIDTH { PARAM_VALUE.C_S01_AXI_AWUSER_WIDTH } {
	# Procedure called to validate C_S01_AXI_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXI_ARUSER_WIDTH { PARAM_VALUE.C_S01_AXI_ARUSER_WIDTH } {
	# Procedure called to update C_S01_AXI_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXI_ARUSER_WIDTH { PARAM_VALUE.C_S01_AXI_ARUSER_WIDTH } {
	# Procedure called to validate C_S01_AXI_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXI_WUSER_WIDTH { PARAM_VALUE.C_S01_AXI_WUSER_WIDTH } {
	# Procedure called to update C_S01_AXI_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXI_WUSER_WIDTH { PARAM_VALUE.C_S01_AXI_WUSER_WIDTH } {
	# Procedure called to validate C_S01_AXI_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXI_RUSER_WIDTH { PARAM_VALUE.C_S01_AXI_RUSER_WIDTH } {
	# Procedure called to update C_S01_AXI_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXI_RUSER_WIDTH { PARAM_VALUE.C_S01_AXI_RUSER_WIDTH } {
	# Procedure called to validate C_S01_AXI_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXI_BUSER_WIDTH { PARAM_VALUE.C_S01_AXI_BUSER_WIDTH } {
	# Procedure called to update C_S01_AXI_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXI_BUSER_WIDTH { PARAM_VALUE.C_S01_AXI_BUSER_WIDTH } {
	# Procedure called to validate C_S01_AXI_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXI_BASEADDR { PARAM_VALUE.C_S01_AXI_BASEADDR } {
	# Procedure called to update C_S01_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXI_BASEADDR { PARAM_VALUE.C_S01_AXI_BASEADDR } {
	# Procedure called to validate C_S01_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S01_AXI_HIGHADDR { PARAM_VALUE.C_S01_AXI_HIGHADDR } {
	# Procedure called to update C_S01_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXI_HIGHADDR { PARAM_VALUE.C_S01_AXI_HIGHADDR } {
	# Procedure called to validate C_S01_AXI_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_S02_AXI_ID_WIDTH { PARAM_VALUE.C_S02_AXI_ID_WIDTH } {
	# Procedure called to update C_S02_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXI_ID_WIDTH { PARAM_VALUE.C_S02_AXI_ID_WIDTH } {
	# Procedure called to validate C_S02_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S02_AXI_ADDR_WIDTH { PARAM_VALUE.C_S02_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S02_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXI_ADDR_WIDTH { PARAM_VALUE.C_S02_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S02_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S02_AXI_AWUSER_WIDTH { PARAM_VALUE.C_S02_AXI_AWUSER_WIDTH } {
	# Procedure called to update C_S02_AXI_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXI_AWUSER_WIDTH { PARAM_VALUE.C_S02_AXI_AWUSER_WIDTH } {
	# Procedure called to validate C_S02_AXI_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S02_AXI_ARUSER_WIDTH { PARAM_VALUE.C_S02_AXI_ARUSER_WIDTH } {
	# Procedure called to update C_S02_AXI_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXI_ARUSER_WIDTH { PARAM_VALUE.C_S02_AXI_ARUSER_WIDTH } {
	# Procedure called to validate C_S02_AXI_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S02_AXI_WUSER_WIDTH { PARAM_VALUE.C_S02_AXI_WUSER_WIDTH } {
	# Procedure called to update C_S02_AXI_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXI_WUSER_WIDTH { PARAM_VALUE.C_S02_AXI_WUSER_WIDTH } {
	# Procedure called to validate C_S02_AXI_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S02_AXI_RUSER_WIDTH { PARAM_VALUE.C_S02_AXI_RUSER_WIDTH } {
	# Procedure called to update C_S02_AXI_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXI_RUSER_WIDTH { PARAM_VALUE.C_S02_AXI_RUSER_WIDTH } {
	# Procedure called to validate C_S02_AXI_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S02_AXI_BUSER_WIDTH { PARAM_VALUE.C_S02_AXI_BUSER_WIDTH } {
	# Procedure called to update C_S02_AXI_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXI_BUSER_WIDTH { PARAM_VALUE.C_S02_AXI_BUSER_WIDTH } {
	# Procedure called to validate C_S02_AXI_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S02_AXI_BASEADDR { PARAM_VALUE.C_S02_AXI_BASEADDR } {
	# Procedure called to update C_S02_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXI_BASEADDR { PARAM_VALUE.C_S02_AXI_BASEADDR } {
	# Procedure called to validate C_S02_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S02_AXI_HIGHADDR { PARAM_VALUE.C_S02_AXI_HIGHADDR } {
	# Procedure called to update C_S02_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXI_HIGHADDR { PARAM_VALUE.C_S02_AXI_HIGHADDR } {
	# Procedure called to validate C_S02_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S01_AXI_ID_WIDTH { MODELPARAM_VALUE.C_S01_AXI_ID_WIDTH PARAM_VALUE.C_S01_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S01_AXI_AWUSER_WIDTH { MODELPARAM_VALUE.C_S01_AXI_AWUSER_WIDTH PARAM_VALUE.C_S01_AXI_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXI_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXI_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S01_AXI_ARUSER_WIDTH { MODELPARAM_VALUE.C_S01_AXI_ARUSER_WIDTH PARAM_VALUE.C_S01_AXI_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXI_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXI_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S01_AXI_WUSER_WIDTH { MODELPARAM_VALUE.C_S01_AXI_WUSER_WIDTH PARAM_VALUE.C_S01_AXI_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXI_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXI_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S01_AXI_RUSER_WIDTH { MODELPARAM_VALUE.C_S01_AXI_RUSER_WIDTH PARAM_VALUE.C_S01_AXI_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXI_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXI_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S01_AXI_BUSER_WIDTH { MODELPARAM_VALUE.C_S01_AXI_BUSER_WIDTH PARAM_VALUE.C_S01_AXI_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXI_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXI_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S02_AXI_ID_WIDTH { MODELPARAM_VALUE.C_S02_AXI_ID_WIDTH PARAM_VALUE.C_S02_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S02_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_S02_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S02_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S02_AXI_ADDR_WIDTH PARAM_VALUE.C_S02_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S02_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S02_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S02_AXI_AWUSER_WIDTH { MODELPARAM_VALUE.C_S02_AXI_AWUSER_WIDTH PARAM_VALUE.C_S02_AXI_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S02_AXI_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_S02_AXI_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S02_AXI_ARUSER_WIDTH { MODELPARAM_VALUE.C_S02_AXI_ARUSER_WIDTH PARAM_VALUE.C_S02_AXI_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S02_AXI_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_S02_AXI_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S02_AXI_WUSER_WIDTH { MODELPARAM_VALUE.C_S02_AXI_WUSER_WIDTH PARAM_VALUE.C_S02_AXI_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S02_AXI_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_S02_AXI_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S02_AXI_RUSER_WIDTH { MODELPARAM_VALUE.C_S02_AXI_RUSER_WIDTH PARAM_VALUE.C_S02_AXI_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S02_AXI_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_S02_AXI_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S02_AXI_BUSER_WIDTH { MODELPARAM_VALUE.C_S02_AXI_BUSER_WIDTH PARAM_VALUE.C_S02_AXI_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S02_AXI_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_S02_AXI_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_ENABLE_DRAM { MODELPARAM_VALUE.C_ENABLE_DRAM PARAM_VALUE.C_ENABLE_DRAM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ENABLE_DRAM}] ${MODELPARAM_VALUE.C_ENABLE_DRAM}
}

proc update_MODELPARAM_VALUE.C_ENABLE_FIFO_FPGA_TO_PROC { MODELPARAM_VALUE.C_ENABLE_FIFO_FPGA_TO_PROC PARAM_VALUE.C_ENABLE_FIFO_FPGA_TO_PROC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ENABLE_FIFO_FPGA_TO_PROC}] ${MODELPARAM_VALUE.C_ENABLE_FIFO_FPGA_TO_PROC}
}

proc update_MODELPARAM_VALUE.C_ENABLE_FIFO_PROC_TO_FPGA { MODELPARAM_VALUE.C_ENABLE_FIFO_PROC_TO_FPGA PARAM_VALUE.C_ENABLE_FIFO_PROC_TO_FPGA } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ENABLE_FIFO_PROC_TO_FPGA}] ${MODELPARAM_VALUE.C_ENABLE_FIFO_PROC_TO_FPGA}
}

proc update_MODELPARAM_VALUE.C_REGS_DATA_WIDTH { MODELPARAM_VALUE.C_REGS_DATA_WIDTH PARAM_VALUE.C_REGS_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_REGS_DATA_WIDTH}] ${MODELPARAM_VALUE.C_REGS_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_DRAM_DATA_WIDTH { MODELPARAM_VALUE.C_DRAM_DATA_WIDTH PARAM_VALUE.C_DRAM_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DRAM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_DRAM_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_DRAM_ADDR_WIDTH { MODELPARAM_VALUE.C_DRAM_ADDR_WIDTH PARAM_VALUE.C_DRAM_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DRAM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_DRAM_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_FIFO_DATA_WIDTH { MODELPARAM_VALUE.C_FIFO_DATA_WIDTH PARAM_VALUE.C_FIFO_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_FIFO_DATA_WIDTH}] ${MODELPARAM_VALUE.C_FIFO_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_FIFO_AFULLOFFSET { MODELPARAM_VALUE.C_FIFO_AFULLOFFSET PARAM_VALUE.C_FIFO_AFULLOFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_FIFO_AFULLOFFSET}] ${MODELPARAM_VALUE.C_FIFO_AFULLOFFSET}
}

proc update_MODELPARAM_VALUE.C_FIFO_AEMPTYOFFSET { MODELPARAM_VALUE.C_FIFO_AEMPTYOFFSET PARAM_VALUE.C_FIFO_AEMPTYOFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_FIFO_AEMPTYOFFSET}] ${MODELPARAM_VALUE.C_FIFO_AEMPTYOFFSET}
}

proc update_MODELPARAM_VALUE.C_FIFO_DEPTH { MODELPARAM_VALUE.C_FIFO_DEPTH PARAM_VALUE.C_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_FIFO_DEPTH}] ${MODELPARAM_VALUE.C_FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S01_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S01_AXI_DATA_WIDTH PARAM_VALUE.C_S01_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S01_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S01_AXI_ADDR_WIDTH PARAM_VALUE.C_S01_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S02_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S02_AXI_DATA_WIDTH PARAM_VALUE.C_S02_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S02_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S02_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_DRAM_DEPTH { MODELPARAM_VALUE.C_DRAM_DEPTH PARAM_VALUE.C_DRAM_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DRAM_DEPTH}] ${MODELPARAM_VALUE.C_DRAM_DEPTH}
}

