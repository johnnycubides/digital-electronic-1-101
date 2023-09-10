help: help-sim help-syn
clean: clean-syn clean-sim
TOP=top
#test bench del proyecto para la simulación
tb?=$(TOP)_tb.v
MODULES=blink.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0

MK_SYN=../../../makefile/blackice-syn.mk
MK_SIM=../../../makefile/sim.mk
include $(MK_SYN) $(MK_SIM)
