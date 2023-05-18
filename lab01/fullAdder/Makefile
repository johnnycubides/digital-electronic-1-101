NAME?= full_adder
SRC?= full_adder.v\
		 full_adder_tb.v

RTL_COMMAND?='read_verilog $(NAME).v;\
						 hierarchy -check;\
						 show $(NAME)'

PATH_TOOLS=../../tools
include $(PATH_TOOLS)/verilog-sim.mk
