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
