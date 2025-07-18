DESIGN?=
DEVSERIAL?=/dev/ttyACM0
DIR_BUILD?=build
top_NAME=$(basename $(notdir $(DESIGN)))
##########################################
###--- Rules from ice40-hx8k-syn.mk ---###
##########################################
top?=$(top_NAME)
PCF?=$(top).pcf
JSON?=$(DIR_BUILD)/$(top).json
ASC?=$(DIR_BUILD)/$(top).asc
BISTREAM?=$(DIR_BUILD)/$(top).bit
LOG_YOSYS?=$(DIR_BUILD)/yosys-$(top).log
LOG_NEXTPNR?=$(DIR_BUILD)/nextpnr-$(top).log
# MACRO_SYN sirve para indicar definiciones de preprocesamiento en la sintesis
MACROS_SYN?=
MACROS_SYN := $(foreach macro,$(MACROS_SYN),"$(macro)")

.ONESHELL:
SHELL=/bin/bash
# Enviroment conda to activate
ENV=digital
CONDA_ACTIVATE = source $$($$CONDA_EXE info --base)/etc/profile.d/conda.sh ; conda activate; conda activate $(ENV)
RUN = $(CONDA_ACTIVATE) &&
RUN =# Activate if don't use CONDA

help-syn:
	@printf "\n## SINTESIS Y CONFIGURACIÓN ##\n"
	@printf "\tmake syn\t\t-> Sintetizar diseño\n"
	@printf "\tmake config\t\t-> Configurar fpga from Flash SPI\n"
	@printf "\t\t\t\t   Para configurar desde la flash, se requiere poner un jumper en J7 y en J6 conectar dos jumper entre los pines 4-2 y 3-1\n"
	@printf "\tmake config-sram\t-> Configurar fpga desde la CRAM\n"
	@printf "\t\t\t\t   Para configurar desde la CRAM, se requiere desconectar el jumper en J7 y en J6 conectar dos jumper entre los pines 4-3 y 2-1\n"
	@printf "\tmake log-syn\t\t-> Ver el log de la síntesis con Yosys. Comandos: /palabra -> buscar, n -> próxima palabra, q -> salir, h -> salir\n"
	@printf "\tmake log-pnr\t\t-> Ver el log del place&route con nextpnr. Comandos: /palabra -> buscar, n -> próxima palabra, q -> salir, h -> salir\n"
	@printf "\tmake clean\t\t-> Limipiar síntesis si ha modificado el diseño\n"

syn: json asc bitstream

OBJS+=$(DESIGN)

$(JSON): $(OBJS)
	mkdir -p $(DIR_BUILD)
	$(RUN) yosys $(MACRO_SYN) -p 'verilog_defaults -push; verilog_defaults -add -defer; verilog_defaults -pop; attrmap -tocase keep -imap keep="true" keep=1 -imap keep="false" keep=0 -remove keep=0; synth_ice40 -top $(top) -json $(JSON)' $(OBJS) -l $(LOG_YOSYS)
	# yosys $(MACRO_SYN) -p "synth_ice40 -top $(top) -json $(JSON)" $(OBJS) -l $(LOG_YOSYS)

log-syn:
	less $(LOG_YOSYS)

$(ASC): $(JSON)
	$(RUN) nextpnr-ice40 --hx8k --package ct256 --json $(JSON) --pcf $(PCF) --asc $(ASC) --log $(LOG_NEXTPNR)

log-pnr:
	less $(LOG_NEXTPNR)

$(BISTREAM): $(ASC)
	$(RUN) icepack $(ASC) $(BISTREAM)

config:
	$(RUN) iceprog $(BISTREAM)

config-sram:
	$(RUN) iceprog -S $(BISTREAM)

json:$(JSON)
asc:$(ASC)
bitstream:$(BISTREAM)

Z?=prj
zip:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -3 Makefile > $Z/Makefile
	# Copia el Makefile de *-syn.mk después de la línea 4
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
