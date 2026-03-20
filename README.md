# RV32I Pipelined Core

A pipelined implementation of the base RV32I instruction set, based on the description in _Digital Design and Computer Architecture_ by Harris and Harris.

## Requirements

- Icarus Verilog 13.x

## Canonical Workflow

Run all commands from the repository root:

- `make compile` compiles the baseline testbench and DUT into `build/pipeline5/`.
- `make test` compiles and runs the baseline simulation.
- `make clean` removes generated simulator outputs.

Optional overrides:

- `make test PROGRAM=path/to/program.hex`
- `make test DUMPFILE=build/pipeline5/custom.vcd`

The canonical Icarus source list is `pipeline5/module_list.txt`. Generated waveforms and compiled outputs are intentionally kept out of version control.
