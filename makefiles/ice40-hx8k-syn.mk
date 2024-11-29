DESIGN?=
DEVSERIAL?=/dev/ttyACM0
DIR_BUILD?=build
top_NAME=$(basename $(notdir $(DESIGN)))
top?=$(top_NAME)
PCF?=$(top).pcf
JSON?=$(DIR_BUILD)/$(top).json
ASC?=$(DIR_BUILD)/$(top).asc
BISTREAM?=$(DIR_BUILD)/$(top).bin
# MACRO_SYN sirve para indicar definiciones de preprocesamiento en la sintesis
MACROS_SYN?=
MACROS_SYN := $(foreach macro,$(MACROS_SYN),"$(macro)")

help-syn:
	@echo "\n## SINTESIS Y CONFIGURACIÓN ##"
	@echo "\tmake syn\t\t-> Sintetizar diseño"
	@echo "\tmake config\t\t-> Configurar fpga from Flash SPI"
	@echo "\t\t\t\t   Para configurar desde la flash, se requiere poner un jumper en J7 y en J6 conectar dos jumper entre los pines 4-2 y 3-1"
	@echo "\tmake config-sram\t-> Configurar fpga desde la CRAM"
	@echo "\t\t\t\t   Para configurar desde la CRAM, se requiere desconectar el jumper en J7 y en J6 conectar dos jumper entre los pines 4-3 y 2-1"
	@echo "\tmake clean\t\t-> Limipiar síntesis si ha modificado el diseño"

syn: json asc bitstream

OBJS+=$(DESIGN)

$(JSON): $(OBJS)
	mkdir -p $(DIR_BUILD)
	yosys $(MACRO_SYN) -p "synth_ice40 -top $(top) -json $(JSON)" $(OBJS)

$(ASC): $(JSON)
	nextpnr-ice40 --hx8k --package ct256 --json $(JSON) --pcf $(PCF) --asc $(ASC)

$(BISTREAM): $(ASC)
	icepack $(ASC) $(BISTREAM)

config:
	iceprog $(BISTREAM)

config-sram:
	iceprog -S $(BISTREAM)

json:$(JSON)
asc:$(ASC)
bitstream:$(BISTREAM)

Z?=prj
zip:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -3 Makefile > $Z/Makefile
	# Copia el Makefile de syn desde la línea 4
	sed -n '4,$$p' $(MK_SYN) >> $Z/Makefile
	sed -n '7,$$p' $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md *.pcf .gitignore $Z
ifneq ($(wildcard *.mem),) # Si existe un archivo .mem
	cp -var *.mem $Z
endif
ifneq ($(wildcard *.hex),) # Si existe un archivo .hex
	cp -var *.hex $Z
endif
ifneq ($(wildcard *.png),) # Si existe un archivo .png
	cp -var *.png $Z
endif
ifneq ($(wildcard *.txt),) # Si existe un archivo .txt
	cp -var *.txt $Z
endif
ifneq ($(wildcard *.gtkw),) # Si existe un archivo .gtkw
	cp -var *.gtkw $Z
endif
	zip -r $Z.zip $Z

init:
	@echo "build/\nsim/\n*.log\n$Z/\n" > .gitignore
	touch $(top).png README.md

clean-syn:
	$(RM) -rf $(DIR_BUILD)
	# $(RM) -f $(JSON) $(ASC) $(BISTREAM)

.PHONY: clean
# .PHONY: upload clean $(top).json $(top).bin $(top).asc init_dir_build
