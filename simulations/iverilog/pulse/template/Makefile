help: help-sim
clean: clean-sim
# CONDA=~/miniconda3/bin/conda
# En la variable top poner el id del módulo que contiene el top.v del diseño
top?=pulse
# En la variable tb poner la Descripción de la simulación a realizar
tb?=$(top)_tb.v
# Módules .v que hacen parte del proyecto
DESIGN?=$(top).v
# Agregar aquí otros archivos que se requieran para la simulación
# MORE_SRC2SIM=./file.mem
# MACROS_SIM sirve para indicar definiciones de preprocesamiento
# MACROS_SIM?=
# Z: Nombre para empaquetar proyecto en este caso template
Z=template

top_NAME=$(basename $(notdir $(DESIGN)))
###############################
###--- Rules from sim.mk ---###
###############################
tb?=$(top_NAME)_tb.v
TBN=$(basename $(notdir $(tb)))

S=sim
LOG_YOSYS_RTL?=$(S)/yosys-$(top).log

.ONESHELL:
SHELL=/bin/bash
# Enviroment conda to activate
ENV=digital
CONDA_ACTIVATE = source $$($$CONDA_EXE info --base)/etc/profile.d/conda.sh ; conda activate; conda activate $(ENV)
RUN = $(CONDA_ACTIVATE) &&
RUN =# Activate if don't use CONDA

help-sim:
	@printf "\n## SIMULACIÓN Y RTL##"
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

rtl: rtl-from-json view-svg

sim: clean-sim iverilog-compile vpp-simulate wave

MACROS_SIM := $(foreach macro,$(MACROS_SIM),"$(macro)")
# MORE_SRC2SIM permite agregar más archivos fuentes para la simulación
MORE_SRC2SIM?=
iverilog-compile:
	mkdir -p $S
ifneq ($(MORE_SRC2SIM), )
	cp -var $(MORE_SRC2SIM) $S
endif
	iverilog $(MACROS_SIM) -o $S/$(TBN).vvp -s $(TBN) $(tb) $(DESIGN)

# VVP_ARG permite agregar argumentos en la simulación con vvp
VVP_ARG=
vpp-simulate:
	cd $S && vvp $(TBN).vvp -vcd $(VVP_ARG) -dumpfile=$(TBN).vcd

wave:
	@gtkwave $S/$(TBN).vcd $(TBN).gtkw || (echo "No hay un forma de onda que mostrar en gtkwave, posiblemente no fue solicitada en la simulación")

MACROS_RTL := $(foreach macro,$(MACROS_RTL),"$(macro)")
json-yosys: ## Generar json para el rtl de netlistsvg
	mkdir -p $S
	$(RUN) yosys $(MACROS_RTL) -p 'prep -top $(top); hierarchy -check; proc; write_json $S/$(top).json' $(DESIGN) -l $(LOG_YOSYS_RTL)

log-rtl:
	less $(LOG_YOSYS_RTL)

# Convertir el diseño en un solo archivo de verilog
ConvertOneVerilogFile:
	mkdir -p $S
	$(RUN) yosys $(MACROS_SIM) -p 'prep -top $(top); hierarchy -check; proc; opt -full; write_verilog -noattr -nodec $S/$(top).v' $(DESIGN)
	# yosys -p 'read_verilog $(DESIGN); prep -top $(TOP); hierarchy -check; proc; opt -full; write_verilog -noattr -noexpr -nodec $S/$(TOP).v'
	# yosys -p 'read_verilog $(DESIGN); prep -top $(TOP); hierarchy -check; proc; flatten; synth; write_verilog -noattr -noexpr $S/$(TOP).v'

rtl-from-json: json-yosys
	cp $S/$(top).json $S/$(top)_origin.json # Hacer una copia desde el archivo origen
	sed -E 's/"\$$paramod\$$[^\\]+\\\\([^"]+)"/"\1"/g' $S/$(top)_origin.json > $S/$(top).json # Quitar parametros en el nombre del módulo para que sea legible.
	$(RUN) netlistsvg $S/$(top).json -o $S/$(top).svg
	## convert2SvgwithWhiteBackground
	sed -i 's|<svg\([^>]*\)>|<svg\1>\n  <rect width="100%" height="100%" fill="white"/>|' $S/$(top).svg

view-svg:
	eog $S/$(top).svg

rtl-xdot:
	$(RUN) yosys $(MACROS_SIM) -p $(RTL_COMMAND)

rtl2png:
	convert -density 200 -resize 1200 $S/$(top).svg $(top).png
	# convert -resize 1200 -quality 100 $S/$(TOP).svg $(TOP).png

init-sim:	
	@printf "sim/\n$Z/\n" > .gitignore
	touch README.md $(top).png

RM=rm -rf
# EMPAQUETAR SIMULACIÓN EN .ZIP
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

clean-sim:
	rm -rf $S $Z $Z.zip

## YOSYS ARGUMENTS
RTL_COMMAND?='read_verilog $(DESIGN);\
						 hierarchy -check;\
						 show $(top)'

