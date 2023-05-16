# Estágio de compilação
FROM node:16-alpine AS builder

WORKDIR /app

# Instala o Yarn
RUN apk add --no-cache yarn

# Copia os arquivos de configuração e instala as dependências
COPY package.json yarn.lock tsconfig.json /app/
RUN yarn install --frozen-lockfile

# Copia os arquivos do código-fonte e compila
COPY src /app/src
RUN yarn build

# Estágio de produção
FROM node:16-alpine

WORKDIR /app

# Copia apenas os arquivos necessários do estágio de compilação
COPY --from=builder /app/package.json /app/yarn.lock /app/tsconfig.json /app/
COPY --from=builder /app/build /app/build

# Define as variáveis de ambiente do Kafka
ENV KAFKA_HOST=your-kafka-host \
    KAFKA_PORT=your-kafka-port \
    KAFKA_TOPIC=your-kafka-topic \
    KAFKA_GROUP_ID=your-kafka-group-id

# Executa o consumidor Kafka
CMD ["node", "build/server.js"]
