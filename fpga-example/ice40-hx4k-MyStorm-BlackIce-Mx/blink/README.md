# Ejemplo de Blink en FPGA Blackice

![Imagen RTK](./top.png)

## ¿Cómo ejecutar el ejemplo?

0. Deberá tener las herramientas de desarrollo instaladas en su equipo.
    * Herramientas de simulación y síntesis con *Conda*

1. Descargue el proyecto [prj.zip](./prj.zip) y descomprima en un directorio de trabajo.

2. Para simular y ver los resultados ejecute,

```bash
make sim
```

3. Para sintetizar el proyecto ejecute el siguiente comando:

```bash
make syn
```
4. Para configurar la FPGA (con la FPGA conectada al programador) ejecute:

```bash
make config
```

5. Si quiere obtener el RTL del proyecto y verlo en una imagen SVG ejecute el siguiente comando:

```bash
make rtl
```

> Para obtener los comandos de ayuda escriba en la consola: `make help`
