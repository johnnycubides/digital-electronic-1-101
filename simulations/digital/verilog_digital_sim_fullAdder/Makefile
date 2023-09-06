# CONDA=~/miniconda3/bin/conda
TOP=fulladder
tb?=$(TOP)_tb.v
MODULES=./halfadder.v

RTL_COMMAND?='read_verilog $(TOP).v $(MODULES);\
						 hierarchy -check;\
						 show $(TOP)'

all: compile simulate wave

compile:
	iverilog -o $(TOP).vvp $(tb) $(TOP).v $(MODULES)

simulate:
	vvp $(TOP).vvp

wave:
	gtkwave top.vcd

json:
	yosys -p 'read_verilog $(TOP).v $(MODULES); hierarchy -check; write_json $(TOP).json'

rtl-from-json:
	netlistsvg $(TOP).json -o $(TOP).svg

view-svg:
	eog $(TOP).svg

rtl:
	yosys -p $(RTL_COMMAND)

env:
	$(CONDA) activate digital

clean:
	rm -rf top.vcd $(TOP).vvp $(TOP).json $(TOP).svg
