#!/bin/bash
# crypto_app/cifrado_simetric.sh
# Funciones para cifrado simétrico AES-256

# Submenú para cifrado simétrico
menu_cifrado_simetrico() {
    while true; do
        CHOICE=$(zenity --list \
            --title="Cifrado Simétrico (AES-256)" \
            --text="Selecciona la operación:" \
            --width=500 --height=300 \
            --column="Opción" --column="Descripción" \
            "1" "Generar clave random AES" \
            "2" "Cifrar archivo con AES-256" \
            "3" "Descifrar archivo con AES-256" \
            "4" "Volver al menú principal")

        case "$CHOICE" in
            "1") generar_clave_random_simetric ;;
            "2") cifrar_archivo_simetric ;;
            "3") descifrar_archivo_simetric ;;
            "4"|*) break ;;
        esac
    done
}

#Generar clave AES-256 aleatoria
generar_clave_random_simetric() {
    KEY_PATH=$(zenity --file-selection --save --confirm-overwrite --title="Guardar clave AES como" --filename="keys/key.bin")
    if [ -z "$KEY_PATH" ]; then
        zenity --info --title="Cancelado" --text="Generación de clave cancelada."
        return
    fi

    openssl rand -out "$KEY_PATH" 32
    if [ $? -eq 0 ]; then
        zenity --info --title="Éxito" --text="Clave AES-256 generada y guardada en:\n$KEY_PATH"
    else
        zenity --error --title="Error" --text="No se pudo generar la clave AES."
    fi
}

#Cifrar archivo con AES-256
cifrar_archivo_simetric() {
    # Seleccionar archivo a cifrar
    INPUT_FILE=$(zenity --file-selection --title="Selecciona archivo a cifrar")
    if [ -z "$INPUT_FILE" ]; then
        zenity --info --title="Cancelado" --text="Cifrado cancelado."
        return
    fi

    # Seleccionar clave AES
    KEY_FILE=$(zenity --file-selection --title="Selecciona clave AES (key.bin)")
    if [ -z "$KEY_FILE" ]; then
        zenity --info --title="Cancelado" --text="Cifrado cancelado (sin clave)."
        return
    fi

    OUTPUT_FILE="${INPUT_FILE}.enc"

    openssl enc -aes-256-cbc -pbkdf2 -salt -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass file:"$KEY_FILE" 2>/dev/null
    if [ $? -eq 0 ]; then
        zenity --info --title="Éxito" --text="Archivo cifrado correctamente:\n$OUTPUT_FILE"
    else
        zenity --error --title="Error" --text="Error al cifrar el archivo."
    fi
}

#Descifrar archivo con AES-256
descifrar_archivo_simetric() {
    # Seleccionar archivo cifrado
    ENC_FILE=$(zenity --file-selection --title="Selecciona archivo cifrado (.enc)")
    if [ -z "$ENC_FILE" ]; then
        zenity --info --title="Cancelado" --text="Descifrado cancelado."
        return
    fi

    # Seleccionar clave AES
    KEY_FILE=$(zenity --file-selection --title="Selecciona clave AES (key.bin)")
    if [ -z "$KEY_FILE" ]; then
        zenity --info --title="Cancelado" --text="Descifrado cancelado (sin clave)."
        return
    fi

    OUTPUT_FILE="${ENC_FILE%.enc}_descifrado"

    openssl enc -d -aes-256-cbc -pbkdf2 -in "$ENC_FILE" -out "$OUTPUT_FILE" -pass file:"$KEY_FILE" 2>/dev/null
    if [ $? -eq 0 ]; then
        # Mostrar contenido en ventana Zenity
        zenity --text-info --title="Archivo descifrado" --width=600 --height=400 --filename="$OUTPUT_FILE"
    else
        zenity --error --title="Error" --text="Error al descifrar el archivo."
    fi
}
