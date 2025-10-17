**Título**

Aplicación Bash para operaciones de confidencialidad con OpenSSL

**Objetivo**

Esta aplicación permite realizar operaciones de confidencialidad mediante OpenSSL, incluyendo generación y gestión de claves, cifrado y descifrado de archivos tanto simétrico como asimétrico (híbrido), y administración de claves públicas en un entorno seguro.

---

**Descripción del proyecto**
Este proyecto consiste en una aplicación en Bash que permite realizar operaciones de confidencialidad usando OpenSSL. 
La aplicación ofrece un menú interactivo (en Zenity) que permite:

1. Generar claves
2. Visualizar clave pública
3. Cifrado asimétrico
4. Generar una clave random
5. Cifrado simétrico

- El proyecto está pensado para un entorno seguro, evitando dejar temporales sensibles y mostrando mensajes de error claros y comprensibles.

<img width="333" height="210" alt="image" src="https://github.com/user-attachments/assets/8a0a66b8-786c-42f2-ac98-ba24c1be21c2" />

---


**Estructura del proyecto**
<img width="421" height="115" alt="image" src="https://github.com/user-attachments/assets/d45be014-b11a-44d2-83fb-34f1fba09526" />

---
**Requisitos del sistema**
- Sistema operativo: Debian 12 (o Linux compatible).
- Software necesario:
bash
openssl
zenity 
- Utilidades básicas de GNU/Linux: find, grep, chmod, cp, rm.

---
**Uso de la aplicación**
- Para ejecutar la aplicación correctamente, sigue estos pasos:

1. Accede a la carpeta principal del proyecto, llamada crypto_app:
cd ruta/donde/esta/crypto_app
2. Asegúrate de que el script principal tiene permisos de ejecución:
chmod +x main.sh
3. Ejecuta el script principal desde dentro de la carpeta crypto_app:
./main.sh

⚠️ Importante: La aplicación debe ejecutarse desde su carpeta principal para que funcione correctamente, 
ya que utiliza rutas relativas para guardar y gestionar claves, archivos cifrados y el directorio keyring.

---
**Estructura y uso de carpetas dentro de la aplicación**
1. keys/: Todas las claves generadas por la aplicación (públicas y privadas) se almacenan automáticamente en esta carpeta.

2. files/: Úsala solo para almacenar los archivos que quieras cifrar o descifrar. Esto asegura que la aplicación funcione de forma organizada y sin errores de ruta.

3. keyring/: Carpeta destinada a claves públicas importadas o exportadas. No mezcles las claves generadas aquí; 
este directorio es exclusivo para intercambio y gestión de claves externas.

⚠️ Importante:
"Para el correcto funcionamiento de la aplicación, respeta esta estructura de carpetas y no modifiques las rutas internas a menos que entiendas cómo funciona la app. 
Esto garantiza que las operaciones de cifrado, descifrado y gestión de claves se realicen correctamente."

---
**Notas**

Gestión de archivos sensibles: Los archivos de claves (key.bin, privada.pem, etc.) deben mantenerse en un entorno seguro y con permisos restringidos.

Limpieza de temporales: La aplicación intenta eliminar archivos temporales sensibles tras su uso; sin embargo, revisa que no queden restos de archivos críticos.

Seguridad: No compartas claves privadas ni archivos cifrados con terceros sin un canal seguro.

---
**Explicación del cifrado híbrido.**
- El cifrado híbrido combina cifrado simétrico (AES-256) y cifrado asimétrico (RSA) para aprovechar lo mejor de ambos mundos: velocidad y seguridad. En la  aplicación funciona así:

1. La aplicación genera una clave AES aleatoria y cifra el archivo con AES-256.
2. La clave AES se cifra con la clave pública RSA del destinatario.
3. La clave AES en texto plano se elimina inmediatamente para mantener la seguridad.
4. Para descifrar, se recupera la clave AES con la clave privada RSA y luego se descifra el archivo original.
---

## Autor

| Nombre | Contacto |
|--------|----------|
| Asier Díaz | asier-byte | 
| | **GitHub:** (https://github.com/asier-byte) |



