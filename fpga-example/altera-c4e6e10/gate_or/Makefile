## UBICACIÓN DE LA APLICACIÓN QUARTUS ##

# Ruta donde está quartus instalado
PATH_QUARTUS=~/gitPackages/quartus-app/quartus/bin

# Aplicación de síntesis
CC=$(PATH_QUARTUS)/quartus_sh

# Aplicación para la programación
PGM=$(PATH_QUARTUS)/quartus_pgm

# Cable programador
CABLE=USB-Blaster

# Indice de dispositivos (FPGA) encontrados
INDEX_DEV=1

# Nombre del proyecto que será el TOP en la síntesis
TOP=top

# Build dir
B=build

## INICIO DE COMANDOS ##

# Flujo de compilación: 
compile:
	@echo "Flujo de síntesis"
	$(CC) --flow compile $(TOP)
	@cat $B/$(TOP).fit.summary

# Configurar la FPGA con el bitsream
config:
	@echo "Iniciar programación de FPGA"
	$(PGM) -m JTAG -o "P;$B/$(TOP).sof@$(INDEX_DEV)"

# Listar un cable programador
cable-list:
	@echo "Detectar cable"
	$(PGM) -l

# Detectar una fpga
fpga-detect:
	@echo "Detectar fpga"
	$(PGM) -c $(CABLE) -a

# Ayuda sobre comandos de ejemplo
compile-help:
	$(CC) --help=flow

RM=rm -rf
clean:
	$(RM) db incremental_db $B
