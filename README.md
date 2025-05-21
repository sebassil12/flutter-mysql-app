##Información

Este proyecto se llevo a cabo con el siguiente stack:
--Docker para correr el motor de base de datos de MYSQL
--Node con express para realizar el backend con los endpoints
--Flutter para la aplicación móvil

##¿Cómo desplegar el proyecto?

1. Entrar a la carpeta del backend mediante consola y descargar todas las librerías necesarias mediante 
    un "npm install"
2. Si se desea desplegar el motor de base de datos con docker entonces:
    2.1 Renombrar el archivo copy_env por .env y colocar dentro las credenciales que se van a utilizar para la base de datos.
    2.2 Correr dentro de la carpeta backend el comando "docker compose up -d" (Se debe tener docker instalado en la máquina).
3. Si ya se tiene la base de datos de MYSQL en otro entorno como XAMPP entonces solo renombrar el archivo copy_env por .env y
    colocar las credenciales de la base de datos.
4. Arrancamos el servidor con el comando node server.js

5. Arrancamos la aplicación en Flutter. Tener en consideración que si se despliega en un dispositivo móvil, entonces
    cambiar la ruta de la configuración de los servicios que se encunetra en la carpeta de flutter dentro de /lib/services/config_service.dart
