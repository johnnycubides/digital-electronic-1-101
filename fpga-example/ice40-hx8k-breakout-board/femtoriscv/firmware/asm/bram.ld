MEMORY
{
   BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x4000  /* 16kbits RAM */
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

