

1. Enviar string por uart
```bash
```m
% Script: calcular_memoria_verilog.m
% Calcula la configuración de memoria Verilog para un FPGA con RAM en kbits.
% Ancho de palabra fijo en 32 bits (4 bytes por palabra).

function calcular_memoria_verilog()
    % Solicitar entrada al usuario
    ram_kbits = input('Introduce la RAM embebida del FPGA (en kbits): ');
    
    % Convertir kbits a bytes (1 byte = 8 bits)
    ram_bytes = (ram_kbits * 1024) / 8;  % 80 kbits → 10240 bytes
    
    % Calcular número máximo de palabras de 32 bits (4 bytes cada una)
    num_palabras_max = floor(ram_bytes / 4);
    
    % Valor recomendado (80% del máximo para dejar margen)
    num_palabras_recomendado = floor(num_palabras_max * 0.8);
    
    % Mostrar resultados
    disp('----------------------------------------');
    disp(['RAM total: ' num2str(ram_kbits) ' kbits (' num2str(ram_bytes) ' bytes)']);
    disp(['Ancho de palabra: 32 bits (4 bytes por palabra)']);
    disp('----------------------------------------');
    disp('Configuración Verilog:');
    disp(['  Máximo teórico:    reg [31:0] MEM [0:' num2str(num_palabras_max - 1) '];']);
    disp(['  Recomendado (80%): reg [31:0] MEM [0:' num2str(num_palabras_recomendado - 1) '];']);
    disp('----------------------------------------');
    disp(['Valor para FPGA_RAM_KB en Makefile y .equ IO_HW_CONFIG_RAM:']);
    disp(['  Máximo:    ' num2str(num_palabras_max * 4) ' KB  // ' num2str(num_palabras_max) ' palabras']);
    disp(['  Recomendado: ' num2str(num_palabras_recomendado * 4) ' KB  // ' num2str(num_palabras_recomendado) ' palabras']);
    disp('----------------------------------------');
end
calcular_memoria_verilog();
```
```

```bash
objdump -tC ./firmware.elf | grep 'unused'
```
