#######################################################
###--- VARIABLES A SER CONFIGURADAS POR PROYECTO ---###
#######################################################
# top: nombre del módulo top del diseño
top?=
# DESIGN: Archivos verilog (.v) del diseño, deberá agregar todos los requeridos
DESIGN+=
# MACROS_SYN: Reglas condicionales en el proceso de presíntesis
MACROS_SYN?=
# Z: Nombre base del archivo .zip en el que se empaquetará el projecto
Z?=
# MORE_SRC_TO_ZIP: Otros archivos del diseño a empaquetar en la regla zip
MORE_SRC_TO_ZIP?=
# En la regla zip poner empezar a escribir desde la línea 15

#######################################################
###--- START Rules from colorlight-5a-75e-syn.mk ---###
#######################################################
.ONESHELL:
SHELL=/bin/bash

########################################################
### LISTA DE COMANDO DE AYUDA PARA REALIZAR SYNTESIS ###
########################################################
help-syn:
	@printf "\n## SINTESIS Y CONFIGURACIÓN ##\n"
	@printf "\tmake syn\t\t-> Sintetizar diseño\n"
	@printf "\tmake config\t\t-> Configurar fpga en SRAM\n"
	@printf "\tmake config-flash\t-> Guardar el bitstream en memoria flash\n"
	@printf "\tmake config-help\t-> Ayuda sobre cómo configurar la Colorlight\n"
	@printf "\tmake detect\t\t-> Detectar FPGA\n"
	@printf "\tmake reset\t\t-> Reiniciar FPGA\n"
	@printf "\tmake erase-flash\t-> Borrar la memoria flash de configuración\n"
	@printf "\tmake log-syn\t\t-> Ver el log de la síntesis con Yosys. Comandos: /palabra -> buscar, n -> próxima palabra, q -> salir, h -> salir\n"
	@printf "\tmake log-pnr\t\t-> Ver el log del place&route con nextpnr. Comandos: /palabra -> buscar, n -> próxima palabra, q -> salir, h -> salir\n"
	@printf "\tmake clean\t\t-> Limipiar síntesis si ha modificado el diseño\n"

#####################################
### CONFIGURACIÓN DE HERRAMIENTAS ###
#####################################
# RUN: Entorno donde se encuentran las herramientas
RUN = source digital-logic-design activate &&
# BUILD_DIR: Directorio donde se pondrán los archivos objetos generados en la síntesis
BUILD_DIR?=build
# RM: está declarado como comando para remover archivos sin confirmación y de manera recursiva
RM=rm -rf

#################################
### VARIABLES AUTORELLENABLES ###
#################################
# top: Si no se declara el top del diseño, se asignará como el nombre del primer archivo que está en DESIGN.
top?=$(firstword $(basename $(notdir $(DESIGN))))
# LPF: Archivo de restricciones físicas del diseño.
LPF?=$(top).lpf
# JSON: Archivo donde quedará la representación estructural de la sintesis desde el HDL.
JSON?=$(BUILD_DIR)/$(top).json
# PNR: Archivo donde quedará el place and route del diseño en la FPGA seleccionada.
PNR?=$(BUILD_DIR)/$(top).pnr
# BITSTREAM: Archivo empaquetado de la confiración para la memoria RAM de configuración de la FPGA.
BITSTREAM?=$(BUILD_DIR)/$(top).bit
# LOG_YOSYS: Archivo log del resultado de la sisntesis con yosys.
LOG_YOSYS?=$(BUILD_DIR)/yosys-$(top).log
# LOG_NEXTPNR: Archivo log resultado del place and rout con nextpnr.
LOG_NEXTPNR?=$(BUILD_DIR)/nextpnr-$(top).log

###########################
### PROCESO DE SÍNTESIS ###
###########################
# La regla syn ejecuta el flujo de síntesis donde:
# 1. json: Realiza el proceso de sintesis con Yosys, esto convierte la
#    descripción HDL Verilog en una estructura de objetos relacionados que
#    representan el circuito digital.
# 2. pnr: El cirucito será ahora localizado en los recursos de la FPGA donde
#    será validado para saber si es posible o no de implementarse (place and
#    route).
# 3. bitstream: Se empaqueta esta descripción en 1s y 0s para ser cargada en la
#    ram de configuración de la FPGA.
syn: json pnr bitstream

json:$(JSON)
pnr:$(PNR)
bitstream:$(BITSTREAM)

##########################
### SÍNTESIS CON YOSYS ###
##########################
OBJS+=$(DESIGN)
# MACRO_SYN: sirve para indicar definiciones de preprocesamiento en la sintesis
MACROS_SYN := $(foreach macro,$(MACROS_SYN),"$(macro)")
$(JSON): $(OBJS)
	mkdir -p $(BUILD_DIR)
	$(RUN) yosys $(MACROS_SYN) -p "synth_ecp5 -top $(top) -json $(JSON)" $(OBJS) -l $(LOG_YOSYS)

log-syn:
	less $(LOG_YOSYS)

###################################
### PLACE AND ROUTE CON NEXTPNR ###
###################################
$(PNR): $(JSON)
	$(RUN) nextpnr-ecp5 --25k --package CABGA256 --speed 6 --json $(JSON) --lpf $(LPF) --freq 65 --textcfg $(PNR) --log $(LOG_NEXTPNR)

log-pnr:
	less $(LOG_NEXTPNR)

###############################
### EMPAQUETAR EN BITSTREAM ###
###############################
$(BITSTREAM): $(PNR)
	$(RUN) ecppack $(PNR) $(BITSTREAM)


##########################################
### CONFIGURAR FPGA CON OPENFPGALOADER ###
##########################################
# Cable a usar con openfpgaloader
CABLE= -c ft232RL
# Pines del FTDI usables
FT232RL_TXD=0
FT232RL_RXD=1
FT232RL_RTS=2
FT232RL_CTS=3
FT232RL_DTR=4
FT232RL_DSR=5
FT232RL_DCD=6
FT232RL_RI=7
# JTAG pines relacionados con los pines del ft232rl
TDI=$(FT232RL_TXD)
TDO=$(FT232RL_CTS)
TCK=$(FT232RL_DTR)
TMS=$(FT232RL_RXD)
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
	$(RUN) $(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS)  -r

detect:
	$(RUN) $(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) --detect $(OPTIONS_CABLE)

config-flash:
	$(RUN) $(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) -f $(BITSTREAM) --unprotect-flash

erase-flash:
	$(RUN) $(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) --bulk-erase --unprotect-flash

config-sram:
	$(RUN) $(PATH_OPEN_FPGA_LOADER) $(CONFIG_OPTIONS) -m $(BITSTREAM)

config: config-sram

config-help:
	@printf "## INFORMACIÓN DE CONFIGURACIÓN PARA COLORLIGHT ##\n\n\
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

#######################################
### COMPRIMIR Y EMPAQUETAR PROYECTO ###
#######################################
Z?=prj
zip:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -3 Makefile > $Z/Makefile
	sed -n '15,$$p' $(MK_SYN) >> $Z/Makefile	# Empieza a escribir desde la línea 15
	sed -n '15,$$p' $(MK_SIM) >> $Z/Makefile # Empieza a escribir desde la línea 15
	cp -var *.v *.md *.lpf .gitignore $Z
ifneq ($(wildcard *.pdf),) # Si existe un archivo .pdf
	cp -var *.pdf $Z
endif
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
ifdef MORE_SRC_TO_ZIP
	cp -var $(MORE_SRC_TO_ZIP) $Z
endif
	zip -r $Z.zip $Z

init:
	@echo "build/\nsim/\n*.log\n$Z/\n" > .gitignore
	touch $(top).png README.md

###################################
### LIMPIAR OBJETOS DE SÍNTESIS ###
###################################
# clean-syn: Se usa cuando quiere iniciar síntesis borrando objetos antiguos
clean-syn:
	$(RM) -rf $(BUILD_DIR)
	# $(RM) -f $(JSON) $(PNR) $(BITSTREAM)

.PHONY: clean
# .PHONY: upload clean $(top).json $(top).bin $(top).pnr init_dir_build
