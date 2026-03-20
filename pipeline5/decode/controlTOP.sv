// `default_nettype none
module controlTOP #(
    parameter
    word_width = 32
) (
    
    input logic [6:0] op,
    input logic [14:12] funct3,
    input logic funct7_5,

    output logic regWriteD,
    output logic [1:0] resultSrcD,
    output logic MemWriteD,
    output logic JumpD,
    output logic BranchD,
    output logic [2:0] ALUControlD,
    output logic ALUSrcD,
    output logic [1:0] ImmSrcD
);

wire [1:0] ALUOpD;

ALUDecode #(.word_width(32)) thisALUDecoder
    (
        .op_5(op[5]),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALUOp(ALUOpD),
        .ALUControlD(ALUControlD)
    );

genControlDecode #(.word_width(32)) thisGenDecode
    (
        .op(op), 
        .regWriteD(regWriteD),
        .resultSrcD(resultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUOpD(ALUOpD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD)
    );




endmodule
