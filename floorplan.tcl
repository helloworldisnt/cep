source init_tech.tcl

read_verilog "out/proc_openroad.v"
link_design pipeline_proc_chip

read_sdc "src/clk.sdc"
#todo: check
initialize_floorplan -utilization 40 -aspect_ratio 1.0 -core_space 215 -site CoreSite

source scripts/pin_placement.tcl

#place_pins -hor_layers Metal3 -ver_layers Metal3 -random

source scripts/global_connections.tcl

global_connect

# 2. Voltage Domains (Task 12)
set_voltage_domain -name CORE -power VDD -ground VSS

# 3. Define Grid Strategy (Task 13)
# We use Metal4 (Horizontal) and Metal5 (Vertical) for the main grid.
define_pdn_grid -name core_grid -voltage_domains {CORE}

# 4. Add Rings (Task 14)
# Thick rings around the core to carry heavy current.
add_pdn_ring -grid core_grid \
    -layers {Metal4 Metal5} \
    -widths {5.0 5.0} \
    -spacings {2.0 2.0} \
    -core_offset {2.0 2.0} \
    -connect_to_pads

# 5. Add Stripes (Task 14)
# Vertical and Horizontal stripes to distribute power across the center.
# Pitch 40um ensures good density.
add_pdn_stripe -grid core_grid \
    -layer Metal4 \
    -width 2.0 \
    -pitch 40.0 \
    -offset 5.0 \
    -extend_to_core_ring

add_pdn_stripe -grid core_grid \
    -layer Metal5 \
    -width 2.0 \
    -pitch 40.0 \
    -offset 5.0 \
    -extend_to_core_ring

# 6. Connect Standard Cells (Task 14)
# Drops vias from the grid down to the rails of the logic gates.
add_pdn_connect -grid core_grid -layers {Metal1 Metal4}
add_pdn_connect -grid core_grid -layers {Metal4 Metal5}

pdngen -failed_via_report reports/floorplan/pdngen.rpt

make_tracks
place_pins -hor_layers Metal3 -ver_layers Metal4

write_sdc out/floorplan/floorplan.pre_place.sdc
write_db  out/floorplan/floorplan.pre_place.odb