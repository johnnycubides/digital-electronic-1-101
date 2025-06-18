#ifndef UTILITIES_H
#define UTILITIES_H

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
int atoi_simple_signed(const char *str);

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
void itoa_simple_signed(int value, char *str);

#endif
