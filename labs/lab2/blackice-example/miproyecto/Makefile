help: help-sim help-syn
clean: clean-syn clean-sim
top=top
#test bench del proyecto para la simulación
tb?=$(top)_tb.v
MACROS_SIM=
MACROS_SYN=
MORE_SRC2SIM?=
DESIGN=top.v
DIR_BUILD=build
DEVSERIAL=/dev/ttyACM0
# Z: Nombre para empaquetar proyecto
Z=template

top_NAME=$(basename $(notdir $(DESIGN)))
top?=$(top_NAME)
PCF?=$(top).pcf
JSON?=$(DIR_BUILD)/$(top).json
ASC?=$(DIR_BUILD)/$(top).asc
BISTREAM?=$(DIR_BUILD)/$(top).bin

# MACRO_SYN sirve para indicar definiciones de preprocesamiento en la sintesis
MACRO_SYN?=
MACROS_SYN := $(foreach macro,$(MACROS_SYN),"$(macro)")

help-syn:
	@echo "\n## SINTESIS Y CONFIGURACIÓN ##"
	@echo "\tmake syn\t-> Sintetizar diseño"
	@echo "\tmake config\t-> Configurar fpga"
	@echo "\tmake clean\t-> Limipiar síntesis si ha modificado el diseño"

syn: json asc bitstream

OBJS+=$(DESIGN)

$(JSON): $(OBJS)
	mkdir -p $(DIR_BUILD)
	yosys $(MACRO_SYN) -p "synth_ice40 -top $(top) -json $(JSON)" $(OBJS)

$(ASC): $(JSON)
	nextpnr-ice40 --hx4k --package tq144 --json $(JSON) --pcf $(PCF) --asc $(ASC)

$(BISTREAM): $(ASC)
	icepack $(ASC) $(BISTREAM)

config:
	stty -F $(DEVSERIAL) raw
	cat $(BISTREAM) > $(DEVSERIAL)

json:$(JSON)
asc:$(ASC)
bitstream:$(BISTREAM)

Z?=prj
zip:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -3 Makefile > $Z/Makefile
	# Copia el Makefile de syn desde la línea 4
	sed -n '4,$$p' $(MK_SYN) >> $Z/Makefile
	sed -n '7,$$p' $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md *.pcf .gitignore $Z
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
	# $(RM) -f $(JSON) $(ASC) $(BISTREAM)

.PHONY: clean
# .PHONY: upload clean $(top).json $(top).bin $(top).asc init_dir_build
tb?=$(top_NAME)_tb.v
TBN=$(basename $(notdir $(tb)))

S=sim

help-sim:
	@echo "\n## SIMULACIÓN Y RTL##"
	@echo "\tmake rtl \t-> Crear el RTL desde el TOP"
	@echo "\tmake sim \t-> Simular diseño"
	@echo "\tmake wave \t-> Ver simulación en gtkwave"
	@echo "\nEjemplos de simulaciones con más argumentos:"
	@echo "\tmake sim VVP_ARG=+inputs=5\t\t:Agregar un argumento a la simulación"
	@echo "\tmake sim VVP_ARG=+a=5\ +b=6\t\t:Agregar varios argumentos a la simulación"
	@echo "\tmake sim VVP_ARG+=+a=5 VVP_ARG+=+b=6\t:Agregar varios argumentos a la simulación"
	@echo "\tmake rtl TOP=modulo1\t\t\t:Obtiene el RTL de otros modulos (submodulos)"
	@echo "\tmake rtl rtl2png\t\t\t:Convertir el RTL del TOP desde formato svg a png"
	@echo "\tmake rtl rtl2png TOP=modulo1\t\t:Además de convertir, obtiene el RTL de otros modulos (submodulos)"
	@echo "\tmake ConvertOneVerilogFile\t\t\t:Crear un único verilog del diseño"

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
	iverilog $(MACROS_SIM) -o $S/$(TBN).vvp $(tb)

# VVP_ARG permite agregar argumentos en la simulación con vvp
VVP_ARG=
vpp-simulate:
	cd $S && vvp $(TBN).vvp -vcd $(VVP_ARG) -dumpfile=$(TBN).vcd

wave:
	@gtkwave $S/$(TBN).vcd $(TBN).gtkw || (echo "No hay un forma de onda que mostrar en gtkwave, posiblemente no fue solicitada en la simulación")

json-yosys:
	mkdir -p $S
	yosys $(MACROS_SIM) -p 'prep -top $(top); hierarchy -check; proc; write_json $S/$(top).json' $(DESIGN)

# Convertir el diseño en un solo archivo de verilog
ConvertOneVerilogFile:
	mkdir -p $S
	yosys $(MACROS_SIM) -p 'prep -top $(top); hierarchy -check; proc; opt -full; write_verilog -noattr -nodec $S/$(top).v' $(DESIGN)
	# yosys -p 'read_verilog $(DESIGN); prep -top $(TOP); hierarchy -check; proc; opt -full; write_verilog -noattr -noexpr -nodec $S/$(TOP).v'
	# yosys -p 'read_verilog $(DESIGN); prep -top $(TOP); hierarchy -check; proc; flatten; synth; write_verilog -noattr -noexpr $S/$(TOP).v'

rtl-from-json: json-yosys
	netlistsvg $S/$(top).json -o $S/$(top).svg

view-svg:
	eog $S/$(top).svg

rtl-xdot:
	yosys $(MACROS_SIM) -p $(RTL_COMMAND)

rtl2png:
	convert -density 200 -resize 1200 $S/$(top).svg $(top).png
	# convert -resize 1200 -quality 100 $S/$(TOP).svg $(TOP).png

init-sim:	
	@echo "sim/\n$Z/\n" > .gitignore
	touch README.md $(top).png

RM=rm -rf
# EMPAQUETAR SIMULACIÓN EN .ZIP
Z?=prj
zip-sim:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	# Quitar las últimas dos líneas del Makefile y crear copia en el directorio $Z
	head -n -2 Makefile > $Z/Makefile
	# Agregar desde la línea 7 en adelante en el Makefile
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

