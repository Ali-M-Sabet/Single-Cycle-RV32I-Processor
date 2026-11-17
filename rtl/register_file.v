module register_file (
    input CLK, areset, WE3,
    input [4:0] A1, A2, A3,
    input [31:0] WD3,
    output wire [31:0] RD1, RD2
);
    reg [31:0] regfile [0:31];
    integer i;

    assign RD1 = regfile[A1];
    assign RD2 = regfile[A2];

    always @(posedge CLK or negedge areset) begin
        if (!areset) begin
            for (i = 0; i < 32; i = i + 1)
                regfile[i] <= 32'b0;
        end else if (WE3 && A3 != 5'd0) begin
            regfile[A3] <= WD3;
        end
    end
endmodule
