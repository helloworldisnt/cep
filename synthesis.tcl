# Standard Cells (Core Logic)
yosys read_liberty -lib /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib

# I/O Pads (Typically higher voltage)
yosys read_liberty -lib /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_typ_1p5V_3p3V_25C.lib

# SRAM/Memory (If used by the core)
yosys read_liberty -lib /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_2P_64x32_c2_typ_1p20V_25C.lib

yosys plugin -i slang.so

#yosys read_slang --keep-hierarchy --top "rtl/pipeline_proc_chip" -F threesp.flist --allow-use-before-declare --ignore-unknown-modules
yosys read_slang -top pipeline_proc_chip --keep-hierarchy /foss/designs/cep/rtl/pipeline_proc_chip.sv /foss/designs/cep/rtl/*.sv

yosys tee -q -o "reports/synth_report_one.rpt" stat
yosys write_verilog "out/proc_report_one.v"

yosys hierarchy -check -top pipeline_proc_chip
yosys proc

yosys check
yosys fsm
yosys tee -q -o "reports/fsm.rpt" stat
yosys wreduce
yosys peepopt
yosys opt -noff
yosys memory
yosys opt_dff


###########################################
###### Define target clock frequency ######
###########################################

# 100MHz clock target (10000 ps) - Your performance constraint.
set period_ps 10000


##################################
###### Fine-grain synthesis ######
##################################

yosys techmap
yosys tee -q -o "reports/techmap.rpt" stat

############################
###### Flatten design ######
############################

# Flattening to enable cross-module optimization.
yosys flatten

yosys dfflibmap -liberty /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib
yosys dfflegalize

# ABC Combinational Logic Mapping
yosys abc -liberty /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib \
          -D ${period_ps} \
          -constr src/yosys_abc.constr \
          -script scripts/abc-opt.script

yosys write_verilog -noattr out/proc_mapped.v 
yosys stat -liberty /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib

#######################################
###### Prepare for OpenROAD flow ######
#######################################

yosys splitnets -ports
yosys setundef -zero
yosys hilomap -hicell sg13g2_tiehi L_HI -locell sg13g2_tielo L_LO

# Final netlist for OpenROAD
yosys write_verilog -noattr out/proc_openroad.v

exit
