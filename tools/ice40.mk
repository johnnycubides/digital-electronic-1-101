
synthesize:
	@yosys -p "synth_ice40 -json $@" $(OBJS)

