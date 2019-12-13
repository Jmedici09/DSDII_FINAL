# //////////////////////////////////////////////////////////////////////////////////
# // Company: Binghamton University
# // Engineer: James Medici
# //		   Walter Keyes
# // 
# // Create Date: 11/21/2019 12:33:44 PM
# // Module Name: constraints.xdc
# // Project Name: Final Project
# // Description: Creates clock constraint
# //////////////////////////////////////////////////////////////////////////////////

create_clock -name system_clk -period 4 -waveform {0 2} [get_ports clk]