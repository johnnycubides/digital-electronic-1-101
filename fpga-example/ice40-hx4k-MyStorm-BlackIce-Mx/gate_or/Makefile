help: help-sim help-syn
clean: clean-syn clean-sim
# top=top
DESIGN=./top.v
#test bench del proyecto para la simulación
tb?=top_tb.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=gate_or

MK_SYN=../../../makefiles/blackice-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
