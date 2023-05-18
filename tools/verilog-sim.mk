NAME?=
SRC?=
RTL_COMMAND?='read_verilog $(NAME).v;\
						 hierarchy -check;\
						 show $(NAME)'

all: compile sim wave

compile:
	iverilog -o $(NAME).out $(SRC)

sim:
	vvp $(NAME).out

wave:
	gtkwave *.vcd

clean:
	rm *.vcd $(NAME).out

rtl:
	yosys -p $(RTL_COMMAND)

init:
	touch $(NAME).v $(NAME)_tb.v

# iverilog compiler
# vpp: simulation runtime engine
