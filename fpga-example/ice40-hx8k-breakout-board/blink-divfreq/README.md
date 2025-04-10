# Ejemplo de Blink en FPGA ICE40

![Imagen RTL](./top.png)

## ¿Cómo ejecutar el ejemplo?

1. Deberá tener las herramientas de desarrollo instaladas en su equipo.
    * Herramientas de simulación y síntesis con *Conda*

2. Descargue el proyecto [blink-freqdiv.zip](./blink-freqdiv.zip) y descomprima en un directorio de trabajo.

3. Para simular y ver los resultados ejecute:
```bash
make sim
```

4. Para sintetizar el proyecto ejecute el siguiente comando:
```bash
make syn
```

5. Para configurar la FPGA (con la FPGA conectada al programador) ejecute:
```bash
make config
```

6. Si quiere obtener el RTL del proyecto y verlo en una imagen SVG ejecute el siguiente comando:
```bash
make rtl
```

> Para obtener los comandos de ayuda escriba en la consola: `make help`

[![Divisor de frecuencia en verilog](https://img.youtube.com/vi/vcO0aY5vYSI/0.jpg)](https://www.youtube.com/watch?v=vcO0aY5vYSI "Divisor de frecuencia en verilog")

