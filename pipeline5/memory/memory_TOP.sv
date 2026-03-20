module memoryTOP #(
    parameter
    word_width = 32
) (
    input logic clk, reset,
    input logic RegWriteE,
    input logic [1:0] ResultSrcE,
    input logic MemWriteE,
    input logic [1:0] MemSizeE,
    input logic LoadUnsignedE,
    input logic [word_width-1:0] ALUResultE,
    input logic [word_width-1:0] WriteDataE,
    input logic [4:0] RdE,
    input logic [word_width-1:0] PCPlus4E,

    output logic RegWriteM,
    output logic [1:0] ResultSrcM,
    output logic MemWriteM,
    output logic [1:0] MemSizeM,
    output logic LoadUnsignedM,
    output logic [word_width-1:0] ALUResultM,
    output logic [word_width-1:0] WriteDataM,
    output logic [4:0] RdM,
    output logic [word_width-1:0] PCPlus4M
);

memoryState #(
    .word_width(word_width)
) thisMemoryState (
    .clk(clk),
    .reset(reset),
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .MemSizeE(MemSizeE),
    .LoadUnsignedE(LoadUnsignedE),
    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE),
    .RdE(RdE),
    .PCPlus4E(PCPlus4E),
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWriteM),
    .MemSizeM(MemSizeM),
    .LoadUnsignedM(LoadUnsignedM),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M)
);

endmodule
