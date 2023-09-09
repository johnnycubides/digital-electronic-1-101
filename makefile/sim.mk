# CONDA=~/miniconda3/bin/conda
TOP?=top
#test bench del proyecto para la simulación
tb?=$(TOP)_tb.v
# Módules .v que hacen parte del proyecto
MODULES?=

S=sim

help-sim:
	@echo "make rtl \t-> Crear RTL"
	@echo "make sim \t-> Simular diseño"
	@echo "make wave \t-> Ver simulación en gtkwave"

rtl: rtl-from-json view-svg

sim: iverilog-compile vpp-simulate wave

iverilog-compile:
	mkdir -p $S
	iverilog -o $S/$(TOP).vvp $(tb) $(TOP).v $(MODULES)

vpp-simulate:
	cd $S && vvp $(TOP).vvp -vcd

wave:
	gtkwave $S/top.vcd

json-yosys:
	mkdir -p $S
	yosys -p 'read_verilog $(TOP).v $(MODULES); hierarchy -check; proc; write_json $S/$(TOP).json'

rtl-from-json: json-yosys
	netlistsvg $S/$(TOP).json -o $S/$(TOP).svg

view-svg:
	eog $S/$(TOP).svg

rtl-xdot:
	yosys -p $(RTL_COMMAND)

clean-sim:
	rm -rf $S

## YOSYS ARGUMENTS
RTL_COMMAND?='read_verilog $(TOP).v $(MODULES);\
						 hierarchy -check;\
						 show $(TOP)'

