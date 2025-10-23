help: help-sim help-syn
clean: clean-syn clean-sim
# Diseño
DESIGN=top.v
# test bench del proyecto para la simulación
tb?=./top_tb.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
MACROS_SIM=-DINIT=(2**25-10)
MACROS_RTL?=
MACROS_SYN?=
# Z: Nombre para empaquetar proyecto
Z=template

MK_SYN=../../../makefiles/colorlight-5a-75e-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
