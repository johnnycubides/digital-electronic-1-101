#ifndef UART_H
#define UART_H

#include <stdint.h>

#define IO_BASE 0x400000
#define IO_UART_DAT 8
#define IO_UART_CNTL 16

extern volatile uint32_t *const uart_dat;
extern volatile uint32_t *const uart_cntl;

void putchar(char c);
void putstring(const char *str);

#endif
