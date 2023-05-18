PRJ?=
TESTBENCH?=
RTL_COMMAND?='read_verilog $(PRJ).v $(MODULES);\
						 hierarchy -check;\
						 show $(PRJ)'
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

synth.v:
	yosys -p $(SYNTH_COMMAND)

init:
	touch $(PRJ).v $(PRJ)_tb.v $(MODULES)

# iverilog compiler
# vpp: simulation runtime engine
