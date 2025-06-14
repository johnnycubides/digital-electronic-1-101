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

int getchar();

/**
 * Lee una cadena de longitud fija
 * @param buf Buffer donde almacenar la cadena
 * @param max_len Máximo número de caracteres a leer (incluyendo el nulo)
 * @return Número de caracteres leídos (sin contar el nulo)
 */
int getstring_fixed(char *buf, int max_len);

/**
 * Lee hasta encontrar un terminador específico
 * @param buf Buffer de destino
 * @param max_len Tamaño máximo del buffer
 * @param terminator Carácter que indica fin de lectura
 * @return Número de caracteres leídos (sin contar el nulo)
 */
int getstring_terminated(char *buf, int max_len, char terminator);

/**
 * Implementación estándar similar a fgets()
 * @param buf Buffer de destino
 * @param max_len Tamaño máximo (incluyendo \0)
 * @param terminators Cadena con caracteres terminadores (0 si usar defaults)
 * @return Número de caracteres leídos o -1 si no se leyó nada
 */
int getstring(char *buf, int max_len, const char *terminators);

// char buffer[128];
//
// // Leer hasta Enter (default)
// getstring(buffer, sizeof(buffer), NULL);
//
// // Leer hasta encontrar coma
// getstring(buffer, sizeof(buffer), ",");
//
// // Leer exactamente 10 caracteres
// getstring(buffer, 11, "");  // 10 + 1 para el \0

#endif
