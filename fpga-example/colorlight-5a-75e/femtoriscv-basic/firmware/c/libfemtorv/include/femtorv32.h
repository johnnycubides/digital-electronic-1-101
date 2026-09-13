#ifndef H__FEMTORV32__H
#define H__FEMTORV32__H

#include "HardwareConfig_bits.h"
#include <stdint.h>

/* 
 * On the IceStick, code is entirely executed from the (slow) SPI flash,
 * except for functions marked as fastcode that will be loaded in the
 * (much faster) RAM (but use it wisely, you only got 7kB).
 * Other devices are sufficient RAM to load all the code.
 */
#if defined(ICE_STICK) || defined(ICE_BREAKER)
#define RV32_FASTCODE __attribute((section(".fastcode")))
#else
#define RV32_FASTCODE
#endif

/* Standard library */
extern int  printf(const char *fmt,...); /* supports %s, %d, %x */
extern void exit(int);
extern void abort();
extern int  getchar();
extern int  putchar(int c);
extern int  puts(const char* s);

/* Timing */
extern uint32_t cycles();            /* gets the number of cycles since last reset       (needs NRV_COUNTERS_64) */
extern uint32_t milliseconds();      /* gets the number of milliseconds since last reset (needs NRV_COUNTERS_64) */
extern void wait_cycles(int cycles); /* waits for a number of cycles.       */
extern void milliwait(int ms);       /* waits for a number of milliseconds. */
extern void microwait(int us);       /* waits for a number of microseconds. */
#define delay(ms) milliwait(ms)

/* System */

extern int filesystem_init(); /* 
			       * needs to be called to access files on SDCard (fopen(),fread()...) 
			       * returns 0 on success, non-zero on error.
			       */

extern int exec(const char* filename, int argc, char** argv);
                                       /* 
					* Executes a program from the SDCard. 
					* Returns a non-zero number on error.
					* does not return on success !
					* Supports risc-v elves (.elf) and
					* flat binaries (.bin).
					*/
/* Virtual I/O */
typedef int (*putcharfunc_t)(int);
typedef int (*getcharfunc_t)(void);
void set_putcharfunc(putcharfunc_t fptr);
void set_getcharfunc(getcharfunc_t fptr);

/* Specialized print functions (but one can use printf() instead) */
extern void print_string(const char* s);
extern void print_dec(int val);
extern void print_hex_digits(unsigned int val, int digits);
extern void print_hex(unsigned int val);

/* SDCard */
int sd_init(); /* Return 0 on success, non-zero on failure */
int sd_readsector(uint32_t sector, uint8_t* buffer, uint32_t sector_count); /* 1:success, 0:failure*/
int sd_writesector(uint32_t sector, uint8_t* buffer, uint32_t sector_count); /* 1:success, 0:failure*/


/********************* Memory-mapped IO *******************************************************/

#define IO_BASE      0x400000 /* Base address of memory-mapped IO */

/* Converts a memory-mapped register bit into the corresponding offset to be added to IO_BASE */
#define IO_BIT_TO_OFFSET(io_bit) (1 << (2+(io_bit)))  

/* All the memory-mapped hardware registers */
#define IO_LEDS              IO_BIT_TO_OFFSET(IO_LEDS_bit)
#define IO_UART_CNTL         IO_BIT_TO_OFFSET(IO_UART_CNTL_bit)
#define IO_UART_DAT          IO_BIT_TO_OFFSET(IO_UART_DAT_bit)
#define IO_HW_CONFIG_RAM     IO_BIT_TO_OFFSET(IO_HW_CONFIG_RAM_bit)
#define IO_HW_CONFIG_DEVICES IO_BIT_TO_OFFSET(IO_HW_CONFIG_DEVICES_bit)
#define IO_HW_CONFIG_CPUINFO IO_BIT_TO_OFFSET(IO_HW_CONFIG_CPUINFO_bit)

#define IO_IN(port)       *(volatile uint32_t*)(IO_BASE + port)
#define IO_OUT(port,val)  *(volatile uint32_t*)(IO_BASE + port)=(val)
#define LEDS(val)         IO_OUT(IO_LEDS,val)

#define FEMTOSOC_HAS_DEVICE(bit)  (IO_IN(IO_HW_CONFIG_DEVICES) & (1 << bit))
#define FEMTORV32_FREQ            27000000
#define FEMTORV32_COUNTER_BITS    (IO_IN(IO_HW_CONFIG_CPUINFO) & 127)




#endif
