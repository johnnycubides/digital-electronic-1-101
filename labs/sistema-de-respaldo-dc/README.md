# Laboratorio 3

El flujo de diseño top down incluirá las siguientes etapas:


* **Dominio comportamental (especificación y algoritmo)**: Se plantea inicialmente
el comportamiento del sistema, definiendo cómo debe operar según las
especificaciones. Esto incluye describir de manera abstracta las entradas,
salidas y relaciones lógicas mediante diagramas de flujo, tablas de verdad o

* **Dominio estructural (red de compuertas lógicas)**: Permite abstraer el
problema hacia una descripción más universal, independiente de implementaciones
físicas específicas, facilitando el análisis y la optimización del diseño.

* **Simulación**

* **Síntesis en FPGA (dominio físico final)**: Finalmente, la solución se
implementa en un hardware reconfigurable, regresando al dominio físico con
tecnologías avanzadas que permiten probar y utilizar el diseño en entornos
reales.

## Diseño de un sistema de respaldo DC

Se requiere diseñar un sistema de respaldo energético que funcione como un
circuito de alimentación ininterrumpida para cargas de bajo voltaje DC. El
sistema debe cumplir con las siguientes características:

1. Entrada de energía AC:
  * La entrada primaria será una señal de 120 V RMS de corriente alterna (AC).
  El sistema debe ser capaz de convertir esta entrada a una señal de corriente
  directa (DC) regulada a 5 V para alimentar la carga (Ver conversión DC).

2. Conversión DC:
  * Se necesita implementar un circuito que transforme la señal de 120 V AC en
  5 V DC, con capacidad para alimentar la carga con una batería de respaldo simultáneamente.

3. Batería de respaldo:
  * El sistema debe incluir una batería de 9 V DC como fuente secundaria de
  energía para mantener la continuidad del suministro de 5 V DC en caso de
  interrupción de la red eléctrica.

4. Monitoreo de la batería:
  * El sistema debe contar con un circuito que permita monitorear el nivel de
  carga de la batería y protegerla frente a descargas profundas. Esto implica
  desconectar automáticamente la carga si el voltaje de la batería desciende
  por debajo de un umbral crítico, evitando daños permanentes.

5. Detección de red eléctrica:
  * Se requiere un mecanismo que detecte la presencia o ausencia de energía en
  la red eléctrica. Este circuito debe permitir conmutar automáticamente entre
  la fuente primaria (AC) y la batería en caso de interrupción del suministro
  eléctrico.


## Desarrollo

Teniendo presente el flujo de diseño y las etapas, deberás realizar los siguientes pasos:

1. **Dominio comportamental (especificación y algoritmo)**:

* Proponer un sistema representado en un diagrama de caja negra.
* Plantear la tabla de verdad que describe el comportamiento.
* Representar el algoritmo de la solución a través de un diagrama de flujo.

Observaciones: Recuerde que **usted es libre de diseñar su sistema** teniendo presente su propia lógica, puede hacer indicaciones de aquellas cosas que puedan generar error o estados no deseados.

