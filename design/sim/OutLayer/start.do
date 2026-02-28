
vlib work
vlog -f sourcefile.txt -svinputport=relaxed
vsim -voptargs=+acc work.tb_Output_Layer
add wave *
run -all
