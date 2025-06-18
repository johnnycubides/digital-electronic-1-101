#include "uart.h"
// #include "time.h"

volatile uint32_t *const uart_dat = (uint32_t *)(IO_BASE + IO_UART_DAT);
volatile uint32_t *const uart_cntl = (uint32_t *)(IO_BASE + IO_UART_CNTL);

void putChar(char c) {
  // Escribir el carácter en el registro de datos UART
  *uart_dat = (uint32_t)c;
  // Activar transmisión (equivalente al pulso de control)
  *uart_cntl = 0x01;
  *uart_cntl = 0x00;
  // Esperar a que la UART esté lista (bit 9)
  while ((*uart_cntl & (1 << 9))) {
    // Espera activa
  }
}

void putstring(const char *str) {
  while (*str != '\0') {
    putChar(*str);
    str++;
  }
}

// Función equivalente a getChar en ensamblador
int getChar(void) {
  uint32_t status;
  uint32_t data;
  // Esperar hasta que haya datos disponibles (bit 8 del registro de control)
  do {
    status = *uart_cntl;
  } while ((status & 0x100) == 0);
  // Escribir 0x02 en el registro de control (comportamiento observado en ASM)
  *uart_cntl = 0x02;
  // Leer el dato y devolverlo (máscara de 8 bits como en el ANDI 255)
  data = *uart_dat;
  *uart_cntl = 0x00;
  return data & 0xFF;
}

/**
 * Implementación estándar similar a fgets()
 * @param buf Buffer de destino
 * @param max_len Tamaño máximo (incluyendo \0)
 * @param terminators Cadena con caracteres terminadores (0 si usar defaults)
 * @return Número de caracteres leídos o -1 si no se leyó nada
 */
int getstring(char *buf, int max_len, const char terminator) {
  int i = 0;
  char c;
  for (i = 0; i <= (max_len - 1); i++) {
    c = getChar();
    buf[i] = c;
    if (c == terminator) {
      break;
    }
  }
  buf[i + 1] = '\0';
  return i;
}
