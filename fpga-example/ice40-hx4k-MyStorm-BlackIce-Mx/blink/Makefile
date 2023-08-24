TOP=chip
OBJS+=$(TOP).v blink.v
DIR_BUILD=build
PCF=$(TOP).pcf
JSON=$(DIR_BUILD)/$(TOP).json
ASC=$(DIR_BUILD)/$(TOP).asc
BISTREAM=$(DIR_BUILD)/$(TOP).bin
DEVSERIAL=/dev/ttyACM0


init_dir_build:
	mkdir -p $(DIR_BUILD)

$(JSON): $(OBJS) init_dir_build
	yosys -p "synth_ice40 -top $(TOP) -json $(JSON)" $(OBJS)

$(ASC): $(JSON)
	nextpnr-ice40 --hx4k --package tq144 --json $(JSON) --pcf $(PCF) --asc $(ASC)

$(BISTREAM): $(ASC)
	icepack $(ASC) $(BISTREAM)

upload: $(BISTREAM)
	stty -F $(DEVSERIAL) raw
	cat $(BISTREAM) > $(DEVSERIAL)

json:$(JSON)
asc:$(ASC)
bitstream:$(BISTREAM)

clean:
	$(RM) -f $(JSON) $(ASC) $(BISTREAM)

.PHONY: upload clean $(TOP).json $(TOP).bin $(TOP).asc init_dir_build
