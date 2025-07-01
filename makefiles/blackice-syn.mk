DESIGN?=
DEVSERIAL?=/dev/ttyACM0
DIR_BUILD?=build
top_NAME=$(basename $(notdir $(DESIGN)))
########################################
###--- Rules from blackice-syn.mk ---###
########################################
top?=$(top_NAME)
PCF?=$(top).pcf
JSON?=$(DIR_BUILD)/$(top).json
ASC?=$(DIR_BUILD)/$(top).asc
BISTREAM?=$(DIR_BUILD)/$(top).bin
LOG_YOSYS?=$(DIR_BUILD)/yosys-$(top).log
LOG_NEXTPNR?=$(DIR_BUILD)/nextpnr-$(top).log

# MACRO_SYN sirve para indicar definiciones de preprocesamiento en la sintesis
MACRO_SYN?=
MACROS_SYN := $(foreach macro,$(MACROS_SYN),"$(macro)")

help-syn:
	@echo "\n## SINTESIS Y CONFIGURACIÓN ##"
	@echo "\tmake syn\t-> Sintetizar diseño"
	@echo "\tmake config\t-> Configurar fpga"
	@echo "\tmake log-syn\t\t-> Ver el log de la síntesis con Yosys. Comandos: /palabra -> buscar, n -> próxima palabra, q -> salir, h -> salir"
	@echo "\tmake log-pnr\t\t-> Ver el log del place&route con nextpnr. Comandos: /palabra -> buscar, n -> próxima palabra, q -> salir, h -> salir"
	@echo "\tmake clean\t-> Limipiar síntesis si ha modificado el diseño"

syn: json asc bitstream

OBJS+=$(DESIGN)

$(JSON): $(OBJS)
	mkdir -p $(DIR_BUILD)
	yosys $(MACRO_SYN) -p "synth_ice40 -top $(top) -json $(JSON)" $(OBJS) -l $(LOG_YOSYS)

log-syn:
	less $(LOG_YOSYS)

$(ASC): $(JSON)
	nextpnr-ice40 --hx4k --package tq144 --json $(JSON) --pcf $(PCF) --asc $(ASC) --log $(LOG_NEXTPNR)

log-pnr:
	less $(LOG_NEXTPNR)

$(BISTREAM): $(ASC)
	icepack $(ASC) $(BISTREAM)

config:
	stty -F $(DEVSERIAL) raw
	cat $(BISTREAM) > $(DEVSERIAL)

config-sram: config

json:$(JSON)
asc:$(ASC)
bitstream:$(BISTREAM)

Z?=prj
zip:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -3 Makefile > $Z/Makefile
	# Copia el Makefile de syn después de la línea 4
	sed -n '4,$$p' $(MK_SYN) >> $Z/Makefile
	sed -n '7,$$p' $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md *.pcf .gitignore $Z
ifneq ($(wildcard *.pdf),) # Si existe un archivo .pdf
	cp -var *.pdf $Z
endif
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
ifdef MORE_SRC
	cp -var $(MORE_SRC) $Z
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
