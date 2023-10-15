TOP?=top
DESIGN?=
DIR_BUILD?=build
DEVSERIAL?=/dev/ttyACM0
PCF?=$(TOP).pcf
JSON?=$(DIR_BUILD)/$(TOP).json
ASC?=$(DIR_BUILD)/$(TOP).asc
BISTREAM?=$(DIR_BUILD)/$(TOP).bin

help-syn:
	@echo "\n## SINTESIS Y CONFIGURACIÓN ##"
	@echo "\tmake syn\t\t-> Sintetizar diseño"
	@echo "\tmake config\t\t-> Configurar fpga"
	@echo "\tmake config-sram\t-> Configurar fpga desde la SRAM"

syn: json asc bitstream

OBJS+=$(DESIGN)

$(JSON): $(OBJS)
	mkdir -p $(DIR_BUILD)
	yosys -p "synth_ice40 -top $(TOP) -json $(JSON)" $(OBJS)

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
	sed -n '5,$$p' $(MK_SYN) >> $Z/Makefile
	sed -n '7,$$p' $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md *.pcf .gitignore $Z
ifneq ($(wildcard *.mem),) # Si existe un archivo .png
	cp -var *.mem $Z
endif
ifneq ($(wildcard *.hex),) # Si existe un archivo .png
	cp -var *.hex $Z
endif
ifneq ($(wildcard *.png),) # Si existe un archivo .png
	cp -var *.png $Z
endif
ifneq ($(wildcard *.txt),) # Si existe un archivo .txt
	cp -var *.txt $Z
endif
ifneq ($(wildcard *.gtkw),) # Si existe un archivo .txt
	cp -var *.gtkw $Z
endif
	zip -r $Z.zip $Z

init:
	@echo "build/\nsim/\n*.log\n$Z/\n" > .gitignore
	touch top.png README.md

clean-syn:
	$(RM) -rf $(DIR_BUILD)
	# $(RM) -f $(JSON) $(ASC) $(BISTREAM)

.PHONY: clean
# .PHONY: upload clean $(TOP).json $(TOP).bin $(TOP).asc init_dir_build
