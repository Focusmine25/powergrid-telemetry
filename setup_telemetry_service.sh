#!/bin/bash
# Bash script to create telemetry service folder structure and files

# Define base path
BASE_DIR="./services/telemetry-service"

# Create directories
mkdir -p "$BASE_DIR"

# Create package.json
cat <<EOL > "$BASE_DIR/package.json"
{
  "name": "telemetry-service",
  "version": "1.0.0",
  "description": "PowerGrid telemetry data collector",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "axios": "^1.4.0",
    "uuid": "^9.0.0"
  }
}
EOL

# Create server.js
cat <<'EOL' > "$BASE_DIR/server.js"
const express = require('express');
const { v4: uuidv4 } = require('uuid');

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Simulated telemetry endpoint
app.post('/telemetry', (req, res) => {
  const data = req.body;
  const event = {
    id: uuidv4(),
    timestamp: new Date().toISOString(),
    ...data
  };
  console.log('Received telemetry:', event);
  res.status(200).json({ message: 'Telemetry received', event });
});

app.get('/', (req, res) => {
  res.send('PowerGrid Telemetry Service is running!');
});

app.listen(port, () => {
  console.log(`Telemetry service listening at http://localhost:${port}`);
});
EOL

# Create .dockerignore
cat <<EOL > "$BASE_DIR/.dockerignore"
node_modules
npm-debug.log
EOL

# Create Dockerfile
cat <<EOL > "$BASE_DIR/Dockerfile"
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
EOL

echo "Telemetry service structure created at $BASE_DIR"

