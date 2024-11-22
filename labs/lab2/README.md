# Mi primer diseño

<!--En esta actividad abordará el diseño de una solución de una situación problema,-->
<!--que puede ser abordada desde los conocimientos de circuitos que operan con lógica-->
<!--on/off por contacto y de lógica combinacional.-->
<!--El flujo de diseño planteado permitirá plantear una solución desde el dominio físico (circuito eléctrico),-->
<!--simular esta solución a través de una representación en lenguaje ladder, luego, pasar a un dominio estructural (red de compuertas lógicas), simular la red de compuertas,-->
<!--describir esta red de compuertas en un lenguaje HDL y verificar su funcionamiento nuevamente, para finalmente implementar esta solución en un dominio físico-->
<!--sintetizando la red decompuertas en una FPGA.-->
<!---->
<!--Observará además que una solución se puede abordar en diferentes dominios físicos o tecnologías.-->

En esta actividad, se abordará el diseño de una solución para una situación
problemática, comenzando con la propuesta de una representación del
comportamiento basada en las especificaciones del sistema y el algoritmo que lo
define. A partir de esta representación, se utilizarán conocimientos sobre
circuitos que operan con lógica de contacto on/off y lógica combinacional para
desarrollar el diseño.

El flujo de diseño propuesto incluirá las siguientes etapas:

* Dominio comportamental (especificación y algoritmo): Se plantea inicialmente
el comportamiento del sistema, definiendo cómo debe operar según las
especificaciones. Esto incluye describir de manera abstracta las entradas,
salidas y relaciones lógicas mediante diagramas de flujo, tablas de verdad o
descripciones algorítmicas.
* **Dominio físico inicial (circuito eléctrico)**: Representa el sistema en
términos de componentes eléctricos básicos, como interruptores o relés, que
reflejan el concepto de lógica on/off. Este enfoque ayuda a conceptualizar la
solución desde un punto de vista tangible.
* **Simulación en lenguaje ladder**: Facilita la representación y simulación
del sistema en un entorno de control industrial, siendo una herramienta
ampliamente utilizada en automatización para validar el funcionamiento lógico
antes de pasar a etapas más abstractas.
* **Dominio estructural (red de compuertas lógicas)**: Permite abstraer el
problema hacia una descripción más universal, independiente de implementaciones
físicas específicas, facilitando el análisis y la optimización del diseño.
* **Descripción en lenguaje HDL (Hardware Description Language)**: En esta
etapa, se traduce la solución a un formato estándar para sistemas digitales
modernos, permitiendo realizar simulaciones avanzadas, verificaciones de
funcionamiento y preparativos para la síntesis en hardware.
* **Síntesis en FPGA (dominio físico final)**: Finalmente, la solución se
implementa en un hardware reconfigurable, regresando al dominio físico con
tecnologías avanzadas que permiten probar y utilizar el diseño en entornos
reales.

Durante cada etapa, se enfatizará la validación del diseño para garantizar que
las transiciones entre dominios mantengan la coherencia y funcionalidad de la
solución.

Además, se observará que una misma solución puede abordarse desde diferentes
dominios físicos o tecnologías, lo que refuerza la importancia de comprender
cómo los distintos enfoques impactan en la implementación final y en la
elección de herramientas o métodos adecuados.


## Referencias

* [plcsimulator: simulador de plc lenguaje ladder](https://app.plcsimulator.online/)
