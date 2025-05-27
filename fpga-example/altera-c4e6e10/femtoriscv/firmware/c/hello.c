#include <femtorv32.h>

int main() {
    char k = 0;
    char a = 0;
    for(k=1; k<= 10 ;k++)
        a = k + 2;
     /* Using: "libfemtorv/include/HardwareConfig_bits.h" (derived from "HardwareConfig_bits.v")
      * IO_XXX = 1 << (IO_XXX_bit + 2); IO_LEDS_bit=0; --> (1<<(0+2))=4 --> 0x400004
        delay use FEMTORV32_FREQ to calculate delay, uou must change it to adjust you frequency libfemtorv/include/femtorv32.h
      */
    
     printf("\n\rHello C World!\n\r");
     while(1){
       delay(200);
       k++;
       *(volatile uint32_t*)(0x400004) = ~k;
     }	
   return 0;
}

