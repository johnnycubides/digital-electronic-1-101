DESIGN?=
DEVSERIAL?=/dev/ttyUSB0
DIR_BUILD?=build
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

help-quartus:
	@echo "\n## SINTESIS Y CONFIGURACIÓN ##"
	@echo "\tmake syn\t\t-> Sintetizar diseño"
	@echo "\tmake config\t\t-> Configurar fpga"
	@echo "\tmake config-flash\t-> Configurar flash memory"

init: init-qsf syn-quartus

config: config-cram

# Aplicación de síntesis
CC=$(PATH_QUARTUS)/quartus_sh

# Aplicación para configuración de FPGA
PGM=$(PATH_QUARTUS)/quartus_pgm

# Aplicación para convertir formatos
CPF=$(PATH_QUARTUS)/quartus_cpf

# Indice de dispositivos (FPGA) encontrados
INDEX_DEV=1

## INICIO DE COMANDOS ##

# Flujo de compilación: 
syn:
	@echo "Flujo de síntesis"
	$(CC) --flow compile $(top)
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
	cp -var *.v *.md *.txt *.qsf *.qpf *.png .gitignore $Z
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

init-qsf:
	@echo "build/\nsim/\ndb/\nincremental_db/\n*.log\n$Z/\n" > .gitignore
	@echo "\n### ¡ATENCIÓN! ###"
	@echo "\nMODIFIQUE EL ARCHIVO top.qsf CON LA SIGUIENTE INFORMACIÓN:"
	@cat ./config.txt
	@echo "## END\n"

RM=rm -rf
clean-syn:
	$(RM) db incremental_db $B

clean-zip:
	$(RM) $Z
