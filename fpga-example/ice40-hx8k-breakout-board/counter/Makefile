help: help-sim help-syn
clean: clean-syn clean-sim
TOP=top
#test bench del proyecto para la simulación
tb?=
# Agregar aquí otros archivos que se requieran para la simulación
MORE_SRC2SIM=
# tb?=$(TOP)_tb.v
# DESIGN=./freq_divider.v ./top.v
DESIGN=./top.v ./clk10hz.v ./counter8bits.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0

MK_SYN=../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
