const express = require("express");
const mongoose = require("mongoose");
const Todo = require("./models/todo");
const cors = require("cors");
require('dotenv').config(); // Import dotenv
const client = require('prom-client'); // Import prom-client for metrics

const app = express();
const port = process.env.PORT || 3500; // Use port from environment variables
const mongodb = process.env.DB_URL; // Use MongoDB URL from environment variables

// Connect to MongoDB Atlas
mongoose.connect(mongodb, {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
.then(() => {
    console.log("MongoDB successfully connected");
})
.catch((err) => {
    console.error("Error connecting to MongoDB", err);
});

app.use(cors());
app.use(express.urlencoded({ extended: false }));
app.use(express.json());

// Initialize Prometheus metrics
const register = new client.Registry();
client.collectDefaultMetrics({ register });

// Custom metric for testing
const myGauge = new client.Gauge({
    name: 'my_custom_metric',
    help: 'A custom metric for testing',
});
myGauge.set(Math.random()); // Set a random value for testing

// Webhook endpoint
app.post("/webhook", (req, res) => {
    console.log("Webhook received:", req.body); // Log the received data
    // Process the webhook payload as needed
    
    // Send a response back to acknowledge receipt
    res.sendStatus(200); // Respond with 200 OK
});

// Expose Prometheus metrics endpoint
app.get('/metrics', async (req, res) => {
    try {
        res.set('Content-Type', register.contentType);
        res.end(await register.metrics());
    } catch (err) {
        console.error("Unable to fetch metrics:", err);
        res.status(500).send("Error fetching metrics");
    }
});

// Routes
app.get("/todo", async (req, res) => {
    try {
        const todos = await Todo.find();
        let orderedTodos = [];
        let unorderedTodos = [];

        for (let i = 0; i < todos.length; i++) {
            if (todos[i].order !== undefined) {
                orderedTodos.push(todos[i]);
            } else {
                unorderedTodos.push(todos[i]);
            }
        }

        orderedTodos.sort((a, b) => a.order - b.order);

        const allTodos = [...unorderedTodos, ...orderedTodos];
        res.json(allTodos);
    } catch (error) {
        console.error("Error fetching todos:", error);
        res.status(500).json({ message: 'Error fetching todos.' });
    }
});

app.post("/todo", async (req, res) => {
    try {
        const todo = req.body.todo;

        if (!todo || todo.trim() === "") {
            return res.status(400).json({
                status: false,
                message: "Input field is required"
            });
        }

        await Todo.create({ todo });

        const savedTodos = await Todo.find();

        res.status(201).json({
            status: true,
            message: "Todo successfully added",
            data: savedTodos
        });

    } catch (err) {
        console.error("Request not processed:", err);
        res.status(500).json({ message: "Request not processed" });
    }
});

// Start the server
app.listen(port, '0.0.0.0', () => {
    console.log(`Server is listening on port ${port}`);
});
