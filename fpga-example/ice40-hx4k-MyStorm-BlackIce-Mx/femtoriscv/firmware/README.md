<!-- LTeX: enabled=true language=es -->
<!-- :set spell! -->
<!-- :MarkdownPreview -->
<!-- :GenTocMarked -->

# Instrucciones

Para reconfigurar los parámetros de compilación del firmware en relación a la memoria puede ejecutar el script de octave e introducir el valor de la memoria en kbits, ejemplo:

```bash
octave ./calcular_memoria_verilog.m
```

Resultado:

```bash
octave  calcular_memoria_verilog.m 
Introduce la RAM embebida del FPGA (en kbits): 120
========================================
RAM total: 120 kbits (15360 bytes o 15 kB)
Ancho de palabra: 32 bits (4 bytes por palabra)
----------------------------------------
INSTRUCCIONES:
  - Realice una de las configuraciones TEÓRICA o RECOMENDADA para cada uno de los pasos 1, 2 y 3.
========================================
1. Configuración Verilog:
  - En el archivo ../cores/memory/Memory.v modifique el valor de reg [31:0] MEM por:
----------------------------------------
  // Configuración teórica:
  reg [31:0] MEM [0:3839];
----------------------------------------
  // Configuración recomendada (80%):
  reg [31:0] MEM [0:3071];
========================================
2. Configuración en el linker:
    - En el archivo ./c-code/linker.ld (para C) o ./asm/bram.ld (para ASM) modificar BRAM a:
----------------------------------------
  /* Configuración teórica:*/
  BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x3C00  /* 15kB RAM, 15360 bytes, 3840 palabras de 32 bits */
----------------------------------------
  /* Configuración recomendada (80%):*/
  BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x3000  /* 12kB RAM, 12288 bytes, 3072 palabras de 32 bits */
========================================
3. Configuración en el traductor de palabras:
    - En el archivo ./c-code/Makefile (para C) o ./asm/Makefile (para ASM) modificar FPGA_RAM_BYTES a:
----------------------------------------
  # Configuración teórica:
  FPGA_RAM_BYTES = 15360
----------------------------------------
  # Configuración recomendada (80%):
  FPGA_RAM_BYTES = 12288
========================================
```

Depuración
```bash
objdump -tC ./firmware.elf | grep 'unused'
```
