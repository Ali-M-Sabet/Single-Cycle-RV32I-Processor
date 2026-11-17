module TopModule (
    input clk,
    input reset // active low
);
    wire [31:0] PC, PCNext, Instr;
    wire [31:0] ImmExt;
    wire [31:0] SrcA, SrcB;
    wire [31:0] ALUResult;
    wire [31:0] RD2, ReadData, Result;

    wire zero, signflag;
    // Opposite operand signs determine signed less-than without subtraction overflow.
    wire signed_less = (SrcA[31] ^ SrcB[31]) ? SrcA[31] : signflag;
    wire [2:0] ALUControl;
    wire [1:0] ImmSrc;
    wire ResultSrc, MemWrite, ALUSrc, RegWrite, PCSrc;

    // The 64-word RAM accepts aligned byte addresses from 0 to 252.
    wire valid_data_address = ALUResult[31:8] == 0 && ALUResult[1:0] == 0;
    wire register_write = RegWrite && (!ResultSrc || valid_data_address);
    wire memory_write = MemWrite && reset && valid_data_address;
    wire take_branch = PCSrc && (ImmExt[1:0] == 0);

    PC_reg pc_reg (
        .PCNext(PCNext),
        .CLK(clk),
        .areset(reset),
        .load(1'b1),
        .PC(PC)
    );

    instruction_memory instr_mem (
        .PC(PC),
        .instr(Instr)
    );

    ControlUnit control_unit (
        .zero(zero),
        .signflag(signed_less),
        .op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7(Instr[30]),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .PCSrc(PCSrc)
    );

    register_file reg_file (
        .CLK(clk),
        .areset(reset),
        .WE3(register_write),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WD3(Result),
        .RD1(SrcA),
        .RD2(RD2)
    );

    SignExtender sign_extender (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    Mux2x1 alu_mux (
        .In1(RD2),
        .In2(ImmExt),
        .sel(ALUSrc),
        .out(SrcB)
    );

    ALU alu (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .zero(zero),
        .signflag(signflag)
    );

    data_mem data_memory (
        .CLK(clk),
        .WE(memory_write),
        .A(ALUResult),
        .WD(RD2),
        .RD(ReadData)
    );

    Mux2x1 result_mux (
        .In1(ALUResult),
        .In2(ReadData),
        .sel(ResultSrc),
        .out(Result)
    );

    PC_Next_logic pc_next_logic (
        .PCsrc(take_branch),
        .PC(PC),
        .immExt(ImmExt),
        .PCNext(PCNext)
    );

endmodule
