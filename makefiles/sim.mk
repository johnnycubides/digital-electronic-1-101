# CONDA=~/miniconda3/bin/conda
TOP?=top
#test bench del proyecto para la simulación
tb?=$(TOP)_tb.v
# Módules .v que hacen parte del proyecto
DESIGN?=

S=sim

help-sim:
	@echo "\n## SIMULACIÓN Y RTL##"
	@echo "\tmake rtl \t-> Crear RTL"
	@echo "\tmake sim \t-> Simular diseño"
	@echo "\tmake wave \t-> Ver simulación en gtkwave"
	@echo "\nEjemplos de simulaciones con más argumentos:"
	@echo "\tmake sim VVP_ARG=+inputs=5\t\t:Agregar un argumento a la simulación"
	@echo "\tmake sim VVP_ARG=+a=5\ +b=6\t\t:Agregar varios argumentos a la simulación"
	@echo "\tmake sim VVP_ARG+=+a=5 VVP_ARG+=+b=6\t:Agregar varios argumentos a la simulación"
	@echo "\tmake rtl rtl2png\t\t\t:Convertir el RTL del formato svg a png"
	@echo "\tmake rtl rtl2png TOP=modulo1 DESIGN=modulo2.v\ modulo3.v\t:Además de convertir, obtiene el RTL de otros modulos (submodulos)"
	@echo "\tmake rtl rtl2png TOP=modulo1 DESIGN=\t:Además de lo anterior se puede obtener el RTL de un módulo que no contiene submodulos"

rtl: rtl-from-json view-svg

sim: clean-sim iverilog-compile vpp-simulate wave

iverilog-compile:
	mkdir -p $S
	iverilog -o $S/$(TOP).vvp $(tb) $(DESIGN)

# VVP_ARG permite agregar argumentos en la simulación con vvp
VVP_ARG=
vpp-simulate:
	cd $S && vvp $(TOP).vvp -vcd $(VVP_ARG)

wave:
	@gtkwave $S/top.vcd	|| (echo "No hay un forma de onda que motrar en gtkwave, posiblemente no fue solicitada en la simulación")

json-yosys:
	mkdir -p $S
	yosys -p 'read_verilog $(DESIGN); prep -top $(TOP); hierarchy -check; proc; write_json $S/$(TOP).json'

rtl-from-json: json-yosys
	netlistsvg $S/$(TOP).json -o $S/$(TOP).svg

view-svg:
	eog $S/$(TOP).svg

rtl-xdot:
	yosys -p $(RTL_COMMAND)

rtl2png:
	convert -density 1200 $S/$(TOP).svg $(TOP).png

init-sim:	
	@echo "sim/\nprj/\n" > .gitignore
	touch README.md top.png

RM=rm -rf
# EMPAQUETAR SIMULACIÓN EN .ZIP
Z=prj
zip-sim:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -2 Makefile > $Z/Makefile
	sed -n '7,$$p' $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md .gitignore $Z
ifneq ($(wildcard *.png),) # Si existe un archivo .png
	cp -var *.png $Z
endif
ifneq ($(wildcard *.txt),) # Si existe un archivo .txt
	cp -var *.txt $Z
endif
	zip -r $Z.zip $Z

clean-sim:
	rm -rf $S $Z

## YOSYS ARGUMENTS
RTL_COMMAND?='read_verilog $(DESIGN);\
						 hierarchy -check;\
						 show $(TOP)'

