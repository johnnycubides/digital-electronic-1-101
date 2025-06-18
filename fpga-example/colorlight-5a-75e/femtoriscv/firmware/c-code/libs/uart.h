#ifndef UART_H
#define UART_H

#include <stdint.h>

#define IO_BASE 0x400000
#define IO_UART_DAT 8
#define IO_UART_CNTL 16

extern volatile uint32_t *const uart_dat;
extern volatile uint32_t *const uart_cntl;

void putChar(char c);
void putstring(const char *str);

int getChar();

/**
 * Implementación estándar similar a fgets()
 * @param buf Buffer de destino
 * @param max_len Tamaño máximo (incluyendo \0)
 * @param terminators Cadena con caracteres terminadores (0 si usar defaults)
 * @return Número de caracteres leídos o -1 si no se leyó nada
 */
int getstring(char *buf, int max_len, const char terminators);

#endif
