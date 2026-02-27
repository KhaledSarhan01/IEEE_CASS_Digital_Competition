onerror {resume}
radix define fixed#7#decimal#signed -fixed -fraction 7 -signed -base signed -precision 6
radix define fixed#7#decimal -fixed -fraction 7 -base signed -precision 6
radix define fixed#4#decimal -fixed -fraction 4 -base signed -precision 6
radix define fixed#11#decimal -fixed -fraction 11 -base signed -precision 6
radix define fixed#11#decimal#signed -fixed -fraction 11 -signed -base signed -precision 6
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_DNN/clk
add wave -noupdate /tb_DNN/DUT/u_DNN_Control/current_state
add wave -noupdate /tb_DNN/rst
add wave -noupdate -radix fixed#4#decimal /tb_DNN/in_feature
add wave -noupdate -radix unsigned /tb_DNN/in_address
add wave -noupdate /tb_DNN/in_start
add wave -noupdate -radix hexadecimal /tb_DNN/out_feature
add wave -noupdate /tb_DNN/out_enable
add wave -noupdate -radix unsigned /tb_DNN/out_address
add wave -noupdate /tb_DNN/out_done
add wave -noupdate -divider Controls
add wave -noupdate /tb_DNN/DUT/u_DNN_Control/current_feature_done
add wave -noupdate /tb_DNN/DUT/u_DNN_Control/all_features_done
add wave -noupdate -expand -group in_features /tb_DNN/DUT/u_DNN_Control/in_feature_increament
add wave -noupdate -expand -group in_features /tb_DNN/DUT/u_DNN_Control/in_feature_restart
add wave -noupdate -expand -group in_features -radix unsigned /tb_DNN/DUT/u_DNN_Control/in_feature_count
add wave -noupdate -expand -group out_features /tb_DNN/DUT/u_DNN_Control/out_feature_increament
add wave -noupdate -expand -group out_features /tb_DNN/DUT/u_DNN_Control/out_feature_restart
add wave -noupdate -expand -group out_features /tb_DNN/DUT/u_DNN_Control/out_feature_count
add wave -noupdate -group wieght /tb_DNN/DUT/u_DNN_Control/weight_increament
add wave -noupdate -group wieght /tb_DNN/DUT/u_DNN_Control/weight_restart
add wave -noupdate -group wieght -radix unsigned /tb_DNN/DUT/u_DNN_Control/weight_count
add wave -noupdate -group bias /tb_DNN/DUT/u_DNN_Control/bias_increament
add wave -noupdate -group bias /tb_DNN/DUT/u_DNN_Control/bias_restart
add wave -noupdate -group bias /tb_DNN/DUT/u_DNN_Control/bias_count
add wave -noupdate -divider MAC
add wave -noupdate -radix fixed#4#decimal /tb_DNN/DUT/u_DNN_MAC/feature_in
add wave -noupdate -radix fixed#7#decimal#signed /tb_DNN/DUT/u_DNN_MAC/weight
add wave -noupdate -radix unsigned /tb_DNN/DUT/u_DNN_MAC/weight
add wave -noupdate /tb_DNN/DUT/u_DNN_MAC/weight_en
add wave -noupdate -radix fixed#7#decimal#signed /tb_DNN/DUT/u_DNN_MAC/bais
add wave -noupdate -radix unsigned /tb_DNN/DUT/u_DNN_MAC/bais
add wave -noupdate /tb_DNN/DUT/u_DNN_MAC/bais_en
add wave -noupdate -radix hexadecimal /tb_DNN/DUT/u_DNN_MAC/MAC_out
add wave -noupdate -radix unsigned /tb_DNN/DUT/u_DNN_MAC/MAC_out
add wave -noupdate /tb_DNN/DUT/u_DNN_MAC/bais_qs4_11
add wave -noupdate /tb_DNN/DUT/u_DNN_MAC/product
add wave -noupdate /tb_DNN/DUT/u_DNN_MAC/product_comb
add wave -noupdate /tb_DNN/DUT/u_DNN_MAC/feature_in_reg
add wave -noupdate /tb_DNN/DUT/u_DNN_MAC/weight_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {96 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 190
configure wave -valuecolwidth 116
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
WaveRestoreZoom {0 ns} {196 ns}
