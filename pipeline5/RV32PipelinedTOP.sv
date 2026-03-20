module RV32PipelinedTOP #(
    parameter data_file = "pipeline5/test/test_instructions.txt",
    parameter int word_width = 32
) (
    input logic clk,
    input logic reset,
    output logic [word_width-1:0] WriteDataM,
    output logic [word_width-1:0] ALUResultM,
    output logic MemWrite
);

localparam int r_address_width = 5;

logic StallF;
logic StallD;
logic FlushD;
logic FlushE;
logic RegWriteD;
logic MemWriteD;
logic JumpD;
logic BranchD;
logic ALUSrcD;
logic RegWriteE;
logic MemWriteE;
logic RegWriteM;
logic RegWriteW;
logic PCSrcE;
logic MemHalfD;
logic LoadUnsignedD;
logic MemHalfE;
logic LoadUnsignedE;
logic MemHalfM;
logic LoadUnsignedM;

logic [word_width-1:0] instrF;
logic [word_width-1:0] PCF;
logic [word_width-1:0] PCPlus4F;
logic [word_width-1:0] ImmExtD;
logic [word_width-1:0] PCD;
logic [word_width-1:0] PCPlus4D;
logic [word_width-1:0] PCTargetE;
logic [word_width-1:0] PCPlus4E;
logic [word_width-1:0] ALUResultE;
logic [word_width-1:0] WriteDataE;
logic [word_width-1:0] PCPlus4M;
logic [word_width-1:0] ReadDataM;
logic [word_width-1:0] ReadDataRawM;
logic [word_width-1:0] DataMemWriteData;
logic [word_width-1:0] ResultW;
logic [word_width-1:0] RD1;
logic [word_width-1:0] RD2;
logic [15:0] ReadDataHalfM;
logic IsHalfStoreM;
logic IsHalfLoadM;

logic [r_address_width-1:0] Rs1D;
logic [r_address_width-1:0] Rs2D;
logic [r_address_width-1:0] RdD;
logic [r_address_width-1:0] Rs1E;
logic [r_address_width-1:0] Rs2E;
logic [r_address_width-1:0] RdE;
logic [r_address_width-1:0] RdM;
logic [r_address_width-1:0] RdW;

logic [1:0] ResultSrcD;
logic [1:0] ResultSrcE;
logic [1:0] ResultSrcM;
logic [1:0] forwardAE;
logic [1:0] forwardBE;
logic [2:0] ALUControlD;

FetchTop #(.word_width(word_width)) thisFetchStage (
    .clk(clk),
    .reset(reset),
    .stallF_N(StallF),
    .PCSrcE(PCSrcE),
    .PCTargetE(PCTargetE),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F)
);

decodeTOP #(.word_width(word_width)) thisDecodeStage (
    .clk(clk),
    .reset(reset),
    .instrF(instrF),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),
    .ImmExtD(ImmExtD),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RdD(RdD),
    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .StallD(StallD),
    .FlushD(FlushD),
    .JumpD(JumpD),
    .BranchD(BranchD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .MemHalfD(MemHalfD),
    .LoadUnsignedD(LoadUnsignedD),
    .PCPlus4D(PCPlus4D),
    .PCD(PCD)
);

ExecuteTop #(.word_width(word_width)) thisExecuteStage (
    .clk(clk),
    .reset(reset),
    .FlushE(FlushE),
    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .JumpD(JumpD),
    .BranchD(BranchD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .MemHalfD(MemHalfD),
    .LoadUnsignedD(LoadUnsignedD),
    .RD1(RD1),
    .RD2(RD2),
    .ImmExtD(ImmExtD),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RdD(RdD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .ALUResultM(ALUResultM),
    .forwardAE(forwardAE),
    .forwardBE(forwardBE),
    .ResultW(ResultW),
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .MemHalfE(MemHalfE),
    .LoadUnsignedE(LoadUnsignedE),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),
    .PCSrcE(PCSrcE),
    .PCTargetE(PCTargetE),
    .PCPlus4E(PCPlus4E),
    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE)
);

memoryTOP #(.word_width(word_width)) thisMemoryStage (
    .clk(clk),
    .reset(reset),
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .MemHalfE(MemHalfE),
    .LoadUnsignedE(LoadUnsignedE),
    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE),
    .RdE(RdE),
    .PCPlus4E(PCPlus4E),
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWrite),
    .MemHalfM(MemHalfM),
    .LoadUnsignedM(LoadUnsignedM),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M)
);

writebackTOP #(.word_width(word_width)) thisWritebackStage (
    .clk(clk),
    .reset(reset),
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .ALUResultM(ALUResultM),
    .ReadDataM(ReadDataM),
    .PCPlus4M(PCPlus4M),
    .RdM(RdM),
    .ResultW(ResultW),
    .RegWriteW(RegWriteW),
    .RdW(RdW)
);

hazardTOP #(.word_width(word_width)) thisHazardUnit (
    .RegWriteW(RegWriteW),
    .RegWriteM(RegWriteM),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RdW(RdW),
    .RdM(RdM),
    .ResultSrcE(ResultSrcE),
    .PCSrcE(PCSrcE),
    .forwardAE(forwardAE),
    .forwardBE(forwardBE),
    .StallD(StallD),
    .FlushD(FlushD),
    .FlushE(FlushE),
    .StallF(StallF)
);

regFile #(.address_width(r_address_width)) thisRegFile (
    .clk(clk),
    .we3(RegWriteW),
    .rd_addr1(Rs1D),
    .rd_addr2(Rs2D),
    .wr_addr3(RdW),
    .wr_data3(ResultW),
    .rd_data1(RD1),
    .rd_data2(RD2)
);

memory #(.data_file(data_file)) thisInstructionMemory (
    .clk(clk),
    .we(1'b0),
    .addr(PCF),
    .rd_data(instrF),
    .wr_data('0)
);

memory #(.data_file("")) thisDataMemory (
    .clk(clk),
    .we(MemWrite),
    .addr(ALUResultM),
    .wr_data(DataMemWriteData),
    .rd_data(ReadDataRawM)
);

assign IsHalfStoreM = MemHalfM && MemWrite;
assign IsHalfLoadM = MemHalfM && (ResultSrcM == 2'b01);
assign ReadDataHalfM = ALUResultM[1] ? ReadDataRawM[31:16] : ReadDataRawM[15:0];
assign DataMemWriteData = IsHalfStoreM
    ? (ALUResultM[1]
        ? {WriteDataM[15:0], ReadDataRawM[15:0]}
        : {ReadDataRawM[31:16], WriteDataM[15:0]})
    : WriteDataM;
assign ReadDataM = IsHalfLoadM
    ? (LoadUnsignedM
        ? {16'b0, ReadDataHalfM}
        : {{16{ReadDataHalfM[15]}}, ReadDataHalfM})
    : ReadDataRawM;

endmodule
