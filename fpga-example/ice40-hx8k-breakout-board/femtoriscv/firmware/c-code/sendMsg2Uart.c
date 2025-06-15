#include "libs/time.h"
#include "libs/uart.h"
#include <stdint.h>

// Definición de direcciones de memoria (equivalentes a las constantes en ASM)
#define IO_BASE 0x400000
#define IO_LEDS 4

// Punteros a los registros de hardware
volatile uint32_t *const gp = (uint32_t *)IO_BASE;

// Mensaje a mostrar (equivalente a la sección .data)
const char hello[] = "Hello, ASM world\n\r";

int main() {
  // Inicialización del stack pointer (simulado)
  // En realidad en C esto lo hace el startup code
  while (1) { // Equivalente al main_loop
    putstring(hello);
    wait(20); // Valor arbitrario para el wait (en ASM se usaba a0)
  }
  return 0; // Nunca se alcanzará
}
