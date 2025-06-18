#include "math.h"

// Punteros a los registros del multiplicador
volatile uint32_t *const mult_op_a = (uint32_t *)(MULT_BASE + MULT_OP_A);
volatile uint32_t *const mult_op_b = (uint32_t *)(MULT_BASE + MULT_OP_B);
volatile uint32_t *const mult_init = (uint32_t *)(MULT_BASE + MULT_INIT);
volatile uint32_t *const mult_result = (uint32_t *)(MULT_BASE + MULT_RESULT);
volatile uint32_t *const mult_done = (uint32_t *)(MULT_BASE + MULT_DONE);

// uint32_t mult_hw(uint32_t a, uint32_t b) { return a + b; }
// Función que implementa la multiplicación por hardware
uint32_t mult_hw(uint32_t a, uint32_t b) {

  // Escribir los operandos
  *mult_op_a = a;
  *mult_op_b = b;

  // Iniciar la multiplicación (flanco de subida)
  *mult_init = 1;
  *mult_init = 0;

  // Esperar a que se complete la operación
  while ((*mult_done & 0x1) == 0) {
    __asm__ volatile(
        "nop"); // Instrucción no operación para evitar optimización
    // Busy-wait - en un sistema real podrías añadir un timeout aquí
  }

  return *mult_result;
}
