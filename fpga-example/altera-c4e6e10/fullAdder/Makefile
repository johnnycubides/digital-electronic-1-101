help: help-sim help-quartus
clean: clean-zip clean-syn-quartus clean-sim

TOP=top
#test bench del proyecto para la simulación
tb=$(TOP)_tb.v
# Módules .v que hacen parte del proyecto
MODULES=./fulladder.v ./halfadder.v
# # Ruta donde está quartus instalado
PATH_QUARTUS=~/gitPackages/quartus/quartus/bin
# # Cable programador
# CABLE=USB-Blaster

MK_SYN=../../../makefiles/altera-c4e6e10-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
