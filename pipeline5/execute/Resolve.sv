module Resolve #(
    parameter word_width = 32
) (
    input logic [word_width-1: 0] RD1E, RD2E,
    input logic [word_width-1: 0] ImmExtE,
    input logic [word_width-1: 0] ForwardResultM,
    input logic [1:0] forwardAE, forwardBE,
    input logic ALUSrcE,
    input logic [word_width-1: 0] ResultW,

    output logic [word_width-1: 0] WriteDataE,
    output logic [word_width-1: 0] SrcAE, SrcBE
);



mux_3_1 #(.word_width(32)) muxA
    (
        .sel(forwardAE),
        .in00(RD1E),
        .in01(ResultW),
        .in10(ForwardResultM),
        .out(SrcAE)
    );


wire [word_width-1: 0] SrcBE_i;
mux_3_1 #(.word_width(32)) muxB
    (
        .sel(forwardBE),
        .in00(RD2E),
        .in01(ResultW),
        .in10(ForwardResultM),
        .out(SrcBE_i)
    );

always_comb begin
    SrcBE = (ALUSrcE==0)? SrcBE_i: ImmExtE;
    WriteDataE = SrcBE_i;
end

endmodule
