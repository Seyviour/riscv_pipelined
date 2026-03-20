SHELL := /bin/sh

BUILD_DIR := build/pipeline5
VVP_OUT := $(BUILD_DIR)/pipeline5.vvp
SOURCE_LIST := pipeline5/module_list.txt

PROGRAM ?= pipeline5/test/test_instructions.txt
DUMPFILE ?= $(BUILD_DIR)/test32.vcd

IVERILOG ?= iverilog
VVP ?= vvp

IVERILOG_FLAGS := -g2012 -s testbench -f $(SOURCE_LIST) -o $(VVP_OUT)
IVERILOG_PARAMS := -Ptestbench.PROGRAM_FILE=\"$(PROGRAM)\" -Ptestbench.DUMPFILE=\"$(DUMPFILE)\"

.PHONY: check-tools compile test clean

check-tools:
	@command -v $(IVERILOG) >/dev/null 2>&1 || { echo "Missing tool: $(IVERILOG)"; exit 1; }
	@command -v $(VVP) >/dev/null 2>&1 || { echo "Missing tool: $(VVP)"; exit 1; }

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

compile: check-tools | $(BUILD_DIR)
	$(IVERILOG) $(IVERILOG_FLAGS) $(IVERILOG_PARAMS)

test: compile
	$(VVP) $(VVP_OUT)

clean:
	rm -rf build
