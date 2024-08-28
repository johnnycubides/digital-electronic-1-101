help: help-sim help-syn
clean: clean-syn clean-sim
# top=
# test bench del proyecto para la simulación
tb?=./counter8bits_tb.v
# Agregar aquí otros archivos que se requieran para la simulación
MORE_SRC2SIM=
# tb?=$(TOP)_tb.v
# DESIGN=./freq_divider.v ./top.v
DESIGN=./j1a.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=counter

MK_SYN=../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
