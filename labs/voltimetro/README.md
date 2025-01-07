<!-- LTeX: language=es -->

# Diseño de multímetro DC

Representación contextual:

![Nivel contextual](./voltimetro.drawio.png) 

## Desarrollo Top-Down

1. Dominio comportamental

* Identifique los requerimientos funcionales y no funcionales del sistema a diseñar.
* Identifique las entradas y salidas de información con su tipo (analógicas y digitales).
* Realice una representación del comportamiento de su sistema a través de un diagrama de flujo o pseudo-código.
* Puede hacer uso de otras herramientas (como tablas de verdad) para realizar las demás especificaciones del sistema.

2. Dominio estructural

* Realice un diagrama de caja negra de los diferentes módulos que requiere su sistema.
* En el caso de que cada módulo contenga otros submódulos, identifique a través de diagramas de caja negra cómo están relacionados.
* Realice el diseño de cada módulo a través de compuertas lógicas, decodificadores, multiplexores, entre otros.
* Describa su diseño en HDL.
* Desarrolle simulaciones en *Digital* de su diseño y verifique el comportamiento.
* Realice simulaciones en *Iverilog* de su diseño y verifique el comportamiento.

3. Dominio físico

* Monte el circuito requerido para realizar la implementación física.
* Proponga un protocolo de ensayo-pruebas para garantizar que usted y la FPGA operarán en un entorno seguro.
* Realice el proceso de síntesis de su diseño y configure la FPGA para realizar las pruebas del montaje del circuito.
* Realice un vídeo en Youtube explicando **este flujo de diseño, resultados y sus conclusiones (haga uso del material documental)**, el vídeo no debe superar los 5 minutos.

## Recomendaciones

* Estudie el funcionamiento de un ADC por aproximaciones sucesivas.
* Estudie desde el datasheet del ADC0808 las características de operación, diagrama de bloques, esquemá de conexión, etc.
