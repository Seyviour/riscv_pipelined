module ALU #(
    parameter
    word_width = 32
) (
    input logic [3:0] ALUControl,
    input logic [word_width-1: 0] SrcA,
    input logic [word_width-1: 0] SrcB,
    output logic [word_width-1: 0] Result, 
    output logic zero
);

    localparam logic [3:0] ALU_ADD  = 4'b0000;
    localparam logic [3:0] ALU_SUB  = 4'b1000;
    localparam logic [3:0] ALU_SLL  = 4'b0001;
    localparam logic [3:0] ALU_SLT  = 4'b0010;
    localparam logic [3:0] ALU_SLTU = 4'b0011;
    localparam logic [3:0] ALU_XOR  = 4'b0100;
    localparam logic [3:0] ALU_SRL  = 4'b0101;
    localparam logic [3:0] ALU_SRA  = 4'b1101;
    localparam logic [3:0] ALU_OR   = 4'b0110;
    localparam logic [3:0] ALU_AND  = 4'b0111;

    logic [4:0] ShiftAmt;
    assign ShiftAmt = SrcB[4:0];

    always_comb
        case(ALUControl)
            ALU_ADD: Result = SrcA + SrcB;
            ALU_SUB: Result = SrcA - SrcB;
            ALU_SLL: Result = SrcA << ShiftAmt;
            ALU_SLT: Result = ($signed(SrcA) < $signed(SrcB)) ? {{(word_width-1){1'b0}}, 1'b1} : '0;
            ALU_SLTU: Result = (SrcA < SrcB) ? {{(word_width-1){1'b0}}, 1'b1} : '0;
            ALU_XOR: Result = SrcA ^ SrcB;
            ALU_SRL: Result = SrcA >> ShiftAmt;
            ALU_SRA: Result = $signed(SrcA) >>> ShiftAmt;
            ALU_OR: Result = SrcA | SrcB;
            ALU_AND: Result = SrcA & SrcB;
            default: Result = '0;
    endcase

    assign zero = (Result == 0);
    
endmodule
