.equ IO_BASE, 0x400000  
.equ IO_LEDS, 4
.equ IO_UART_DAT, 8
.equ IO_UART_CNTL, 16
.globl start


start:
  li   gp,IO_BASE
	li   sp,0x400

main_loop:
    la   a0, hello
    call putstring
    call wait
    j    main_loop    # Bucle infinito

putstring:
    addi sp, sp, -4   # Guardar espacio en la pila para ra
    sw   ra, 0(sp)    # Almacenar ra (return address)
    mv   t2, a0       # t2 = puntero al string (a0 contiene la dirección de "hello")

.L1:
    lbu  a0, 0(t2)    # Cargar byte sin signo (carácter actual) en a0
    beqz a0, .L2      # Si es cero (fin de cadena), saltar a .L2
    call putchar      # Llamar a putchar (dependencia externa)
    addi t2, t2, 1    # Incrementar puntero (siguiente carácter)
    j    .L1          # Repetir bucle

.L2:
    lw   ra, 0(sp)    # Restaurar ra
    addi sp, sp, 4    # Liberar espacio en la pila
    ret               # Retornar

.section .data
hello:
	.asciz "Hello, ASM world\n\r"
