help: help-sim help-quartus
clean: clean-syn clean-sim
top=top
# Agregar aquí otros archivos que se requieran para la simulación
MORE_SRC2SIM=./file.mem
DESIGN+= top.v
DESIGN+= clk10hz.v
DESIGN+= counter8bits.v
DESIGN+= dual_port_ram.v
#test bench del proyecto para la simulación
tb?=./top_tb.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# MACROS_SYN?=
MACROS_SIM=-DSIM
# Ruta donde está quartus instalado
PATH_QUARTUS=~/gitPackages/quartus/quartus/bin
# Z: Nombre para empaquetar proyecto
Z=ram_counter

MK_SYN=../../../../makefiles/altera-c4e6e10-syn.mk
MK_SIM=../../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
