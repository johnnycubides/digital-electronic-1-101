DESIGN?=
DEVSERIAL?=/dev/ttyUSB0
DIR_BUILD?=build
top_NAME=$(basename $(notdir $(DESIGN)))
##############################################
###--- Rules from altera-c4e6e10-syn.mk ---###
##############################################
top?=$(top_NAME)
# Ruta donde está quartus instalado
PATH_QUARTUS?=~/gitPackages/quartus/quartus/bin
# Cable programador
CABLE?=USB-Blaster
# Configuration device
CONF_DEV=EPCS16
# Flash loader
FLASH_LOADER=EP4CE10

# Configs project
QPF_FILE := $(top).qpf
QSF_FILE := $(top).qsf
VERILOG_LIST_FILE :=verilog_sources.tcl

# Outputs dirs
B=$(DIR_BUILD)
LOG_DIR := logs
REPORT_DIR := reports

# Optimizacition options
OPTIMIZATION_LEVEL := balanced
FITTER_EFFORT := auto
REMOVE_DUPLICATE_LOGIC := on
OPTIMIZATION_TECHNIQUE := speed

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
CC :=$(PATH_QUARTUS)/quartus_sh
# Aplicación para configuración de FPGA
PGM :=$(PATH_QUARTUS)/quartus_pgm
# Aplicación para convertir formatos
CPF :=$(PATH_QUARTUS)/quartus_cpf
# Mapeo, síntesis lógica
MAP :=$(PATH_QUARTUS)/quartus_map
# Place and route (fitter)
FIT :=$(PATH_QUARTUS)/quartus_fit
# Asociación de pines y optimización Assembler
ASM :=$(PATH_QUARTUS)/quartus_asm
# Generación de archivos de configuración
STA :=$(PATH_QUARTUS)/quartus_sta

# Indice de dispositivos (FPGA) encontrados
INDEX_DEV=1

# Si existen macros definidas, las pone en el formato que comprede quartus_map
MACROS_SYN_MAP := $(foreach macro,$(MACROS_SYN),--verilog_macro "$(macro)")

## INICIO DE COMANDOS ##

# Generar archivo con la lista de archivos Verilog
$(VERILOG_LIST_FILE): $(DESIGN)
	@echo "Generando archivo de lista Verilog: $@"
	@echo "# Archivo generado automáticamente - Lista de archivos Verilog" > $@
	$(foreach file,$(DESIGN),echo "set_global_assignment -name VERILOG_FILE $(file)" >> $@;)

# Reglas para pasos individuales

init-dirs:
	@mkdir -p $(BUILD_DIR) $(LOG_DIR) $(REPORT_DIR)

map:
	@echo "Ejecutando solo quartus_map..."
	$(MAP) $(top) --source=$(QPF_FILE) --optimize=$(OPTIMIZATION_LEVEL) \
		> $(LOG_DIR)/map.log 2>&1

fit:
	@echo "Ejecutando solo quartus_fit..."
	$(FIT) $(top) --fitter_effort=$(FITTER_EFFORT) \
		--remove_duplicat_logic=$(REMOVE_DUPLICATE_LOGIC) \
		> $(LOG_DIR)/fit.log 2>&1

asm:
	@echo "Ejecutando solo quartus_asm..."
	$(ASM) $(top) > $(LOG_DIR)/asm.log 2>&1

sta:
	@echo "Ejecutando solo quartus_sta..."
	$(STA) $(top) --do_report_timing \
		> $(LOG_DIR)/sta.log 2>&1

# Flujo de compilación: 
syn:
	@echo "Iniciando síntesis completa..."
	@echo "Flujo de síntesis $(MACROS_SYN)"
ifeq ($(MACROS_SYN),)
	$(CC) --flow compile $(top).qpf
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
