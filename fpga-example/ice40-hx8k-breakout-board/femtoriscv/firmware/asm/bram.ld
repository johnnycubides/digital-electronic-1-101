MEMORY
{
   BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x3000  /* 12kB RAM, 12288 bytes, 3072 palabras de 32 bits */
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

