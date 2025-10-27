// server.js
const express = require("express");
const amqp = require("amqplib");
const app = express();
const PORT = 8080;

// Simple middleware to parse JSON
app.use(express.json());

// Basic test route
app.get("/", (req, res) => {
  res.send("Telemetry Service is running ✅");
});

// Simulated telemetry endpoint
app.get("/metrics", (req, res) => {
  const telemetryData = generateTelemetryData();
  res.json(telemetryData);
});

// Start the server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`⚡ Telemetry Service running on port ${PORT}`);
});

// ---------------- RabbitMQ Setup ----------------
const RABBITMQ_URL = process.env.RABBITMQ_URL || "amqp://guest:guest@rabbitmq:5672";
let channel;

async function initRabbitMQ() {
  try {
    const conn = await amqp.connect(RABBITMQ_URL);
    channel = await conn.createChannel();
    await channel.assertQueue("telemetry", { durable: false });
    console.log("✅ Connected to RabbitMQ");
  } catch (err) {
    console.error("❌ Failed to connect to RabbitMQ:", err);
    // Retry connection every 5 seconds if failed
    setTimeout(initRabbitMQ, 5000);
  }
}

function publishTelemetry(data) {
  if (!channel) return console.error("⚠️ Channel not ready yet, message skipped");
  channel.sendToQueue("telemetry", Buffer.from(JSON.stringify(data)));
  console.log("📨 Telemetry sent:", data);
}

// Initialize RabbitMQ connection
initRabbitMQ();

// ---------------- Telemetry Simulation ----------------
function generateTelemetryData() {
  return {
    voltage: (220 + Math.random() * 10).toFixed(2),
    current: (Math.random() * 15).toFixed(2),
    powerUsage: (Math.random() * 3000).toFixed(2),
    timestamp: new Date().toISOString(),
  };
}

// Publish telemetry every 5 seconds
setInterval(() => {
  const telemetryData = generateTelemetryData();
  publishTelemetry(telemetryData);
}, 5000);

