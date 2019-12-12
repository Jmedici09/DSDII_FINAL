#cd "C:\\Users\\James\\Documents\\College Semesters\\11 Fall 2019\\EECE 573 DSD2\\Assignments\\Final Project\\Tcl"
# run with "vivado -mode tcl -source synth.tcl"
# run with "vivado -mode batch -source synth.tcl"


# Includes
#source vivado_init.tcl

# Set input directories
set sourceInputDir "../Sources"
set constraintsInputDir "../Constraints"

# Set output directory
set outputDir "../Reports"
file mkdir $outputDir

# Set up design sources and constraints
read_verilog {
	../Sources/divider.v
	../Sources/control.v
	../Sources/datapath.v
	../Sources/lrShiftSFR.v
	../Sources/lShiftSFR.v
	../Sources/subSFR.v
	../Sources/udCounterSFR.v}
read_xdc $constraintsInputDir/constraints.xdc
set_property part xc7a35tcpg236-2L [current_project]
# ----------------------------------------------------- #
##FSM Type: seq
#
##Step 3: Synth Design
#synth_design -fsm_extraction sequential -directive AreaOptimized_high -resource_sharing on -retiming -top divider > $outputDir/synth_out_seq.rpt
#
## Write design checkpoint
##good design to write a checkpoint after synth, implementation, and bitstream
#write_checkpoint -force $outputDir/synth_checkpoint_seq.dcp
#
#opt_design -sweep -resynth_area -aggressive_remap -merge_equivalent_drivers -debug_log > $outputDir/opt_out_seq.rpt
#
## Report to csv file
#report_utilization -file $outputDir/synth_utilization_seq.rpt
#report_timing -file $outputDir/synth_timing_seq.rpt
#
##FSM Type: gray
#
##Step 3: Synth Design
#synth_design -fsm_extraction gray -directive AreaOptimized_high -resource_sharing on -retiming -top divider > $outputDir/synth_out_gray.rpt
#
## Write design checkpoint
##good design to write a checkpoint after synth, implementation, and bitstream
#write_checkpoint -force $outputDir/synth_checkpoint_gray.dcp
#
#opt_design -sweep -resynth_area -aggressive_remap -merge_equivalent_drivers -debug_log > $outputDir/opt_out_gray.rpt
#
## Report to csv file
#report_utilization -file $outputDir/synth_utilization_gray.rpt
#report_timing -file $outputDir/synth_timing_gray.rpt

##FSM Type: johnson

##Step 3: Synth Design
#synth_design -fsm_extraction johnson -directive AreaOptimized_high -resource_sharing on -retiming -top divider > $outputDir/synth_out_johnson.rpt
#
## Write design checkpoint
##good design to write a checkpoint after synth, implementation, and bitstream
#write_checkpoint -force $outputDir/synth_checkpoint_johnson.dcp
#
#opt_design -sweep -resynth_area -aggressive_remap -merge_equivalent_drivers -debug_log > $outputDir/opt_out_johnson.rpt
#
## Report to csv file
#report_utilization -file $outputDir/synth_utilization_johnson.rpt
#report_timing -file $outputDir/synth_timing_johnson.rpt

#FSM Type: one-hot

#Step 3: Synth Design
synth_design -fsm_extraction one_hot -directive AreaOptimized_high -resource_sharing on -retiming -top divider > $outputDir/synth_out_one_hot.rpt

# Write design checkpoint
#good design to write a checkpoint after synth, implementation, and bitstream
#write_checkpoint -force $outputDir/synth_checkpoint_one_hot.dcp

#opt_design -sweep -resynth_area -aggressive_remap -merge_equivalent_drivers -debug_log > $outputDir/opt_out_one_hot.rpt

# Report to csv file
report_utilization -file $outputDir/synth_utilization_one_hot.rpt
report_timing -file $outputDir/synth_timing_one_hot.rpt