// server.js
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
const User = require('./models/User');

dotenv.config();
const app = express();
app.use(express.json());
app.use(cors());

// Routes
app.use('/auth', require('./routes/auth'));
app.use('/admin', require('./routes/admin'));
app.use('/movies', require('./routes/movies'));

// Health check
app.get('/', (req, res) => res.send('Riyobox API is running...'));

// Config
const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI; // Use only environment variable in cloud

// Create default admin
const createDefaultAdmin = async () => {
  try {
    const adminExists = await User.findOne({ email: 'admin@example.com' });
    if (!adminExists) {
      const admin = new User({
        name: 'Super Admin',
        email: 'admin@example.com',
        password: 'admin123',
        role: 'admin'
      });
      await admin.save(); // use save() instead of create()
      console.log('Default admin created: admin@example.com / admin123');
    }
  } catch (error) {
    console.error('Error creating default admin:', error.message);
  }
};

// Connect MongoDB and start server
mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('MongoDB connected');
    createDefaultAdmin();
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
  })
  .catch((err) => {
    console.error('MongoDB connection error:', err.message);
    process.exit(1);
  });
