# Küçük ve temiz bir base
FROM node:20-alpine

# Bazı paketler (opsiyonel ama derleme sorunlarını engeller)
RUN apk add --no-cache bash git curl

# Firebase CLI global kur
RUN npm install -g firebase-tools

# Varsayılan çalışma klasörü
WORKDIR /app
