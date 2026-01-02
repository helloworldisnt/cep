#read_db  out/placement/placement.placed.odb
#read_sdc out/placement/placement.placed.sdc

set_wire_rc -clock -layer Metal5
estimate_parasitics -placement

repair_clock_inverters

configure_cts_characterization -max_slew 1.5e-9 -max_cap 1.0e-12

clock_tree_synthesis -root_buf $ctsBufRoot -buf_list $ctsBuf

repair_clock_nets

report_clock_latency -clock clk_sys > reports/cts/clock_latency.rpt
report_cts -out_file reports/cts/cts_summary.rpt

#POST CTS

set_propagated_clock [all_clocks]

set_wire_rc -signal -layer Metal4
set_wire_rc -clock  -layer Metal5
estimate_parasitics -placement

#Fixing Hold Violations
repair_timing -hold -setup -verbose

detailed_placement
check_placement -verbose

report_cts
report_checks -path_group clk_sys > reports/cts/timing_post_cts.rpt

report_design_area > reports/cts/area.rpt
report_power -corner tt > reports/cts/power.rpt

write_db  out/cts/pocessor.cts.odb
write_sdc out/cts/pocessor.cts.sdc