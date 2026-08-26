top?=
# Módules .v que hacen parte del proyecto
DESIGN?=
MACROS_SIM?=
MACROS_RTL?=

###############################
###--- Rules from sim.mk ---###
###############################
.ONESHELL:
SHELL=/bin/bash
# RUN: Entorno donde se encuentran las herramientas
RUN = source digital-logic-design activate &&

############################################################
### LISTA DE COMANDO DE AYUDA PARA REALIZAR SIMULACIONES ###
############################################################
help-sim:
	@printf "\n## SIMULACIÓN Y RTL ##\n"
	@printf "\tmake rtl \t-> Crear el RTL desde el TOP\n"
	@printf "\tmake sim \t-> Simular diseño\n"
	@printf "\tmake wave \t-> Ver simulación en gtkwave\n"
	@printf "\tmake log-rtl \t-> Ver el log del RTL. Comandos: /palabra -> buscar, n -> próxima palabra, q -> salir, h -> salir\n"
	@printf "\nEjemplos de simulaciones con más argumentos:\n"
	@printf "\tmake sim VVP_ARG=+inputs=5\t\t:Agregar un argumento a la simulación\n"
	@printf "\tmake sim VVP_ARG=+a=5\ +b=6\t\t:Agregar varios argumentos a la simulación\n"
	@printf "\tmake sim VVP_ARG+=+a=5 VVP_ARG+=+b=6\t:Agregar varios argumentos a la simulación\n"
	@printf "\tmake rtl top=modulo1\t\t\t:Obtiene el RTL de otros modulos (submodulos)\n"
	@printf "\tmake rtl rtl2png\t\t\t:Convertir el RTL del TOP desde formato svg a png\n"
	@printf "\tmake rtl rtl2png top=modulo1\t\t:Además de convertir, obtiene el RTL de otros modulos (submodulos)\n"
	@printf "\tmake ConvertOneVerilogFile\t\t:Crear un único verilog del diseño\n"

#####################################
### CONFIGURACIÓN DE HERRAMIENTAS ###
#####################################
# WAVE_VIEWER es el visor de formas de onda, opciones: gtkwave, surfer
WAVE_VIEWER?=gtkwave
# RTL_GENERATOR: Herramienta para generación de imagen RTL en svg, opciones: netlistsvg, netlist2svg
RTL_GENERATOR?=netlistsvg
# RTL_VIEWER Visor de RTL, opciones: open eog
RTL_VIEWER?=open
# S representa el directorio donde estarán los archivos de simulación
S?=sim
# RM está declarado como comando para remover archivos sin confirmación y de manera recursiva
RM=rm -rf

#################################
### VARIABLES AUTORELLENABLES ###
#################################
# tb: Archivo verilog que contiene el testbench
tb?=$(top)_tb.v
# TB_MODULE_NAME: Nombre del módulo contenido en el archivo testbench a simular
TB_MODULE_NAME?=$(basename $(notdir $(tb)))
# LOG_YOSYS_RTL: archivo donde se almacena el log de las ejecuciones de yosys
LOG_YOSYS_RTL?=$(S)/yosys-$(top).log

#############################
### PROCESO DE SIMULACIÓN ###
#############################
# La regla sim ejecuta el flujo de simulación donde: 
# 1. clean-sim: limpia objetos de simulaciones anteriores.
# 2. iverilog-compile: construye el script de simulación desde iverilog a
#    través de la descripción del testbench
# 3. vpp-simulate: Ejecuta la simulación y genera archivos de resultados
# 4. wave: en el caso de generar archivos de forma de onda los visualiza con el
#    visor especificado
sim: clean-sim iverilog-compile vpp-simulate wave

###########################################
### PROCESO DE GENERACIÓN DE IMAGEN RTL ###
###########################################
# La regla rtl ejecuta el flujo de genración de imagen rtl donde:
# 1. rtl-from-json: Yosys genera una síntesis de la red en formato json desde
#    los archivos verilog de la descripción de hardware
# 2. view-svg: desde el archivo json genera una imagen que representa la
#    estructura del circuito digital
rtl: rtl-from-json view-svg

##########################################
### GENERACIÓN DE SCRIPT DE SIMULACIÓN ###
##########################################
#  MACROS_SIM: Todos los macros declarados aquí afectarán el código verilog en
#  el preproceso, esto permite activar partes de código según lo que se desee
#  observar en una simulación
MACROS_SIM := $(foreach macro,$(MACROS_SIM),"$(macro)")
# MORE_SRC2SIM permite agregar más archivos fuentes para la simulación
MORE_SRC2SIM?=
iverilog-compile:
	mkdir -p $S
ifneq ($(MORE_SRC2SIM), )
	cp -var $(MORE_SRC2SIM) $S
endif
	$(RUN) iverilog $(MACROS_SIM) -o $S/$(TB_MODULE_NAME).vvp -s $(TB_MODULE_NAME) $(tb) $(DESIGN)

###############################
### EJECUCIÓN DE SIMULACIÓN ###
###############################
# VVP_ARG permite agregar argumentos en la simulación con vvp
VVP_ARG?=
vpp-simulate:
	cd $S && $(RUN) vvp $(TB_MODULE_NAME).vvp -vcd $(VVP_ARG) -dumpfile=$(TB_MODULE_NAME).vcd

#######################################
### VISUALIZACIÓN DE FORMAS DE ONDA ###
#######################################
wave:
ifeq ($(WAVE_VIEWER), gtkwave) # Si el visor es gtkwave entonces:
	$(RUN) $(WAVE_VIEWER) $S/$(TB_MODULE_NAME).vcd $(TB_MODULE_NAME).gtkw || (echo "No hay un forma de onda que mostrar en gtkwave, posiblemente no fue solicitada en la simulación")
endif

################################
### SÍMTESIS ESTRUCTURAL RTL ###
################################
#  MACROS_RTL: Todos los macros declarados aquí afectarán el código verilog en
#  el preproceso, esto permite activar partes de código según lo que se desee
#  observar en en la sítesis en la generación del RTL
MACROS_RTL := $(foreach macro,$(MACROS_RTL),"$(macro)")
json-yosys: ## Generar json para el rtl de netlistsvg
	mkdir -p $S
	$(RUN) yosys $(MACROS_RTL) -p 'prep -top $(top); hierarchy -check; proc; write_json $S/$(top).json' $(DESIGN) -l $(LOG_YOSYS_RTL)

################################################
### REGISTRO DE RESULTADOS AL GENERAR EL RTL ###
################################################
# Sirve para identificar los sucesos en el proceso de síntesis, traquear
# errores en el código, etc.
log-rtl:
	less $(LOG_YOSYS_RTL)

#######################################################################
### GENERAR UN ÚNICO ARCHIVO VERILOG DE UN PROYECTO VERILOG MODULAR ###
#######################################################################
# Convertir el diseño en un solo archivo de verilog, esto es útil si se desea
# simular en Digital con iverilog como una caja negra
ConvertOneVerilogFile:
	mkdir -p $S
	$(RUN) yosys $(MACROS_SIM) -p 'prep -top $(top); hierarchy -check; proc; opt -full; write_verilog -noattr -nodec $S/$(top).v' $(DESIGN)

###############################################
### GENERAR IMAGEN SVG DEL RTL DESDE YOSYS  ###
###############################################
# Yosys realiza un proceso de sintesis, seguido, netlistsvg construye una
# imagen de la estructura representada en un árbol (json)
rtl-from-json: json-yosys
	# Las siguientes intrucciones son temporales mientras se resuelve en netlistsvg o netlist2svg
	# START patch
	# Se hace una copia desde el archivo json de origen.
	cp $S/$(top).json $S/$(top)_origin.json
	# Quitar parametros en el nombre del módulo para que sea legible.
	sed -E \
  -e 's/"\$$paramod(\$$[^\\]+)?\\\\([^\\"]+)[^"]*": \{/"\2": {/g' \
  -e 's/"type": "\$$paramod(\$$[^\\]+)?\\\\([^\\"]+)[^"]*"/"type": "\2"/g' $S/$(top)_origin.json > $S/$(top).json 
	# END patch
	# Geneeración de imagen RTL
	$(RUN) $(RTL_GENERATOR) $S/$(top).json -o $S/$(top).svg
	# El siguiente comando pone un frame blanco al svg para su facil visulalización
	sed -i 's|<svg\([^>]*\)>|<svg\1>\n  <rect width="100%" height="100%" fill="white"/>|' $S/$(top).svg

################################################
### VISUALIZAR EL SVG QUE REPRESENTA EL RTL  ###
################################################
view-svg:
	@$(RTL_VIEWER) $S/$(top).svg

####################################################
### POBLAR NUEVOS PROYECTOS DESDE ESTE MAKEFILE  ###
####################################################
init-sim:	
	@printf "sim/\n$Z/\n" > .gitignore
	touch README.md

#############################
### EMPAQUETAR SIMULACIÓN ###
#############################
# Se usa para generar un comprimido .zip cuando quiere compartir instrucciones
# para realizar simulaciones con esta receta. 
# Z representa el directorio donde se empaquetará las fuentes de la simulación.
Z?=prj
zip-sim:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	# Quitar las últimas dos líneas del Makefile y crear copia en el directorio $Z
	head -n -2 Makefile > $Z/Makefile
	# Agregar el contenido de sim.mk después de la línea 6
	sed -n '6,$$p' $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md .gitignore $Z
ifneq ($(wildcard *.mem),) # Si existe un archivo .png
	cp -var *.mem $Z
endif
ifneq ($(wildcard *.hex),) # Si existe un archivo .png
	cp -var *.hex $Z
endif
ifneq ($(wildcard *.png),) # Si existe un archivo .png
	cp -var *.png $Z
endif
ifneq ($(wildcard *.svg),) # Si existe un archivo .png
	cp -var *.svg $Z
endif
ifneq ($(wildcard *.txt),) # Si existe un archivo .txt
	cp -var *.txt $Z
endif
ifneq ($(wildcard *.gtkw),) # Si existe un archivo .txt
	cp -var *.gtkw $Z
endif
ifneq ($(wildcard *.dig),) # Si existe un archivo .dig
	cp -var *.dig $Z
endif
	zip -r $Z.zip $Z

#######################################
### LIMPIAR OBJETOS DE SIMULACIONES ###
#######################################
# Se usa cuando quiere iniciar simulaciones borrando objetos antiguos
clean-sim:
	$(RM) $S $Z $Z.zip

