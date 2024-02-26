TOP?=top
DESIGN?=
DIR_BUILD?=build
DEVSERIAL?=/dev/ttyACM0
DEF_MACROS_VERILOG_SYN?=
LPF?=$(TOP).lpf
JSON?=$(DIR_BUILD)/$(TOP).json
PNR?=$(DIR_BUILD)/$(TOP).pnr
BISTREAM?=$(DIR_BUILD)/$(TOP).bin

help-syn:
	@echo "\n## SINTESIS Y CONFIGURACIÓN ##"
	@echo "\tmake syn\t\t-> Sintetizar diseño"
	@echo "\tmake config\t\t-> Configurar fpga en SRAM"
	@echo "\tmake config-flash\t-> Guardar el bistream en memoria flash"

syn: json pnr bitstream

OBJS+=$(DESIGN)

$(JSON): $(OBJS)
	mkdir -p $(DIR_BUILD)
	yosys $(DEF_MACROS_VERILOG_SYN) -p "synth_ecp5 -top $(TOP) -json $(JSON)" $(OBJS)

$(PNR): $(JSON)
	nextpnr-ecp5 --25k --package CABGA256 --speed 6 --json $(JSON) --lpf $(LPF) --freq 65 --textcfg $(PNR)

$(BISTREAM): $(PNR)
	ecppack $(PNR) $(BISTREAM)
# USB-UART
CABLE= -c ft232RL
# Pines del FTDI usable
FT232RL_TXD=0
FT232RL_RXD=1
FT232RL_RTS=2
FT232RL_CTS=3
FT232RL_DTR=4
FT232RL_DSR=5
FT232RL_DCD=6
FT232RL_RI=7
# JTAG pines relacionados con los pines del ft232rl
TDO=$(FT232RL_TXD)
TDI=$(FT232RL_RXD)
TMS=$(FT232RL_RTS)
TCK=$(FT232RL_CTS)
# JTAG pines relacionados con los pines del ft232rl
CABLE_PINES= --pins=$(TDI):$(TDO):$(TCK):$(TMS)

CONFIG_OPTIONS+=$(CABLE)
CONFIG_OPTIONS+=$(CABLE_PINES)
CONFIG_OPTIONS+= --verbose
CONFIG_OPTIONS+= --freq 3000000
# CONFIG_OPTIONS+= --invert-read-edge

PATH_OPEN_FPGA_LOADER=openFPGALoader

reset:
	$(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS)  -r

detect:
	$(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) --detect $(OPTIONS_CABLE)

config-flash:
	$(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) -f $(BISTREAM)

config-sram:
	$(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) -m $(BISTREAM)

config: config-sram

json:$(JSON)
pnr:$(PNR)
bitstream:$(BISTREAM)

Z?=prj
zip:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -3 Makefile > $Z/Makefile
	sed -n '6,$$p' $(MK_SYN) >> $Z/Makefile	# Empieza a escribir desde la línea 6
	sed -n '8,$$p' $(MK_SIM) >> $Z/Makefile # Empieza a escribir desde la línea 8
	cp -var *.v *.md *.lpf .gitignore $Z
ifneq ($(wildcard *.mem),) # Si existe un archivo .mem
	cp -var *.mem $Z
endif
ifneq ($(wildcard *.hex),) # Si existe un archivo .hex
	cp -var *.hex $Z
endif
ifneq ($(wildcard *.png),) # Si existe un archivo .png
	cp -var *.png $Z
endif
ifneq ($(wildcard *.txt),) # Si existe un archivo .txt
	cp -var *.txt $Z
endif
ifneq ($(wildcard *.gtkw),) # Si existe un archivo .gtkw
	cp -var *.gtkw $Z
endif
	zip -r $Z.zip $Z

init:
	@echo "build/\nsim/\n*.log\n$Z/\n" > .gitignore
	touch $(TOP).png README.md

clean-syn:
	$(RM) -rf $(DIR_BUILD)
	# $(RM) -f $(JSON) $(PNR) $(BISTREAM)

.PHONY: clean
# .PHONY: upload clean $(TOP).json $(TOP).bin $(TOP).pnr init_dir_build
