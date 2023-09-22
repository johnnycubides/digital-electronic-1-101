help: help-sim help-syn
clean: clean-syn clean-sim
TOP=dual_port_ram
#test bench del proyecto para la simulación
tb?=./ram_tb.v
MORE_SRC2SIM=./file.mem
# tb?=$(TOP)_tb.v
DESIGN=ram.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0

MK_SYN=../../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
