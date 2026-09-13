.equ IO_BASE, 0x400000  
.equ IO_LEDS, 4
.equ IO_UART_DAT, 8
.equ IO_UART_CNTL, 16
.section .text
.globl start 
.globl blinker
.globl put_hello

start:
        li   gp,IO_BASE
	li   sp,0x400
blinker:
	
	li   t0, 62
	sw   t0, IO_LEDS(gp)
	call wait
	li   t0, 61
	sw   t0, IO_LEDS(gp)
	call wait
	li   t0, 59
	sw   t0, IO_LEDS(gp)
	call wait
	li   t0, 55
	sw   t0, IO_LEDS(gp)
	call wait
	li   t0, 47
	sw   t0, IO_LEDS(gp)
	call wait
	li   t0, 31
	sw   t0, IO_LEDS(gp)
	call wait
	li   t0, 47
	sw   t0, IO_LEDS(gp)
	call wait
	li   t0, 55
	sw   t0, IO_LEDS(gp)
	call wait
	li   t0, 59
	sw   t0, IO_LEDS(gp)
	call wait
	li   t0, 61
	sw   t0, IO_LEDS(gp)
	call wait
	li   t0, 62
	sw   t0, IO_LEDS(gp)
	call wait

	la   a0, hello
	call putstring
        call getchar    # data received on a0
        call putchar    # data to send on a0
        li   a0,0x0A
        call putchar    # data to send on a0
	j    blinker
putstring:
	addi sp,sp,-4 # save ra on the stack
	sw ra,0(sp)   # (need to do that for functions that call functions)
	mv t2,a0	
.L1:    lbu a0,0(t2)
	beqz a0,.L2
	call putchar
	addi t2,t2,1	
	j .L1
.L2:    lw ra,0(sp)  # restore ra
	addi sp,sp,4 # restore sp
	ret	
#	ebreak

.section .data
hello:
	.asciz "Hello, ASM world\n\r"
	
