# Instalación de Quartus en Linux

En el siguiente vídeo encontrará un ejemplo de instalación de Quartus para GNU/Linux donde solo se hace uso
del justamente las dependencias para la Cyclone IV, lo anterior permite que el tamaño de la instalación
sea menor a la instalación standar.

> Atención: En el vídeo se realiza la instalación de Quartus en su versión 23.1.1. Para realizar
> La instalación de Quartus en su versión actual **25.1.0** basta con seguir los pasos del vídeo
> Pero seleccionando la versión deseada, es decir, el procesos de instalación es el mismo.

Video de instalación:

[![Instalación de Quartus Lite para FPGA Cyclone IV en Linux](https://img.youtube.com/vi/2SIvtz-5iro/0.jpg)](https://www.youtube.com/watch?v=2SIvtz-5iro "Instalación de Quartus Lite para FPGA Cyclone IV en Linux")

## Agregar reglas para el dispositivo programador (Blaster)

Después de realizada la instalación deberá agregar las reglas para que el kernel
pueda hacer uso del *Altera Blaster* el cual es el programador de la fpga. Para
agregar las reglas ejecute los pasos del 1 al 3 que verá a continuación:

1. Crear un archivo representativo de las reglas:
```bash
sudo lite-xl /etc/udev/rules.d/60-blaster.rules
```
2. En él agregar el siguiente contenido, guardar y cerrar:

```bash
# Altera USB Blaster
ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="660", GROUP="plugdev", TAG+="uaccess"
# Altera USB Blaster2
ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="660", GROUP="plugdev", TAG+="uaccess"
ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="660", GROUP="plugdev", TAG+="uaccess"
```

3. Reiniciar las reglas:
```bash
sudo udevadm control --reload-rules
```
