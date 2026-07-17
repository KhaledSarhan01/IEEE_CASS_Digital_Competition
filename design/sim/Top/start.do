vlib work
vlog -f sourcefile.txt -svinputport=relaxed
vsim -t 1ps -voptargs=+acc work.tb_LeNet
add wave *
run -all
