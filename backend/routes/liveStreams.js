const express = require('express');
const router = express.Router();
const LiveStream = require('../models/LiveStream');
const { protect, admin } = require('../middleware/authMiddleware');

// Get all live streams
router.get('/', async (req, res) => {
    try {
        const streams = await LiveStream.find();
        res.json(streams);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Add or update a live stream
router.post('/', protect, admin, async (req, res) => {
    const { fixtureId, streamUrl, title } = req.body;
    try {
        let stream = await LiveStream.findOne({ fixtureId });
        if (stream) {
            stream.streamUrl = streamUrl;
            stream.title = title;
            await stream.save();
        } else {
            stream = await LiveStream.create({ fixtureId, streamUrl, title });
        }
        res.status(201).json(stream);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// Delete a live stream
router.delete('/:id', protect, admin, async (req, res) => {
    try {
        await LiveStream.findByIdAndDelete(req.params.id);
        res.json({ message: 'Stream removed' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
