#!/bin/bash

# ===============================================
# SCRIPT PRINCIPAL: crypto_app/main.sh
# ===============================================

# Cargar funciones externas
source ./gestion_claves.sh
source ./gestion_publicas.sh
source ./cifrado_asimetrico.sh
source ./clave_random.sh
source ./cifrado_simetrico.sh

# Título de la aplicación
APP_TITLE="CryptoApp - Gestor de Claves y Cifrado (AsierDíaz)"

# Bucle principal para mostrar el menú hasta que el usuario elija Salir
while true; do

    # Muestra el menú Zenity principal
    CHOICE=$(zenity --list \
        --title="$APP_TITLE" \
        --text="Selecciona la operación que deseas realizar:" \
        --width=400 --height=350 \
        --column="Opción" --column="Descripción" \
        "1" "Generar claves" \
        "2" "Visualizar clave pública" \
        "3" "Cifrado asimétrico" \
        "4" "Generar clave random" \
        "5" "Cifrado simétrico" \
        "6" "Salir de la Aplicación")

    # Verifica la opción seleccionada
    case "$CHOICE" in
        "1")
            zenity --info --title="INFO" --text="Has elegido: Generar claves."
            #Llamamos a la función que está en gestion_claves.sh
            generar_claves
            ;;
        "2")
            zenity --info --title="INFO" --text="Has elegido: Visualizar clave pública."
            menu_gestion_publicas
            ;;
        "3")
            zenity --info --title="INFO" --text="Has elegido: Cifrado asimétrico."
            menu_cifrado_asimetrico
            ;;
        "4")
            zenity --info --title="INFO" --text="Has elegido: Generar clave random."
            generar_clave_random
            ;;
        "5")
            zenity --info --title="INFO" --text="Has elegido: Cfrado simétrico."
            menu_cifrado_simetrico
            ;;
        "6")
            # Opción para salir del bucle (y de la aplicación)
            zenity --info --title="ADIOS" --text="Saliendo de la aplicación. ¡Hasta pronto!"
            break
            ;;
        *)
            # Maneja la cancelación (cerrar la ventana) o la pulsación de Esc/Enter sin seleccionar
            if [ -n "$CHOICE" ]; then
                zenity --error --title="ERROR" --text="Opción no válida. Inténtalo de nuevo."
            else
                # Si CHOICHE está vacío (el usuario canceló/cerró)
                zenity --info --title="ADIOS" --text="Saliendo de la aplicación por cancelación."
                break
            fi
            ;;
    esac

done
