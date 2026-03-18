
vlib work
vlog -f sourcefile.txt -svinputport=relaxed
vsim -voptargs=+acc work.tb_CNN
add wave *
run -all
