help: help-sim help-syn
clean: clean-syn clean-sim
# top=top
top=SOC
#test bench del proyecto para la simulación
tb?=$(top)_tb.v
MACROS_SIM=-DINIT=(2**24-10)
MACROS_RTL=
MACROS_SYN=
# DESIGN=top.v
DESIGN = SOC.v
DESIGN+= address_decoder.v
DESIGN+= peripheral_mux.v
DESIGN+= cores/cpu/femtorv32_quark.v
DESIGN+= cores/uart/perip_uart.v
DESIGN+= cores/uart/uart.v
DESIGN+= cores/mult/perip_mult.v
DESIGN+= cores/mult/mult.v
DESIGN+= cores/dpRAM/dpram.v
DESIGN+= cores/dpRAM/perip_dpram.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=rtl

MK_SYN=../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
