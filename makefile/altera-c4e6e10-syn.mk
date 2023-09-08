TOP?=top
# Módules .v que hacen parte del proyecto
MODULES?=
# Ruta donde está quartus instalado
PATH_QUARTUS?=~/gitPackages/quartus/quartus/bin
# Cable programador
CABLE?=USB-Blaster

B=build

help-quartus:
	@echo "make rtl\t\t-> Crear RTL"
	@echo "make sim\t-> Simular diseño"

init: init-qsf syn-quartus

syn: syn-quartus

report-syn: report-syn-quartus

config: config-fpga-quartus

# clean: clean-sim clean-syn-quartus

# Aplicación de síntesis
CC=$(PATH_QUARTUS)/quartus_sh

# Aplicación para la programación
PGM=$(PATH_QUARTUS)/quartus_pgm

# Indice de dispositivos (FPGA) encontrados
INDEX_DEV=1

## INICIO DE COMANDOS ##

# Flujo de compilación: 
syn-quartus:
	@echo "Flujo de síntesis"
	$(CC) --flow compile $(TOP)
	@cat $B/$(TOP).fit.summary

report-syn-quartus:
	cat $B/top.sta.rpt

# Configurar la FPGA con el bitsream
config-fpga-quartus:
	@echo "Iniciar programación de FPGA"
	$(PGM) -m JTAG -o "P;$B/$(TOP).sof@$(INDEX_DEV)"

# Listar un cable programador
cable-list-quartus:
	@echo "Detectar cable"
	$(PGM) -l

# Detectar una fpga
fpga-detect-quartus:
	@echo "Detectar fpga"
	$(PGM) -c $(CABLE) -a

# Ayuda sobre comandos de ejemplo
syn-quartus-help:
	$(CC) --help=flow

init-qsf:
	@echo "build/\nsim/\ndb/\nincremental_db/\n*.log\n" > .gitignore
	@echo "\n### ¡ATENCIÓN! ###"
	@echo "\nMODIFIQUE EL ARCHIVO top.qsf CON LA SIGUIENTE INFORMACIÓN:"
	@echo "set_global_assignment -name FAMILY \"Cyclone IV E\""
	@echo "set_global_assignment -name DEVICE EP4CE10E22C8"
	@echo "set_global_assignment -name TOP_LEVEL_ENTITY top"
	@echo "set_global_assignment -name PROJECT_OUTPUT_DIRECTORY build\n"


RM=rm -rf
clean-syn-quartus:
	$(RM) db incremental_db $B
