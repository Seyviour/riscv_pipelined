module writebackTOP #(
    parameter
    word_width = 32
) (
    input logic clk, reset, 
    input logic RegWriteM ,
    input logic [1:0] ResultSrcM,
    input logic [word_width-1:0] ALUResultM,
    input logic [word_width-1:0] ReadDataM,
    input logic [word_width-1:0] PCPlus4M,
    input logic [4:0] RdM,

    output logic [word_width-1:0] ResultW, 
    output logic RegWriteW,
    output logic [4:0] RdW

);

logic [word_width-1:0] ALUResultW;
logic [word_width-1:0] ReadDataW;
logic [word_width-1:0] PCPlus4W;
logic [1:0] ResultSrcW;


writeback_state 
#(
  .word_width (word_width )
)
writeback_state (
  .clk(clk),
  .reset(reset),
  .RegWriteM (RegWriteM ),
  .ResultSrcM (ResultSrcM ),
  .ALUResultM (ALUResultM ),
  .ReadDataM (ReadDataM ),
  .PCPlus4M (PCPlus4M ),
  .RdM (RdM ),
  .RegWriteW (RegWriteW ),
  .ResultSrcW (ResultSrcW ),
  .ALUResultW (ALUResultW ),
  .ReadDataW (ReadDataW ),
  .PCPlus4W (PCPlus4W ),
  .RdW  ( RdW)
);

mux_3_1 #(.word_width(word_width)) ResultMux
    (
        .sel(ResultSrcW),
        .in00(ALUResultW),
        .in01(ReadDataW),
        .in10(PCPlus4W),
        .out(ResultW)
    );


endmodule
