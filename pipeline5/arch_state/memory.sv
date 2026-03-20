module memory #(
    parameter data_file = "",
    parameter int word_size = 32,
    parameter int address_width = 32,
    parameter int no_words = 64
) (
    input logic clk, we, 
    input logic [address_width-1: 0] addr,
    input logic [word_size-1: 0] wr_data,
    output logic [word_size-1: 0] rd_data
);
    logic [word_size-1: 0] RAM [0:no_words-1];
    logic [31:2] this_address;
    integer idx;

    initial begin
        for (idx = 0; idx < no_words; idx = idx + 1)
            RAM[idx] = '0;

        if (data_file != "")
            $readmemh(data_file, RAM);
    end

    assign this_address = addr[31:2];
    always_comb
        rd_data = RAM[this_address];


    always_ff @(posedge clk)
        if (we)
            RAM[addr[31:2]] <= wr_data; // word aligned
            
endmodule
