# Configuración básica
FPGA_RAM_BYTES = 8192
# CROSS   = riscv32-unknown-elf
CROSS   = riscv64-unknown-elf
CC      = $(CROSS)-gcc
AS      = $(CROSS)-as
LD      = $(CROSS)-ld
OBJCOPY = $(CROSS)-objcopy
OBJDUMP = $(CROSS)-objdump

# Archivos objeto principales + los de libs/
SRC_DIR = libs
SRCS += ./libs/uart.c
SRCS += ./libs/math.c
SRCS += ./libs/time.c
SRCS += ./libs/utilities.c
# SRCS    = $(wildcard $(SRC_DIR)/*.c)  # Encuentra todos los .c en libs/
OBJS    = $(SRCS:.c=.o)              # Convierte libs/archivo.c → libs/archivo.o
# OBJECTS = crt0.o loopBackChar.o $(OBJS)         # Todos los .o a enlazar
# OBJECTS = crt0.o loopBackString.o $(OBJS)         # Todos los .o a enlazar
# OBJECTS = crt0.o multiplier.o $(OBJS)         # Todos los .o a enlazar
OBJECTS = crt0.o sendMsg2Uart.o $(OBJS)         # Todos los .o a enlazar

LIB_DIR = -L/home/$$USER/miniconda3/envs/digital/riscv64-elf/lib/rv32i/ilp32/ \
          -L/home/$$USER/miniconda3/envs/digital/lib/gcc/riscv64-elf/10.1.0/rv32iac/ilp32/
LIBS    = -lm -lc -lgcc

# Directorios para headers y librerías
INCLUDE = -I. -I$(SRC_DIR)
# LIB_DIR += -L. 
LIB_DIR += -L$(SRC_DIR)

AFLAGS = -march=rv32i -mabi=ilp32

# Banderas de compilación y enlazado (optimizadas para eliminar código muerto)
CFLAGS  = $(INCLUDE) -fno-pic -march=rv32i -mabi=ilp32 \
          -fno-stack-protector -w -Wl,--no-relax \
          -ffunction-sections -fdata-sections

# Banderas de enlazado
LDFLAGS = -m elf32lriscv -b elf32-littleriscv \
					--no-relax --print-memory-usage \
					-Tlinker.ld
# --gc-sections \

LIBS    = -lm -lc -lgcc

# Reglas principales
all: firmware.hex

asm:
	$(CC) $(CFLAGS) -S $f $(SRCS)

firmware.elf: $(OBJECTS)
	$(LD) $(LDFLAGS) -Map firmware.map $(OBJECTS) -o $@ $(LIB_DIR)
	chmod -x $@

firmware.hex: firmware.elf firmware.lst
	../firmware_words_src/firmware_words firmware.elf -ram $(FPGA_RAM_BYTES) -max_addr $(FPGA_RAM_BYTES) -out firmware.hex
	cp firmware.hex ../../

firmware.lst: firmware.elf
	$(OBJDUMP) -h -S $< > $@

# Regla genérica para compilar cualquier .c → .o (incluyendo los de libs/)
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(AS) $(AFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJECTS) *.elf *.bin .*~ *~ *.map *.d *.hex *.lst *.o *.s

.PHONY: all clean
