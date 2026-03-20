module memoryState #(
    parameter
    word_width = 32
) (
    input logic clk, reset,
    input logic RegWriteE,
    input logic [1:0] ResultSrcE,
    input logic MemWriteE,
    input logic MemHalfE,
    input logic LoadUnsignedE,
    input logic [word_width-1:0] ALUResultE,
    input logic [word_width-1:0] WriteDataE,
    input logic [4:0] RdE,
    input logic [word_width-1:0] PCPlus4E,

    output logic RegWriteM,
    output logic [1:0] ResultSrcM,
    output logic MemWriteM,
    output logic MemHalfM,
    output logic LoadUnsignedM,
    output logic [word_width-1:0] ALUResultM,
    output logic [word_width-1:0] WriteDataM,
    output logic [4:0] RdM,
    output logic [word_width-1:0] PCPlus4M
);

always_ff @(posedge clk) begin
    if (reset) begin
        RdM <= 0;
        RegWriteM <= 0;
        MemWriteM <= 0;
        MemHalfM <= 0;
        LoadUnsignedM <= 0;
        ResultSrcM <= 0;
        ALUResultM <= 0;
        WriteDataM <= 0;
        PCPlus4M <= 0;
    end else begin
        RdM <= RdE;
        RegWriteM <= RegWriteE;
        MemWriteM <= MemWriteE;
        MemHalfM <= MemHalfE;
        LoadUnsignedM <= LoadUnsignedE;
        ResultSrcM <= ResultSrcE;
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        PCPlus4M <= PCPlus4E;
    end
end

endmodule
