# CONDA=~/miniconda3/bin/conda
TOP=counter
tb?=$(TOP)_tb.v
MODULES=

RTL_COMMAND?='read_verilog $(TOP).v $(MODULES);\
						 hierarchy -check; proc;\
						 show $(TOP)'

JSON_COMMAND?='read_verilog $(TOP).v $(MODULES);\
							hierarchy -check; proc;\
							write_json $(TOP).json'

sim: compile simulate wave

compile:
	iverilog -o $(TOP).vvp $(tb) $(TOP).v $(MODULES)

simulate:
	vvp $(TOP).vvp

wave:
	gtkwave top.vcd

rtl: get-json rtl-from-json view-svg

get-json:
	yosys -p $(JSON_COMMAND)

rtl-from-json:
	netlistsvg $(TOP).json -o $(TOP).svg
	@echo "$(TOP).svg generado"

view-svg:
	eog $(TOP).svg

rtl-gravphiz:
	yosys -p $(RTL_COMMAND)

env:
	$(CONDA) activate digital

clean:
	rm -rf top.vcd $(TOP).vvp $(TOP).json $(TOP).svg
