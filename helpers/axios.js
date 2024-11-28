const axios = require('axios');

const instance = axios.create({
  baseURL: process.env.RAG_BASE_URL,
  headers: {
    'x-api-key': process.env.RAG_API_KEY,
  },
});

module.exports = instance;
