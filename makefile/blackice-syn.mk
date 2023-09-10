TOP?=top
MODULES?=
DIR_BUILD?=build
DEVSERIAL?=/dev/ttyACM0
PCF?=$(TOP).pcf
JSON?=$(DIR_BUILD)/$(TOP).json
ASC?=$(DIR_BUILD)/$(TOP).asc
BISTREAM?=$(DIR_BUILD)/$(TOP).bin

help-syn:
	@echo "make syn\t-> Sintetizar diseño"
	@echo "make config\t-> Configurar fpga"

syn: json asc bitstream

OBJS+=$(TOP).v $(MODULES)

$(JSON): $(OBJS)
	mkdir -p $(DIR_BUILD)
	yosys -p "synth_ice40 -top $(TOP) -json $(JSON)" $(OBJS)

$(ASC): $(JSON)
	nextpnr-ice40 --hx4k --package tq144 --json $(JSON) --pcf $(PCF) --asc $(ASC)

$(BISTREAM): $(ASC)
	icepack $(ASC) $(BISTREAM)

config:
	stty -F $(DEVSERIAL) raw
	cat $(BISTREAM) > $(DEVSERIAL)

json:$(JSON)
asc:$(ASC)
bitstream:$(BISTREAM)

Z=prj
zip:
	$(RM) $Z $Z.zip
	mkdir -p $Z
	head -n -3 Makefile > $Z/Makefile
	sed -n '5,$$p' $(MK_SYN) >> $Z/Makefile
	sed -n '7,$$p' $(MK_SIM) >> $Z/Makefile
	cp -var *.v *.md *.png *.pcf .gitignore $Z
	zip -r $Z.zip $Z

init:
	@echo "build/\nsim/\n*.log\n$Z/\n" > .gitignore
	touch top.png README.md

clean-syn:
	$(RM) -f $(JSON) $(ASC) $(BISTREAM)

# .PHONY: upload clean $(TOP).json $(TOP).bin $(TOP).asc init_dir_build
