# 📱 Proyecto Flutter + Node.js + MySQL

## 📦 Información

Este proyecto se llevó a cabo con el siguiente stack:

- 🐳 **Docker** para correr el motor de base de datos MySQL  
- ⚙️ **Node.js con Express** para el backend y creación de endpoints  
- 📱 **Flutter** para la aplicación móvil

---

## 🚀 ¿Cómo desplegar el proyecto?

### 🔧 1. Backend

1. Entrar a la carpeta del backend mediante la terminal.
2. Instalar las dependencias necesarias con el siguiente comando:

   ```bash
   npm install
🐳 2. Base de datos con Docker (opcional)
Renombrar el archivo copy_env a .env.

Configurar dentro del archivo .env las credenciales de la base de datos.

Ejecutar el siguiente comando dentro de la carpeta del backend para levantar la base de datos:

    docker compose up -d

⚠️ Nota: Se debe tener Docker instalado en la máquina.

🛠️ 3. Base de datos externa (como XAMPP)
Si ya se cuenta con una base de datos MySQL en otro entorno (como XAMPP):

Renombrar el archivo copy_env a .env.

Configurar las credenciales de conexión a la base de datos en dicho archivo.

▶️ 4. Iniciar el servidor
Ejecutar el siguiente comando para iniciar el backend:

    node server.js

📱 5. Iniciar la aplicación Flutter
Entrar a la carpeta del proyecto Flutter.

Ejecutar el siguiente comando:

    flutter run
    
⚠️ Importante: Si se va a desplegar la app en un dispositivo móvil real, se debe actualizar la ruta del servidor en el archivo:

flutter/lib/services/config_service.dart

Asegúrate de colocar la IP local del servidor backend si están en la misma red.