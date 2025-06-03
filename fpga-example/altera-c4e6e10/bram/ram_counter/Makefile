help: help-sim help-syn
clean: clean-syn clean-sim
# TOP=top
#test bench del proyecto para la simulación
tb?=./top_tb.v
MACROS_SIM=-DSIM
# Agregar aquí otros archivos que se requieran para la simulación
MORE_SRC2SIM=./file.mem
DESIGN+= top.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Ruta donde está quartus instalado
PATH_QUARTUS=~/gitPackages/quartus/quartus/bin
# Z: Nombre para empaquetar proyecto
Z=ram_counter

MK_SYN=../../../../makefiles/altera-c4e6e10-syn.mk
MK_SIM=../../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
