FROM node:16


WORKDIR /app


COPY package.json .

RUN npm install


COPY server.js .


EXPOSE 8080


CMD ["node", "server.js"]
