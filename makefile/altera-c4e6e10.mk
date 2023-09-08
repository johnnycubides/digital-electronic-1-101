# CONDA=~/miniconda3/bin/conda
TOP?=top
#test bench del proyecto para la simulación
tb?=$(TOP)_tb.v
# Módules .v que hacen parte del proyecto
MODULES?=
# Ruta donde está quartus instalado
PATH_QUARTUS?=~/gitPackages/quartus/quartus/bin
# Cable programador
CABLE?=USB-Blaster

S=sim
B=build

help:
	@echo "rtl \t \t -> Crear RTL"
	@echo "simulate \t-> Simular diseño"
	@echo "sintetizar \t-> Sintetizar diseño"

init: init-qsf syn-quartus

rtl: rtl-from-json view-svg

sim: iverilog-compile vpp-simulate wave

syn: syn-quartus

report-syn: report-syn-quartus

config: config-fpga-quartus

clean: clean-sim clean-syn-quartus

iverilog-compile:
	mkdir -p $S
	iverilog -o $S/$(TOP).vvp $(tb) $(TOP).v $(MODULES)

vpp-simulate:
	cd $S && vvp $(TOP).vvp -vcd

wave:
	gtkwave $S/top.vcd

json-yosys:
	mkdir -p $S
	yosys -p 'read_verilog $(TOP).v $(MODULES); hierarchy -check; proc; write_json $S/$(TOP).json'

rtl-from-json: json-yosys
	netlistsvg $S/$(TOP).json -o $S/$(TOP).svg

view-svg:
	eog $S/$(TOP).svg

rtl-xdot:
	yosys -p $(RTL_COMMAND)

clean-sim:
	rm -rf $S
## YOSYS ARGUMENTS

RTL_COMMAND?='read_verilog $(TOP).v $(MODULES);\
						 hierarchy -check;\
						 show $(TOP)'

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
