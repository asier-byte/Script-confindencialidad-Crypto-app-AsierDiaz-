#!/bin/bash
# ===============================================
# crypto_app/cifrado_asimetrico.sh
# ===============================================

# Submenú para cifrado asimétrico
menu_cifrado_asimetrico() {
    while true; do
        CHOICE=$(zenity --list \
            --title="Cifrado Asimétrico (Híbrido)" \
            --text="Selecciona la operación:" \
            --width=500 --height=300 \
            --column="Opción" --column="Descripción" \
            "1" "Cifrar archivo (híbrido: AES + RSA)" \
            "2" "Descifrar archivo (híbrido)" \
            "3" "Volver al menú principal")

        case "$CHOICE" in
            "1") cifrar_archivo_asimetrico ;;
            "2") descifrar_archivo_asimetrico ;;
            "3"|*) break ;;
        esac
    done
}

cifrar_archivo_asimetrico() {
    #Seleccionar archivo a cifrar
    INPUT_FILE=$(zenity --file-selection --title="Selecciona el archivo que deseas cifrar")
    if [ $? -ne 0 ] || [ -z "$INPUT_FILE" ]; then
        zenity --warning --title="Cancelado" --text="Operación cancelada por el usuario."
        return
    fi

    #Seleccionar clave pública RSA
    PUB_KEY=$(zenity --file-selection --title="Selecciona la clave pública (PEM) para cifrar la clave AES")
    if [ $? -ne 0 ] || [ -z "$PUB_KEY" ]; then
        zenity --warning --title="Cancelado" --text="No se seleccionó una clave pública."
        return
    fi

     #Generar una clave AES aleatoria de 32 bytes (256 bits)
    AES_KEY="./key.bin"
    openssl rand -out "$AES_KEY" 32

    #Cifrar el archivo con AES-256-CBC
    OUTPUT_FILE="${INPUT_FILE}.enc"
    openssl enc -aes-256-cbc -pbkdf2 -salt -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass file:"$AES_KEY"

    if [ $? -ne 0 ]; then
        zenity --error --title="Error" --text="Error al cifrar el archivo con AES."
        shred -u "$AES_KEY" 2>/dev/null
        return
    fi

    #Cifrar la clave AES con la clave pública RSA
    ENC_AES_KEY="${OUTPUT_FILE}.key.enc"
    openssl pkeyutl -encrypt -pubin -inkey "$PUB_KEY" -in "$AES_KEY" -out "$ENC_AES_KEY"

    if [ $? -ne 0 ]; then
        zenity --error --title="Error" --text="Error al cifrar la clave AES con la clave pública."
        shred -u "$AES_KEY" 2>/dev/null
        rm -f "$OUTPUT_FILE"
        return
    fi

    #Eliminar la clave AES temporal en texto plano
    shred -u "$AES_KEY"

     Mensaje final
    zenity --info --title="Cifrado completado" --width=400 \
        --text="✅ Cifrado híbrido realizado con éxito.\n\nArchivos generados:\n- ${OUTPUT_FILE}\n- ${ENC_AES_KEY}"
}


descifrar_archivo_asimetrico() {
    # 1. Seleccionar archivo cifrado
    ENC_FILE=$(zenity --file-selection --title="Selecciona el archivo cifrado (.enc)")
    if [ $? -ne 0 ] || [ -z "$ENC_FILE" ]; then
        zenity --info --title="Cancelado" --text="Descifrado cancelado."
        return
    fi

    # 2. Seleccionar la clave AES cifrada (key.bin.enc)
    ENC_KEY_FILE=$(zenity --file-selection --title="Selecciona la clave AES cifrada (key.bin.enc)")
    if [ $? -ne 0 ] || [ -z "$ENC_KEY_FILE" ]; then
        zenity --info --title="Cancelado" --text="Descifrado cancelado (sin clave cifrada)."
        return
    fi

    # 3. Seleccionar la clave privada RSA
    PRIV_KEY=$(zenity --file-selection --title="Selecciona la clave privada RSA (PEM)")
    if [ $? -ne 0 ] || [ -z "$PRIV_KEY" ]; then
        zenity --info --title="Cancelado" --text="Descifrado cancelado (sin clave privada)."
        return
    fi

    # 4. Descifrar la clave AES
    openssl pkeyutl -decrypt -inkey "$PRIV_KEY" -in "$ENC_KEY_FILE" -out key.bin 2>/dev/null
    if [ $? -ne 0 ]; then
        zenity --error --title="Error" --text="No se pudo descifrar la clave AES. Verifica la clave privada."
        rm -f key.bin
        return
    fi

    # 5. Descifrar el archivo con AES-256
    OUTPUT_FILE="${ENC_FILE%.enc}_descifrado"
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$ENC_FILE" -out "$OUTPUT_FILE" -pass file:./key.bin 2>/dev/null
    if [ $? -ne 0 ]; then
        zenity --error --title="Error" --text="Error al descifrar el archivo con AES-256."
        rm -f key.bin
        return
    fi

    # 6. Limpiar clave temporal
    rm -f key.bin

    # 7. Mostrar resultado
    zenity --info --title="Éxito" --text="Archivo descifrado con éxito.\n\nArchivo original: $OUTPUT_FILE"

    # 8. Si es un archivo de texto, mostrar su contenido
    if file "$OUTPUT_FILE" | grep -q "text"; then
        zenity --text-info --title="Contenido del archivo descifrado" \
               --filename="$OUTPUT_FILE" --width=700 --height=500
    else
        zenity --info --title="Archivo no legible" \
               --text="El archivo descifrado no es de texto y no puede mostrarse aquí.\n\nSe guardó en:\n$OUTPUT_FILE"
    fi
}




