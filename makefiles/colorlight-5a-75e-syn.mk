DESIGN?=
DEVSERIAL?=/dev/ttyACM0
DIR_BUILD?=build
MACROS_SYN?=
top_NAME=$(basename $(notdir $(DESIGN)))
top?=$(top_NAME)
LPF?=$(top).lpf
JSON?=$(DIR_BUILD)/$(top).json
PNR?=$(DIR_BUILD)/$(top).pnr
BISTREAM?=$(DIR_BUILD)/$(top).bin

help-syn:
	@echo "\n## SINTESIS Y CONFIGURACIÓN ##"
	@echo "\tmake syn\t\t-> Sintetizar diseño"
	@echo "\tmake config\t\t-> Configurar fpga en CRAM"
	@echo "\tmake config-flash\t-> Guardar el bistream en memoria flash"
	@echo "\tmake config-help\t-> Ayuda sobre cómo configurar la Colorlight"
	@echo "\tmake detect\t\t-> Detectar FPGA"
	@echo "\tmake reset\t\t-> Reiniciar FPGA"
	@echo "\tmake erase-flash\t-> Borrar la memoria flash de configuración"

syn: json pnr bitstream

OBJS+=$(DESIGN)

$(JSON): $(OBJS)
	mkdir -p $(DIR_BUILD)
	yosys $(MACROS_SYN) -p "synth_ecp5 -top $(top) -json $(JSON)" $(OBJS)

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
TDO=$(FT232RL_CTS)
TDI=$(FT232RL_TXD)
TMS=$(FT232RL_RXD)
TCK=$(FT232RL_DTR)
# JTAG pines relacionados con los pines del ft232rl
CABLE_PINES?=$(TDI):$(TDO):$(TCK):$(TMS)

CONFIG_OPTIONS+=$(CABLE)

ifneq ($(CABLE_PINES),) # Si cables es diferente de vacío
CONFIG_OPTIONS+= --pins=$(CABLE_PINES)
endif
CONFIG_OPTIONS+= --verbose
CONFIG_OPTIONS+= --freq 3000000
# CONFIG_OPTIONS+= --invert-read-edge

PATH_OPEN_FPGA_LOADER=openFPGALoader

reset:
	$(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS)  -r

detect:
	$(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) --detect $(OPTIONS_CABLE)

config-flash:
	$(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) -f $(BISTREAM) --unprotect-flash

erase-flash:
	$(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) --bulk-erase

config-sram:
	$(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) -m $(BISTREAM)

config: config-sram

config-help:
	@echo "## INFORMACIÓN DE CONFIGURACIÓN PARA COLORLIGHT ##\n\n\
	1. ENERGIZAR LA PLACA DE DESARROLLO COLORLIGHT: Para configurar la Colorlight se requiere un bridge como también una fuente de alimentación. \
	En este ejemplo, se supondrá el uso del FT232RL, el cual es un adaptador USB a UART que sirve para emular un bridge JTAG. \
	Primero deberá garantizar la alimentación del ECP5; la Colorlight tiene dos entradas de alimentación, una de 3.3v en el conector J33 y otra de 5v en J18. \
	Si trata de alimentar la Colorlight con el FT232RL a 3.3v es muy probable que no tenga la corriente suficiente para funcionar el circuito de la FPGA y por consiguiente, no se configure. \
	Puede hacer uso de la salida de 5v del FT232RL para configurar la FPGA, siempre y cuando no tenga sensores y actuadores que consuman mucha energia. Por tanto, \
	se RECOMIENDA EL USO DE UNA FUENTE EXTERNA DE 5V PARA UNA CONFIGURACIÓN DE LA COLORLIGHT CORRECTA. \n\n\
	2. PROCESO DE CONFIGURACIÓN: Se puede realizar la configuración a través de los comandos *make config* o *make config-flash*, para tal fin, deberá conectar el adapatador FT232RL a la COLORLIGHT \
	teniendo presente los pines a usar. \n\
	2.1 El FT232RL tiene 8 pines configurables para el JTAG que se identifican de la siguiente manera: \n\n\
	\tFT232RL: TXD=0, RXD=1, RTS=2, CTS=3, DTR=4, DSR=5, DCD=6 y RI=7\n\n\
	2.2 La Colorlight tiene los siguientes puertos de JTAG:\n\n\
	\tJTAG COLORLIGHT: TDI=J32, TDO=J30, TCK=J27 y TMS=J31\n\n\
	2.3 El comando *make config* y los alternativos tiene asociado los pines del JTAG de la siguiente manera: **CABLE_PINES=TDI:TDO:TCK:TMS**, en donde los valores son sustituidos por el número del pin del FT232RL \
	para emular el JTAG. Por defecto, al ejecutar el comando *make config*, los pines que son usados son:\n\n\
	\t-Orden de los pines para la configuración: CABLE_PINES=TDI:TDO:TCK:TMS\n\
	\t-Pines del FT232RL usados por defecto:     CABLE_PINES=$(TDI):$(TDO):$(TCK):$(TMS)\t\t, es decir, La pareja de pines [pinFPGA--pinFT232], como sigue: J32--TXD, J30--CTS, J27--DTR y J31--RXD.\n\n\
	2.4 Si desea hacer uso de otros pines, simplemente conectelos desde el FT232RL al JTAG de la FPGA y en el uso del comando *make config* y sus alternativos, indique explícitamente los pines a usar, ejemplo:\n\n\
	\tmake config CABLE_PINES=5:4:7:6\n\n\
	Lo anterior quiere decir que se ha seleccionado una configuración en la cual se conectará la FPGA y el FT232RL como sigue: TDI--DSR, TDO--DTR, TCK--RI y TMS--DCD.\n\n\
	3. OBSERVACIONES:\n\
	\t-Recuerde conectar el GND del FT232RL al GND de la COLORLIGHT\n\
	\t-Puede agregar la configuración de los cables (CABLE_PINES=pines seleccionados) en las cabeceras del Makefile para que no sea necesaria recordar la configuración de los pines que usted a seleccionado\n\
	\t-Puede detectar una FPGA con el comando *make detect*\n\
	\t-Puede reiniciar una FPGA con el comando *make reset*\n\
	"

json:$(JSON)
pnr:$(PNR)
bitstream:$(BISTREAM)

Z?=prj
zip:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -3 Makefile > $Z/Makefile
	# Copia el Makefile de syn desde la línea 5
	sed -n '5,$$p' $(MK_SYN) >> $Z/Makefile	# Empieza a escribir desde la línea 6
	sed -n '7,$$p' $(MK_SIM) >> $Z/Makefile # Empieza a escribir desde la línea 7
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
	touch $(top).png README.md

clean-syn:
	$(RM) -rf $(DIR_BUILD)
	# $(RM) -f $(JSON) $(PNR) $(BISTREAM)

.PHONY: clean
# .PHONY: upload clean $(top).json $(top).bin $(top).pnr init_dir_build
