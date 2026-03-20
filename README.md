# RV32I Pipelined Core

A pipelined implementation of most of the RV32I integer instruction set, based on the description in _Digital Design and Computer Architecture_ by Harris and Harris.

## Requirements

- Icarus Verilog 13.x

## TEsts

Run all commands from the repository root:

- `make compile` compiles the baseline testbench and DUT into `build/pipeline5/`.
- `make test` compiles and runs the baseline simulation.
- `make clean` removes generated simulator outputs.

Optional overrides:

- `make test PROGRAM=path/to/program.hex`
- `make test DUMPFILE=build/pipeline5/custom.vcd`


Unimplemented instructions include:

- `fence`
- `ecall`
- `ebreak`
- Trap/exception handling for illegal or misaligned accesses
