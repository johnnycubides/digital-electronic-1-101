.section .text       # Sección de código ejecutable
.globl wait          # Hace la etiqueta 'wait' visible globalmente

wait:
    addi sp,sp,-4    # Reserva espacio en el stack (4 bytes)
    sw   t0,0(sp)    # Guarda el valor actual de t0 en el stack
    
    li   t0, 1       # Carga el valor inmediato 1 en el registro t0
    sll  t0, t0, a0  # Desplaza t0 a la izquierda por el valor en a0 (2^a0)
    
.L0:                 # Etiqueta local .L0 (inicio del bucle)
    addi t0,t0,-1    # Decrementa t0 en 1
    bnez t0, .L0     # Si t0 no es cero, salta a .L0 (repite el bucle)
    
    lw   t0,0(sp)    # Restaura el valor original de t0 desde el stack
    addi sp,sp,4     # Libera el espacio en el stack
    ret              # Retorna de la función
