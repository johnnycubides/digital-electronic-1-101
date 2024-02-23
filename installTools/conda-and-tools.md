---
lang: es
---

<!-- vim-markdown-toc Marked -->

* [Instalación de herramientas](#instalación-de-herramientas)
    * [Instalación de Miniconda](#instalación-de-miniconda)
        * [Instalación de herramientas opensource desde Miniconda](#instalación-de-herramientas-opensource-desde-miniconda)
            * [Instalación de herramientas de desarrollo con un solo comando (Opción 1 recomendada)](#instalación-de-herramientas-de-desarrollo-con-un-solo-comando-(opción-1-recomendada))
            * [Agregar reglas para el uso del hardware y dar permisos (necesario en ambas opciones)](#agregar-reglas-para-el-uso-del-hardware-y-dar-permisos-(necesario-en-ambas-opciones))
            * [Instalación de herramientas de desarrollo paso a paso (Opción 2)](#instalación-de-herramientas-de-desarrollo-paso-a-paso-(opción-2))
    * [Digital Simulador de circuitos](#digital-simulador-de-circuitos)
        * [Instalación de Digital](#instalación-de-digital)
        * [Complementos para digital](#complementos-para-digital)
    * [Referencias](#referencias)

<!-- vim-markdown-toc -->

# Instalación de herramientas

A continuación se propone la instalación de diferentes herramientas para el diseño, simulación, síntesis, ruteo y configuarción
de circuitos digitales en tecnologías como es el caso de las FPGA. Tenga presente que al final deberá realizar estas actividades:

* Instalación miniconda
* Instalación de herramientas _opensource_
* Instalación de _Digital_
* Dar permisos al puerto USB para comunicación serial

> **¡Tenga en cuenta!** Las instrucciones que van delante del símbolo ` $ ` son aquellas a realizar en el prompt de la consola/terminal; deberá copiarlas y
> pegarlas en la consola para luego ejecutarlas. Las demás líneas o campos son salidas o resultados de una operación que podrá usar como
> comparación.


Antes de instalar las herramientas recomendadas en esta guía, ejecute este
comando para instalar o actualizar algunas dependencias:

```bash
sudo apt update
sudo apt install eog imagemagick curl geany geany-plugins
```

## Instalación de Miniconda

Miniconda es un ecosistema que homogeniza las características requeridas para
la instalación y ejecución de aplicaciones, a través de variables de entorno y
un gestor de paquetes online, lo anterior facilita la instalación de
aplicaciones con un solo comando y evita los problemas que se asocien a estos
mismos.

Ejecute los siguientes 3 comandos en una terminal de linux, si en la terminal
se presenta algún error comparta el resultado para recibir sugerencias.

```bash
cd Downloads
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh # Seguir las instrucciones y reiniciar la terminal
```

### Instalación de herramientas opensource desde Miniconda

Se presentan dos opciones de instalación, en principio haga uso de la opción 1
recomendad y seguido de permisos al puerto serial.

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
(base) $ conda create -n digital python=3.7 # Configurar digital como variable de entorno y python3.10
(base) $ conda activate digital  # Activar la variable de entorno de conda denominada digital
(digital) $ python --version # Debe presentarse la version 3.7 para poder continuar
```
> Recuerde que para activar el entorno **digital** deberá hacer uso del comando `$ conda activate digital`.
> Para desactivar la variable de entorno **digital** en conda ejecutar `$ conda deactivate`


```bash
(digital) $ conda install -c litex-hub nextpnr-ice40
(digital) $ conda install -c litex-hub nextpnr-ecp5
(digital) $ conda install -c litex-hub iceprog
(digital) $ conda install -c litex-hub yosys
(digital) $ conda install -c litex-hub iverilog
(digital) $ conda install -c symbiflow netlistsvg
(digital) $ conda install -c conda-forge graphviz
(digital) $ conda install -c conda-forge gtkwave 
```

> Para comprobar que se han instalado las herramientas requeridas podrá listar y ubicarlas con el comando `$ conda list`
> Para remover un paquete instalado puede ejecutar como sigue: `conda remove name-package`


También puede comprobar las versiones instaladas como sigue:

```
(digital) $ gtkwave --version # versión instalada v3.3.117
(digital) $ yosys --version) # versión instalada Yosys 0.32+74
(digital) $ iverilog -v # versión instalada 13.0
```

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

### Complementos para digital

Digital permite importar descripciones VHDL o Verilog a su área de trabajo para realizar simulaciones, para habilitar esta opción
se requiere la instalación de un simulador según el lenguaje que se quiera importar:

* Para Verilog -> Icarus Verilog (el cual ya fue instalado con conda), [docs](https://steveicarus.github.io/iverilog/usage/installation.html), [Windows bin](https://bleyer.org/icarus/)
* Para VHDL -> GHDL (si quiere simulador con VHDL), [Docs](http://ghdl.free.fr/site/pmwiki.php?n=Main.HomePage), [Binarios](https://github.com/ghdl/ghdl/releases), [Wiki](https://github.com/ghdl/ghdl/wiki)

## Referencias

* [Conda  config spec-file](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#activating-an-environment)
* [Nextpnr](https://github.com/YosysHQ/nextpnr)
* [Yosys](https://github.com/YosysHQ/yosys)
