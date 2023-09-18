help: help-sim
clean: clean-sim
# CONDA=~/miniconda3/bin/conda
# En la variable TOP poner el nombre que contiene el top.v del diseño
TOP?=top
# En la variable tb poner la Descripción de la simulación a realizar
tb?=$(TOP)_tb.v
# Módules .v que hacen parte del proyecto
# En la variable MODULES se debe agregar los demás módulos que pertenecen al proyecto
MODULES?=

MK_SIM=../../../makefiles/sim.mk
include $(MK_SIM)
