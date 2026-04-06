#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20.000ns [get_ports CLOCK2_50]
create_clock -period 20.000ns [get_ports CLOCK3_50]
create_clock -period 20.000ns [get_ports CLOCK4_50]
create_clock -period 20.000ns [get_ports CLOCK_50]

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -clock { CLOCK_50 } 2 [get_ports {LEDR[9] LEDR[0] LEDR[1] LEDR[2] LEDR[3] LEDR[4] LEDR[5] LEDR[6] LEDR[7] LEDR[8] HEX5[6] HEX0[0] HEX0[1] HEX0[2] HEX0[3] HEX0[4] HEX0[5] HEX0[6] HEX1[0] HEX1[1] HEX1[2] HEX1[3] HEX1[4] HEX1[5] HEX1[6] HEX2[0] HEX2[1] HEX2[2] HEX2[3] HEX2[4] HEX2[5] HEX2[6] HEX3[0] HEX3[1] HEX3[2] HEX3[3] HEX3[4] HEX3[5] HEX3[6] HEX4[0] HEX4[1] HEX4[2] HEX4[3] HEX4[4] HEX4[5] HEX4[6] HEX5[0] HEX5[1] HEX5[2] HEX5[3] HEX5[4] HEX5[5]}]



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



