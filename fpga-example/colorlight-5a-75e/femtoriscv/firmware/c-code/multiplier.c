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

//   int i = 0;
//   while (i < 10) {
//     if (i == 1) {
//       putChar('T');
//     }
//     itoa_simple_signed(i, buffer);
//     putstring(buffer);
//     wait(20);
//     i++;
//   }
//   for (i = 1; i < 10; i++) {
//     if (i == 1) {
//       putChar('T');
//     }
//     itoa_simple_signed(i, buffer);
//     putstring(buffer);
//     wait(20);
//   }
//   return 0;
// }

// while (1) {
// char ret = mult_hw(1, 1) + 48;
// char ret = 48;
// putChar(ret);
//   wait(20);
// }
// while (1) {
//   if (mult_hw(12, 13) == 1) {
//     putChar('T');
//   } else {
//     putChar('F');
//   }
// }
// uint32_t *i;
// &i =
// int i = 1;
// for (i = 1; i < 10; i++) {
// wait(20);
// uint32_t result = mult_hw(1, 13);
// itoa_simple_signed(result, buffer);
// if (mult_hw(i, 13) == 14) {
// putChar('T');
// } else {
// putChar('F');
// }
// itoa_simple_signed(mult_hw(i, 13), buffer);
// putstring(buffer);
// buffer[0] = '\n';
// buffer[1] = '\r';
// buffer[2] = '\0';
// putstring(buffer);
// }
// mult_hw(1, 2);
