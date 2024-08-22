help: help-sim help-syn
clean: clean-syn clean-sim
top=top
#test bench del proyecto para la simulación
tb?=$(top)_tb.v
DESIGN=top.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=and2_lut4

MK_SYN=../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
