// FROM HARRIS AND HARRIS

module extend(input logic[31:7] instr,
              input logic[2:0] immsrc,
              output logic[31:0] immext);


    // INSTRUCTION STRUCTURE
    // I-TYPE =>   31:20->imm11:0    19:15->rs1(5bits)  14:12->f3(3bits)   11:7->rd(5bits)                      6:0->op(7bits)
    // S-TYPE =>   31:25->imm11:5    24:20->rs2(5bits)  19:15->rs1(5bits)  14:12->f3(3bits)   11:7->imm4:0      6:0->op(7bits)
    // R-TYPE =>   31:25->funct7     24:20->rs2(5bits)  19:15->rs1(5bits)  14:12->f3(3bits)   11:7->rd(5bits)   6:0->op(7bits)
    // B-TYPE =>   31:25->imm12,10:5 24:20->rs2(5bits)  19:15->rs1(5bits)  14:12->f3(3bits)   11:7->(imm4:1,11) 6:0->op(7bits)
    always @(*) begin
        case(immsrc)
            // I-type
            3'b000: immext = {{20{instr[31]}}, instr[31:20]};
            // S-type
            3'b001: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            // B-type
            3'b010: immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            // J-type
            3'b011: immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            // U-type
            3'b100: immext = {instr[31:12], 12'b0};

            default: immext = 0;
   
        endcase
    end
    

endmodule
