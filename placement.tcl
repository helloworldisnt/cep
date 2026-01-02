#read_db  out/floorplan/floorplan.pre_place.odb
#read_sdc out/floorplan/floorplan.pre_place.sdc


set_thread_count 8

global_placement -density 0.5

report_cell_usage -file reports/placement/cellUsage_initial.rpt

set_wire_rc -signal -layer Metal4
set_wire_rc -clock  -layer Metal4
estimate_parasitics -placement

report_check_types -violators > reports/placement/drv_violations.rpt

repair_design -verbose

report_cell_usage -file reports/placement/cellUsage_fixed.rpt
report_check_types -violators > reports/placement/drv_violations_fixed.rpt

detailed_placement

check_placement -verbose

write_sdc out/placement/placement.placed.sdc
write_db  out/placement/placement.placed.odb