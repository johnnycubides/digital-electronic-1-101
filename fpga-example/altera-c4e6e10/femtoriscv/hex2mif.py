input_file = "firmware.hex"
output_file = "firmware.mif"

# Configuración (ajusta según tus necesidades)
WIDTH = 32       # Ancho de palabra en bits (32 bits = 8 caracteres hex)
DEPTH = 4096     # Profundidad de la memoria (ajusta al tamaño requerido)

with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
    # Escribe la cabecera del archivo MIF
    f_out.write(f"DEPTH = {DEPTH};\n")
    f_out.write(f"WIDTH = {WIDTH};\n")
    f_out.write("ADDRESS_RADIX = HEX;\n")
    f_out.write("DATA_RADIX = HEX;\n")
    f_out.write("CONTENT\nBEGIN\n")

    addr = 0
    for line in f_in:
        # Procesa cada palabra en la línea (separadas por espacios)
        words = line.strip().split()
        for word in words:
            if len(word) == 8:  # Asegura que es una palabra de 32 bits (8 hex chars)
                f_out.write(f"{addr:04X} : {word.upper()};\n")
                addr += 1

    # Rellena el resto de la memoria con ceros (opcional)
    while addr < DEPTH:
        f_out.write(f"{addr:04X} : {'0' * 8};\n")
        addr += 1

    f_out.write("END;\n")

print(f"Archivo MIF generado: {output_file}")
