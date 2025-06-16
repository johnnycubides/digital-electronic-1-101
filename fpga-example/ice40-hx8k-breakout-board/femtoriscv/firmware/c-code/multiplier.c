#include "./libs/math.h"
#include "./libs/time.h"
#include "./libs/uart.h"
#include <stdint.h>

#define IO_BASE 0x400000
#define IO_LEDS 4

volatile uint32_t *const gp = (uint32_t *)IO_BASE;

char buffer[16] = "echo\n\r";

int main() {
  wait(20);
  putstring(buffer);
  wait(20);
  // while (1) {
  // char ret = mult_hw(1, 1) + 48;
  // char ret = 48;
  // putChar(ret);
  //   wait(20);
  // }
  while (1) {
    if (mult_hw(12, 12) == 1) {
      putChar('T');
    } else {
      putChar('F');
    }
  }
  return 0;
}
