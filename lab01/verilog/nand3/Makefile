NAME?= and3

SRC= and3.v\
		 and3_tb.v

all: compile sim wave

compile:
	iverilog -o $(NAME).out $(SRC)

sim:
	vvp $(NAME).out

wave:
	gtkwave *.vcd

clean:
	rm *.vcd $(NAME).out

# iverilog compiler
# vpp: simulation runtime engine
