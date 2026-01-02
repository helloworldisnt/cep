# ==============================================================================
# PIN PLACEMENT SCRIPT (Final Robust Version)
# ==============================================================================

# 1. Define IO Sites
# We use the correct site name we found earlier: sg13g2_ioSite
make_io_sites \
    -horizontal_site sg13g2_ioSite \
    -vertical_site   sg13g2_ioSite \
    -corner_site     sg13g2_ioSite \
    -offset          0

# 2. Place Pads by Edge
# CRITICAL FIX: We explicitly define the -master for every pad.
# This ensures missing pads are recreated with the CORRECT type.

# --- NORTH EDGE (Outputs + Core Power) ---
puts ">>> Placing North Pads..."
# Signal Outputs (Data) -> sg13g2_IOPadOut4mA
place_pad -master sg13g2_IOPadOut4mA -row IO_NORTH -location  400.0 {pad_arr0_0}
place_pad -master sg13g2_IOPadOut4mA -row IO_NORTH -location  700.0 {pad_arr0_1}
place_pad -master sg13g2_IOPadOut4mA -row IO_NORTH -location 1000.0 {pad_arr0_2}
place_pad -master sg13g2_IOPadOut4mA -row IO_NORTH -location 1300.0 {pad_arr0_3}
# Core Power (Logic Supply) -> sg13g2_IOPadVdd / sg13g2_IOPadVss
place_pad -master sg13g2_IOPadVdd    -row IO_NORTH -location 1600.0 {pad_vdd0}
place_pad -master sg13g2_IOPadVss    -row IO_NORTH -location 1900.0 {pad_vss0}

# --- EAST EDGE (Outputs + IO Power) ---
puts ">>> Placing East Pads..."
place_pad -master sg13g2_IOPadOut4mA -row IO_EAST  -location  400.0 {pad_arr1_0}
place_pad -master sg13g2_IOPadOut4mA -row IO_EAST  -location  700.0 {pad_arr1_1}
place_pad -master sg13g2_IOPadOut4mA -row IO_EAST  -location 1000.0 {pad_arr1_2}
place_pad -master sg13g2_IOPadOut4mA -row IO_EAST  -location 1300.0 {pad_arr1_3}
# IO Power (Ring Supply) -> sg13g2_IOPadIOVdd / sg13g2_IOPadIOVss
place_pad -master sg13g2_IOPadIOVdd  -row IO_EAST  -location 1600.0 {pad_vddio0}
place_pad -master sg13g2_IOPadIOVss  -row IO_EAST  -location 1900.0 {pad_vssio0}

# --- SOUTH EDGE (Outputs + Inputs) ---
puts ">>> Placing South Pads..."
place_pad -master sg13g2_IOPadOut4mA -row IO_SOUTH -location  400.0 {pad_arr2_0}
place_pad -master sg13g2_IOPadOut4mA -row IO_SOUTH -location  700.0 {pad_arr2_1}
place_pad -master sg13g2_IOPadOut4mA -row IO_SOUTH -location 1000.0 {pad_arr2_2}
place_pad -master sg13g2_IOPadOut4mA -row IO_SOUTH -location 1300.0 {pad_arr2_3}
# Inputs (Control) -> sg13g2_IOPadIn
place_pad -master sg13g2_IOPadIn     -row IO_SOUTH -location 1600.0 {pad_clk}
place_pad -master sg13g2_IOPadIn     -row IO_SOUTH -location 1900.0 {pad_reset}

# --- WEST EDGE (Outputs + Redundant Power) ---
puts ">>> Placing West Pads..."
place_pad -master sg13g2_IOPadOut4mA -row IO_WEST  -location  300.0 {pad_arr3_0}
place_pad -master sg13g2_IOPadOut4mA -row IO_WEST  -location  550.0 {pad_arr3_1}
place_pad -master sg13g2_IOPadOut4mA -row IO_WEST  -location  800.0 {pad_arr3_2}
place_pad -master sg13g2_IOPadOut4mA -row IO_WEST  -location 1050.0 {pad_arr3_3}
# Core Power
place_pad -master sg13g2_IOPadVdd    -row IO_WEST  -location 1300.0 {pad_vdd1}
place_pad -master sg13g2_IOPadVss    -row IO_WEST  -location 1550.0 {pad_vss1}
# IO Power
place_pad -master sg13g2_IOPadIOVdd  -row IO_WEST  -location 1800.0 {pad_vddio1}
place_pad -master sg13g2_IOPadIOVss  -row IO_WEST  -location 2050.0 {pad_vssio1}

# 3. Place Corner Cells
puts ">>> Placing Corner Cells..."
place_corners sg13g2_Corner

# 4. Fill the Gaps
puts ">>> Placing IO Filler Cells..."
# Using the list 'iofill' defined in init_tech.tcl
place_io_fill -row IO_NORTH {*}$iofill
place_io_fill -row IO_SOUTH {*}$iofill
place_io_fill -row IO_WEST  {*}$iofill
place_io_fill -row IO_EAST  {*}$iofill

# 5. Connect the Pad Ring
connect_by_abutment

puts ">>> Pin Placement Complete."