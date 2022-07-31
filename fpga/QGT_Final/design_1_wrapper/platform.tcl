# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final/design_1_wrapper/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final/design_1_wrapper/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {design_1_wrapper}\
-hw {/home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final/design_1_wrapper.xsa}\
-out {/home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {design_1_wrapper}
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
platform generate -quick
platform generate
platform active {design_1_wrapper}
platform config -updatehw {/home/agustin/Escritorio/Github/QMARL/fpga/QGT_Final/design_1_wrapper.xsa}
platform generate -domains 
