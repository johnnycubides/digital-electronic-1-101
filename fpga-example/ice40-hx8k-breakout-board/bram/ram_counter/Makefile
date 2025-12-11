help: help-sim help-syn
clean: clean-syn clean-sim
top=top
#test bench del proyecto para la simulación
tb?=./top_tb.v
MACROS_SIM=-DSIM
# Agregar aquí otros archivos que se requieran para la simulación
MORE_SRC2SIM=./file.mem
DESIGN=./top.v
DESIGN+=./clk10hz.v
DESIGN+=./counter8bits.v
DESIGN+=./dual_port_ram.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=ram_counter

MK_SYN=../../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
