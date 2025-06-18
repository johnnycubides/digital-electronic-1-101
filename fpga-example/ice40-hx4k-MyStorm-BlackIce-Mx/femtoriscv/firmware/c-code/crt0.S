.section .text.startup
.global _start

_start:
  /* Configurar el puntero de pila */
  la sp, _stack_top

  /* Inicializar .bss a cero */
  la a0, __bss_start
  la a1, __bss_end
  li a2, 0

zero_bss:
  bgeu a0, a1, bss_done
  sw a2, 0(a0)
  addi a0, a0, 4
  j zero_bss

bss_done:
  /* Llamar a main() */
  call main

  /* Bucle infinito si main retorna */
hang:
  j hang
