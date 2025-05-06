OBJECTS =  hello.o 
CROSS   = riscv64-unknown-elf
# CROSS   = riscv32-unknown-elf
CC      = $(CROSS)-gcc
AS      = $(CROSS)-as
LD      = $(CROSS)-ld
OBJDUMP = $(CROSS)-objdump
LIB_DIR = -Llibfemtorv -L/home/$$USER/miniconda3/envs/digital/riscv64-elf/lib/rv32i/ilp32/ \
          -L/home/$$USER/miniconda3/envs/digital/lib/gcc/riscv64-elf/10.1.0/rv32iac/ilp32/
LIBS    = -lfemtorv -lm -lc -lgcc
LDFLAGS = -m elf32lriscv -b elf32-littleriscv --no-relax --print-memory-usage -Tlinker.ld
AFLAGS  = -march=rv32i -mabi=ilp32
CFLAGS  =  -Ilibfemtorv/include -Ilibfemtoc/include -fno-pic -march=rv32i -mabi=ilp32 -fno-stack-protector -w -Wl,--no-relax
OBJCOPY = $(CROSS)-objcopy
all: firmware.hex
#vpath %S libfemtorv 

%.bin: %.elf
#	$(OBJCOPY) -O verilog $< $@
	$(OBJCOPY) -O binary $< $@
	chmod -x $@

firmware.elf: $(OBJECTS) 
	$(LD) $(LDFLAGS)  -Map firmware.map $(OBJECTS) -o $@  ${LIB_DIR}  ${LIBS}  
	chmod -x $@
	
firmware.hex: firmware.elf firmware.lst
	../firmware_words_src/firmware_words firmware.elf -ram 8192 -max_addr 8192  -out firmware.hex
	cp firmware.hex ../../
	
firmware.lst: firmware.elf
	$(OBJDUMP) -h -S $< > $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< 
%.o: %.S
	$(AS) $(AFLAGS) -c $< -o $@
clean:
	rm -rf  $(OBJECTS) *.elf *.bin .*~ *~ *.map *.d *.hex *.lst
.PHONY: clean
