generar_clave_random() {
    # 1. Seleccionar longitud de la clave
    KEY_LENGTH=$(zenity --list \
        --title="Generar Clave Aleatoria" \
        --text="Selecciona la longitud de la clave AES:" \
        --column="Bytes" --column="Nivel de seguridad" \
        "16" "AES-128 (128 bits)" \
        "24" "AES-192 (192 bits)" \
        "32" "AES-256 (256 bits)")

    if [ -z "$KEY_LENGTH" ]; then
        zenity --info --title="Cancelado" --text="Operación cancelada."
        return
    fi

    # 2. Seleccionar formato de salida
    FORMAT=$(zenity --list \
        --title="Formato de la clave" \
        --text="Selecciona el formato de salida:" \
        --column="Formato" --column="Descripción" \
        "hex" "Hexadecimal (recomendado para ficheros)" \
        "base64" "Base64 (más legible)")

    if [ -z "$FORMAT" ]; then
        zenity --info --title="Cancelado" --text="Operación cancelada."
        return
    fi

    # 3. Generar la clave con OpenSSL
    if [ "$FORMAT" = "hex" ]; then
        CLAVE=$(openssl rand -hex "$KEY_LENGTH")
    else
        CLAVE=$(openssl rand -base64 "$KEY_LENGTH")
    fi

    # 4. Preguntar si quiere guardarla o solo visualizarla
    zenity --question --title="Guardar clave" \
        --text="¿Deseas guardar la clave en un archivo?" \
        --ok-label="Sí, guardar" --cancel-label="Solo mostrar"

    if [ $? -eq 0 ]; then
        # 5. Guardar clave en archivo
        SAVE_PATH=$(zenity --file-selection --save --confirm-overwrite --title="Guardar clave como" --filename="keys/clave_random.txt")
        if [ -n "$SAVE_PATH" ]; then
            echo "$CLAVE" > "$SAVE_PATH"
            zenity --info --title="Éxito" --text="Clave aleatoria guardada en:\n$SAVE_PATH"
        else
            zenity --info --title="Cancelado" --text="No se guardó la clave."
        fi
    else
        # 6. Mostrar la clave directamente
        echo "$CLAVE" | zenity --text-info --title="Clave Aleatoria Generada" --width=500 --height=300
    fi
}
