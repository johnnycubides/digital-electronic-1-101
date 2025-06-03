def intel_hex_line(address, data):
    length = len(data) // 2  # Cada byte son 2 caracteres hex
    hex_line = f"{length:02X}{address:04X}00{data}"
    
    # Calcular checksum
    bytes_to_sum = bytes.fromhex(hex_line)
    checksum = (-sum(bytes_to_sum)) & 0xFF
    checksum_str = f"{checksum:02X}"
    
    return f":{hex_line}{checksum_str}"

def txt_to_intel_hex(input_file, output_file):
    with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
        address = 0x0000
        for line in f_in:
            line = line.strip()
            if not line:
                continue
            
            # Procesar cada palabra (4 bytes) en la línea
            words = line.split()
            for word in words:
                if len(word) != 8:  # Asegurar que es 32 bits (8 caracteres hex)
                    continue
                
                # Dividir en bytes (little-endian)
                data = "".join([word[i:i+2] for i in range(6, -1, -2)])
                
                # Escribir línea Intel HEX
                hex_line = intel_hex_line(address, data)
                f_out.write(hex_line + '\n')
                address += 4  # Incrementar dirección (4 bytes por palabra)
        
        # Línea de fin de archivo
        f_out.write(":00000001FF\n")

# Uso:
txt_to_intel_hex("firmware.hex", "firmware.mif")
