`timescale 1ns/1ps

module testbench #(
    parameter PROGRAM_FILE = "pipeline5/test/test_instructions.txt",
    parameter DUMPFILE = "build/pipeline5/test32.vcd",
    parameter int MAX_CYCLES = 500
) ();
logic clk = 1'b0;
logic reset = 1'b1;
logic [31:0] WriteData;
logic [31:0] DataAdr;
logic MemWrite;
integer cycles = 0;

RV32PipelinedTOP #(
    .data_file(PROGRAM_FILE)
) dut (
    .clk(clk),
    .reset(reset),
    .WriteDataM(WriteData),
    .ALUResultM(DataAdr),
    .MemWrite(MemWrite)
);

initial begin
    #22 reset = 1'b0;
end

initial begin
    $dumpfile(DUMPFILE);
    $dumpvars(0, dut);
end

always #5 clk = ~clk;

always @(negedge clk) begin
    if (reset) begin
        cycles = 0;
    end else begin
        cycles = cycles + 1;
    end

    if (!reset && MemWrite) begin
        if ((DataAdr === 32'd100) && (WriteData === 32'd25)) begin
            $display("Simulation succeeded");
            $finish;
        end

        if (DataAdr !== 32'd96) begin
            $fatal(1, "Simulation failed: write addr=%0d data=%0d", DataAdr, WriteData);
        end
    end

    if (!reset && (cycles >= MAX_CYCLES)) begin
        $fatal(1, "Simulation timed out after %0d cycles", cycles);
    end
end

endmodule
