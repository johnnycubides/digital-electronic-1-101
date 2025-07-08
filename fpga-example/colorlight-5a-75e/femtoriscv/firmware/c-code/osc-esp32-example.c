#include "libs/time.h"
#include "libs/uart.h"
#include "libs/utilities.h"
#include <stdint.h>

// Definición de direcciones de memoria (equivalentes a las constantes en ASM)
#define IO_BASE 0x400000
#define IO_LEDS 4

// Punteros a los registros de hardware
volatile uint32_t *const gp = (uint32_t *)IO_BASE;

int main() {
  const char topic[] = "osc /dev1/teclado ";
  char osc_msg[32];
  char midi[3];
  // Inicialización del stack pointer (simulado)
  // En realidad en C esto lo hace el startup code
  while (1) { // Equivalente al main_loop
    uint8_t i;
    for (i = 60; i < 80; i++) {
      osc_msg[0] = '\0';           // Limpiando el array de char
      itoa_simple_signed(i, midi); // Convertir el entero a string y guardar
      mi_strcat(osc_msg, topic);   // Agregar el topic al mensaje
      mi_strcat(osc_msg, "i ");    // Agregar el formato del valor a enviar
      mi_strcat(osc_msg, midi);    // "/dev/teclado i midi"
      putstring(osc_msg);
      wait(20); // Valor arbitrario para el wait (en ASM se usaba a0)
    }
  }
  return 0; // Nunca se alcanzará
}
