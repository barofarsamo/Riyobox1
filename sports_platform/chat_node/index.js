const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
    cors: { origin: "*" }
});

/**
 * REAL-TIME CHAT & NOTIFICATIONS (Node.js)
 *
 * Responsibilities:
 * 1. Live fan chat rooms for matches
 * 2. Automated live commentary feed
 * 3. Push notification orchestration
 * 4. Lightweight event handling
 */

io.on('connection', (socket) => {
    console.log('User connected to chat');

    socket.on('join_match_room', (matchId) => {
        socket.join(`match_${matchId}`);
        console.log(`User joined chat for match ${matchId}`);
    });

    socket.on('send_message', (data) => {
        // Broadcast to specific match room
        io.to(`match_${data.matchId}`).emit('new_message', {
            user: data.user,
            text: data.text,
            timestamp: new Date()
        });
    });

    socket.on('disconnect', () => {
        console.log('User disconnected from chat');
    });
});

const PORT = process.env.PORT || 4000;
server.listen(PORT, () => {
    console.log(`Chat & Notification service running on port ${PORT}`);
});
