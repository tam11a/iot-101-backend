# Base image
FROM node:22-alpine

# Create app directory
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

# Install app dependencies
RUN npm install

# Bundle app source
COPY . .

# Copy the .env file
COPY .env ./

# Generate prisma client
RUN npx prisma generate

# Creates a "dist" folder with the production build
RUN npm run build

# Run migrations and seed on container startup
CMD ["sh", "-c", "npx prisma migrate deploy && npx prisma db seed && npm run start:prod"]

# Install openssl mannually
RUN apk add --no-cache openssl

# Expose the port on which the app will run
EXPOSE 4000
