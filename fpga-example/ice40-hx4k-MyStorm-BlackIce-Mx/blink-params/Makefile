help: help-sim help-syn
clean: clean-syn clean-sim
TOP=top
DESIGN=top.v
#test bench del proyecto para la simulación
tb?=$(TOP)_tb.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=blink

MK_SYN=../../../makefiles/blackice-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
