help: help-sim
clean: clean-sim
# CONDA=~/miniconda3/bin/conda
TOP?=bcd7seg
#test bench del proyecto para la simulación
tb?=$(TOP)_tb.v
# DESIGN modules.v que hacen parte del proyecto
DESIGN?=bcd7seg.v
# Agregar aquí otros archivos que se requieran para la simulación
MORE_SRC2SIM=
# Z: Nombre para empaquetar proyecto
Z=bcd7seg

MK_SIM=../../../makefiles/sim.mk
include $(MK_SIM)
