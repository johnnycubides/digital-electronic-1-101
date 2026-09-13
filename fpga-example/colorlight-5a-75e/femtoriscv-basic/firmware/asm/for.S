.section .text
.globl for

for:
        li   t0, 0
        li   t1, 0
        li   t2, 10
loop:
        addi t0,t0,1
        addi t1,t0,2
        bge  t2,t0,loop

