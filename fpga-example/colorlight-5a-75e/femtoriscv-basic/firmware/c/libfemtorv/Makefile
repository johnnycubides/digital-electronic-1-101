OBJECTS =  microwait.o  milliwait.o  wait_cycles.o  femtorv32.o  uart.o cycles_32.o print.o printf.o
# CROSS   = riscv64-unknown-elf
CROSS 	= riscv64-unknown-elf
# CROSS   = riscv32-unknown-elf
CC      = $(CROSS)-gcc
AS      = $(CROSS)-as
LD      = $(CROSS)-ld
AR      = $(CROSS)-ar
RANLIB  = $(CROSS)-ranlib
OBJCOPY = $(CROSS)-objcopy
OBJDUMP = $(CROSS)-objdump
AFLAGS  = -march=rv32i -mabi=ilp32
CFLAGS  = -Iinclude -I. -fno-pic -march=rv32i -mabi=ilp32 -fno-stack-protector -w -Wl,--no-relax


all: libfemtorv.a crt0_baremetal.o

libfemtorv.a: $(OBJECTS) 
	$(AR) cq $@ $(OBJECTS)
	$(RANLIB) $@	
%.o: %.c
	$(CC) $(CFLAGS) -c $<
%.o: %.S
	$(AS) $(AFLAGS) -c $< -o $@
clean:
	rm -rf  $(OBJECTS) *.elf *.bin .*~ *~ *.map *.d *.hex *.o libfemtorv.a
.PHONY: clean


#export PATH=$PATH:/home/carlos/Embedded/litex_work/learn-fpga/FemtoRV/FIRMWARE/TOOLCHAIN/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14/bin/
#riscv64-unknown-elf-as -march=rv32imafc -mabi=ilp32f -I. -I/home/carlos/Embedded/litex_work/learn-fpga/FemtoRV/FIRMWARE//LIBFEMTOC  femtorv32.S -o femtorv32.o 
#riscv64-unknown-elf-ar cq libfemtorv32.a femtorv32.o  uart.o cycles_32.o cycles_64.o femto_elf.o  
#riscv64-unknown-elf-ranlib libfemtorv32.a

