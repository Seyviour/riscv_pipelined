// `default_nettype none

module decodeTOP #(
    parameter
    word_width = 32
) (
    input logic clk, reset,
    input logic [word_width-1: 0] instrF,
    input logic [word_width-1: 0] PCF,
    input logic  [word_width-1: 0] PCPlus4F,

    input logic FlushD,
    input logic StallD, 

    output logic [19: 15] rd_A1_RF,
    output logic [24: 20] rd_A2_RF,
    output logic [31: 0] ImmExtD,
    output logic [19: 15] Rs1D,
    output logic [24: 20] Rs2D,
    output logic [11: 7] RdD,

    output logic RegWriteD,
    output logic [1:0] ResultSrcD,
    output logic MemWriteD,
    output logic JumpD,
    output logic BranchD,
    output logic [2:0] ALUControlD,
    output logic ALUSrcD,
    output logic [word_width-1: 0] PCPlus4D,
    output logic [word_width-1: 0] PCD
);

logic [word_width-1: 0] instrD; 
decodeState #(.word_width(32)) thisDecodeState
    (
        //input
        .clk(clk), 
        .instrF(instrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        .reset(reset),
        .FlushD(FlushD),
        .enable(~StallD),

        //output
        .instrD(instrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

logic [24: 20] i_24_20;
logic [19: 15] i_19_15;
logic [6: 0] i_6_0;
logic [14: 12] i_14_12;
logic i_30;
logic [11: 7] i_11_7;
logic [31: 7] i_31_7;


Split this_split 
    (
        .instr(instrD),
        .i_24_20(i_24_20),
        .i_19_15(i_19_15),
        .i_6_0(i_6_0),
        .i_14_12(i_14_12),
        .i_30(i_30),
        .i_11_7(i_11_7),
        .i_31_7(i_31_7)
    );


logic [6:0] op;
assign op = i_6_0;
logic [14:12] funct3;
assign funct3 = i_14_12;
logic funct7_5;
assign funct7_5 = i_30;

assign rd_A1_RF = i_19_15;
assign rd_A2_RF = i_24_20;
assign Rs1D = i_19_15; 
assign Rs2D = i_24_20; assign  RdD = i_11_7;



logic [1:0] ImmSrcD;
controlTOP #(.word_width(word_width)) thisControl
    (
        .op(op),
        .funct3(funct3),
        .funct7_5(funct7_5),
        
        .regWriteD(RegWriteD),
        .resultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD)
    );

extend thisExtend
    (
        .instr(instrD[31:7]),
        .immsrc(ImmSrcD),
        .immext(ImmExtD)
    );
    
endmodule
