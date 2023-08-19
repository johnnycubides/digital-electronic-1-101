# Instalación de herramientas de desarrollo

El diseño de sistemas digitales contiene diferentes fases como se describe aquí: (diagrama de diseño de flujo digital)

Para tal fin se plantea la instalación de las siguientes herramientas:

* [ngspice](): Se trata de un **motor** de simulación que permite observar a diferentes niveles de simulación el comportamiento de los diseños.
* [qucs_s](): es un entorno de simulación de circuitos que puede integrar diferentes simuladores como es el caso de ngspice.
* [Yosys]():
* []

Las anteriores herramientas funcionan mejor en entornos GNU/Linux y para facilitar el proceso de instalación
se hace uso de [miniconda]()

## 1. Instalación de GNU/Linux

GNU/Linux (de ahora en adelante solo Linux) es un sistema operativo multiarquitectura de código
libre distribuido en diferentes presentaciones según requerimientos del usuario final. La selección
de una distribución Linux va depender de los recursos de hardware como también del funcionamiento principal,
por ejemplo, si se requiere montar un servidor web en Internet va a preferir una distribución Linux
que contenga aplicaciones como apache, nginx, nodejs, php, entre otros, pero lo que menos va importar
es que la distribución contenga un gestor de ventas gráfico, pues todo deberá ser controlado y operado de manera
remota.

La distribución Linux requerida en este caso deberá estar orientada a computadoras de escritorio, y el 
gestor de escritorio a usar (KDE, plasma, gnome, lxde, cinnamon, xfce, entro otros), dependerá
de los recursos de hardware con los que se cuente en el equipo y en segundo lugar de los gustos del usuario
final.

Para un usuario principiante se recomienda el uso de distribuciones como 
[Linux mint](https://www.linuxmint.com/download.php) la cual facilita la 
instalación de Linux y tiene diferentes mecanismos para que el usuario se sienta
cómodo a la hora de aprender del S.O.. Puede conocer otras versiones Linux y sus características visitando
[Distrowatch.com](https://distrowatch.com/)

Con respecto a la instalación de Linux se puede instalar en tres modos distintos:

* Arranque dual: Arranque compartido con diferentes sistemas operativos.
* Linux como único sistema operativo en el computador.
* Maquina virtual: Se hace uso de una máquina virtual (virtualbox, qemu, vware, entre otros) desde un
S.O. Host como Windows o MacOs y se comparte desde allí el acceso a los recursos de hardware del equipo.
* Linux como un subsistema: En el caso de windows a través de un capa de compatibilidad se puede hacer
uso del kernel de Linux.

De las anteriores opciones la más recomendada para interactuar con el hardware es el Arranque dual.

### Instalación de Linux mint

Aunque se puede instalar cualquier otra distribución, en esta guía se ha recomendado la instalación
de Linux mint para principiantes.

1. Visite el enlace de descarga de [Linus mint download](https://www.linuxmint.com/download.php) y seleccione
el escritorio (cinnamon, xfce, mate) según sus recursos de hardware y gusto.

** Requerimientos mínimos**

* Cinnamon: dual-core CPU and 4GB of RAM
* Mate: dual-core CPU and 4GB of RAM (fluído)
* xfc: dual-core and 2GB of RAM (fluído)


