help: help-sim help-syn
clean: clean-syn clean-sim
TOP=top
#test bench del proyecto para la simulación
tb?=$(TOP)_tb.v
DESIGN=top.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=uart_tx_strcuture

MK_SYN=../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
