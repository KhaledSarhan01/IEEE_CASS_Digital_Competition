
vlib work
vlog -f sourcefile.txt -svinputport=relaxed
vsim -voptargs=+acc work.tb_PE
add wave *
run -all
