
module ALUDecode #(
    parameter
    word_width = 32
) (
    input logic op_5, 
    input logic[2:0] funct3,
    input logic funct7_5,
    input logic [1:0] ALUOp,
    output logic [3:0] ALUControlD
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

logic RtypeSub;
assign RtypeSub = funct7_5 & op_5;

always_comb
    case(ALUOp)
        2'b00: ALUControlD = ALU_ADD;
        2'b01: ALUControlD = ALU_SUB;
        
        default: case(funct3) // R-type or I-type ALU
            3'b000: if (RtypeSub)
                        ALUControlD = ALU_SUB;
                    else
                        ALUControlD = ALU_ADD;
            3'b001: ALUControlD = ALU_SLL;
            3'b010: ALUControlD = ALU_SLT;
            3'b011: ALUControlD = ALU_SLTU;
            3'b100: ALUControlD = ALU_XOR;
            3'b101: if (funct7_5)
                        ALUControlD = ALU_SRA;
                    else
                        ALUControlD = ALU_SRL;
            3'b110: ALUControlD = ALU_OR;
            3'b111: ALUControlD = ALU_AND;
            default: ALUControlD = ALU_ADD;
        endcase
    endcase

endmodule
