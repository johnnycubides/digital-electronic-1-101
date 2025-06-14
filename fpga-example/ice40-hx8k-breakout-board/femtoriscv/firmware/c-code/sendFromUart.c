#include "./libs/time.h"
#include "./libs/uart.h"
#include <stdint.h>

#define IO_BASE 0x400000
#define IO_LEDS 4

volatile uint32_t *const gp = (uint32_t *)IO_BASE;

// Mensaje a mostrar (equivalente a la sección .data)
const char hello[] = "Hello, ASM world johnny\n\r";

int main() {
  // Inicialización del stack pointer (simulado)
  // En realidad en C esto lo hace el startup code

  while (1) { // Equivalente al main_loop
    putstring(hello);
    wait(20); // Valor arbitrario para el wait (en ASM se usaba a0)
  }
  return 0;
}
