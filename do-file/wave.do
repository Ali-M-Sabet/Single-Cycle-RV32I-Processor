add wave -divider {Clock and reset}
add wave sim:/cpu_tb/clk
add wave -label reset_n sim:/cpu_tb/reset

add wave -divider {Instruction and branch}
add wave -radix hexadecimal sim:/cpu_tb/dut/PC sim:/cpu_tb/dut/Instr
add wave sim:/cpu_tb/dut/take_branch

add wave -divider {Fibonacci registers}
add wave -radix unsigned -label x1 {sim:/cpu_tb/dut/reg_file/regfile[1]}
add wave -radix unsigned -label x2 {sim:/cpu_tb/dut/reg_file/regfile[2]}
add wave -radix unsigned -label x5 {sim:/cpu_tb/dut/reg_file/regfile[5]}

add wave -divider {Data memory}
add wave sim:/cpu_tb/dut/memory_write
add wave -radix hexadecimal -label store_address sim:/cpu_tb/dut/ALUResult
add wave -radix unsigned -label store_data sim:/cpu_tb/dut/RD2
for {set i 0} {$i < 10} {incr i} {
    add wave -radix unsigned -label [format {RAM[%d]} $i] [format {sim:/cpu_tb/dut/data_memory/data_memory[%d]} $i]
}
