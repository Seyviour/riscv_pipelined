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
    output logic [1:0] ImmSrcD,
    output logic MemHalfD,
    output logic LoadUnsignedD
);

logic [1:0] ALUOpD;
logic regWriteRawD;
logic [1:0] resultSrcRawD;
logic MemWriteRawD;
logic JumpRawD;
logic BranchRawD;
logic ALUSrcRawD;
logic [1:0] ImmSrcRawD;
logic MemAccessValidD;

ALUDecode #(.word_width(32)) thisALUDecoder (
    .op_5(op[5]),
    .funct3(funct3),
    .funct7_5(funct7_5),
    .ALUOp(ALUOpD),
    .ALUControlD(ALUControlD)
);

genControlDecode #(.word_width(32)) thisGenDecode (
    .op(op),
    .regWriteD(regWriteRawD),
    .resultSrcD(resultSrcRawD),
    .MemWriteD(MemWriteRawD),
    .JumpD(JumpRawD),
    .BranchD(BranchRawD),
    .ALUOpD(ALUOpD),
    .ALUSrcD(ALUSrcRawD),
    .ImmSrcD(ImmSrcRawD)
);

always_comb begin
    MemHalfD = 1'b0;
    LoadUnsignedD = 1'b0;
    MemAccessValidD = 1'b1;

    case (op)
        7'b0000011: begin
            case (funct3)
                3'b001: MemHalfD = 1'b1; // lh
                3'b010: begin end        // lw
                3'b101: begin            // lhu
                    MemHalfD = 1'b1;
                    LoadUnsignedD = 1'b1;
                end
                default: MemAccessValidD = 1'b0;
            endcase
        end
        7'b0100011: begin
            case (funct3)
                3'b001: MemHalfD = 1'b1; // sh
                3'b010: begin end        // sw
                default: MemAccessValidD = 1'b0;
            endcase
        end
        default: begin end
    endcase

    regWriteD = regWriteRawD & MemAccessValidD;
    resultSrcD = MemAccessValidD ? resultSrcRawD : 2'b00;
    MemWriteD = MemWriteRawD & MemAccessValidD;
    JumpD = JumpRawD;
    BranchD = BranchRawD;
    ALUSrcD = ALUSrcRawD;
    ImmSrcD = ImmSrcRawD;
end

endmodule
