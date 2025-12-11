help: help-sim help-syn
clean: clean-syn clean-sim
top=top
DESIGN=top.v
DESIGN+=blink.v
#test bench del proyecto para la simulación
tb?=./top_tb.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# MACROS_SYN?=
MACROS_SIM=-DINIT=(2**25-10)
# Z: Nombre para empaquetar proyecto
Z=blink

MK_SYN=../../../makefiles/colorlight-5a-75e-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
