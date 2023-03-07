const app = require('./server');
const express = require('express');
const cors = require('cors');
const logger = require('./logger');

const PORT = 3333;
const HOST = '0.0.0.0';

app.use(express.json());
app.use(cors());

app.listen(PORT, HOST, () => {
  logger.info(`Server is listening on ${PORT} port`);
});
