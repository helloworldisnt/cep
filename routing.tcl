#read_db  out/cts/pocessor.cts.odb
#read_sdc out/cts/pocessor.cts.sdc

make_tracks

set_routing_layers -signal Metal1-TopMetal2 -clock Metal1-TopMetal2

set_global_routing_layer_adjustment Metal1 0.9

# --- Middle (Signal Highway) ---
# Low penalty: This is where we want the wires to go.
set_global_routing_layer_adjustment Metal2 0.3
set_global_routing_layer_adjustment Metal3 0.3
set_global_routing_layer_adjustment Metal4 0.3
set_global_routing_layer_adjustment Metal5 0.3

# --- Top (Bond Pads) ---
# Extreme penalty: We only go here because the Pin is physically here.
# We do NOT want to route signals on these massive power layers.
set_global_routing_layer_adjustment TopMetal1 0.9
set_global_routing_layer_adjustment TopMetal2 0.9

# 4. Run Global Route
global_route -congestion_report_file reports/routing/congestion.rpt -allow_congestion


estimate_parasitics -global_routing
repair_timing -hold -hold_margin 0.05 -repair_tns 100
check_placement -verbose

estimate_parasitics -global_routing
check_antennas
repair_antennas

set_thread_count 1
detailed_route -output_drc reports/drc.rpt \
               -bottom_routing_layer Metal1 \
               -top_routing_layer TopMetal2 \
               -verbose 1

filler_placement {sg13g2_fill_8 sg13g2_fill_4 sg13g2_fill_2 sg13g2_fill_1}
global_connect

write_def out/routing/proc.def
write_verilog out/routing/proc_finalnet.v
write_verilog -include_pwr_gnd out/routing/proc_lvs.v
write_sdc out/routing/proc.sdc
write_db out/routing/proc.odb

