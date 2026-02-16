const mongoose = require('mongoose');

const LiveStreamSchema = new mongoose.Schema({
    fixtureId: { type: Number, required: true, unique: true },
    streamUrl: { type: String, required: true },
    title: { type: String },
    status: { type: String, default: 'active' }, // active, ended
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('LiveStream', LiveStreamSchema);
