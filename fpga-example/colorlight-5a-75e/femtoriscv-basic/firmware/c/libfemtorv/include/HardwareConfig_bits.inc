
# Constants for memory-mapped IO registers.                      
# Automatically extracted from RTL/DEVICES/HardwareConfig_bits.v 

.equ IO_LEDS_bit, 0
.equ IO_UART_DAT_bit, 1
.equ IO_UART_CNTL_bit, 2
.equ IO_HW_CONFIG_RAM_bit, 14
.equ IO_HW_CONFIG_DEVICES_bit, 18
.equ IO_HW_CONFIG_CPUINFO_bit, 19
.equ IO_MAPPED_SPI_FLASH_bit, 20

#################################################################
# IO_XXX = 1 << (IO_XXX_bit + 2)

.equ IO_LEDS, 4
.equ IO_UART_DAT, 8
.equ IO_UART_CNTL, 16
.equ IO_HW_CONFIG_RAM, 3072
.equ IO_HW_CONFIG_DEVICES, 1048576
.equ IO_HW_CONFIG_CPUINFO, 2097152
.equ IO_MAPPED_SPI_FLASH, 4194304
