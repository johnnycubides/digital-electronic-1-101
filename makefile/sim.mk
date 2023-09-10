# CONDA=~/miniconda3/bin/conda
TOP?=top
#test bench del proyecto para la simulación
tb?=$(TOP)_tb.v
# Módules .v que hacen parte del proyecto
MODULES?=

S=sim

help-sim:
	@echo "make rtl \t-> Crear RTL"
	@echo "make sim \t-> Simular diseño"
	@echo "make wave \t-> Ver simulación en gtkwave"

rtl: rtl-from-json view-svg

sim: clean-sim iverilog-compile vpp-simulate wave

iverilog-compile:
	mkdir -p $S
	iverilog -o $S/$(TOP).vvp $(tb) $(TOP).v $(MODULES)

vpp-simulate:
	cd $S && vvp $(TOP).vvp -vcd

wave:
	@gtkwave $S/top.vcd	|| (echo "No hay un forma de onda que motrar en gtkwave, posiblemente no fue solicitada en la simulación")

json-yosys:
	mkdir -p $S
	yosys -p 'read_verilog $(TOP).v $(MODULES); hierarchy -check; proc; write_json $S/$(TOP).json'

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
RTL_COMMAND?='read_verilog $(TOP).v $(MODULES);\
						 hierarchy -check;\
						 show $(TOP)'

