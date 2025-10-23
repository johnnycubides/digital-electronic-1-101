help: help-sim
clean: clean-sim
# CONDA=~/miniconda3/bin/conda
# En la variable top poner el id del módulo que contiene el top.v del diseño
top?=pulse
# Módules .v que hacen parte del proyecto
DESIGN?=$(top).v
# En la variable tb poner la Descripción de la simulación a realizar
tb?=$(top)_tb.v
# Agregar aquí otros archivos que se requieran para la simulación
# MORE_SRC2SIM=./file.mem
# MACROS_SIM sirve para indicar definiciones de preprocesamiento
# MACROS_SIM?=
# Z: Nombre para empaquetar proyecto en este caso template
Z=pulse

MK_SIM=../../../makefiles/sim.mk
include $(MK_SIM)
