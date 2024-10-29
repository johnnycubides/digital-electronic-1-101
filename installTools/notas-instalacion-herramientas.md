## Digital Simulador de circuitos

![imagen de digital](https://github.com/hneemann/Digital/raw/master/distribution/screenshot2.png)

Digital es una herramienta didáctica escrita en java e inspirada por [logisim](http://www.cburch.com/logisim/).
Esta herramienta permite comprender cómo se construyen y se comportan los diferentes circuitos electrónicos digitales,
realiza diferentes análisis, test de comportamiento, como también exporta los módulos digitales a lenguajes de descripción HDL.

* [Repositorio del proyecto digital en github](https://github.com/hneemann/Digital)

### Instalación de Digital

> Digital requiere la máquina virtual de java, puede comprobar que tenga instalada usando el comando`java --version`.
> en el caso de no tener instalada la máquina virtual podría revisar el siguiente enlace: [JVM](https://adoptium.net/).

> En el caso de no tener instalado el JDK o alguna librería requerida en Linux podrá realizar la instalación del JDK desde un gestor de paquetes, ejemplo:
```bash
$ sudo apt install openjdk-11-jdk # > Si es una distribución basada en debian
$ pamac install jdk-openjdk # > Si es una distribución basada en arch
```

Para realizar la instalación de Digital en su sistema podrá seguir estos 3 pasos:

1. Descargar [Digital.zip](https://github.com/hneemann/Digital/releases/latest/download/Digital.zip): este archivo contiene la aplicación y los scripts necesarios.
2. Ejecutar la aplicación: Se descomprime el archivo .zip y en la carpeta generada basta con lanzar el ejecutable con extensión .exe para Windows o `java -jar Digital.jar` en una terminal para Linux.
3. Instalar Digital: si desea encontrar Digital en el menú de aplicaciones bastará con ejecutar el comando `./install.sh` en el directorio donde se encuentra Digital.jar.

A continuación se presenta el ejemplo de instalación de *Digital* en un directorio del usuario. Observe el paso a paso:

```
curl https://raw.githubusercontent.com/johnnycubides/swissknife/refs/heads/master/bash/installs/digital-sh/digital-install.sh | bash -s install
```

**Observación**: En algunas distribuciones va a requerirse la instalación de libfuse, la cual se puede instalar puedes ejecutar `sudo apt install libfuse2`


### Instalación de herramientas opensource desde Miniconda

Se presentan dos opciones de instalación, en principio haga uso de la opción 1
recomendada y seguido de permisos al puerto serial.

#### Instalación de herramientas de desarrollo con un solo comando (Opción 1 recomendada)

Con este único comando podrá instalar todas las herramientas _opensource_ para
el proceso de diseño de sistemas digitales.

```bash
curl https://raw.githubusercontent.com/johnnycubides/digital-electronic-1-101/main/installTools/spec-file.txt > ./spec-file.txt && conda create -n digital --file ./spec-file.txt
```

#### Agregar reglas para el uso del hardware y dar permisos (necesario en ambas opciones)

El puerto serial (USB-serial) requiere permisos para poder comunicarse con la
tarjeta de desarrollo a través del protocolo _UART_. Para dar permisos, ejecute
el siguiente comando:

```bash
curl https://raw.githubusercontent.com/johnnycubides/digital-electronic-1-101/main/installTools/hw-permissions.sh | sh
```

Reinicie el equipo, inicie una terminal y al ejecutar el comando `groups` en
ella deberá ver el grupo *dialout* en pantalla.

#### Instalación de herramientas de desarrollo paso a paso (Opción 2)

Estos comandos fueron ejecutados en la sección anterior de instalación de un
solo comando, sin embargo, se ponen acá para que pueda conocer las herramientas
que fueron instaladas.

```bash
(base) $ conda update conda # Actualizar conda
(base) $ conda create -n digital python=3.7 # Configurar digital como variable de entorno y python3.7
(base) $ conda activate digital  # Activar la variable de entorno de conda denominada digital
(digital) $ python --version # Debe presentarse la version 3.7 para poder continuar
```
> Recuerde que para activar el entorno **digital** deberá hacer uso del comando `$ conda activate digital`.
> Para desactivar la variable de entorno **digital** en conda ejecutar `$ conda deactivate`


```bash
(digital) $ conda install conda-forge::libstdcxx-ng
(digital) $ conda install conda-forge::libusb
(digital) $ conda install conda-forge::libftdi 
(digital) $ conda install conda-forge::libhidapi
(digital) $ conda install johnnycubides::openfpgaloader 
(digital) $ conda install -c litex-hub nextpnr-ice40
(digital) $ conda install -c litex-hub nextpnr-ecp5
(digital) $ conda install -c litex-hub iceprog
(digital) $ conda install -c litex-hub yosys
(digital) $ conda install -c litex-hub iverilog
(digital) $ conda install -c symbiflow netlistsvg
(digital) $ conda install -c conda-forge graphviz
(digital) $ conda install -c conda-forge gtkwave 
(digital) $ conda install conda-forge::verilator
(digital) $ conda install gcc-riscv64-elf-newlib
(digital) $ conda install conda-forge::verible
```

> Para comprobar que se han instalado las herramientas requeridas podrá listar y ubicarlas con el comando `$ conda list`
> Para remover un paquete instalado puede ejecutar como sigue: `conda remove name-package`


También puede comprobar las versiones instaladas como sigue:

```
(digital) $ gtkwave --version # versión instalada v3.3.117
(digital) $ yosys --version) # versión instalada Yosys 0.32+74
(digital) $ iverilog -v # versión instalada 13.0
```

