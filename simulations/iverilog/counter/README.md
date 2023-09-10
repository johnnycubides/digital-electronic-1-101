# Simulación de contador de 3 bits

![RTL del contador](./counter.png)

## Simulación manual

1. Crear el ejecutable *top.vvp* con iverilog:
```bash
iverilog -o top.vvp counter_tb.v counter.v
```

2. Iniciar la simulación generar resultados
```bash
vvp top.vvp
```
> Para finalizar simulación: `> finsih`

* Podría también realizar la simulación creando un archivo
`./file_list.txt` que contiene los módulos que intervienen en la simulación:

```bash
iverilog -o top.vvp -c file_list.txt
vvp top.vvp
```

## Simulación a través de Makefile

Este proyecto contiene un `Makefile` que permite automatizar el proceso, para conocer
las diferentes opciones ejecute en la terminal el comando: `make help`

```bash
make sim        -> Simular diseño
make wave       -> Ver simulación en gtkwave
make rtl        -> Crear RTL
```

Regards,

Johnny
