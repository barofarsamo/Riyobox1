const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
    cors: { origin: "*" }
});

io.on('connection', (socket) => {
    socket.on('join_match_room', (matchId) => {
        socket.join(`match_${matchId}`);
    });
    socket.on('send_message', (data) => {
        io.to(`match_${data.matchId}`).emit('new_message', data);
    });
});

const PORT = process.env.PORT || 4000;
server.listen(PORT, () => {
    console.log(`Chat service running on port ${PORT}`);
});
