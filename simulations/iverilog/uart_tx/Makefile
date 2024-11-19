help: help-sim
clean: clean-sim
# CONDA=~/miniconda3/bin/conda
# En la variable TOP poner el nombre que contiene el top.v del diseño
top?=top
# En la variable tb poner la Descripción de la simulación a realizar
tb?=$(top)_tb.v
# Módules .v que hacen parte del proyecto
# En la variable DESIGN se debe agregar los demás módulos que pertenecen al proyecto
DESIGN?=./top.v ./uart_tx_8n1.v
# Agregar aquí otros archivos que se requieran para la simulación
# MORE_SRC2SIM=./file.mem
# Z: Nombre para empaquetar proyecto
Z=uart_tx

MK_SIM=../../../makefiles/sim.mk
include $(MK_SIM)
