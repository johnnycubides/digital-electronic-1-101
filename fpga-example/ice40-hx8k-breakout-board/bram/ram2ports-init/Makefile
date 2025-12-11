help: help-sim help-syn
clean: clean-syn clean-sim
top=dual_port_ram
#test bench del proyecto para la simulación
tb?=./dual_port_ram_tb.v
MORE_SRC2SIM=./file.mem
# tb?=$(TOP)_tb.v
DESIGN=./dual_port_ram.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=ram2ports-init

MK_SYN=../../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
