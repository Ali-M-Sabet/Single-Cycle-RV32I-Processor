`timescale 1ns/1ps
module cpu_tb;
    reg clk = 0;
    reg reset = 0;

    TopModule dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        @(negedge clk);
        reset = 1;

        // Byte address 80 marks the end of the Fibonacci program.
        for (int cycle = 0; cycle < 100 && dut.PC !== 32'd80; cycle++) begin
            @(posedge clk);
            #1;
        end

        if (dut.PC !== 32'd80)
            $fatal(1, "Fibonacci program did not reach its end");
        if (dut.reg_file.regfile[1] !== 32'd55 ||
            dut.reg_file.regfile[2] !== 32'd89 ||
            dut.reg_file.regfile[5] !== 32'd10)
            $fatal(1, "Incorrect Fibonacci register results");
        if (dut.data_memory.data_memory[8] !== 32'd55 ||
            dut.data_memory.data_memory[9] !== 32'd89)
            $fatal(1, "Incorrect Fibonacci memory results");

        $display("PASS: Fibonacci program");
        $finish;
    end
endmodule
