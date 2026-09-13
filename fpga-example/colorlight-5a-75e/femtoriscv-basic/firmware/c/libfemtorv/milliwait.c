#include <femtorv32.h>

void milliwait(int time) {
   wait_cycles(time * FEMTORV32_FREQ / 1000);
}

