help: help-sim help-syn
clean: clean-syn clean-sim
TOP=top
#test bench del proyecto para la simulación
tb?=top_tb.v
DESIGN=top.v
DEF_MACROS_VERILOG_SYN=-DBOARD_FREQ=25 -DCPU_FREQ=100 -DNEGATIVE_RESET
DEF_MACROS_VERILOG_SIM=-DBENCH -DSIM -DBOARD_FREQ=10 -DCPU_FREQ=10
DIR_BUILD=build
DEVSERIAL=/dev/ttyUSB0
# Z: Nombre para empaquetar proyecto
Z=blink-pll

MK_SYN=../../../../makefiles/colorlight-5a-75e-syn.mk
MK_SIM=../../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
