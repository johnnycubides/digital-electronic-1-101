help: help-sim help-syn
clean: clean-syn clean-sim
top=top
DESIGN=top.v
#test bench del proyecto para la simulación
tb?=$(top)_tb.v
MACROS_SIM=-DINIT=(2**24-10)
MACROS_RTL=
MACROS_SYN=
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=blink

MK_SYN=../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
