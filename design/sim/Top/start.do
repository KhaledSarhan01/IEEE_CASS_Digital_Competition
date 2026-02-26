vlib work
vlog -f sourcefile.txt -svinputport=relaxed
vsim -voptargs=+acc work.tb_LeNet
add wave *
run -all
