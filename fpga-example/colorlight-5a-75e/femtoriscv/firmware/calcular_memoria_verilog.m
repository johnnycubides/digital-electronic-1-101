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
    disp('========================================');
    disp(['RAM total: ' num2str(ram_kbits) ' kbits (' num2str(ram_bytes) ' bytes o ' num2str(round(ram_bytes / 1024)) ' kB)']);
    disp(['Ancho de palabra: 32 bits (4 bytes por palabra)']);
    disp('----------------------------------------');
    disp('INSTRUCCIONES:');
    disp(['  - Realice una de las configuraciones TEÓRICA o RECOMENDADA para cada uno de los pasos 1, 2 y 3.']);
    disp('========================================');
    disp('1. Configuración Verilog:');
    disp(['  - En el archivo ../cores/memory/Memory.v modifique el valor de reg [31:0] MEM por:']);
    disp('----------------------------------------');
    disp(['  // Configuración teórica:']);
    disp(['  reg [31:0] MEM [0:' num2str(num_palabras_max - 1) '];']);
    disp('----------------------------------------');
    disp(['  // Configuración recomendada (80%):']);
    disp(['  reg [31:0] MEM [0:' num2str(num_palabras_recomendado - 1) '];']);
    disp('========================================');
    disp(['2. Configuración en el linker:']);
    disp(['    - En el archivo ./c-code/linker.ld (para C) o ./asm/bram.ld (para ASM) modificar BRAM a:']);
    % Información del máximo teórico
    disp('----------------------------------------');
    disp(['  /* Configuración teórica:*/']);
    disp(['  BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x' dec2hex(num_palabras_max * 4) ...
          '  /* ' num2str(round(num_palabras_max *4 / 1024)) 'kB RAM, ' num2str(num_palabras_max * 4) ' bytes, ' ...
          num2str(num_palabras_max) ' palabras de 32 bits */']);
    % Información del valor recomendado (80%)
    disp('----------------------------------------');
    disp(['  /* Configuración recomendada (80%):*/']);
    disp(['  BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x' dec2hex(num_palabras_recomendado * 4) ...
          '  /* ' num2str(round(num_palabras_recomendado *4 / 1024)) 'kB RAM, ' num2str(num_palabras_recomendado * 4) ' bytes, ' ...
          num2str(num_palabras_recomendado) ' palabras de 32 bits */']);
    disp('========================================');
    disp(['3. Configuración en el traductor de palabras:']);
    disp(['    - En el archivo ./c-code/Makefile (para C) o ./asm/Makefile (para ASM) modificar FPGA_RAM_BYTES a:']);
    disp('----------------------------------------');
    disp(['  # Configuración teórica:']);
    disp(['  FPGA_RAM_BYTES = ' num2str(num_palabras_max * 4) ])
    disp('----------------------------------------');
    disp(['  # Configuración recomendada (80%):']);
    disp(['  FPGA_RAM_BYTES = ' num2str(num_palabras_recomendado * 4) ])
    disp('========================================');
end
calcular_memoria_verilog();
