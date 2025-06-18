#include "utilities.h"

/**
 * @brief Convierte una cadena ASCII a un número entero con signo.
 *
 * Características:
 * - Ignora espacios en blanco al inicio.
 * - Soporta signo negativo (`-`), pero no positivo (`+`).
 * - Compatible con arquitecturas RISC-V RV32I (sin multiplicación, división,
 * módulo).
 *
 * Limitaciones:
 * - No maneja desbordamientos.
 * - Solo procesa números en base 10.
 * - Termina el procesamiento ante cualquier carácter no numérico.
 *
 * Ejemplos:
 *   atoi_simple_signed("  -123")   → -123
 *   atoi_simple_signed("42abc")    → 42
 *   atoi_simple_signed("   789")   → 789
 *   atoi_simple_signed("")         → 0
 *   atoi_simple_signed("-")        → 0
 */
int atoi_simple_signed(const char *str) {
  int result = 0;
  int negative = 0;
  char ch;

  // Ignora espacios en blanco iniciales
  while (*str == ' ' || *str == '\t') {
    str++;
  }

  // Verifica signo
  if (*str == '-') {
    negative = 1;
    str++;
  }

  // Procesa dígitos
  while ((ch = *str++) != '\0') {
    if (ch >= '0' && ch <= '9') {
      result = (result << 3) + (result << 1); // Multiplica por 10
      result += ch - '0';
    } else {
      break;
    }
  }

  return negative ? -result : result;
}

/**
 * @brief Convierte un número entero con signo a una cadena decimal ASCII
 * terminada en '\0'.
 *
 * Características:
 * - Compatible con arquitecturas sin multiplicación ni división (RISC-V RV32I).
 * - Usa restas sucesivas con potencias de 10 para formar cada dígito.
 * - Soporta valores negativos agregando el signo '-' al inicio.
 *
 * Limitaciones:
 * - Requiere un buffer de al menos 12 bytes (suficiente para INT32 con signo y
 * '\0').
 * - No maneja bases distintas a 10.
 *
 * Ejemplos:
 *   itoa_simple_signed(-123, buf) → buf = "-123"
 *   itoa_simple_signed(456, buf)  → buf = "456"
 */
void itoa_simple_signed(int value, char *str) {
  int divisores[] = {1000000000, 100000000, 10000000, 1000000, 100000,
                     10000,      1000,      100,      10,      1};
  int i, d;
  int started = 0;
  char *ptr = str;

  // Manejo de número negativo
  if (value < 0) {
    *ptr++ = '-';

    // Convierte a positivo usando complemento (sin multiplicación)
    // Importante: -(2^31) se mantiene como -2^31, pero esto sigue siendo válido
    value = -value;
  }

  // Conversión usando restas sucesivas
  for (i = 0; i < 10; ++i) {
    d = 0;
    while (value >= divisores[i]) {
      value -= divisores[i];
      d++;
    }

    if (d != 0 || started || i == 9) {
      *ptr++ = '0' + d;
      started = 1;
    }
  }

  *ptr = '\0';
}
