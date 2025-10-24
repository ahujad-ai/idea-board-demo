# Stage 1: Build Vite App
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* vite.config.js ./

# Install dependencies
RUN npm install

# Copy all source files including index.html
COPY . .

# ✅ Add build argument for API URL (used by Vite)
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

# Build the Vite app
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
