# Instalación de Quartus en Linux

[![Instalación de Quartus Lite para FPGA Cyclone IV en Linux](https://img.youtube.com/vi/jhNEbPWZCAY/0.jpg)](https://www.youtube.com/watch?v=jhNEbPWZCAY "Instalación de Quartus Lite para FPGA Cyclone IV en Linux")

## Agregar reglas para el dispositivo programador (Blaster)

1. Crear un archivo representativo de reglas:
```bash
sudo geany /etc/udev/rules.d/60-blaster.rules
```
2. En él agregar el siguiente contenido:

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
