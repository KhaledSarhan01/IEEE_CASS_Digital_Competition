onerror {resume}
radix define fixed#7#decimal#signed -fixed -fraction 7 -signed -base signed -precision 4
radix define fixed#4#decimal -fixed -fraction 4 -base signed -precision 6
radix define fixed#11#decimal#signed -fixed -fraction 11 -signed -base signed -precision 6
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_CNN/clk
add wave -noupdate /tb_CNN/rst
add wave -noupdate /tb_CNN/clear
add wave -noupdate -divider Y
add wave -noupdate /tb_CNN/y1
add wave -noupdate -radix fixed#4#decimal /tb_CNN/y2
add wave -noupdate -radix fixed#4#decimal /tb_CNN/y3
add wave -noupdate -radix fixed#4#decimal /tb_CNN/y4
add wave -noupdate -radix fixed#4#decimal /tb_CNN/y5
add wave -noupdate -radix fixed#4#decimal /tb_CNN/y6
add wave -noupdate -divider X
add wave -noupdate /tb_CNN/x1
add wave -noupdate -radix fixed#7#decimal#signed /tb_CNN/x2
add wave -noupdate -radix fixed#7#decimal#signed /tb_CNN/x3
add wave -noupdate -radix fixed#7#decimal#signed /tb_CNN/x4
add wave -noupdate -radix fixed#7#decimal#signed /tb_CNN/x5
add wave -noupdate -divider C
add wave -noupdate /tb_CNN/c1
add wave -noupdate -radix fixed#11#decimal#signed /tb_CNN/c2
add wave -noupdate -radix fixed#11#decimal#signed /tb_CNN/c3
add wave -noupdate -radix fixed#11#decimal#signed /tb_CNN/c4
add wave -noupdate -divider Internals
add wave -noupdate -group x_reg -radix fixed#7#decimal#signed /tb_CNN/DUT/x1_reg
add wave -noupdate -group x_reg -radix fixed#7#decimal#signed /tb_CNN/DUT/x2_reg
add wave -noupdate -group x_reg -radix fixed#7#decimal#signed /tb_CNN/DUT/x3_reg
add wave -noupdate -group x_reg -radix fixed#7#decimal#signed /tb_CNN/DUT/x4_reg
add wave -noupdate -group x_reg -radix fixed#7#decimal#signed /tb_CNN/DUT/x5_reg
add wave -noupdate -group y_reg -radix fixed#4#decimal /tb_CNN/DUT/y1_reg
add wave -noupdate -group y_reg -radix fixed#4#decimal /tb_CNN/DUT/y2_reg
add wave -noupdate -group y_reg -radix fixed#4#decimal /tb_CNN/DUT/y3_reg
add wave -noupdate -group y_reg -radix fixed#4#decimal /tb_CNN/DUT/y4_reg
add wave -noupdate -group y_reg -radix fixed#4#decimal /tb_CNN/DUT/y5_reg
add wave -noupdate -group y_reg -radix fixed#4#decimal /tb_CNN/DUT/y6_reg
add wave -noupdate -group c1 -radix fixed#11#decimal#signed /tb_CNN/DUT/c1_1
add wave -noupdate -group c1 -radix fixed#11#decimal#signed /tb_CNN/DUT/c1_2
add wave -noupdate -group c1 -radix fixed#11#decimal#signed /tb_CNN/DUT/c1_3
add wave -noupdate -group c1 -radix fixed#11#decimal#signed /tb_CNN/DUT/c1_4
add wave -noupdate -group c1 -radix fixed#11#decimal#signed /tb_CNN/DUT/c1_5
add wave -noupdate -expand -group c2 -radix fixed#11#decimal#signed /tb_CNN/DUT/c2_1
add wave -noupdate -expand -group c2 -radix fixed#11#decimal#signed /tb_CNN/DUT/c2_2
add wave -noupdate -expand -group c2 -radix fixed#11#decimal#signed /tb_CNN/DUT/c2_3
add wave -noupdate -expand -group c2 -radix fixed#11#decimal#signed /tb_CNN/DUT/c2_4
add wave -noupdate -expand -group c2 -radix fixed#11#decimal#signed /tb_CNN/DUT/c2_5
add wave -noupdate -group c3 -radix fixed#11#decimal#signed /tb_CNN/DUT/c3_1
add wave -noupdate -group c3 -radix fixed#11#decimal#signed /tb_CNN/DUT/c3_2
add wave -noupdate -group c3 -radix fixed#11#decimal#signed /tb_CNN/DUT/c3_3
add wave -noupdate -group c3 -radix fixed#11#decimal#signed /tb_CNN/DUT/c3_4
add wave -noupdate -group c3 -radix fixed#11#decimal#signed /tb_CNN/DUT/c3_5
add wave -noupdate -group c4 -radix fixed#11#decimal#signed /tb_CNN/DUT/c4_1
add wave -noupdate -group c4 -radix fixed#11#decimal#signed /tb_CNN/DUT/c4_2
add wave -noupdate -group c4 -radix fixed#11#decimal#signed /tb_CNN/DUT/c4_3
add wave -noupdate -group c4 -radix fixed#11#decimal#signed /tb_CNN/DUT/c4_4
add wave -noupdate -group c4 -radix fixed#11#decimal#signed /tb_CNN/DUT/c4_5
add wave -noupdate -divider PE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {105 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 98
configure wave -valuecolwidth 88
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {18 ns} {143 ns}
