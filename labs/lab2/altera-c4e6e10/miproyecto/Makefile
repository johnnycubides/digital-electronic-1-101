help: help-sim help-quartus
clean: clean-zip clean-syn clean-sim
top=top
#test bench del proyecto para la simulación
tb=$(top)_tb.v
MACROS_SIM=
MACROS_SYN=
DESIGN=./top.v
DIR_BUILD=build
DEVSERIAL=
# Ruta donde está quartus instalado
# Debe coincidir la ruta del sintetizador de quartus para poderlo usar.
# En este caso coincide, sino, debe ser remplazada por la ruta donde lo haya instalado.
PATH_QUARTUS=~/gitPackages/quartus/quartus/bin
# Cable programador
# CABLE=USB-Blaster
# Z: Nombre para empaquetar proyecto
Z=template

top_NAME=$(basename $(notdir $(DESIGN)))
top?=$(top_NAME)
# Ruta donde está quartus instalado
PATH_QUARTUS?=~/gitPackages/quartus/quartus/bin
# Cable programador
CABLE?=USB-Blaster
# Configuration device
CONF_DEV=EPCS16
# Flash loader
FLASH_LOADER=EP4CE10

B=$(DIR_BUILD)
# MACROS_SYN sirve para indicar definiciones de preprocesamiento
MACROS_SYN?=

help-quartus:
	@echo "\n## SINTESIS Y CONFIGURACIÓN ##"
	@echo "\tmake syn\t\t-> Sintetizar diseño"
	@echo "\tmake config\t\t-> Configurar fpga"
	@echo "\tmake config-flash\t-> Configurar flash memory"
	@echo "\tmake erase-flash\t-> Borrar memoria flash (debe tener un archivo $B/$(top).jic)"
	@echo "\tmake clean\t\t-> Limipiar síntesis si ha modificado el diseño"

init: init-quartus-prj syn

config: config-cram

# Scrip general de flujo de diseño
CC=$(PATH_QUARTUS)/quartus_sh
# Aplicación para configuración de FPGA
PGM=$(PATH_QUARTUS)/quartus_pgm
# Aplicación para convertir formatos
CPF=$(PATH_QUARTUS)/quartus_cpf
# Mapeo, síntesis lógica
MAP=$(PATH_QUARTUS)/quartus_map
# Place and route (fitter)
FIT=$(PATH_QUARTUS)/quartus_fit
# Asociación de pines y optimización Assembler
ASM=$(PATH_QUARTUS)/quartus_asm
# Generación de archivos de configuración
STA=$(PATH_QUARTUS)/quartus_sta

# Indice de dispositivos (FPGA) encontrados
INDEX_DEV=1

# Si existen macros definidas, las pone en el formato que comprede quartus_map
MACROS_SYN_MAP := $(foreach macro,$(MACROS_SYN),--verilog_macro "$(macro)")

## INICIO DE COMANDOS ##

# Flujo de compilación: 
syn:
	@echo "Flujo de síntesis $(MACROS_SYN)"
ifeq ($(MACROS_SYN),)
	$(CC) --flow compile $(top)
else
	$(MAP) $(top) $(MACROS_SYN_MAP)
	$(FIT) $(top)
	$(ASM) $(top)
	$(STA) $(top)
endif
	@cat $B/$(top).fit.summary

syn-report:
	cat $B/top.sta.rpt

# Configurar cram
config-cram:
	@echo "Iniciar programación de FPGA"
	$(PGM) -m JTAG -o "p;$B/$(top).sof@$(INDEX_DEV)"

# Configurar memoria flash
# Para conocer las diferentes opciones ./quartus_pgm --help=o
config-flash:
	@echo "Iniciar configuración de memoria flash tarjeta de desarrollo"
	$(PGM) -m JTAG -o "pvbi;$B/$(top).jic@$(INDEX_DEV)"

erase-flash:
	@echo "Borrar flash"
	$(PGM) -m JTAG -o "ir;$B/$(top).jic@$(INDEX_DEV)"

# Convertir archivo sof a jic
# Opciones relacionadas al converter ./quartus_cpf --help=jic
convert-sof2jic:
	$(CPF) -c -d $(CONF_DEV) -s $(FLASH_LOADER) -m ASx1 $B/$(top).sof $B/$(top).jic

# Listar un cable programador
cable-list:
	@echo "Detectar cable"
	$(PGM) -l

# Detectar una fpga
fpga-detect:
	@echo "Detectar fpga"
	$(PGM) -c $(CABLE) -a

# Ayuda sobre comandos de ejemplo
syn-help:
	$(CC) --help=flow

# EMPAQUETAR PROYECTO EN .ZIP
Z?=prj
zip:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -3 Makefile > $Z/Makefile
	sed -n '4,$$p' $(MK_SYN) >> $Z/Makefile
	sed -n '7,$$p' $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md *.qsf *.qpf *.png .gitignore $Z
ifneq ($(wildcard *.txt),) # Si existe un archivo .png
	cp -var *.txt $Z
endif
ifneq ($(wildcard *.pdf),) # Si existe un archivo .png
	cp -var *.pdf $Z
endif
ifneq ($(wildcard *.mem),) # Si existe un archivo .png
	cp -var *.mem $Z
endif
ifneq ($(wildcard *.hex),) # Si existe un archivo .png
	cp -var *.hex $Z
endif
ifneq ($(wildcard *.gtkw),) # Si existe un archivo .txt
	cp -var *.gtkw $Z
endif
	zip -r $Z.zip $Z

init-quartus-prj:
	@echo "build/\nsim/\ndb/\nincremental_db/\n*.log\n$Z/\n" > .gitignore
	@printf '%s\n' \
		'##  CONFIGURACIÓN DE PROYECTO agregar en el archivo top.qsf ##' \
		'' \
		'set_global_assignment -name FAMILY "Cyclone IV E"' \
		'set_global_assignment -name DEVICE EP4CE10E22C8' \
		'set_global_assignment -name TOP_LEVEL_ENTITY top' \
		'set_global_assignment -name PROJECT_OUTPUT_DIRECTORY build' \
		'' \
		'## ASIGNACIÓN DE PINES ##' \
		'set_location_assignment PIN_86 -to a' \
		'set_location_assignment PIN_74 -to y' \
		> top.qsf

RM=rm -rf
clean-syn:
	$(RM) db incremental_db $B

clean-zip:
	$(RM) $Z
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
	@echo "\tmake ConvertOneVerilogFile\t\t:Crear un único verilog del diseño"

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

