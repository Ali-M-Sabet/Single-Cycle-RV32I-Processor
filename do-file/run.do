# Run from the repository root.
if {[file exists work]} {
    vdel -all -lib work
}
vlib work
vlog rtl/*.v
vlog -sv tb/cpu_tb.sv
vsim -onfinish stop -voptargs=+acc work.cpu_tb
do do-file/wave.do
run -all
