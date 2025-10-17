#!/bin/bash
# ================================
# Menú de gestión de claves públicas
# ================================


menu_gestion_publicas() {
    while true; do
        CHOICE=$(zenity --list \
            --title="Gestión de Claves Públicas" \
            --text="Selecciona la operación que deseas realizar:" \
            --width=500 --height=350 \
            --column="Opción" --column="Descripción" \
            "1" "Visualizar clave pública" \
            "2" "Buscar claves públicas" \
            "3" "Importar clave pública" \
            "4" "Exportar clave pública" \
            "5" "Volver al menú principal")

        case "$CHOICE" in
            "1") visualizar_clave_publica ;;
            "2") buscar_claves_publicas ;;
            "3") importar_clave_publica ;;
            "4") exportar_clave_publica ;;
            "5"|*) break ;;
        esac
    done
}


#
#
#

visualizar_clave_publica() {
    FILE_NAME=$(zenity --entry \
        --title="Visualizar Clave Pública" \
        --text="Introduce el nombre base de la clave (sin _pub.pem):")

    if [ $? -ne 0 ] || [ -z "$FILE_NAME" ]; then
        zenity --info --title="Cancelado" --text="Operación cancelada."
        return
    fi

    PUB_KEY_PATH="keys/${FILE_NAME}_pub.pem"

    if [ ! -f "$PUB_KEY_PATH" ]; then
        zenity --error --title="Error" --text="No se encontró el archivo: $PUB_KEY_PATH"
    else
        zenity --text-info \
            --title="Clave Pública: $FILE_NAME" \
            --filename="$PUB_KEY_PATH" \
            --width=600 --height=400
    fi
}

#
#
#

buscar_claves_publicas() {
    KEYS_DIR="./keys"

    if [ ! -d "$KEYS_DIR" ]; then
        echo "Error: no existe la carpeta $KEYS_DIR"
        return
    fi

    RESULTADOS=$(find "$KEYS_DIR" -maxdepth 1 -type f \( -name "*_pub.pem" -o -name "*.pub" \) 2>/dev/null)

    # Depuración: imprimir lo que encontró
    echo "RESULTADOS encontrados:"
    echo "$RESULTADOS"

    if [ -z "$RESULTADOS" ]; then
        echo "No se encontraron claves públicas."
        return
    fi

    sleep 3

}

#
#
#

importar_clave_publica() {
    FILE_TO_IMPORT=$(zenity --file-selection --title="Selecciona la clave pública a importar")

    if [ $? -ne 0 ] || [ -z "$FILE_TO_IMPORT" ]; then
        zenity --info --title="Cancelado" --text="Importación cancelada."
        return
    fi

    mkdir -p keyring
    cp "$FILE_TO_IMPORT" keyring/
    chmod 600 "keyring/$(basename "$FILE_TO_IMPORT")"

    zenity --info --title="Importación completada" \
        --text="Clave pública importada en keyring/: $(basename "$FILE_TO_IMPORT")"
}

#
#
#

exportar_clave_publica() {
    FILE_TO_EXPORT=$(zenity --file-selection --title="Selecciona la clave pública a exportar" --filename="keyring/")

    if [ $? -ne 0 ] || [ -z "$FILE_TO_EXPORT" ]; then
        zenity --info --title="Cancelado" --text="Exportación cancelada."
        return
    fi

    DEST_PATH=$(zenity --file-selection --save --confirm-overwrite --title="Elige destino para exportar")

    if [ $? -ne 0 ] || [ -z "$DEST_PATH" ]; then
        zenity --info --title="Cancelado" --text="Exportación cancelada."
        return
    fi

    cp "$FILE_TO_EXPORT" "$DEST_PATH"
    zenity --info --title="Exportación completada" --text="Clave exportada a: $DEST_PATH"
}

