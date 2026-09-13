MEMORY
{
    BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x8000  /* 32kB RAM, 32768 bytes, 8192 palabras de 32 bits */
}
SECTIONS
{
    everything :
    {
	. = ALIGN(4);
	example1.o (.text)
        *(.*)
    } >BRAM
}

