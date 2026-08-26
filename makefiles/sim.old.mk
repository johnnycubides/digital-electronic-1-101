ENV=digital
CONDA_ACTIVATE = source $$($$CONDA_EXE info --base)/etc/profile.d/conda.sh ; conda activate; conda activate $(ENV)
RUN = $(CONDA_ACTIVATE) &&

rtl-from-json: json-yosys
	cp $S/$(top).json $S/$(top)_origin.json # Hacer una copia desde el archivo origen
	# sed -E 's/"\$$paramod\$$[^\\]+\\\\([^"]+)"/"\1"/g' $S/$(top)_origin.json > $S/$(top).json # Quitar parametros en el nombre del módulo para que sea legible.
	# "\$paramod        # literal $paramod
	# (\$[^\\]+)?       # hash opcional ($abcdef...)
	# \\\\              # separador \
	# ([^\\"]+)         # nombre del módulo (lo que queremos)
	# .*"               # ignora el resto (parámetros, etc.)
	# sed -E 's/"\$$paramod(\$$[^\\]+)?\\\\([^\\"]+).*/"\2"/g' $S/$(top)_origin.json > $S/$(top).json # Quitar parametros en el nombre del módulo para que sea legible.
	sed -E \
  -e 's/"\$$paramod(\$$[^\\]+)?\\\\([^\\"]+)[^"]*": \{/"\2": {/g' \
  -e 's/"type": "\$$paramod(\$$[^\\]+)?\\\\([^\\"]+)[^"]*"/"type": "\2"/g' $S/$(top)_origin.json > $S/$(top).json # Quitar parametros en el nombre del módulo para que sea legible.
	$(RUN) $(RTL_GENERATOR) $S/$(top).json -o $S/$(top).svg
	## convert2SvgwithWhiteBackground

# Convertir el diseño en un solo archivo de verilog
ConvertOneVerilogFile:
	mkdir -p $S
	$(RUN) yosys $(MACROS_SIM) -p 'prep -top $(top); hierarchy -check; proc; opt -full; write_verilog -noattr -nodec $S/$(top).v' $(DESIGN)
	# yosys -p 'read_verilog $(DESIGN); prep -top $(TOP); hierarchy -check; proc; opt -full; write_verilog -noattr -noexpr -nodec $S/$(TOP).v'
	# yosys -p 'read_verilog $(DESIGN); prep -top $(TOP); hierarchy -check; proc; flatten; synth; write_verilog -noattr -noexpr $S/$(TOP).v'

rtl2png:
	convert -density 200 -resize 1200 $S/$(top).svg $(top).png
	# convert -resize 1200 -quality 100 $S/$(TOP).svg $(TOP).png

rtl-xdot:
	$(RUN) yosys $(MACROS_SIM) -p $(RTL_COMMAND)

## YOSYS ARGUMENTS
RTL_COMMAND?='read_verilog $(DESIGN);\
						 hierarchy -check;\
						 show $(top)'

init-sim:	
	@printf "sim/\n$Z/\n" > .gitignore
	touch README.md $(top).png # Crear archivo vacío
