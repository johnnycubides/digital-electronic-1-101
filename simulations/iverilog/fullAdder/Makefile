help: help-sim
clean: clean-sim
# CONDA=~/miniconda3/bin/conda
top?=fulladder
# DESIGN modules.v que hacen parte del proyecto
DESIGN?=./fulladder.v
#test bench del proyecto para la simulación
tb?=$(top)_tb.v
# Z: Nombre para empaquetar proyecto
Z=fulladder

MK_SIM=../../../makefiles/sim.mk
include $(MK_SIM)
