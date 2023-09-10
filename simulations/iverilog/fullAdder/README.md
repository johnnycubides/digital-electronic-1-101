# Simulación de un sumador completo

Vídeo sobre la simulación aquí planteada:

[![Simulación de un circuito digital con herramientas opensource](https://img.youtube.com/vi/N9OJL0nyhSQ/0.jpg)](https://www.youtube.com/watch?v=N9OJL0nyhSQ "Simulación de un circuito digital con herramientas opensource")

* RTL del sumador completo

![RTL del sumador completo](./fulladder.png)

* RTL del medio sumador

![RTL del medio sumador](./halfadder.png)

## Simulación manual

1. Descargar el archivo [prj.zip](./prj.zip) que contiene el proyecto y descomprimir en el área de trabajo.

2. Crear el ejecutable *top.vvp* con iverilog:

```bash
iverilog -o top.vvp fulladder_tb.v fulladder.v halfadder.v
```

3. Iniciar la simulación generar resultados

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

## Obtener los RTL

* RTL fulladder.v

```bash
make rtl rtl2png TOP=fulladder MODULES=halfadder.v
```

* RTL halfadder.v

```bash
make rtl rtl2png TOP=halfadder MODULES=
```

Regards,

Johnny
