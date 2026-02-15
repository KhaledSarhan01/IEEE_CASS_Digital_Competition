onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_MAC/clk
add wave -noupdate /tb_MAC/rst
add wave -noupdate /tb_MAC/weight_en
add wave -noupdate /tb_MAC/weight_real
add wave -noupdate /tb_MAC/bais_real
add wave -noupdate /tb_MAC/feature_real
add wave -noupdate /tb_MAC/bais_en
add wave -noupdate /tb_MAC/MAC_out
add wave -noupdate /tb_MAC/real_expected
add wave -noupdate /tb_MAC/real_got
add wave -noupdate /tb_MAC/error_count
add wave -noupdate -divider Internals
add wave -noupdate /tb_MAC/uut/clk
add wave -noupdate /tb_MAC/uut/rst
add wave -noupdate /tb_MAC/uut/feature_in
add wave -noupdate /tb_MAC/uut/weight
add wave -noupdate /tb_MAC/uut/weight_en
add wave -noupdate /tb_MAC/uut/bais
add wave -noupdate /tb_MAC/uut/bais_en
add wave -noupdate /tb_MAC/uut/MAC_out
add wave -noupdate /tb_MAC/uut/bais_qs4_11
add wave -noupdate /tb_MAC/uut/feature_in_reg
add wave -noupdate /tb_MAC/uut/weight_reg
add wave -noupdate /tb_MAC/uut/product
add wave -noupdate /tb_MAC/uut/product_comb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {45 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 100
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
WaveRestoreZoom {0 ns} {96 ns}
