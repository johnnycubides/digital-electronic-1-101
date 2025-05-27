#include <femtorv32.h>

void wait_cycles(int nb_cycles) {
  uint32_t lim = cycles() + (uint32_t)nb_cycles;
  while(cycles()<lim);
}
