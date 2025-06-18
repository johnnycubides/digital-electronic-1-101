<!-- LTeX: enabled=true language=es -->
<!-- :set spell! -->
<!-- :MarkdownPreview -->
<!-- :GenTocMarked -->

# SoC FemtoRiscv32i

![SoC FemtoR32i](./SOC.svg)


SoC basado en un riscv de instrucciones base (32 bits instrucciones integer)

Este proyecto está dividido en dosrk procesos:

1. Creación de tareas de software en lenguaje **C** (`./firmware/c-code/`) o en **ASM** (`./firmware/asm/`).
2. Sintesis de SoC desde el Makefile (`./Makefile`) de este directorio.

## Cómo ejecutar el ejemplo

```bash
cd ./firmware/ && make firmware_words # Generar tradutor bin a palabras. Solo se ejecuta una ÚNICA VEZ
make c-clean c-build # Creación ejecutable de riscv32i
make clean syn # Crear el bitstream para configurar la fpga
make config # Configurar fpga
```
## Conectar FPGA a esp32

![fpga-esp32](./docs/soc-esp32.svg)

![Imagen RTK](./blink.png)

## ¿Cómo ejecutar el ejemplo?

1. Deberá tener las herramientas de desarrollo instaladas en su equipo.
    * Herramientas de simulación y síntesis con *Conda*

2. Descargue el proyecto [template.zip](./template.zip) y descomprima en un directorio de trabajo.

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

## Micropython ESP32

1. Instalar las dependencias de flashing del esp32. Para ello ejecute estos pasos:

```bash
sudo apt install picocom
conda activate digital # Active la variable de entorno de digital
pip install click esptool pyyaml adafruit-ampy
```

> **Observación**: en el caso de no ser compatible la variable de entorno
**generando error**, podría crear una nueva variable de entorno con conda que
soporte los paquetes a instalar, por ejemplo:
```bash
conda create --name esp32
conda activate esp32
pip install click esptool pyyaml adafruit-ampy
```

Tenga presente que para desactivar el entorno basta con `conda deactivate`.


2. Desde la [página oficial de descargas de Micropython para el
   ESP32](https://micropython.org/download/ESP32_GENERIC/) descargue la útima
versión de micropython disponibles para el esp32, en este caso se trata de la
versión
[v1.25.0(2025-4-15).bin](https://micropython.org/resources/firmware/ESP32_GENERIC-20250415-v1.25.0.bin),
para tal finalidad puede ejecutar el siguiente comando:

```bash
wget -O micropython-esp32.bin "https://micropython.org/resources/firmware/ESP32_GENERIC-20250415-v1.25.0.bin"
```

3. Instale micropython en el esp32. Para ello solo deje conectado el esp32 en
   los puertos USB del PC así logrará que el instalador detecte automáticamente
el bridge del esp32 para su flashing. Ejecute los siguientes comandos:

```bash
# Recuerde tener activa la variable de entorno donde tienen instalada las librerías de python
esptool.py erase_flash
esptool.py --baud 460800 write_flash 0x1000 micropython-esp32.bin

Resultado:

<details>
```bash
esptool.py v4.7.0
Found 6 serial ports
Serial port /dev/ttyUSB1
Connecting......................................
/dev/ttyUSB1 failed to connect: Failed to connect to Espressif device: No serial data received.
For troubleshooting steps visit: https://docs.espressif.com/projects/esptool/en/latest/troubleshooting.html
Serial port /dev/ttyUSB0
Connecting....
Detecting chip type... Unsupported detection protocol, switching and trying again...
Connecting.....
Detecting chip type... ESP32
Chip is ESP32-D0WDQ6 (revision v1.0)
Features: WiFi, BT, Dual Core, 240MHz, VRef calibration in efuse, Coding Scheme None
Crystal is 40MHz
MAC: a4:cf:12:74:fd:e4
Uploading stub...
Running stub...
Stub running...
Erasing flash (this may take a while)...
Chip erase completed successfully in 7.6s
Hard resetting via RTS pin...
```
</details>

>  **Observación**: En el caso de que no haga flashing, oprima el botón de BOOT en el esp32:

4. Abra una terminal e interactue con micropython el cual usa una sintaxis de Python3. Para ello ejecute los siguientes comandos:

```bash
# Verifique el archivo representativo del puerto serial del esp32, es probable que sea /dev/ttyUSB0
picocom /dev/ttyUSB0 -b 115200 # Dependiendo del archivo representativo el tty puede cambiar

```
