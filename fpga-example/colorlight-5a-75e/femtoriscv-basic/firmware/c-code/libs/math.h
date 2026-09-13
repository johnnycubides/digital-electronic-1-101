#ifndef MATH_H
#define MATH_H
#include <stdint.h>

// Direcciones base y offsets del multiplicador hardware
#define MULT_BASE 0x420000
#define MULT_OP_A 0x04
#define MULT_OP_B 0x08
#define MULT_INIT 0x0C
#define MULT_RESULT 0x10
#define MULT_DONE 0x14

// Tipo para acceder a registros mapeados en memoria
/*typedef volatile uint32_t *const hw_reg;*/
extern volatile uint32_t *const mult_op_a;
extern volatile uint32_t *const mult_op_b;
extern volatile uint32_t *const mult_init;
extern volatile uint32_t *const mult_result;
extern volatile uint32_t *const mult_done;

// Función que implementa la multiplicación por hardware
uint32_t mult_hw(uint32_t a, uint32_t b);

#endif
