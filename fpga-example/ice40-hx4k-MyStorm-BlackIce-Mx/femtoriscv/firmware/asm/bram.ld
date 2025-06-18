MEMORY
{
    BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x2000  /* 8kB RAM, 8192 bytes, 2048 palabras de 32 bits */
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

