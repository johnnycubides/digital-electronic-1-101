#include "./libs/math.h"
#include "./libs/time.h"
#include "./libs/uart.h"
#include "./libs/utilities.h"
#include <stdint.h>

#define IO_BASE 0x400000
#define IO_LEDS 4

volatile uint32_t *const gp = (uint32_t *)IO_BASE;

char buffer[16] = "Tablas\n\r";

int main() {
  wait(20);
  putstring(buffer);

  uint32_t i = 1, j = 1;
  for (i = 1; i < 10; i++) {
    for (j = 1; j < 10; j++) {
      wait(20);
      buffer[0] = i + 48;
      buffer[1] = 'x';
      buffer[2] = j + 48;
      buffer[3] = '=';
      buffer[4] = '\0';
      putstring(buffer);
      uint32_t result = mult_hw(i, j);
      itoa_simple_signed(result, buffer);
      putstring(buffer);
      buffer[0] = '\n';
      buffer[1] = '\r';
      buffer[2] = '\0';
      putstring(buffer);
    }
  }
}
