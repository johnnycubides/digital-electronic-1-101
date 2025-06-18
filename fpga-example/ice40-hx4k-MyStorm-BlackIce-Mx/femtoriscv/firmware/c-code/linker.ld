ENTRY(_start)

MEMORY
{
    BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x2000  /* 8kB RAM, 8192 bytes, 2048 palabras de 32 bits */
}


SECTIONS
{
    .text : {
        . = ALIGN(4);
        *(.text.startup)  /* Punto de entrada _start */
        *(.text*)
        *(.rodata*)
    } > BRAM

    .data : {
        . = ALIGN(4);
        *(.data*)
    } > BRAM

    .bss : {
        . = ALIGN(4);
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    } > BRAM

    .stack (NOLOAD) : {
        _stack_start = .;
        . = . + 0x0400; /* 1KB stack */
        _stack_end = .;
        _stack_top = .;
    } > BRAM
}
