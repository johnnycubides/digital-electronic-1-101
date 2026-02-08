help: help-sim help-quartus
clean: clean-zip clean-syn clean-sim
top=top
#test bench del proyecto para la simulación
tb=$(top)_tb.v
MACROS_SIM=
MACROS_RTL=
MACROS_SYN=
# Módules .v que hacen parte del proyecto
DESIGN+=./top.v
DEVSERIAL=
# Ruta donde está quartus instalado
PATH_QUARTUS=~/gitPackages/quartus/quartus/bin
# Cable programador
# CABLE=USB-Blaster
# Z: Nombre para empaquetar proyecto
Z=template

MK_SYN=../../../makefiles/altera-c4e6e10-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
