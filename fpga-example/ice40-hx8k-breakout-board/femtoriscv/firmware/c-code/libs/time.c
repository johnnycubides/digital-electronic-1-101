#include "time.h"

void wait(uint32_t cycles) {
  uint32_t count = 1 << cycles; // Equivalente al sll

  while (count--) {
    // Bucle de espera
  }
}
