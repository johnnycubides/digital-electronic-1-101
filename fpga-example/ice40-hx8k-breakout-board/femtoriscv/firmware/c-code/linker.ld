ENTRY(main)
/* Script de enlazado personalizado basado en el original */
MEMORY
{
   BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x4000  /* 16kB RAM */
}

SECTIONS
{
    .text : {
        . = ALIGN(4);
        *(.text.startup)  /* Sección de inicio */
        *(.text*)        /* Todo el resto de código */
        *(.rodata*)      /* Datos de solo lectura */
        *(.data*)        /* Datos inicializados */
        *(.bss*)         /* Datos no inicializados */
        *(COMMON)        /* Variables comunes */
        . = ALIGN(4);
    } > BRAM

    /* Definición del inicio de la pila al final de la BRAM */
    _stack_start = ORIGIN(BRAM) + LENGTH(BRAM);
}
