# Laboratorio de implementación de máquinas de estado algorítmicas (ASM)

El propósito es seguir el flujo completo de desarrollo de un controlador basado
en una **Máquina de Estado Algorítmica (ASM)**, presentando cada uno de los
artefactos requeridos (diagramas, código, descripciones, etc.).

Este laboratorio corresponde al desarrollo del controlador principal del
proyecto final. Cada equipo deberá proponer el comportamiento que implementará
mediante una ASM y el periférico o hardware que controlará. La propuesta deberá
ser validada por el profesor antes de iniciar el desarrollo.

Como equipo de trabajo, presente una propuesta que incluya:

* Descripción del comportamiento del controlador.
* Periférico o hardware que será controlado.
* Entradas y salidas principales del sistema.

Una vez aprobada la propuesta (discord), desarrolle el siguiente flujo de diseño:

1. **Definir las especificaciones:**  
   Describa el comportamiento esperado del controlador, las entradas, salidas y restricciones del sistema. Explique el propósito de la ASM dentro del proyecto.

2. **Definir el comportamiento:**  
   Utilice un diagrama de flujo correspondiente a la **Máquina de Estado Algorítmica (ASM)** para describir el comportamiento del controlador. A partir de este diagrama identifique los estados, decisiones y acciones del sistema.

3. **Definir la estructura:**  
   Proponga una estructura (diagramas de bloques, módulos, registros, redes de compuertas, etc.) que responda al comportamiento definido en la ASM.

4. **Describir el diseño en HDL:**  
   Implemente la ASM en **Verilog**, manteniendo la coherencia con las especificaciones y el diagrama desarrollado anteriormente. Realice las correcciones necesarias para asegurar que el diseño sea **sintetizable**.

5. **Representar en RTL:**  
   Tome su diseño en Verilog y, mediante **Yosys** y **Netlistsvg** (usando el comando `make rtl` de los ejemplos), genere la descripción estructural en RTL. Compare el resultado con la estructura propuesta en el paso 3.

6. **Simular el diseño:**  
   Construya un *testbench* en Verilog que permita evaluar el comportamiento definido en la ASM. Conecte el *testbench* a su diseño, simule con **Icarus Verilog (iverilog)** y visualice con **GTKWave** (recuerde que la simulación y visualización pueden realizarse usando el comando `make sim` de los ejemplos). Verifique que el comportamiento corresponda con las especificaciones; en caso contrario, realice los ajustes necesarios en los pasos anteriores y repita la simulación.

7. **Sintetizar y configurar en FPGA:**  
   Integre el controlador al proyecto final y configure la FPGA usando alguno de los ejemplos compartidos en formato `.zip`. Asegúrese de indicar en el archivo de restricciones físicas las conexiones de las señales externas de su diseño. Ejecute el proceso de síntesis y configuración (`make clean syn conf`) y verifique nuevamente el comportamiento. Si existen discrepancias, realice los ajustes pertinentes y repita el proceso.

8. **Presentar resultados:**  
   Entregue los resultados del flujo de diseño en formato **PDF** y en un **video de YouTube** (de máximo 5 minutos). En el video explique las especificaciones, la ASM desarrollada, el flujo de implementación y el funcionamiento del controlador integrado en el proyecto.

## Referencias

* [Ejemplos de simulaciones con iverilog](../../simulations/iverilog): Diferentes ejemplos a implementar con iverilog con lógica combinacional, secuencial, testbench.
* [Explicación sobre el flujo de simulación con gtkwave](https://www.youtube.com/watch?v=N9OJL0nyhSQ)
* [Material introductorio del lenguaje Verilog, gtkwave, yosys](../../resources/)
