---
lang: es
---

<!-- vim-markdown-toc Marked -->

* [GNU/Linux en electrónica digital](#gnu/linux-en-electrónica-digital)
    * [1. Instalación de GNU/Linux](#1.-instalación-de-gnu/linux)
        * [Instalación de Linux mint](#instalación-de-linux-mint)
            * [Ejemplos de instalación de Linux mint](#ejemplos-de-instalación-de-linux-mint)
    * [2. Aprende a usar GNU/Linux](#2.-aprende-a-usar-gnu/linux)
    * [3. Gestores de paquetes](#3.-gestores-de-paquetes)

<!-- vim-markdown-toc -->

# GNU/Linux en electrónica digital

Para realizar el diseño de un sistema digital, en cada fase se requiere
diferentes herramientas que permiten realizar diferentes análisis,
simulaciones, entre otros. A continuación se listan algunas de ellas:

* [Yosys](https://github.com/YosysHQ/yosys): Herramienta de síntesis de
  sistemas digitales.
* [iverilog](https://github.com/steveicarus/iverilog): Herramienta de
  simulación de descripciones de hardware.:
* [ngspice](https://ngspice.sourceforge.io/): Se trata de un **motor** de
  simulación que permite observar a diferentes niveles de simulación el
  comportamiento de los diseños, como puede ser ver tiempo de retardos y su
  propagación, el *fan_in* y el *fan_out*, consumo en potencia, entre otros.
* [qucs_s](https://ra3xdh.github.io/): Es un entorno de simulación de circuitos
  que permite diseñar de manera gráfica, el cual puede integrar diferentes
  simuladores como es el caso de ngspice.

Las anteriores herramientas funcionan mejor en entornos GNU/Linux y para
facilitar el proceso de instalación de estas herramientas se hace uso de
[Miniconda](https://docs.anaconda.com/free/miniconda/index.html)

## 1. Instalación de GNU/Linux

GNU/Linux (de ahora en adelante solo Linux) es un sistema operativo
multiarquitectura de código libre distribuido en diferentes presentaciones
según requerimientos del usuario final. La selección de una distribución Linux
va a depender de los recursos de hardware como también del funcionamiento
principal, por ejemplo, si se requiere montar un servidor web en Internet va a
preferir una distribución Linux que contenga aplicaciones como apache, nginx,
nodejs, php, entre otros, pero lo que menos va a importar es que la
distribución contenga un gestor de ventas gráfico, pues todo deberá ser
controlado y operado de manera remota.

La distribución Linux requerida en este caso deberá estar orientada a
computadoras de escritorio, y el gestor de escritorio a usar (KDE, plasma,
gnome, lxde, cinnamon, xfce, entro otros), dependerá de los recursos de
hardware con los que se cuente en el equipo y en segundo lugar de los gustos
del usuario final.

Para un usuario principiante se recomienda el uso de distribuciones como [Linux
mint](https://www.linuxmint.com/download.php) la cual facilita la instalación
de Linux y tiene diferentes mecanismos para que el usuario se sienta cómodo a
la hora de aprender del sistema operativo. Puede conocer otras versiones Linux
y sus características visitando [Distrowatch.com](https://distrowatch.com/),
también podría llenar un cuestionario en
[Distrochooser](https://distrochooser.de/es) el cual le puede sugerir una
distribución Linux a la medida.

Con respecto a la instalación de Linux se puede instalar en tres modos distintos:

* Arranque dual: Arranque compartido con diferentes sistemas operativos.
* Linux como único sistema operativo en el computador.
* Máquina virtual: Se hace uso de una máquina virtual (virtualbox, qemu, vware,
  entre otros) desde un S.O. Host como Windows o MacOs y se comparte desde allí
  el acceso a los recursos de hardware del equipo.
* Linux como un subsistema: En el caso de Windows a través de una capa de
  compatibilidad se puede hacer uso del kernel de Linux.

De las anteriores opciones la más recomendada para interactuar con el hardware es el Arranque dual.

### Instalación de Linux mint

Aunque se puede instalar cualquier otra distribución, en esta guía se ha recomendado la instalación
de Linux mint para principiantes.

1. Visite el enlace de descarga de [Linux Mint download](https://www.linuxmint.com/download.php) y seleccione
el escritorio (cinnamon, xfce, mate) según sus recursos de hardware y gusto.

**Requerimientos mínimos**

* Cinnamon: dual-core CPU and 4GB of RAM
* Mate: dual-core CPU and 4GB of RAM (fluído)
* xfc: dual-core and 2GB of RAM (fluído)

#### Ejemplos de instalación de Linux mint

Los estudiantes del curso de electrónica digital han compartidos sus experiencias y recomendaciones de instalación
de GNU/Linux y demás herramientas para electrónica digital:

* [Instalación de Linux Mint como único sistema en el PC](https://github.com/mricol/ED1G5E3/tree/main/Informe1)
* [Instalación de Linux Mint en dual boot](https://github.com/2023-2S-digital/laboratorio-I)
* [Instalación de Linux Mint en dual boot](https://github.com/Juanpalo123/Digital_Informe_1)
* [Instalación de Linux Mint en máquina virtual, equipo DavidN110](https://github.com/DavidN110/Laboratorio-Electronica-Digital-I-Grupo2/blob/main/Informe1/Informe%201%20'Instalaci%C3%B3n%20linux%20y%20herramientas%20de%20digital'.md)
* [Instalación de Linux Mint en virtualbox](https://github.com/JulianQunal/Digital-I/blob/main/Pr%C3%A1cticas/Pr%C3%A1ctica%201/Instalaci%C3%B3n%20de%20Herramientas.md)
* [Instlación de Linux Mint en máquina virtual](https://github.com/LuisVaca1503/Lab_DIgital_1/blob/main/Practica_1/Informe_1.md)
* [Instalación de herramientas en miniconda](https://github.com/Daniel-Porras/Digital-1-2023-2/tree/main/Pr%C3%A1ctica%20No%201)
* [Instación de herramientas conda](https://github.com/xXNarstickXx/E-Digital-I-2023-2-G3M-G6L-EQ1/tree/aedac264f40923c5ae5b405f492fac74afd4714f/Laboratorio%201)

## 2. Aprende a usar GNU/Linux

La interfaz principal entre el Kernel de Linux y el usuario es la terminal/shell; en Linux
hay diferentes "estilos de shell", pero la mayoría comparten comandos y de manera general
se pueden citar los siguientes:

|Comando  |Acción |Ejemplo  |
|:-------------:|:-------------|:-----|
|`pwd`  | Posición absoluta actual en el árbol de directorios | `pwd` |
|`cat`  | Imprimir en pantalla el contenido de un archivo | `cat README.md` |
|`mkdir`  | Crear un directorio en el lugar especificado  | `mkdir directorio`  |
|`mkdir -p` | Crear un directorio vacío con su respectivo padre | `mkdir -p ./directorioPadre/directorioHijo` |
|`ls` | Listar el contenido de un directorio | `ls -ltrh` |
|`ln -s`| Crea enlaces simbólicos (en Windows accesos directos) para ficheros | `ln -s /path/archivoFuente /path/archivoDestino` |
|`cd` | Entrar a un directorio  | `cd directorio` |
|`cd ..`  | Subir un nivel en el árbol de directorio| `cd ../` |
|`rm` | Remover un archivo  | `rm archivo.txt` |
|`rm -r`| Remover ficheros de manera recursiva | `rm -r directorio/` |
|`cp`| Hacer copias de ficheros | `cp path/directorio path/copia` |
|`mv`| Mover fichero a nuevoPath/ | `mv archivo pathDestino/` |
|`mv`| Cambiar el nombre de un fichero | `mv archivo nuevoNombreArchivo` |
|`grep`| Buscar una coincidencia dentro de los ficheros | `grep -lr "palabraCoincidencia" path/` |
|`find`| Encontrar un archivo en alguna ruta | `find ./ -iname "parteDelNombreDelArchivoAEncontrar*"`|

Para tener mayor claridad sobre el mundo de los comandos en Linux tenga de referencia el siguiente libro que le permitirá conocer las combinaciones de los comandos y argumentos según su necesidad.

[The Linux Comman Line en PDF](https://github.com/johnnycubides/curso-scorm-sistemas-digitales/raw/main/ref-docs/books/linux/TLCL-19.01.pdf)

[Sitio oficial del libro](https://linuxcommand.org/index.php)

También puede tener una lista de comandos útiles en linux en el siguiente sitio: [linuxcommandlibrary](https://linuxcommandlibrary.com/)

## 3. Gestores de paquetes

En "Linux" existen maneras distintas para instalar un programa, entre ellas:

* **Compilar desde archivos fuentes**: se requiere tener los archivos fuentes, reglas de compilación pueden estar basadas en [Make](https://es.wikipedia.org/wiki/Make), compiladores y librerías como parte de las dependencias de compilación.
* **Aplicaciones empaquetadas**: En este caso se obtiene un archivo que se desempaquetará y se instalará en el sistema linux sin requerir el compilador, en el caso de las Distribuciones basadas en "Debian" los paquetes son de extensión **.deb**.
* **Gestores de paquetes**: Las distribuciones Linux tienen servidores en la nube con las aplicaciones empaquetadas para distintas arquitecturas, a través de un cliente instalado en la computadora instalará el paquete con sus dependencias.

Para el caso de Debian y la mayoría de sus derivados se hace uso de algunos gestores de paquetes que facilitan el proceso de instalación de los programas; tal es el caso de **apt**, **apt-get** o **aptitude**.

A continuación se explica el proceso de uso **apt**:

|Comando| Observación |
|:-------------|:-------------|
| `apt update` | Actualiza los apuntadores de los sources list para que pueda encontrar los servidores donde están los paquetes de los programas |
| `apt install paquete` | Permite instalar una aplicación con la opción de aceptar algunas condiciones como por ejemplo instalación de dependencias |
| `apt install -f` | Tratará de reparar el funcionamiento de una aplicación a través de por ejemplo la instalación de dependencias rotas, sino lo logra, es posible que desinstale la aplicación y se requiera un procedimiento manual |
| `apt remove paquete` | Desinstala un paquete |
