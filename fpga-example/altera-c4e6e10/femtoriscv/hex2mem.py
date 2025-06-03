def convertir_firmware(input_file: str, output_file: str):
    with open(input_file, 'r') as f:
        lines = f.readlines()

    result_lines = []

    for line in lines:
        # Dividir la línea por espacios y procesar cada palabra
        words = line.strip().split()
        for word in words:
            # Asegurar que la palabra tenga exactamente 8 dígitos hexadecimales
            word = word.zfill(8)
            # Dividir en bytes (dos caracteres cada uno)
            bytes_group = [word[i:i+2] for i in range(0, 8, 2)]
            result_lines.append(' '.join(bytes_group))

    # Guardar resultado en archivo de salida
    with open(output_file, 'w') as f:
        for line in result_lines:
            f.write(line + '\n')


if __name__ == "__main__":
    input_path = "firmware.hex"
    output_path = "firmware.mem"
    convertir_firmware(input_path, output_path)
    print(f"Conversión completada. Archivo generado: {output_path}")

