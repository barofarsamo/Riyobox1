const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
const User = require('./models/User');

dotenv.config();
const app = express();
app.use(express.json());
app.use(cors());

app.use('/auth', require('./routes/auth'));
app.use('/admin', require('./routes/admin'));
app.use('/movies', require('./routes/movies'));

app.get('/', (req, res) => res.send('Riyobox API is running...'));

const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/riyobox';

const createDefaultAdmin = async () => {
  try {
    const adminExists = await User.findOne({ email: 'admin@example.com' });
    if (!adminExists) {
      await User.create({ name: 'Super Admin', email: 'admin@example.com', password: 'admin123', role: 'admin' });
      console.log('Default admin created: admin@example.com / admin123');
    }
  } catch (error) {
    console.error('Error creating default admin:', error.message);
  }
};

mongoose.connect(MONGO_URI)
  .then(() => {
    console.log('MongoDB connected');
    createDefaultAdmin();
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
  })
  .catch((err) => {
    console.error('MongoDB connection error:', err.message);
    process.exit(1);
  });
