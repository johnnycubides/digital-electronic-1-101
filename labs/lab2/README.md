<!-- LTeX: language=es -->
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

* **Dominio comportamental (especificación y algoritmo)**: Se plantea inicialmente
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

## Situación a enfrentar

<!--Usted tiene un familiar que vive en el campo, tiene una finca y posibilidades de adaptar fuentes de energía para el consumo-->
<!--energético de su casa. En el lugar cuenta con la red eléctrica del comercializador de la zona rural y una excelente radiación-->
<!--solar. él sabe que usted está estudiando una ingeniería relacionada a la electricidad y le indica que está aburrido de los-->
<!--cortes de energía eléctrica en su zona. Usted por ocurrencia le sugiere tener un banco de baterías y un sistema fotovoltaíco para-->
<!--poder suplir de energía a su hogar cuando tenga fallos en la red eléctrica. A su familiar le suena la idea y como dicen coloquialmente-->
<!--¡lo embala!, llama a los demás familiares y empieza a expresar que usted se ha comprometido a desarrollar y diseñar-->
<!--ese sistema. usted por lo tanto siente que debe hacer lo mejor para que en Navidad sus familiares le feliciten porque está aplicando-->
<!--los conocimientos que ha estado desarrollando en su carrera.-->
<!---->
<!--Después de realizar las mediciones pertinentes de la carga eléctrica del hogar usted adquiere un sistema foltovoltáico, banco de baterías e iversores-->
<!--para acodicionar la red eléctrica de la casa y tiene los siguientes materiales:-->
<!---->
<!--* Un relé para conmutar la red del inversor y la red eléctrica del comercializador de la zona.-->
<!--* Un relé para energizar o desenergizar la red interna de la casa, en el caso de requerir realizar algún mantenimiento-->
<!--* Un sensor de medición de carga de la bateria, el cual sensa cuando la batería está cargada y cuando está descargada, tiene contactos tanto normalmente abiertos como normalmente cerrados.-->
<!--* Un sensor de luz que puede ser usado para detectar cuando hay radiación solar, tiene contactos tanto abiertos como cerrados-->
<!--* Un sensor detector de energía de red, el cual indica cuando hay electricidad en la red y cuando no la hay, tiene contactos abiertos y cerrados-->
<!--* Un tablero de mando en el cual usted puede poner diferentes indicadores, como pueden ser, paro de emergencia, batería descargada, detector de red electrica, casa energizada, etc.-->
<!--* Un botón de paro de emergencia o  demantenimiento, el cual, como fue mencionado, puede desenergizar su casa y para realizar otros mantenimientos.-->
<!---->
<!--El sistema que usted diseña minimo debe ser capaz de:-->
<!---->
<!--* Conmutar las fuentes de energía, ya sea de las baterías (el inversor) o de la red eléctrica.-->
<!--* Indicar cuando están las baterías descargadas-->
<!--* Indicar si se encuentra energizada la casa-->
<!--* Indicar si se detecta la red eléctrica de la casa-->
<!--* Indicar si hay suficiente radiación solar-->
<!--* Desde el tablero de mando poder detener el sistema desenergizado la casa.-->
<!---->
<!--Podrá realizar las combinaciones que usted crea convenientes, recuerde que ante su familia, usted es el que sabe, buena suerte!-->

Tienes un familiar que vive en el campo, en una finca, y tiene la posibilidad
de adaptar fuentes de energía para suplir el consumo eléctrico de su hogar. En
la zona donde vive, cuenta con la red eléctrica del comercializador local, pero
también dispone de una excelente radiación solar. Este familiar, sabiendo que
estás estudiando una ingeniería relacionada con la electricidad, te comenta que
está cansado de los constantes cortes de energía.

Con base en esto, se te ocurre sugerirle que implemente un banco de baterías y
un sistema fotovoltaico para garantizar el suministro de energía cuando haya
fallos en la red eléctrica. A tu familiar le entusiasma la idea (¡lo embala,
como se dice coloquialmente!) y no tarda en contárselo al resto de la familia,
expresando que te has comprometido a diseñar y desarrollar dicho sistema. Ante
esta situación, decides tomar el reto en serio, pensando que sería genial
recibir felicitaciones de todos en Navidad por aplicar los conocimientos
adquiridos en tu carrera.

Después de realizar las mediciones pertinentes del consumo eléctrico de la
casa, adquieres un sistema fotovoltaico, un banco de baterías e inversores para
acondicionar la red eléctrica del hogar. Además, cuentas con los siguientes
materiales:

1. Un relé para conmutar entre la red del inversor y la red eléctrica del
   comercializador.
2. Un relé para energizar o desenergizar la red interna de la casa en caso de
   requerir mantenimiento.
3. Un sensor de carga de batería, que detecta cuando la batería está cargada o
   descargada; incluye contactos normalmente abiertos y cerrados.
4. Un sensor de luz, que detecta la radiación solar; incluye contactos
   normalmente abiertos y cerrados.
5. Un sensor detector de red eléctrica, que indica si hay o no suministro en la
   red eléctrica; incluye contactos abiertos y cerrados.
6. Un tablero de mando, donde puedes instalar diversos indicadores, como: paro
   de emergencia, batería descargada, detector de red eléctrica, casa
energizada, entre otros.
7. Un botón de paro de emergencia o mantenimiento, que permite desenergizar la
   casa para realizar intervenciones de forma segura.

El sistema que diseñes debe ser, como mínimo, capaz de:

1. Conmutar entre las fuentes de energía: el banco de baterías (inversor) y la
   red eléctrica.
2. Indicar cuando las baterías están descargadas.
3. Indicar si la casa está energizada.
4. Indicar si la red eléctrica está disponible.
5. Indicar si hay suficiente radiación solar.
6. Permitir detener el sistema y desenergizar la casa desde el tablero de
   mando.

Puedes combinar los elementos disponibles de la manera que consideres más
adecuada para cumplir con los requisitos. Recuerda que, ante tu familia, tú
eres quien sabe. ¡Buena suerte!

## Referencias

* [plcsimulator: simulador de plc lenguaje ladder](https://app.plcsimulator.online/)
