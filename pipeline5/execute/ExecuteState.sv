module ExecuteState #(
    parameter
    word_width = 32
) (
    input logic clk, reset,
    input logic FlushE,
    input logic RegWriteD,
    input logic [1:0] ResultSrcD,
    input logic MemWriteD,
    input logic JumpD,
    input logic BranchD,
    input logic [2:0] BranchKindD,
    input logic [3:0] ALUControlD,
    input logic ALUSrcD,
    input logic [1:0] SrcASelectD,
    input logic JalrD,
    input logic [1:0] MemSizeD,
    input logic LoadUnsignedD,
    input logic [word_width-1:0] RD1, RD2, ImmExtD,
    input logic [4:0] Rs1D, Rs2D, RdD,
    input logic [word_width-1:0] PCD, PCPlus4D,

    output logic RegWriteE,
    output logic [1:0] ResultSrcE,
    output logic MemWriteE,
    output logic [1:0] SrcASelectE,
    output logic JalrE,
    output logic [1:0] MemSizeE,
    output logic LoadUnsignedE,
    output logic JumpE,
    output logic BranchE,
    output logic [2:0] BranchKindE,
    output logic [3:0] ALUControlE,
    output logic ALUSrcE,
    output logic [word_width-1:0] RD1E, RD2E, ImmExtE,
    output logic [4:0] Rs1E, Rs2E, RdE,
    output logic [word_width-1:0] PCE, PCPlus4E
);

always_ff @(posedge clk) begin
    if (FlushE | reset) begin
        ResultSrcE <= 0;
        ALUControlE <= 0;
        ALUSrcE <= 0;
        BranchKindE <= 0;
        SrcASelectE <= 0;
        JalrE <= 0;
        MemSizeE <= 0;
        LoadUnsignedE <= 0;
        RD1E <= 0;
        RD2E <= 0;
        ImmExtE <= 0;
        Rs1E <= 0;
        Rs2E <= 0;
        RdE <= 0;
        PCE <= 0;
        PCPlus4E <= 0;
    end else begin
        ResultSrcE <= ResultSrcD;
        ALUControlE <= ALUControlD;
        ALUSrcE <= ALUSrcD;
        BranchKindE <= BranchKindD;
        SrcASelectE <= SrcASelectD;
        JalrE <= JalrD;
        MemSizeE <= MemSizeD;
        LoadUnsignedE <= LoadUnsignedD;
        RD1E <= RD1;
        RD2E <= RD2;
        ImmExtE <= ImmExtD;
        Rs1E <= Rs1D;
        Rs2E <= Rs2D;
        RdE <= RdD;
        PCE <= PCD;
        PCPlus4E <= PCPlus4D;
    end
end

always_ff @(posedge clk) begin
    if (FlushE | reset) begin
        RegWriteE <= 0;
        MemWriteE <= 0;
        JumpE <= 0;
        BranchE <= 0;
    end else begin
        RegWriteE <= RegWriteD;
        MemWriteE <= MemWriteD;
        JumpE <= JumpD;
        BranchE <= BranchD;
    end
end

endmodule
