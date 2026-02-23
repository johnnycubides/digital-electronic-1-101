# Template en FPGA Altera Cyclone IV

La información compartida a continuación tiene el objetivo de ser el punto de
partida para el desarrollo de proyectos con esta tarjeta de desarrollo. Se
invita a seguir los pasos para iniciarse con este flujo de desarrollo y después
modificar su contenido en función de sus necesidades.

Para usar este template, descargue el [template.zip](./template.zip).

Este template contiene un ejemplo completo para la tarjeta de desarrollo
*Altera Cyclone IV* la cual está basada en una FPGA de altera Cyclone IV. El
ejemplo diseñado, consiste de una compuerta negadora. La entrada de la
compuerta es el **pulsador P86** y la salida es el **LED P74** (Revisar
serigrafía para localizar pines).

Para reproducir este ejemplo siga estos pasos:

1. Preparar su computador con un sistema operativo Linux, se recomienda uno
   basado en Debian, como es el caso de Linux mint. Además de una basta
información sobre instalación de un sistema Linux por internet, se puede apoyar
de las diferentes [experiencias de instalación de sus compañeros de
laboratorio](https://github.com/johnnycubides/digital-electronic-1-101/blob/main/installTools/how-install-linux.md).
2. Instalación de herramientas de simulación, síntesis y configuración con
   herramientas opensource: [En este enlace encontrará la receta de instalación
de diferentes
herramientas](https://github.com/johnnycubides/digital-electronic-1-101/blob/main/installTools/conda-and-tools.md)
(Yosys, P&R, Iverilog, Digital, Lite-XL y más). Estas herramientas hacen parte
del flujo de desarrollo digital opensource.
3. Instalación de Quartus para síntesis y configuración de tarjeta de
   desarrollo: Por favor instale **Quartus** en su versión **25.1.0** [como es
indicado en el siguiente
enlace](https://github.com/johnnycubides/digital-electronic-1-101/blob/main/installTools/quartus.md).
4. Conexiones eléctricas entre la tarjeta de desarrollo y el PC deberá usar
   ambos cables USB de la tarjeta de desarrollo; uno para energizar el Core y
el otro cable USB para controlar el bridge Blaster para el proceso de
configuración. **Atención**, si al ejecutar los siguientes comandos, no es
capaz de replicar el ejemplo y está seguro de superar todas las configuraciones
en el software, considere el caso donde los puertos USB de su computador no
entregan la suficiente energía al Blaster, en ese caso puede ser necesario usar
un hub USB con alimentación externa o de conexión tipo USB C.
5. Ya está listo para ejecutar el ejemplo:
* Descomprima el contenido de [template.zip](./template.zip) en un directorio
de su elección y haga uso del editor **Lite-XL** para cargar este directorio
generado llamado `template/`. Explore su contenido.
* Con la combinación de teclas **ALT + t** abra una terminal dentro del editor,
si esto no sucede, la instalación de los complementos de lite-xl no fue
completada y deberá reinstalar el editor.
* Dentro de esta terminal ejecute los siguientes comandos:

```bash
make rtl # Presentación RTL del diseño resultante de la descripción
make sim # Simulación del comportamiento del diseño
make syn # Sintetizar diseño
make config # Configurar el ejemplo en la FPGA
```

* Los anteriores comandos pueden ser ejecutados desde el editor a través de la
**barra de herramientas**, donde encuentra los **íconos de Synthesis y Config**. En ese
menú también encuentra otros íconos para realizar procesos de simulación,
representación de diagramas RTL, compilación de firmware.

Con lo anterior debería ver los LEDs de la tarjeta Core representando el
contador binario.

* Para más comandos, puede ejecutar `make help` en la terminal.

## Contenido del template.zip

```bash
template/
├── EP4CE6-pin-conf.txt
├── docs
│   ├── A-C4E6-SCH.pdf
│   └── altera-cyclone-iv.png
├── Makefile
├── README.md
├── top.qpf
├── top.qsf
├── top_tb.gtkw
├── top_tb.v
└── top.v
```

* [EP4CE6-pin-conf.txt](./EP4CE6-pin-conf.txt): Archivo de texto con las
definiciones de los pines usado en el `top.qsf` responsable de las
restricciones físicas, conecta el diseño lógico descrito en Verilog HDL con los
GPIO de la FPGA.
* [docs/A-C4E6-SCH.pdf](./docs/A-C4E6-SCH.pdf): Esquemático de la tarjeta de
desarrollo, la cual contiene la FPGA Cyclone IV.
* [docs/altera-cyclone-iv.png](./docs/altera-cyclone-iv.png): Imagen de la tarjeta de desarrollo.
* [Makefile](./Makefile): Archivo de automatización del flujo de simulación,
síntesis, configuración y monitoreo. Es un archivo de recetas de los diferentes
procesos, se recomienda agregar en él solo los archivos fuentes del diseño.
* [README.md](./README.md): Este archivo de documentación.
* [top.qpf](./top.qpf): Archivo de proyecto de quartus para el proceso de
síntesis. NO EDITE ESTE ARCHIVO.
* [top.qsf](./top.qsf): archivo donde se realizan indicaciones sobre el proceso
de síntesis y configuración. Tenga presente que para las declaraciones de
restricciones física se puede apoyar del contenido dentro de archivo
`EP4CE6-pin-conf.txt` copiando y adaptando esas declaraciones según sea
necesario.
* [top_tb.gtkw](./top_tb.gtkw): Este archivo es la configuración del
visualizador de formas de onda GTKWave. GTKWave e IVerilog son las herramientas
de simulación que permite observar el comportamiento del circuito comparando
datos de entrada y de salida que han sido estimulados por un archivo testbetch
`top_tb.v`.
* [top_tb.v](./top_tb.v): Este archivo escrito en lenguaje Verilog corresponde
al testbetch del diseño que deberá editar según la simulación a realizar. En
este testbetch se aprovecha el lenguaje verilog para describir los estímulos y
los probes, sin embargo, este archivo no es sintetizable, es decir, no puede
ser implementado como un circuito en una FPGA.
* [top.v](./top.v): Archivo Verilog HDL que contiene la descripción del
circuito digital para el flujo de diseño, se recomienda no cambiar el nombre
del archivo. Para agregar más archivos .v al diseño, basta con ubicarlos en
este directorio y listarlos en el archivo Makefile en la variable `DESIGN`.
Ejemplo:

```Makefile
DESIGN+=./top.v
DESIGN+=./file1.v
DESIGN+=./file2.v
```

## Referencias

* [Land boards A-C4E6 Cyclone IV Wiki](http://land-boards.com/blwiki/index.php?title=A-C4E6_Cyclone_IV_FPGA_EP4CE6E22C8N_Development_Board)
* Configuración volátil y persistente de FPGA Cyclone IV:
[![Configuración volátil y persistente de FPGA Cyclone IV](https://img.youtube.com/vi/QzFHMY5IMPI/0.jpg)](https://www.youtube.com/watch?v=QzFHMY5IMPI "Configuración volátil y persistente de FPGA Cyclone IV")

Saludos,

Johnny
