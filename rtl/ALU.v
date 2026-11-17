module ALU #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] SrcA, SrcB,
    input [2:0] ALUControl,
    output reg [WIDTH-1:0] ALUResult,
    output wire zero,
    output wire signflag
);

    localparam SHIFT_BITS = (WIDTH < 5) ? WIDTH : 5;

    always @(*) begin
        case (ALUControl)
            3'b000: ALUResult = SrcA + SrcB;
            3'b001: ALUResult = SrcA << SrcB[SHIFT_BITS-1:0];
            3'b010: ALUResult = SrcA - SrcB;
            3'b100: ALUResult = SrcA ^ SrcB;
            3'b101: ALUResult = SrcA >> SrcB[SHIFT_BITS-1:0];
            3'b110: ALUResult = SrcA | SrcB;
            3'b111: ALUResult = SrcA & SrcB;
            default: ALUResult = 0;
        endcase
    end

    assign zero = (ALUResult == 0);
    assign signflag = ALUResult[WIDTH-1];

endmodule
