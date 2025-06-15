// #include "./libs/time.h"
#include "./libs/uart.h"
#include <stdint.h>

#define NULL (void *)0

#define IO_BASE 0x400000
#define IO_LEDS 4

volatile uint32_t *const gp = (uint32_t *)IO_BASE;

char buffer[16] = "echo\n\r";

int main() {
  // Inicialización del stack pointer (simulado)
  // En realidad en C esto lo hace el startup code

  while (1) { // Equivalente al main_loop
    getstring(buffer, sizeof(buffer), NULL);
    putstring(buffer);
  }
  return 0;
}
