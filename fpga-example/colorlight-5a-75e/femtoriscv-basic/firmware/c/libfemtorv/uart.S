.include "femtorv32.inc"
	
#################################################################################	
# NanoRv UART support
#################################################################################

.global	putchar
.type	putchar, @function
putchar:
   sw a0, IO_UART_DAT(gp)
   li t0, 1<<9
.L0:  
   lw t1, IO_UART_CNTL(gp)
   and t1, t1, t0
   bnez t1, .L0
  ret

.global	getchar
.type	getchar, @function
getchar:
        lw a0,IO_UART_DAT(gp)
	andi t0,a0,256 # bit 8 = data ready
        beqz t0,getchar
	andi a0, a0, 255
	li t0, 10                  # <enter> generates CR/LF, we ignore LF.
	beq a0, t0, getchar
        ret 

