help: help-sim help-quartus
clean: clean-zip clean-syn clean-sim
top=SOC
#test bench del proyecto para la simulación
tb=$(top)_tb.v
MACROS_SIM=
MACROS_RTL=
MACROS_SYN= BENCH SIM PASSTHROUGH_PLL BOARD_FREQ=27 CPU_FREQ=27
DESIGN+= SOC.v
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
DEVSERIAL=
# Ruta donde está quartus instalado
PATH_QUARTUS=~/gitPackages/quartus/quartus/bin
# Cable programador
# CABLE=USB-Blaster
# Z: Nombre para empaquetar proyecto
Z=femtoriscv

MK_SYN=../../../makefiles/altera-c4e6e10-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
