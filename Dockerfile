# Usa la imagen oficial de Node.js 22 como base
FROM node:22 AS build

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Copia el package.json y package-lock.json (o yarn.lock) al contenedor
COPY package*.json ./

# Instala las dependencias del proyecto
RUN npm install

# Copia el resto del código fuente del proyecto al contenedor
COPY . .

# Construye la aplicación de NestJS
RUN npm run build

# Usa la imagen de Node.js 22 para la etapa de producción
FROM node:22 AS production

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Copia el package.json y package-lock.json (o yarn.lock) desde la etapa anterior
COPY --from=build /usr/src/app/package*.json ./

# Instala solo las dependencias de producción
RUN npm install --only=production

# Copia el código fuente y la carpeta build desde la etapa anterior
COPY --from=build /usr/src/app/dist ./dist

# Expone el puerto en el que la aplicación NestJS escucha (3000)
EXPOSE 3000

# Comando para correr la aplicación en producción
CMD ["node", "dist/main"]
