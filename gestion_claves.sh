#!/bin/bash
# ===============================================
# crypto_app/gestion_claves.sh
# Contiene funciones para la gestión de claves RSA/PEM
# ===============================================

generar_claves() {
    local BITS FILE_NAME

    # 1. Pedir al usuario el tamaño de la clave (BITS: 2048 o 4096)
    BITS=$(zenity --list \
        --title="Generar Claves RSA" \
        --text="Selecciona el tamaño de la clave (bits):" \
        --column="Opción" \
        "2048" \
        "4096" \
        --height=200)

    # Verificar si el usuario pulsó Cancelar o no eligió
    if [ $? -ne 0 ] || [ -z "$BITS" ]; then
        zenity --info --title="Cancelado" --text="Generación de claves cancelada."
        return 1
    fi

    # 2. Pedir al usuario el nombre base del archivo de salida
    FILE_NAME=$(zenity --entry \
        --title="Nombre de la Clave" \
        --text="Introduce el nombre base para los archivos (ej: mi_clave). \nSe guardará en el directorio keys/.")

    # Verificar si el usuario pulsó Cancelar o no introdujo nombre
    if [ $? -ne 0 ] || [ -z "$FILE_NAME" ]; then
        zenity --info --title="Cancelado" --text="Generación de claves cancelada."
        return 1
    fi

    # Ruta de salida: keys/nombre_introducido
    PRIV_KEY_PATH="keys/${FILE_NAME}_priv.pem"
    PUB_KEY_PATH="keys/${FILE_NAME}_pub.pem"

    # 3. GENERAR la CLAVE PRIVADA (RSA)
    zenity --info --title="Proceso" --text="Generando clave privada $BITS-bit. Por favor, espere..."

    # Genera la clave privada RSA sin contraseña
    openssl genrsa -out "$PRIV_KEY_PATH" "$BITS" 2> /dev/null

    if [ $? -ne 0 ]; then
        zenity --error --title="Error" --text="Error al generar la clave privada RSA. Revisa la instalación de openssl."
        return 1
    fi

    # 4. EXPORTAR la CLAVE PÚBLICA (PEM)
    # Extrae la clave pública del archivo de clave privada
    openssl rsa -in "$PRIV_KEY_PATH" -pubout -out "$PUB_KEY_PATH" 2> /dev/null

    if [ $? -ne 0 ]; then
        zenity --error --title="Error" --text="Error al extraer la clave pública."
        return 1
    fi

    # 5. Mostrar Éxito
    zenity --info --title="Éxito" --text="Claves RSA $BITS-bit generadas con éxito:\n\nClave Privada: $PRIV_KEY_PATH\nClave Pública: $PUB_KEY_PATH"
}
