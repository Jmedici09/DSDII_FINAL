#cd "C:\\Users\\James\\Documents\\College Semesters\\11 Fall 2019\\EECE 573 DSD2\\Assignments\\Final Project\\Tcl"
# run with "vivado -mode tcl -source synth.tcl"
# run with "vivado -mode batch -source synth.tcl"


# Includes
#source vivado_init.tcl

# Set input directories
set sourceInputDir "../src/Sources"
set constraintsInputDir "../src/Constraints"

# Set output directory
set outputDir "./Reports"
file mkdir $outputDir

# Set up design sources and constraints
read_verilog $sourceInputDir/top.v
read_constraints $constraintsInputDir/constraints.xdc
# ----------------------------------------------------- #
#FSM Type: auto

#Step 3: Synth Design
synth_design -fsm_extraction auto -directive AreaOptimized_high -top arbiter2 > $outputDir/synth_out_auto.rpt

# Write design checkpoint
#good design to write a checkpoint after synth, implementation, and bitstream
write_checkpoint -force $outputDir/synth_checkpoint_auto.dcp

# Report to csv file
report_utilization -file $outputDir/synth_utilization_auto.rpt

# ----------------------------------------------------- #
#FSM Type: off

#Step 3: Synth Design
synth_design -fsm_extraction off -directive AreaOptimized_high  -top arbiter2 > $outputDir/synth_out_off.rpt

# Write design checkpoint
#good design to write a checkpoint after synth, implementation, and bitstream
write_checkpoint -force $outputDir/synth_checkpoint_off.dcp

# Report to csv file
report_utilization -file $outputDir/synth_utilization_off.rpt


# ----------------------------------------------------- #
#FSM Type: one_hot

#Step 3: Synth Design
synth_design -fsm_extraction one_hot -directive AreaOptimized_high  -top arbiter2 > $outputDir/synth_out_one_hot.rpt

# Write design checkpoint
#good design to write a checkpoint after synth, implementation, and bitstream
write_checkpoint -force $outputDir/synth_checkpoint_one_hot.dcp

# Report to csv file
report_utilization -file $outputDir/synth_utilization_one_hot.rpt

# ----------------------------------------------------- #
#FSM Type: sequential

#Step 3: Synth Design
synth_design -fsm_extraction sequential -directive AreaOptimized_high  -top arbiter2 > $outputDir/synth_out_sequential.rpt

# Write design checkpoint
#good design to write a checkpoint after synth, implementation, and bitstream
write_checkpoint -force $outputDir/synth_checkpoint_sequential.dcp

# Report to csv file
report_utilization -file $outputDir/synth_utilization_sequential.rpt

# ----------------------------------------------------- #
#FSM Type: johnson

#Step 3: Synth Design
synth_design -fsm_extraction johnson -directive AreaOptimized_high  -top arbiter2 > $outputDir/synth_out_johnson.rpt

# Write design checkpoint
#good design to write a checkpoint after synth, implementation, and bitstream
write_checkpoint -force $outputDir/synth_checkpoint_johnson.dcp

# Report to csv file
report_utilization -file $outputDir/synth_utilization_johnson.rpt

# ----------------------------------------------------- #
#FSM Type: gray

#Step 3: Synth Design
synth_design -fsm_extraction gray -directive AreaOptimized_high  -top arbiter2 > $outputDir/synth_out_gray.rpt

# Write design checkpoint
#good design to write a checkpoint after synth, implementation, and bitstream
write_checkpoint -force $outputDir/synth_checkpoint_gray.dcp

# Report to csv file
report_utilization -file $outputDir/synth_utilization_gray.rpt
