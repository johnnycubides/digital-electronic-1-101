help: help-sim help-syn
clean: clean-syn clean-sim
# top=top
top=SOC
#test bench del proyecto para la simulación
tb?=$(top)_tb.v
MACROS_SIM=-DINIT=(2**24-10) -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27
MACROS_RTL=
MACROS_SYN=
TB_V = SOC_tb.v
# DESIGN=top.v
DESIGN+= SOC.v
DESIGN+= cores/cpu/femtorv32_quark.v
DESIGN+= address_decoder.v
DESIGN+= chip_select.v
DESIGN+= cores/memory/Memory.v
DESIGN+= cores/uart/perip_uart.v
DESIGN+= cores/uart/uart.v
DESIGN+= cores/mult/perip_mult.v
DESIGN+= cores/mult/mult.v
DESIGN+= cores/dpRAM/dpram.v
DESIGN+= cores/dpRAM/perip_dpram.v
DIR_BUILD=build
PORT=/dev/ttyUSB1
BAUD=9600
# Z: Nombre para empaquetar proyecto
Z=femtoriscv
MORE_SRC2SIM=firmware.hex
more_src=cores init_dpram.ini firmware docs
c-build:
	make -C ./firmware c-build
c-clean:
	make -C ./firmware c-clean
asm-build:
	make -C ./firmware asm-build
asm-clean:
	make -C ./firmware asm-clean
t:
	picocom $(PORT) -b $(BAUD)

MK_SYN=../../../makefiles/ice40-hx8k-syn.mk
MK_SIM=../../../makefiles/sim.mk
include $(MK_SYN) $(MK_SIM)
