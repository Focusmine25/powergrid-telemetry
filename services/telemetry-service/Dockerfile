# Use official Node.js LTS image
FROM node:20-alpine

# Create app directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json* ./
RUN npm install --production

# Copy source code
COPY server.js ./

# Expose port
EXPOSE 3000

# Run the service
CMD ["npm", "start"]
