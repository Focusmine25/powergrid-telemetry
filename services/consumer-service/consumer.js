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
