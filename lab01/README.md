# Simulación de circuitos digitales con heramientas opensource

1. Hacer una revisión de la documentación de Digital que e identificar en esta revisión
las capacidades de ésta aplicación, limitaciones, herramientas y ejemplos de uso.

2. Realizar la simulación de un circuito digital y de allí obserbar:
    * Tabla de verdad
    * Expresión algebraica asociada al circuito
    * Mapa de Karnaugh
    * Simulación
    * Casos de prueba

3. Realizar la simulación del circuito digital con iverilog y gtkwave
    * Describir el circuito digital en verilog
    * Crear el testbench de los casos de prueba
    * Realizar la simulación
    * Observar en gtkwave los resultados de manera gráfica


4. Combinar Digital, iverilog y gtwave
    * En digital con el circuito anterior
        * Exportar a verilog
        * Crear un testbench con los casos de prueba
    * En iverilog crear la simulación con los archivos generados archivo.v y tb.v0
    * En gtkwave observar los resultados de la simulación

## Flujo de simulación con iverilog y gtkwave

### Compilar

* `iverilog -o file.out file_tb.v file.v ... others_modules.v` # Compila un archivo de simulación

### Simular

* `vpp file.out`

### Observar las formas de ondas con gtkwave

* `gtkwave nombre_archivo.vcd` permite ver el resultado de una simulación en gtkwave

### Ver el diagrama RTL (optional)

* `yosys -p 'read_verilog file.v; hierarchy -check; write_json file.json'`
* `netlistsvg file.json -o file.svg`

## Referencias

* Documentación de Digital en español [Digital.pdf](https://github.com/hneemann/Digital/releases/download/v0.30/Doc_Espanol.pdf)
