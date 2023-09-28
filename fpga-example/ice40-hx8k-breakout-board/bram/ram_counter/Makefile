help: help-sim help-syn
clean: clean-syn clean-sim
TOP=top
#test bench del proyecto para la simulación
tb?=$(TOP)_tb.v
# Agregar aquí otros archivos que se requieran para la simulación
MORE_SRC2SIM=./file.mem
DESIGN=./top.v ./clk10hz.v ./counter8bits.v ./ram.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=ram_counter

MK_SYN=../../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
