module ExecuteTop #(
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
    input logic [word_width-1: 0] RD1, RD2, ImmExtD,
    input logic [4:0] Rs1D, Rs2D, RdD,
    input logic [word_width-1: 0] PCD, PCPlus4D,

    input logic [word_width-1: 0] ForwardResultM,
    input logic [1:0] forwardAE, forwardBE,
    input logic [word_width-1: 0] ResultW,

    output logic RegWriteE,
    output logic [1:0] ResultSrcE,
    output logic MemWriteE,
    output logic [1:0] MemSizeE,
    output logic LoadUnsignedE,
    output logic [4:0] RdE,
    output logic PCSrcE,
    output logic [word_width-1: 0] PCTargetE,
    output logic [word_width-1: 0] PCPlus4E,
    output logic [word_width-1: 0] ALUResultE,
    output logic [word_width-1: 0] WriteDataE,
    output logic [4:0] Rs1E, Rs2E
);

logic [word_width-1:0] PCE;
logic [word_width-1:0] RD1E, RD2E, ImmExtE;
logic [2:0] BranchKindE;
logic [3:0] ALUControlE;
logic JumpE;
logic BranchE;
logic JalrE;
logic zeroE;
logic ALUSrcE;
logic [1:0] SrcASelectE;
logic [word_width-1:0] ResolvedRs1E, SrcBE;
logic [word_width-1:0] ALUSrcAE;
logic [word_width-1:0] PCPlusImmE;
logic eqE;
logic ltSignedE;
logic ltUnsignedE;
logic branchTakenE;

localparam logic [2:0] BR_NONE = 3'b000;
localparam logic [2:0] BR_EQ   = 3'b001;
localparam logic [2:0] BR_NE   = 3'b010;
localparam logic [2:0] BR_LT   = 3'b011;
localparam logic [2:0] BR_GE   = 3'b100;
localparam logic [2:0] BR_LTU  = 3'b101;
localparam logic [2:0] BR_GEU  = 3'b110;
localparam logic [1:0] SRCA_RS1  = 2'b00;
localparam logic [1:0] SRCA_PC   = 2'b01;
localparam logic [1:0] SRCA_ZERO = 2'b10;

ExecuteState #(.word_width(32)) thisExecuteState (
    .clk(clk),
    .FlushE(FlushE),
    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .JumpD(JumpD),
    .BranchD(BranchD),
    .BranchKindD(BranchKindD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .SrcASelectD(SrcASelectD),
    .JalrD(JalrD),
    .MemSizeD(MemSizeD),
    .LoadUnsignedD(LoadUnsignedD),
    .RD1(RD1),
    .RD2(RD2),
    .ImmExtD(ImmExtD),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RdD(RdD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .SrcASelectE(SrcASelectE),
    .JalrE(JalrE),
    .MemSizeE(MemSizeE),
    .LoadUnsignedE(LoadUnsignedE),
    .JumpE(JumpE),
    .BranchE(BranchE),
    .BranchKindE(BranchKindE),
    .ALUControlE(ALUControlE),
    .ALUSrcE(ALUSrcE),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .ImmExtE(ImmExtE),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),
    .PCE(PCE),
    .PCPlus4E(PCPlus4E)
);

Resolve #(.word_width(32)) thisResolver (
    .RD1E(RD1E),
    .RD2E(RD2E),
    .ImmExtE(ImmExtE),
    .ForwardResultM(ForwardResultM),
    .forwardAE(forwardAE),
    .forwardBE(forwardBE),
    .ALUSrcE(ALUSrcE),
    .ResultW(ResultW),
    .WriteDataE(WriteDataE),
    .SrcAE(ResolvedRs1E),
    .SrcBE(SrcBE)
);

ALU #(.word_width(32)) thisALU (
    .ALUControl(ALUControlE),
    .SrcA(ALUSrcAE),
    .SrcB(SrcBE),
    .Result(ALUResultE),
    .zero(zeroE)
);

adder #(.word_size(32)) thisPCAdder (
    .A(PCE),
    .B(ImmExtE),
    .C(PCPlusImmE)
);

always_comb begin
    case (SrcASelectE)
        SRCA_PC: ALUSrcAE = PCE;
        SRCA_ZERO: ALUSrcAE = '0;
        default: ALUSrcAE = ResolvedRs1E;
    endcase
end

assign eqE = (ResolvedRs1E == WriteDataE);
assign ltSignedE = ($signed(ResolvedRs1E) < $signed(WriteDataE));
assign ltUnsignedE = (ResolvedRs1E < WriteDataE);
assign PCTargetE = JalrE ? {ALUResultE[31:1], 1'b0} : PCPlusImmE;

always_comb begin
    case (BranchKindE)
        BR_EQ: branchTakenE = eqE;
        BR_NE: branchTakenE = ~eqE;
        BR_LT: branchTakenE = ltSignedE;
        BR_GE: branchTakenE = ~ltSignedE;
        BR_LTU: branchTakenE = ltUnsignedE;
        BR_GEU: branchTakenE = ~ltUnsignedE;
        default: branchTakenE = 1'b0;
    endcase
end

always_comb
    PCSrcE = (JumpE | (BranchE & branchTakenE));

endmodule
