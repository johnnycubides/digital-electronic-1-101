#include "./uart.h"

volatile uint32_t *const uart_dat = (uint32_t *)(IO_BASE + IO_UART_DAT);
volatile uint32_t *const uart_cntl = (uint32_t *)(IO_BASE + IO_UART_CNTL);

void putchar(char c) {
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
    putchar(*str);
    str++;
  }
}

// Función equivalente a getchar en ensamblador
int getchar(void) {
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
  return data & 0xFF;
}

/**
 * Lee una cadena de longitud fija
 * @param buf Buffer donde almacenar la cadena
 * @param max_len Máximo número de caracteres a leer (incluyendo el nulo)
 * @return Número de caracteres leídos (sin contar el nulo)
 */
int getstring_fixed(char *buf, int max_len) {
  int i = 0;
  char c;
  // Prevención de overflow
  if (max_len <= 0)
    return 0;
  while (i < max_len - 1) {
    c = getchar();
    // Opcional: Terminar con Enter (CR/LF)
    if (c == '\n' || c == '\r') {
      break;
    }
    buf[i++] = c;
  }
  // Asegurar terminación nula
  buf[i] = '\0';
  return i;
}

/**
 * Lee hasta encontrar un terminador específico
 * @param buf Buffer de destino
 * @param max_len Tamaño máximo del buffer
 * @param terminator Carácter que indica fin de lectura
 * @return Número de caracteres leídos (sin contar el nulo)
 */
int getstring_terminated(char *buf, int max_len, char terminator) {
  int i = 0;
  char c;
  if (max_len <= 0)
    return 0;
  while (i < max_len - 1) {
    c = getchar();
    if (c == terminator || c == '\0') {
      break;
    }
    // Opcional: Ignorar retornos de carro
    if (c == '\r')
      continue;
    buf[i++] = c;
  }
  buf[i] = '\0';
  return i;
}

/**
 * Implementación estándar similar a fgets()
 * @param buf Buffer de destino
 * @param max_len Tamaño máximo (incluyendo \0)
 * @param terminators Cadena con caracteres terminadores (0 si usar defaults)
 * @return Número de caracteres leídos o -1 si no se leyó nada
 */
int getstring(char *buf, int max_len, const char *terminators) {
  static const char default_terms[] = "\n\r\0";
  const char *terms = terminators ? terminators : default_terms;
  int i = 0;
  char c;
  if (max_len <= 0)
    return -1;
  while (i < max_len - 1) {
    c = getchar();
    // Comprobar si es terminador
    const char *t = terms;
    while (*t) {
      if (c == *t) {
        buf[i] = '\0';
        return (i > 0) ? i : -1;
      }
      t++;
    }
    // Caracteres especiales (backspace, etc.)
    if (c == '\b' && i > 0) {
      i--;
      continue;
    }
    buf[i++] = c;
  }
  buf[i] = '\0';
  return i;
}
