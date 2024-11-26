const promClient = require('prom-client');
const fetch = require('node-fetch');

// Prometheus metrics collection
const collectDefaultMetrics = promClient.collectDefaultMetrics;

// Create a new Prometheus Registry
const registry = new promClient.Registry();

// Collect default metrics and register them with the custom registry
collectDefaultMetrics({ register: registry });

// Create a custom gauge for frontend health
registry.registerMetric(new promClient.Gauge({
  name: 'frontend_health_status',
  help: 'Health status of the frontend',
  async collect() {
    try {
      const res = await fetch('http://frontend-service:3000/health'); // Replace with actual frontend health URL
      if (res.status === 200) {
        this.set(1); // Set to 1 if frontend is healthy
      } else {
        this.set(0); // Set to 0 if frontend is not healthy
      }
    } catch (error) {
      console.error('Error fetching frontend health:', error);
      this.set(0); // Set to 0 if there is an error fetching health status
    }
  }
}));

// Export the registry for use in the main server file
module.exports = registry;
