TOP?=top
# Módules .v que hacen parte del proyecto
MODULES?=
# Ruta donde está quartus instalado
PATH_QUARTUS?=~/gitPackages/quartus/quartus/bin
# Cable programador
CABLE?=USB-Blaster

B=build

help-quartus:
	@echo "make syn\t-> Sintetizar diseño"
	@echo "make config\t-> Configurar fpga"

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

# EMPAQUETAR PROYECTO EN .ZIP
Z=prj
zip-src:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	sed -n '1,2p' ./Makefile > $Z/Makefile
	sed -n '11,$$p' ./Makefile >> $Z/Makefile
	cat $(MK_SYN) >> $Z/Makefile
	cat $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md *.txt *.qsf *.qpf .gitignore $Z
	zip -r $Z.zip $Z

init-qsf:
	@echo "build/\nsim/\ndb/\nincremental_db/\n*.log\n$Z/\n" > .gitignore
	@echo "\n### ¡ATENCIÓN! ###"
	@echo "\nMODIFIQUE EL ARCHIVO top.qsf CON LA SIGUIENTE INFORMACIÓN:"
	@cat ./config.txt
	@echo "## END\n"

RM=rm -rf
clean-syn-quartus:
	$(RM) db incremental_db $B

clean-zip:
	$(RM) $Z
