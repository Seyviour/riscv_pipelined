`default_nettype none
module genControlDecode #(
    parameter
    word_width = 32
) (
    input logic [6:0] op,
    // input logic [14:12] funct3,
    // input logic funct7_5,

    output logic regWriteD,
    output logic [1:0] resultSrcD,
    output logic MemWriteD,
    output logic JumpD,
    output logic BranchD,
    output logic [1:0] ALUOpD,
    output logic ALUSrcD,
    output logic [2:0] ImmSrcD
);


//regWrite__resultSrc__MemWrite__Jump__Branch__ImmSrc
//RegWrite__ImmSrc__ALUSrc__MemWrite__ResultSrc__Branch__ALUOp__Jump

logic [11:0] controls; 

always_comb
    {regWriteD, ImmSrcD, ALUSrcD, MemWriteD, resultSrcD, BranchD, ALUOpD, JumpD} = controls;

always_comb
    case (op)
        7'b0000011: controls = 12'b1_000_1_0_01_0_00_0; // loads
        7'b0100011: controls = 12'b0_001_1_1_00_0_00_0; // stores
        7'b0110011: controls = 12'b1_xxx_0_0_00_0_10_0; // R-type
        7'b1100011: controls = 12'b0_010_0_0_00_1_01_0; // branches
        7'b0010011: controls = 12'b1_000_1_0_00_0_10_0; // I-type ALU
        7'b1101111: controls = 12'b1_011_0_0_10_0_00_1; // jal
        7'b1100111: controls = 12'b1_000_1_0_10_0_00_1; // jalr
        7'b0010111: controls = 12'b1_100_1_0_00_0_00_0; // auipc
        7'b0110111: controls = 12'b1_100_1_0_00_0_00_0; // lui
        default:    controls = 12'b0_xxx_x_x_00_0_xx_0; // unsupported
    endcase


    
endmodule
