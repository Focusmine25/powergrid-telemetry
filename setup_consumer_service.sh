#!/bin/bash
echo "Ì≥¶ Setting up Consumer Service..."

# Create folder structure
mkdir -p services/consumer-service
cd services/consumer-service

# Create package.json
cat <<'PKG' > package.json
{
  "name": "consumer-service",
  "version": "1.0.0",
  "description": "PowerGrid Telemetry Consumer Service",
  "main": "consumer.js",
  "scripts": {
    "start": "node consumer.js"
  },
  "dependencies": {
    "amqplib": "^0.10.3"
  }
}
PKG

# Create consumer.js
cat <<'JS' > consumer.js
const amqp = require("amqplib");

async function startConsumer() {
  try {
    const connection = await amqp.connect("amqp://guest:guest@rabbitmq:5672");
    const channel = await connection.createChannel();
    const queue = "telemetry_queue";

    await channel.assertQueue(queue, { durable: true });
    console.log(`[‚úî] Connected to RabbitMQ, waiting for messages in "${queue}"...`);

    channel.consume(queue, (msg) => {
      if (msg !== null) {
        const data = JSON.parse(msg.content.toString());
        console.log(`[Ì≥°] Received telemetry:`, data);
        channel.ack(msg);
      }
    });
  } catch (error) {
    console.error("[‚ùå] Error:", error);
    setTimeout(startConsumer, 5000);
  }
}

startConsumer();
JS

# Create Dockerfile
cat <<'DOCKER' > Dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD ["npm", "start"]
DOCKER

echo "‚úÖ Consumer Service created successfully!"
