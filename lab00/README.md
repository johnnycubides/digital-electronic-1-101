# Instalación de herramientas

## Digital

![imagen de digital](https://github.com/hneemann/Digital/raw/master/distribution/screenshot2.png)

Digital es una herramienta didáctica escrita en java e inspirada por [logisim](http://www.cburch.com/logisim/).
Esta herramienta permite comprender cómo se construyen y se
comportan los diferentes circuitos electrónicos digitales, realiza diferentes análisis, test de comportamiento,
como también exporta los módulos digitales a lenguajes de descripción HDL.

* [Repositorio del proyecto digital en github](https://github.com/hneemann/Digital)

**Instalación**

1. Instalación de la [JVM](https://adoptium.net/): Digital por estar escrito en java requerir la máquina
virtual de java, en el mismo repositorio de Digital, indica cómo se puede obtener.

2. Descargar [Digital.zip](https://github.com/hneemann/Digital/releases/latest/download/Digital.zip): este archivo contiene la aplicación y los scripts necesarios.
3. Ejecutar la aplicación: Se descomprime el archivo .zip y en la carpeta generada basta con lanzar el ejecutable con extensión .exe para Windows o `java -jar Digital.jar` en una terminal para Linux.

**Instalación de Complementos**

Digital permite importar descripciones VHDL o Verilog a su área de trabajo para realizar simulaciones, para habilitar esta opción
se requiere la instalación de un simulador según el lenguaje que se quiera importar.

* Para Verilog -> Icarus Verilog, [docs](https://steveicarus.github.io/iverilog/usage/installation.html), [Windows bin](https://bleyer.org/icarus/)
* Para VHDL -> GHDL, [Docs](http://ghdl.free.fr/site/pmwiki.php?n=Main.HomePage), [Binarios](https://github.com/ghdl/ghdl/releases)

