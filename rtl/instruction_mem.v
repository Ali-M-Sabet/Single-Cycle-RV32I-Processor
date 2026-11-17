module instruction_memory(
    input [31:0] PC,
    output reg [31:0] instr
);
    reg [31:0] instr_mem[0:63];

    integer index;
    initial begin
        for (index = 0; index < 64; index = index + 1)
            instr_mem[index] = 32'b0;
        $readmemh("programs/program.txt", instr_mem);
    end

    always @(*) begin
        instr = (PC[31:8] == 0 && PC[1:0] == 0) ? instr_mem[PC[7:2]] : 32'b0;
    end
endmodule
