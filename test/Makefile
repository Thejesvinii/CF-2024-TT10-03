# Makefile for Cocotb AXI Simulation
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# Default settings
SIM ?= icarus            # Default simulator: Icarus Verilog (use SIM=verilator for Verilator)
TOPLEVEL_LANG ?= verilog # Set Verilog as the top-level language

SRC_DIR = $(PWD)/../src  # Source directory for Verilog files

ifneq ($(GATES),yes)

# RTL Simulation
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(SRC_DIR)/axi.v $(SRC_DIR)/tt_um_thejesvinii_axi.v

else

# Gate Level Simulation
SIM_BUILD = sim_build/gl
COMPILE_ARGS += -DGL_TEST -DFUNCTIONAL -DUSE_POWER_PINS -DSIM -DUNIT_DELAY=\#1

VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Include testbench files
VERILOG_SOURCES += $(PWD)/tb.v

# Set top module (testbench)
TOPLEVEL = tb

# Python test file (test.py)
MODULE = test

# Compilation arguments for Verilog files
COMPILE_ARGS += -I$(SRC_DIR)

# Cocotb Simulation Setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# Ensure results.xml is generated
results.xml:
    @echo "<testsuites><testsuite></testsuite></testsuites>" > results.xml
