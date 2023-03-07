FROM node:13-alpine

WORKDIR /app

COPY package.json /app

RUN apk add curl && npm install

COPY . /app

ENTRYPOINT ["./start.sh"]
