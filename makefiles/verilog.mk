PRJ?=
TESTBENCH?=$(PRJ)_tb.v
# RTL_COMMAND?='read_verilog $(PRJ).v $(MODULES);\
# 						 hierarchy -check;\
# 						 show $(PRJ)'
RTL_COMMAND?='read_verilog $(PRJ).v $(MODULES);\
						 hierarchy -check;\
						 write_json $(PRJ).json'
SYNTH_COMMAND?='read_verilog $(PRJ).v $(MODULES);\
		 hierarchy -check;\
		 write_verilog synth.v;'



all: compile sim wave

compile:
	iverilog -o $(PRJ).out $(TESTBENCH) $(PRJ).v $(MODULES)

sim:
	vvp $(PRJ).out

wave:
	gtkwave *.vcd

clean:
	rm *.vcd $(PRJ).out synth.v

rtl:
	yosys -p $(RTL_COMMAND)

svg:
	netlistsvg $(PRJ).json -o $(PRJ).svg

synth.v:
	yosys -p $(SYNTH_COMMAND)

init:
	touch $(PRJ).v $(TESTBENCH) $(MODULES)

# iverilog compiler
# vpp: simulation runtime engine
