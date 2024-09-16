vlib work 
vlog -f sourcefile.txt
vsim -voptargs=+accs work.AHBSlave_tb
add wave *
run -all