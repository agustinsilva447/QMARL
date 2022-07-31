# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final/QGT_final_system/_ide/scripts/debugger_qgt_final-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final/QGT_final_system/_ide/scripts/debugger_qgt_final-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Xilinx TUL 1234-tulA" && level==0 && jtag_device_ctx=="jsn-TUL-1234-tulA-23727093-0"}
fpga -file /home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final/QGT_final/_ide/bitstream/design_1_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw /home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final/design_1_wrapper/export/design_1_wrapper/hw/design_1_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source /home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final/QGT_final/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow /home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final/QGT_final/Debug/QGT_final.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
