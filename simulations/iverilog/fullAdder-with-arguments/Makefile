help: help-sim
clean: clean-sim
# CONDA=~/miniconda3/bin/conda
top?=fulladder
#test bench del proyecto para la simulación
tb?=$(top)_tb.v
# DESIGN modules.v que hacen parte del proyecto
DESIGN?=./halfadder.v ./fulladder.v
# Z: Nombre para empaquetar proyecto
Z=fulladder-with-arguments

MK_SIM=../../../makefiles/sim.mk
include $(MK_SIM)
