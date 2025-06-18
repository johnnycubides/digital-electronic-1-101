#include <stdint.h>

// Definición de direcciones de memoria (equivalentes a las constantes en ASM)
#define IO_BASE 0x400000
#define IO_LEDS 4
#define IO_UART_DAT 8
#define IO_UART_CNTL 16

// Punteros a los registros de hardware
volatile uint32_t *const gp = (uint32_t *)IO_BASE;
volatile uint32_t *const uart_dat = (uint32_t *)(IO_BASE + IO_UART_DAT);
volatile uint32_t *const uart_cntl = (uint32_t *)(IO_BASE + IO_UART_CNTL);

// Mensaje a mostrar (equivalente a la sección .data)
const char hello[] = "Hello, ASM world\n\r";

// Prototipos de funciones
void putchar(char c);
void putstring(const char *str);
void wait(uint32_t cycles);

int main() {
  // Inicialización del stack pointer (simulado)
  // En realidad en C esto lo hace el startup code

  while (1) { // Equivalente al main_loop
    putstring(hello);
    wait(20); // Valor arbitrario para el wait (en ASM se usaba a0)
  }

  return 0; // Nunca se alcanzará
}

void putstring(const char *str) {
  while (*str != '\0') {
    putchar(*str);
    str++;
  }
}

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

void wait(uint32_t cycles) {
  uint32_t count = 1 << cycles; // Equivalente al sll

  while (count--) {
    // Bucle de espera
  }
}
