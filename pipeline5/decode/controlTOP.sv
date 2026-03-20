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
    output logic [2:0] BranchKindD,
    output logic [3:0] ALUControlD,
    output logic ALUSrcD,
    output logic [2:0] ImmSrcD,
    output logic [1:0] SrcASelectD,
    output logic JalrD,
    output logic [1:0] MemSizeD,
    output logic LoadUnsignedD
);

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
localparam logic [1:0] MEM_BYTE  = 2'b00;
localparam logic [1:0] MEM_HALF  = 2'b01;
localparam logic [1:0] MEM_WORD  = 2'b10;

logic [1:0] ALUOpD;
logic regWriteRawD;
logic [1:0] resultSrcRawD;
logic MemWriteRawD;
logic JumpRawD;
logic BranchRawD;
logic ALUSrcRawD;
logic [2:0] ImmSrcRawD;
logic MemAccessValidD;
logic BranchValidD;
logic JumpValidD;
logic ControlValidD;

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
    MemSizeD = MEM_WORD;
    LoadUnsignedD = 1'b0;
    MemAccessValidD = 1'b1;
    BranchValidD = 1'b1;
    JumpValidD = 1'b1;
    BranchKindD = BR_NONE;
    SrcASelectD = SRCA_RS1;
    JalrD = 1'b0;

    case (op)
        7'b0000011: begin
            case (funct3)
                3'b000: MemSizeD = MEM_BYTE; // lb
                3'b001: MemSizeD = MEM_HALF; // lh
                3'b010: MemSizeD = MEM_WORD; // lw
                3'b100: begin                 // lbu
                    MemSizeD = MEM_BYTE;
                    LoadUnsignedD = 1'b1;
                end
                3'b101: begin            // lhu
                    MemSizeD = MEM_HALF;
                    LoadUnsignedD = 1'b1;
                end
                default: MemAccessValidD = 1'b0;
            endcase
        end
        7'b0100011: begin
            case (funct3)
                3'b000: MemSizeD = MEM_BYTE; // sb
                3'b001: MemSizeD = MEM_HALF; // sh
                3'b010: MemSizeD = MEM_WORD; // sw
                default: MemAccessValidD = 1'b0;
            endcase
        end
        7'b1100011: begin
            case (funct3)
                3'b000: BranchKindD = BR_EQ;
                3'b001: BranchKindD = BR_NE;
                3'b100: BranchKindD = BR_LT;
                3'b101: BranchKindD = BR_GE;
                3'b110: BranchKindD = BR_LTU;
                3'b111: BranchKindD = BR_GEU;
                default: BranchValidD = 1'b0;
            endcase
        end
        7'b1100111: begin
            if (funct3 == 3'b000)
                JalrD = 1'b1;
            else
                JumpValidD = 1'b0;
        end
        7'b0010111: SrcASelectD = SRCA_PC;   // auipc
        7'b0110111: SrcASelectD = SRCA_ZERO; // lui
        default: begin end
    endcase

    ControlValidD = MemAccessValidD & BranchValidD & JumpValidD;
    regWriteD = regWriteRawD & ControlValidD;
    resultSrcD = ControlValidD ? resultSrcRawD : 2'b00;
    MemWriteD = MemWriteRawD & ControlValidD;
    JumpD = JumpRawD & JumpValidD;
    BranchD = BranchRawD & BranchValidD;
    ALUSrcD = ALUSrcRawD;
    ImmSrcD = ImmSrcRawD;
end

endmodule
