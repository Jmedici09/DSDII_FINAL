# //////////////////////////////////////////////////////////////////////////////////
# // Company: Binghamton University
# // Engineer: James Medici
# //		   Walter Keyes
# // 
# // Create Date: 11/21/2019 12:33:44 PM
# // Module Name: synth.tcl
# // Project Name: Final Project
# // Description: Synthesizes divider.v and puts reports in ../Reports
# //
# // NOTES: RUN FROM "/Tcl" DIRECTORY
# //////////////////////////////////////////////////////////////////////////////////

# Includes
#source vivado_init.tcl

# Set input directories
set sourceInputDir "../Sources"
set constraintsInputDir "../Constraints"

# Set output directory
set outputDir "../Reports"
file mkdir $outputDir

# Set up design sources and constraints
read_verilog $sourceInputDir/divider.v

set_property part xc7a35tcpg236-2L [current_project]
# ----------------------------------------------------- #
#FSM Type: Auto

#Step 3: Synth Design
synth_design -top divider > $outputDir/synth_out.rpt

# Write design checkpoint
#good design to write a checkpoint after synth, implementation, and bitstream
write_checkpoint -force $outputDir/synth_checkpoint.dcp

read_xdc $constraintsInputDir/constraints.xdc

# Report to csv file
report_utilization -file $outputDir/synth_utilization.rpt
report_timing -file $outputDir/synth_timing.rpt

