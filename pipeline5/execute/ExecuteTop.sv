module ExecuteTop #(
    parameter
    word_width = 32
) (
    input logic clk, reset,  
    input logic FlushE,
    input logic RegWriteD,
    input logic [1:0] ResultSrcD,
    input logic  MemWriteD, 
    input logic JumpD,
    input logic BranchD, 
    input logic [2:0] ALUControlD,
    input logic ALUSrcD,
    input logic [word_width-1: 0] RD1, RD2, ImmExtD,
    input logic [4: 0] Rs1D, Rs2D, RdD,
    input logic [word_width-1: 0] PCD, PCPlus4D,


    input logic [word_width-1: 0] ALUResultM,
    input logic [1:0] forwardAE, forwardBE,
    input logic [word_width-1: 0] ResultW,


    output logic RegWriteE,
    output logic [1:0] ResultSrcE,
    output logic  MemWriteE,  
    output logic [4: 0] RdE,
    output logic PCSrcE, 
    output logic [word_width-1: 0] PCTargetE,
    output logic [word_width-1: 0] PCPlus4E,
    output logic [word_width-1: 0] ALUResultE,
    output logic [word_width-1: 0] WriteDataE,
    output logic [4: 0] Rs1E, Rs2E
);

logic [word_width-1:0] PCE; 

logic [word_width-1: 0] RD1E, RD2E, ImmExtE;
logic [2:0] ALUControlE;
logic JumpE;
logic BranchE;
logic zeroE;

logic ALUSrcE;




ExecuteState #(.word_width(32)) thisExecuteState
    (
        .clk(clk),
        .FlushE(FlushE),
        .RegWriteD(RegWriteD), 
        .ResultSrcD(ResultSrcD), 
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
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
        .JumpE(JumpE),
        .BranchE(BranchE),
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


logic [word_width-1: 0] SrcAE, SrcBE;
Resolve #(.word_width(32)) thisResolver
    (
        .RD1E(RD1E),
        .RD2E(RD2E),
        .ImmExtE(ImmExtE),
        .ALUResultM(ALUResultM),
        .forwardAE(forwardAE),
        .forwardBE(forwardBE),
        .ALUSrcE(ALUSrcE),
        .ResultW(ResultW),
        .WriteDataE(WriteDataE),
        .SrcAE(SrcAE),
        .SrcBE(SrcBE)
    );

ALU #(.word_width(32)) thisALU
    (
        .ALUControl(ALUControlE),
        .SrcA(SrcAE),
        .SrcB(SrcBE),
        .Result(ALUResultE), 
        .zero(zeroE)
    );

adder #(.word_size(32)) thisPCAdder
    (
        .A(PCE),
        .B(ImmExtE),
        .C(PCTargetE)
    );

always_comb
    PCSrcE = ((BranchE &  zeroE) | JumpE); 

endmodule
