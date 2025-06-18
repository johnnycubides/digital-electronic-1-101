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

## Configurar el ESP32 como bridge UART

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
```

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

>  **Observación**: En el caso de que no haga flashing, oprima el botón de BOOT en el esp32:

</details>


4. Abra una terminal e interactue con micropython el cual usa una sintaxis de Python3. Para ello ejecute los siguientes comandos:

```bash
# Verifique el archivo representativo del puerto serial del esp32, es probable que sea /dev/ttyUSB0
picocom /dev/ttyUSB1 -b 115200 # Dependiendo del archivo representativo el tty puede cambiar
```

Resultado:

<details>

  ```py
picocom /dev/ttyUSB1 -b 115200
picocom v3.1

port is        : /dev/ttyUSB0
flowcontrol    : none
baudrate is    : 115200
parity is      : none
databits are   : 8
stopbits are   : 1
escape is      : C-a
local echo is  : no
noinit is      : no
noreset is     : no
hangup is      : no
nolock is      : no
send_cmd is    : sz -vv
receive_cmd is : rz -vv -E
imap is        : 
omap is        : 
emap is        : crcrlf,delbs,
logfile is     : none
initstring     : none
exit_after is  : not set
exit is        : no

Type [C-a] [C-h] to see available commands
Terminal ready

>>> print("hello")
hello
>>> 
  ```

</details>

Para salir de `picocom` ejecute la secuencia **CTRL+a** y luego **CTRL+x**.

5. Cargue un script de micropython en el esp32 para realizar el puente entre la FPGA y el esp32.
Para tal finalidad, cree un archivo `main.py` y agregue el siguiente contenido:

```py
from machine import UART
from time import sleep

uart_fpga = None
uart_usb = None

def init():
    global uart_usb
    global uart_fpga
    # UART0: ahora libre
    uart_usb = UART(1, baudrate=115200, tx=1, rx=3)
    # UART2: FPGA
    uart_fpga = UART(2, baudrate=57600, tx=17, rx=16)

def bridge_uart():
    while True:
        if uart_fpga.any():
            uart_usb.write(uart_fpga.read())
        if uart_usb.any():
            uart_fpga.write(uart_usb.read())
        sleep(0.001)

def start():
    init()
    bridge_uart()

```

A continuación suba el script `main.py` al esp32. Para ello ejecuta el siguiente comando:

```bash
ampy -p /dev/ttyUSB1 -b 115200 put main.py
```
