# Laboratorio de implementación de perifericos

Este laboratorio consiste en la creación de una tarea de hardware para alguno de los dispositivos
que se lista a continuación a modo de periférico. El plan consiste en seguir el flujo de desarrollo
presentando cada uno de los artefactos planteados (diagramas, código, descripciones, etc).

Como equipo de trabajo realice una implementación de un controlador para alguno de los periféricos enlistados:
Como equipo de trabajo seleccione uno de los dispositivos planteados y discuta con el profesor el alcance 
del controlador a realizar.

* Servomotor sg90
* Sensor Ultrasonido
* Puente H con PWM
* Generador de tonos
* Clock de segundos con 7 segmentos x2
* Stepper

Con respecto al flujo de desarrollo debe presentar los siguientes pasos:

1. Definir comportamiento:
Haga uso de un diagrama de flujo y/o tablas de verdad que permitan luego evaluar la funcionalidad de la tarea de hardware a realizar.
2. Definir estructura:
Proponga una estructura (Diagramas de bloques, redes de compuertas, etc) que pueda responder al planteamento comportamental propuesto.
3. Describir diseño en HDL:
Traduzca su diagrama de flujo al lenguaje Verilog, donde mantenga la coherencia y funcionalidad requerida, realice las correcciones pertinentes
para que su diseño sea sintetizable.
4. Representar en RTL: Tome su diseño descrito en Verilog y a través de yosys y netlisvg (comando **make rtl** de los ejemplos) genere
la descripción estructural en RTL, compare el resultado con la estructura propuesta en el paso 2.
5. Simular diseño:
Construya un testbench en lenguaje verilog que permita evaluar la descripción del comportamiento (punto 1.), conecte su testbench al diseño propuesto
en verilog, simule con **iverilog** y  visualice con **gtkwave** (recuerde que la simulación y visualización es lograda a través del código de ejemplo
con el comando **make sim**). Verifique Que se comporte como se especificó en el paso 1., en caso de ser distinto, haga las correcciones necesarias
para los puntos 2, 3, 4 y realice nuevamente la simulación.
6. Sintetizar y configurar en FPGA: Monte su diseño haciendo uso de alguno de los ejemplos compartidos en .zip para la implementación en su FPGA,
recuerde indicar en el archivo de restricciones físicas las conexiones de las señales al exterior de su diseño, realice el proceso de sintesis y 
configuración (**make syn conf**) y verifique nuevamente el comportamiento, en caso de ser diferente, realice los ajustes necesarios en los pasos
3 y 4 y vuelva a realizar la configuración.
7. Presentar los resultados del flujo de diseño en formato PDF y en video de youtube, sobre el vídeo, no ser mayor a 5 minutos, explicar el flujo
a través del documento PDF y mostrar el funcionamiento del prototipo.


# Laboratorio de implementación de periféricos

El propósito es seguir el flujo completo de desarrollo, presentando cada uno de los artefactos requeridos (diagramas, código, descripciones, etc.).
Este laboratorio consiste en la creación de una tarea de hardware para alguno de los dispositivos listados a continuación, a modo de periférico.  

Como equipo de trabajo, realice la implementación de un controlador para uno de los periféricos enlistados.  
Seleccione el dispositivo de interés y discuta con el profesor el alcance del controlador a desarrollar.

* Servomotor SG90: Controle la posición del servomotor a través de pulsadores.
* Sensor de ultrasonido: Muestre por medio de Leds la distancia a la que está un objeto.
* Puente H con PWM: Controle sentido de giro de un motor y velocidad a través de pulsadores.
* Generador de tonos: Envíe a un parlante diferentes tonos audibles seleccionando el tono a través de pulsadores.
* Reloj de segundos con 2 displays de 7 segmentos: Construya un contador de segundos que se reinicie cada 60 segundos.
* Motor paso a paso (Stepper): Controle el giro del un motor paso a paso a través de pulsadores.

Con respecto al flujo de desarrollo, deben presentarse los siguientes pasos:

1. **Definir el comportamiento:**  
   Utilice un diagrama de flujo y/o tablas de verdad que permitan posteriormente evaluar la funcionalidad de la tarea de hardware a implementar.

2. **Definir la estructura:**  
   Proponga una estructura (diagramas de bloques, redes de compuertas, etc.) que responda al planteamiento comportamental definido.

3. **Describir el diseño en HDL:**  
   Traduza su diagrama de flujo al lenguaje **Verilog**, manteniendo la coherencia y la funcionalidad requeridas.  
   Realice las correcciones necesarias para asegurar que su diseño sea **sintetizable**.

4. **Representar en RTL:**  
   Tome su diseño en Verilog y, mediante **Yosys** y **Netlistsvg** (usando el comando `make rtl` de los ejemplos), genere la descripción estructural en RTL.  
   Compare el resultado con la estructura propuesta en el paso 2 (el resultado no es necesariamente igual al creado por usted en el paso 2).

5. **Simular el diseño:**  
   Construya un *testbench* en Verilog que permita evaluar el comportamiento definido en el paso 1.  
   Conecte el *testbench* a su diseño, simule con **Icarus Verilog (iverilog)** y visualice con **GTKWave** (recuerde que la simulación y visualización pueden realizarse usando el comando `make sim` de los ejemplos).  
   Verifique que el comportamiento corresponda con lo especificado en el paso 1; en caso contrario, realice los ajustes necesarios en los pasos 2, 3 y 4, y repita la simulación.

6. **Sintetizar y configurar en FPGA:**  
   Monte su diseño usando alguno de los ejemplos compartidos en formato `.zip` para su implementación en la FPGA.  
   Asegúrese de indicar en el archivo de restricciones físicas las conexiones de las señales externas de su diseño.  
   Ejecute el proceso de síntesis y configuración (`make clean syn conf`) y verifique nuevamente el comportamiento.  
   Si existen discrepancias, realice los ajustes pertinentes en los pasos 3 y 4, y repita la configuración.

7. **Presentar resultados:**  
   Entregue los resultados del flujo de diseño en formato **PDF** y en un **video de YouTube** (de máximo 5 minutos).  
   En el video, explique el flujo de desarrollo descrito en el documento PDF y muestre el funcionamiento del prototipo.

## Referencias

* [Ejemplos de simulaciones con iverilog](../../simulations/iverilog): Diferentes ejemplos a implentar con iverilog con lógica combinacional, secuencial, testbench.
* [Explicación sobre el flujo de simulación con gtkwave](https://www.youtube.com/watch?v=N9OJL0nyhSQ)
* [Material introductorio del lenguaje Verilog, gtkwave, yosys](../../resources/)
