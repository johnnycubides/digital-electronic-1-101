.section .text
.globl wait

wait:
	addi sp,sp,-4      # save a3, a4, a5 on the stack
	sw   t0,0(sp) 
   li   t0, 1
   sll  t0, t0, a0
.L0:       
        addi t0,t0,-1
	bnez t0, .L0

	lw   t0,0(sp) 
	addi sp,sp,4      # save a3, a4, a5 on the stack
	ret
