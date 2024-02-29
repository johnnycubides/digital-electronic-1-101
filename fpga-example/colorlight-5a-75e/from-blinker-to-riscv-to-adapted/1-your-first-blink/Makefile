help: help-sim help-syn
clean: clean-syn clean-sim
TOP=top
#test bench del proyecto para la simulación
tb?=$(TOP)_tb.v
DESIGN=top.v
DEF_MACROS_VERILOG_SYN=
DEF_MACROS_VERILOG_SIM=
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=1-your-first-blink

MK_SYN=../../../../makefiles/colorlight-5a-75e-syn.mk
MK_SIM=../../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
