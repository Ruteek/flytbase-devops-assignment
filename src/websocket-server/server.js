const WebSocket = require('ws');

const PORT = 8080;
const wss = new WebSocket.Server({ port: PORT });

console.log(`WebSocket server is running on ws://localhost:${PORT}`);

wss.on('connection', ws => {
    console.log("Client connected");

    ws.on('message', message => {
        console.log(`Received: ${message}`);
        ws.send(`Echo: ${message}`);
    });

    ws.on('close', () => {
        console.log("Client disconnected");
    });
});

// Prevent Node.js from exiting
process.stdin.resume();

