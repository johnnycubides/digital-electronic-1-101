.equ UART_BASE, 0x400000  
.equ IO_UART_DAT, 8
.equ IO_UART_CNTL, 16

.section .text
.globl putchar

putchar:
   addi sp,sp,-8      # save a3, a4, a5 on the stack
   sw   t0,0(sp) 
   sw   t1,4(sp) 

   li   gp, UART_BASE
   sw   a0, IO_UART_DAT(gp)
   li   t0, 0x01
   sw   t0, IO_UART_CNTL(gp)
   li   t0, 0x00
   sw   t0, IO_UART_CNTL(gp)
   li   t0, 1<<9
.L0:  
   lw   t1, IO_UART_CNTL(gp)
   and  t1, t1, t0
   bnez t1, .L0
   
   lw   t0,0(sp) 
   lw   t1,4(sp)
   addi sp,sp,8      # save a3, a4, a5 on the stack
  ret

