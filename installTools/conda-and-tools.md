---
lang: es
---

<!-- vim-markdown-toc Marked -->

* [Instalación de herramientas](#instalación-de-herramientas)
  * [1. Instalación de dependencias](#1.-instalación-de-dependencias)
  * [2. Instalación de Miniconda](#2.-instalación-de-miniconda)
    * [2.1 Instalación de herramientas opensource desde Miniconda](#2.1-instalación-de-herramientas-opensource-desde-miniconda)
  * [3. Agregar reglas para el uso del hardware y dar permisos](#3.-agregar-reglas-para-el-uso-del-hardware-y-dar-permisos)
  * [4. Instalación de herramientas importantes en el diseño](#4.-instalación-de-herramientas-importantes-en-el-diseño)
    * [4.1 Digital: Simulador de circuitos](#4.1-digital:-simulador-de-circuitos)
      * [Instalación de Digital](#instalación-de-digital)
    * [4.2 Lite XL: Editor de texto liviano](#4.2-lite-xl:-editor-de-texto-liviano)
    * [4.3 Qucs_S | Simulador de circuitos analógicos y digitales](#4.3-qucs_s-|-simulador-de-circuitos-analógicos-y-digitales)
  * [Referencias](#referencias)

<!-- vim-markdown-toc -->

# Instalación de herramientas

A continuación se propone la instalación de diferentes herramientas para el diseño, simulación, síntesis, ruteo y configuarción
de circuitos digitales en tecnologías como es el caso de las FPGA. Tenga presente que al final deberá realizar estas actividades:

* Instalación Miniconda
* Instalación de herramientas _opensource_
* Dar permisos al puerto USB para comunicación serial
* Instalación de _Digital_
* Instalación del editor de texto Lite XL
* Instalación de Qucs para simulaciones analógicas y digitales

> **¡Tenga en cuenta!** Las instrucciones que van delante del símbolo ` $ ` son aquellas a realizar en el prompt de la consola/terminal; deberá copiarlas y
> pegarlas en la consola para luego ejecutarlas. Las demás líneas o campos son salidas o resultados de una operación que podrá usar como
> comparación.


Antes de instalar las herramientas recomendadas en esta guía, ejecute este
comando para instalar o actualizar algunas dependencias:

## 1. Instalación de dependencias

Para las distribuciones basadas en debian, puede ejecutar el siguiente comando:

```bash
sudo apt update
sudo apt install eog imagemagick curl wget openjdk-11-jdk git pulseview ngspice -y
```

En el caso de otras distribuciones deberá consultar cómo puede hacerlo.

## 2. Instalación de Miniconda

Miniconda es un ecosistema que homogeniza las características requeridas para
la instalación y ejecución de aplicaciones, a través de variables de entorno y
un gestor de paquetes online, lo anterior facilita la instalación de
aplicaciones con un solo comando y evita los problemas que se asocien a estos
mismos.

Ejecute los siguientes 3 comandos en una terminal de linux, si en la terminal
se presenta algún error comparta el resultado para recibir sugerencias.

```bash
cd && cd Descargas || cd Downloads
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh # Seguir las instrucciones y reiniciar la terminal
```

### 2.1 Instalación de herramientas opensource desde Miniconda

A continuación se presenta las instrucciones de instalación de las herramientas de desarrollo 
como también para habilitar los permisos de hardware.

Con el siguiente comando podrá instalar todas las herramientas _opensource_
para el proceso de diseño de sistemas digitales.

```bash
curl https://raw.githubusercontent.com/johnnycubides/digital-electronic-1-101/main/installTools/spec-file.txt > ./spec-file.txt && conda create -n digital --file ./spec-file.txt
```

Para iniciar el entorno de conda con las herramientas instaladas deberá siempre
ejecutar en la terminal `conda activate digital`, sin embargo, si desea que
cada vez que se lance una terminal, conda quede activo, guarde en el archivo
`~/.bashrc` la instrucción anteriormente indicada. Una manera de hacerlo es la
siguiente:

```
echo "conda activate digital" >> ~/.bashrc
```

## 3. Agregar reglas para el uso del hardware y dar permisos

El puerto serial (USB-serial) requiere permisos para poder comunicarse con la
tarjeta de desarrollo a través del protocolo _UART_. Para dar permisos, ejecute
el siguiente comando:

```bash
curl https://raw.githubusercontent.com/johnnycubides/digital-electronic-1-101/main/installTools/hw-permissions.sh | sh
```

Reinicie el equipo, inicie una terminal y al ejecutar el comando `groups` en
ella deberá ver el grupo *dialout* en pantalla.

## 4. Instalación de herramientas importantes en el diseño

### 4.1 Digital: Simulador de circuitos

Digital es una herramienta didáctica escrita en java e inspirada por [logisim](http://www.cburch.com/logisim/).
Esta herramienta permite comprender cómo se construyen y se comportan los diferentes circuitos electrónicos digitales,
realiza diferentes análisis, test de comportamiento, como también exporta los módulos digitales a lenguajes de descripción HDL.

* [Repositorio del proyecto digital en github](https://github.com/hneemann/Digital)

#### Instalación de Digital

Ejecute el siguiente comando en la terminal:

```
curl https://raw.githubusercontent.com/johnnycubides/swissknife/refs/heads/master/bash/installs/digital-sh/digital-install.sh | bash -s install
```

**Observación**: En algunas distribuciones va a requerirse la instalación de libfuse, la cual se puede instalar puedes ejecutar `sudo apt install libfuse2`

### 4.2 Lite XL: Editor de texto liviano

Se trata de un editor liviano y potente con capacidad de resalte de sintaxis, servidor LSP, terminal embebida, entre otras.
Para realizar la instalación ejecute el siguiente comando en la terminal:

```
curl https://raw.githubusercontent.com/johnnycubides/swissknife/master/bash/installs/lite-xl/install-all.bash | bash
```

### 4.3 Qucs_S | Simulador de circuitos analógicos y digitales

Simulador de circuitos que hace uso de ngspice, puede realizar simulaciones
digitales como analógicas. Para instalar, ejecute el siguiente comando:

```
curl https://raw.githubusercontent.com/johnnycubides/swissknife/master/bash/installs/qucs_s/install-all.bash | bash -s all
```

## Referencias

* [Conda  config spec-file](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#activating-an-environment)
* [Nextpnr](https://github.com/YosysHQ/nextpnr)
* [Yosys](https://github.com/YosysHQ/yosys)
