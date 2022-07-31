create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list design_1_i/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/comblock_0_reg5_o[0]} {design_1_i/comblock_0_reg5_o[1]} {design_1_i/comblock_0_reg5_o[2]} {design_1_i/comblock_0_reg5_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/comblock_0_reg1_o[0]} {design_1_i/comblock_0_reg1_o[1]} {design_1_i/comblock_0_reg1_o[2]} {design_1_i/comblock_0_reg1_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 4 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {design_1_i/comblock_0_reg3_o[0]} {design_1_i/comblock_0_reg3_o[1]} {design_1_i/comblock_0_reg3_o[2]} {design_1_i/comblock_0_reg3_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {design_1_i/comblock_0_reg4_o[0]} {design_1_i/comblock_0_reg4_o[1]} {design_1_i/comblock_0_reg4_o[2]} {design_1_i/comblock_0_reg4_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {design_1_i/QGT_state_fixpt_0_p11[0]} {design_1_i/QGT_state_fixpt_0_p11[1]} {design_1_i/QGT_state_fixpt_0_p11[2]} {design_1_i/QGT_state_fixpt_0_p11[3]} {design_1_i/QGT_state_fixpt_0_p11[4]} {design_1_i/QGT_state_fixpt_0_p11[5]} {design_1_i/QGT_state_fixpt_0_p11[6]} {design_1_i/QGT_state_fixpt_0_p11[7]} {design_1_i/QGT_state_fixpt_0_p11[8]} {design_1_i/QGT_state_fixpt_0_p11[9]} {design_1_i/QGT_state_fixpt_0_p11[10]} {design_1_i/QGT_state_fixpt_0_p11[11]} {design_1_i/QGT_state_fixpt_0_p11[12]} {design_1_i/QGT_state_fixpt_0_p11[13]} {design_1_i/QGT_state_fixpt_0_p11[14]} {design_1_i/QGT_state_fixpt_0_p11[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {design_1_i/QGT_state_fixpt_0_p00[0]} {design_1_i/QGT_state_fixpt_0_p00[1]} {design_1_i/QGT_state_fixpt_0_p00[2]} {design_1_i/QGT_state_fixpt_0_p00[3]} {design_1_i/QGT_state_fixpt_0_p00[4]} {design_1_i/QGT_state_fixpt_0_p00[5]} {design_1_i/QGT_state_fixpt_0_p00[6]} {design_1_i/QGT_state_fixpt_0_p00[7]} {design_1_i/QGT_state_fixpt_0_p00[8]} {design_1_i/QGT_state_fixpt_0_p00[9]} {design_1_i/QGT_state_fixpt_0_p00[10]} {design_1_i/QGT_state_fixpt_0_p00[11]} {design_1_i/QGT_state_fixpt_0_p00[12]} {design_1_i/QGT_state_fixpt_0_p00[13]} {design_1_i/QGT_state_fixpt_0_p00[14]} {design_1_i/QGT_state_fixpt_0_p00[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 16 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {design_1_i/QGT_state_fixpt_0_p01[0]} {design_1_i/QGT_state_fixpt_0_p01[1]} {design_1_i/QGT_state_fixpt_0_p01[2]} {design_1_i/QGT_state_fixpt_0_p01[3]} {design_1_i/QGT_state_fixpt_0_p01[4]} {design_1_i/QGT_state_fixpt_0_p01[5]} {design_1_i/QGT_state_fixpt_0_p01[6]} {design_1_i/QGT_state_fixpt_0_p01[7]} {design_1_i/QGT_state_fixpt_0_p01[8]} {design_1_i/QGT_state_fixpt_0_p01[9]} {design_1_i/QGT_state_fixpt_0_p01[10]} {design_1_i/QGT_state_fixpt_0_p01[11]} {design_1_i/QGT_state_fixpt_0_p01[12]} {design_1_i/QGT_state_fixpt_0_p01[13]} {design_1_i/QGT_state_fixpt_0_p01[14]} {design_1_i/QGT_state_fixpt_0_p01[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 4 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {design_1_i/comblock_0_reg2_o[0]} {design_1_i/comblock_0_reg2_o[1]} {design_1_i/comblock_0_reg2_o[2]} {design_1_i/comblock_0_reg2_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 4 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {design_1_i/comblock_0_reg0_o[0]} {design_1_i/comblock_0_reg0_o[1]} {design_1_i/comblock_0_reg0_o[2]} {design_1_i/comblock_0_reg0_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 16 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {design_1_i/QGT_state_fixpt_0_p10[0]} {design_1_i/QGT_state_fixpt_0_p10[1]} {design_1_i/QGT_state_fixpt_0_p10[2]} {design_1_i/QGT_state_fixpt_0_p10[3]} {design_1_i/QGT_state_fixpt_0_p10[4]} {design_1_i/QGT_state_fixpt_0_p10[5]} {design_1_i/QGT_state_fixpt_0_p10[6]} {design_1_i/QGT_state_fixpt_0_p10[7]} {design_1_i/QGT_state_fixpt_0_p10[8]} {design_1_i/QGT_state_fixpt_0_p10[9]} {design_1_i/QGT_state_fixpt_0_p10[10]} {design_1_i/QGT_state_fixpt_0_p10[11]} {design_1_i/QGT_state_fixpt_0_p10[12]} {design_1_i/QGT_state_fixpt_0_p10[13]} {design_1_i/QGT_state_fixpt_0_p10[14]} {design_1_i/QGT_state_fixpt_0_p10[15]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_FCLK_CLK0]
