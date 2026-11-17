module data_mem (
    input CLK, WE,
    input [31:0] A, WD,
    output wire [31:0] RD
);
    reg [31:0] data_memory [0:63];
    wire valid_address = (A[31:8] == 0) && (A[1:0] == 0);

    always @(posedge CLK) begin
        if (WE)
            data_memory[A[7:2]] <= WD;
    end

    assign RD = valid_address ? data_memory[A[7:2]] : 32'b0;
endmodule
