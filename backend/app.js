const express = require('express');
const promClient = require('prom-client');
const registry = require('./metrics'); // Import the registry from metrics.js

const app = express();

// Endpoint to expose Prometheus metrics
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(await registry.metrics());
});

// Your regular backend routes
app.get('/', (req, res) => {
  res.send('Hello World');
});

// Start the backend server
app.listen(3500, () => {
  console.log('Backend is running on port 3500');
});
