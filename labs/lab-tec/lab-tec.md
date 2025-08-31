# Comparación de tecnologías CMOS vs TTL, acondicionamiento y gestión de señales digitales

## Introducción

La electrónica digital se encarga del procesamiento de señales eléctricas
mediante circuitos que operan con valores discretos. Sin embargo, estos valores
están representados en diferentes niveles de tensión/corriente, frecuencia, de tal
manera que su aplicación depende en gran medida de la tecnología de fabricación.

Para el desarrollo de esta actividad se estudiará la implementación de una operación
lógica en las tecnologías TTL y CMOS donde se observará las diferencias entre 
su circuito equivalente, tiempo de respuesta, entre otros. Además, se
estudiará el diseño de interfaces de entrada y salida (I/O) y en técnicas
de acondicionamiento de señales digitales, lo que permitirá comprender mejor el
comportamiento real de los dispositivos y su integración en sistemas más
complejos.



## Objetivos

* Identificar las características de un dispositivo fabricado en diferentes tecnologías.
* Conocer diferentes técnicas de acondicionamientos de señales digitales.

## 1. Comparación entre tecnologías CMOS vs TTL

### Recursos requeridos

* Negador TTL 74LS04
* Negador CMOS CD4069
* Simulador
* Modelos spice
* Hojas de datos

### Procedimiento

### Parte 1

1. Comparar las especificaciones técnicas de cada uno de los dispositivo mencionados.
2. Determinar el circuito equivalente para cada uno de los dispositivos.
3. Aplicar una señal cuadrada de 1 KHz de tensión adecuada para medir: $V_{out}$ vs $V_{in}$ y a partir de la función de transferencia determinar
   $V_{IH}$, $V_{IL}$, $V_{OH}$, $V_{OL}$.
4. Medir el tiempo de subida ($t_r$), tiempo de bajada ($t_f$), tiempo de retardo ($t_{phl}$ y $t_{plh}$) para cada dispositivo.

### Parte 2

1. Determinar el fan-in y fan-out de cada uno de los dispositivos.
2. Determinar la disipación de potencia.
3. Proponer e implementar un circuito de entrada y de salida para cada uno de los dispositivos teniendo en cuenta los parámetros de cada tecnología para observar el comportamiento del mismo.
4. Observar el comportamiento de la compuerta con "pin al aire" en alguna de sus entradas

### A tener en cuenta

* Simular cada compuerta con su modelo spice variando la frecuencia de la señal de entrada.
* Comparar los resultados de los tiempo medidos en el laboratorio con los obtenidos en la simulación.
* Obtener la característica de $V_{in}$ vs $V_{out}$.
* Comparar las mediciones.

## 2. Diseño de Interfaces de Entrada/Salida (I/O) y Acondicionamiento de Señal Digital

El profesor de laboratorio a cada grupo le asignará uno de los siguientes temas
y dará las instrucciones específicas sobre el cómo deberá ser realizado.

* **Circuito Antirrebote (Debounce)**:
  1. Implemente un circuito que haga uso del CI 74LS04, como entrada un circuito
  basado en un pulsador, como salida una resistencia. Mida el efecto transistorio
  de la entrada vs la salida del CI.
  2. Investigue sobre las técnicas antirebote basadas en circuitos RC,
     modifique el circuito mencionado en 1 de tal manera que se busque el
  efecto de antirebote y nuevamente realice una medición del efecto transitorio
  de la salida en función de la entrada.
  4. Estudie la hoja de datos del CI 74HC14, identidique las principales características
  en función del tema antirebote.
  4. Del circuito pruesto en 1, cambie el CI 74LS04 por el CI 74HC14, mida el efecto
  transitorio de la entrada vs la salida.
  5. Realice un diagrama con la información obtenida que permita generar conclusiones.

* **Circuito pull-up y pull-down**:
  1. Estudie este tipo de cicuitos y su utilidad.
  2. Diseñe e implemente dos circuitos (uno con pull-up y otro con pull-down) basado en *resistencias y pulsadores* con la siguiente
  arquitectura: Circuito de pull-up/down compuerta lógica, led como salida.
  3. Diseñe e implemente dos circuitos (uno con pull-up y otro con pull-down) basado en *resistencias y transistores* con la siguiente
  arquitectura: Circuito de pull-up/down compuerta lógica, led como salida.
  4. Realice un diagrama donde indique el flujo de diseño de estos circuitos junto
  a las especificaciones de selección de valores y componentes, junto a recomendaciones.

* Sensores táctiles digitales (Touch):
  1. Estudio las diferentes técnicas de los sensores táctiles y sus aplicaciones.
  2. Diseñe un circuito táctil que tiene la siguiente arquitectura:
  Una entrada táctil, una compuerta lógica y una salida de leds.
  3. Explique las ventajas y desventajas de estos sensores junto a sus aplicaciones.

* **Buffer y tristate**:
  1. Estudie sobre los circuitos tristate
  2. Implemente un circuito tristate con el CI CD40109B y obtenga la tabla de verdad según las 
  características de este CI.
  3. Implemente un cambiador de nivel con el CI CD40109B que permita cambiar el nivel de 5 V a 3.3V
  4. Realice un diagrama que explique el funcionamiento del circuito implementado junto a sus criterios
  de implementación.

* **Aislamiento galvánico**:
  1. Estudie las diferentes técnicas de este tipo de aislamiento aplicadas en
  sistemas digitales y realice un mapa comparativo.
  2. Diseñe un circuito digital con aislamiento galvánico que tenga la siguiente
  arquitectura: pulsador como entrada del sistema, compuerta lógica, aislador,
  compuerta y led de salida.
  3. Implemente el circuito y realice un diagrama con los resultados obtenidos
  en esta práctica que permitan llegar a conclusiones.

* **Drivers para actuadores**:
  1. Estudie diferentes métodos para controlar actuadores a través de drivers
  2. Plantee un circuito de control para un actuador que tiene las siguientes etapas:
  un/unos pulsador/es (como entrada de señal) una compuerta lógica, un driver de acople, un actuador.
  El actuador puede ser un motor, una resistencia de calor, etc.
  3. Implemente el circuito diseñado, se recomienda acompañar el  circuito de
     LEDs (monitores) que permitan observar el estado ya sea del actuador o si
  prefiere de alguna o de todas las etapas.
  4. Indique cuales fueron las consideraciones relevantes en el diseño e implementación.

* **Generación y control de tiempos (temporización)**:
  1. Estudie el oscilador astable basado en trasistores e implemente un
  oscilador que genere una salida entre 0 a 3.3 voltios o entre 0 a 5 voltios a
  una frecuencia de 1 KHz, puede usar una tecnología mosfet o bjt.
  2. Estudie el LM555 en sus tres modos de operación (monoestable, bistable,
     astable.) y realice la implementación de un oscilador astable con las
  mismas características con las que implementó el oscilador basado en
  transistores (frecuencia y voltaje de salida).
  3. Compare los resultados obtenidos y realice una comparativa de ambas
  implementaciones indicando las diferentes aplicaciones.

### Entregable

Se requiere la entrega de un informe donde responda cada uno de los apartados
teniendo en cuenta simulaciones, especificaciones técnicas de las compuertas
utilizadas en esta práctica, mediciones obtenidas en el laboratorio de manera
sustentada.


## Referencias

* [Qucs, instalación y ejemplos de uso](https://github.com/johnnycubides/qucs-tutorial-examples)
* [Modelos spices del 74LS04 y CD4069](./spice/)
* [Importar modelos en LTSpice](./spice/LTSpice.md)
* [Vídeo sobre niveles de tensión y corriente para algunas tecnologías de electrónica digital](https://www.youtube.com/watch?v=wCQ2D2S836I)
