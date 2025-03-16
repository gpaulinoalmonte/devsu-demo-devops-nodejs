# Usa una imagen oficial de Node.js como base
FROM node:20-alpine

# Instala curl
RUN apk add --no-cache curl

# Crea el usuario sin privilegios antes de asignar permisos
RUN adduser -D appuser

# Establece un directorio de trabajo dentro del contenedor
WORKDIR /app

# Crea el directorio para la base de datos SQLite dentro del contenedor
RUN mkdir -p /app/data && chown -R appuser:appuser /app

# Copia los archivos necesarios
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto de los archivos del proyecto
COPY . /app

# Copia el archivo .env
COPY .env .env

# Establece las variables de entorno por defecto
ENV NODE_ENV=production
ENV PORT=3000
ENV DATABASE_NAME=/app/data/dev.sqlite
ENV DATABASE_USER=user
ENV DATABASE_PASSWORD=password

# Expone el puerto de la aplicación
EXPOSE 3000

# Cambia al usuario sin privilegios
USER appuser

# Define el comando de inicio
CMD ["npm", "start"]

# Healthcheck para verificar que la aplicación responde
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1
