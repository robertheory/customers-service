import { Kafka, EachMessagePayload } from 'kafkajs';

const kafka = new Kafka({
  clientId: 'my-consumer',
  brokers: ['localhost:9092'],
});

const consumer = kafka.consumer({ groupId: 'my-group' });

const runConsumer = async () => {
  await consumer.connect();
  await consumer.subscribe({ topic: 'messages' });

  await consumer.run({
    eachMessage: async (payload: EachMessagePayload) => {
      const { topic, partition, message } = payload;
      console.log({
        topic,
        partition,
        offset: message.offset,
        value: message.value?.toString(),
      });
    },
  });
};

runConsumer().catch((error) => {
  console.error('Error:', error);
  process.exit(1);
});
