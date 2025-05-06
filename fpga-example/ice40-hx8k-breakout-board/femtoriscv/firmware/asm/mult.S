.equ MULT_BASE,   0x420000  
.equ MULT_OP_A,   0x04
.equ MULT_OP_B,   0x08
.equ MULT_INIT,   0x0C
.equ MULT_RESULT, 0x10
.equ MULT_DONE,   0x14

.section .text
.globl mult
.globl mult_hw
# a0 * a1
mult:
  addi sp,sp,-12      # save a3, a4, a5 on the stack
  sw   a3,0(sp) 
  sw   a4,4(sp) 
  sw   a5,8(sp) 

  mv    a4, a0
  mv    a5, a1       # a4 * a5
  li    a0, 0        # PP = 0
.L2:
  andi  a3, a5, 1    # 
  beqz  a3, .L1      # LSB of a5 = 0 ?
  add   a0, a0, a4   # PP = PP + a4
.L1:
  srli  a5, a5, 1    # a5 = a5/2
  slli  a4, a4, 1    # a0 = a0*2
  bnez  a5, .L2      # loop until a5 = 0 

  lw   a3,0(sp)  # 
  lw   a4,4(sp)  # 
  lw   a5,8(sp)  # 
  addi sp,sp,12  # restore sp
  ret
  
mult_hw:
  li   gp, MULT_BASE 
  sw   a0, MULT_OP_A(gp)  
  sw   a1, MULT_OP_B(gp)
  li   a0, 1
  sw   a0, MULT_INIT(gp) 
  sw   zero, MULT_INIT(gp)  
.L0:
   li   t0, 1  
   lw   t1, MULT_DONE(gp)
   and  t1, t1, t0
   beqz t1, .L0  
   lw   a0, MULT_RESULT(gp)
  ret
#a4        a5     a3       a0    
#000111   0101   0000     0000
#000111   0101   0001     0000
#000111   0101   0001     0111
#001110   0010   0001     0111
#001110   0010   0000     0111
#011100   0001   0000     0111
#011100   0001   0001     0111
#011100   0001   0001   100011
#111000   0000   0001   100011  
