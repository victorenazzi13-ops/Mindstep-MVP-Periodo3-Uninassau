const express = require('express');
const authMiddleware = require('./middlewares/authMiddleware');
const cors = require('cors');
require('dotenv').config();

const authRoutes = require('./routes/authRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);

app.get('/', (req, res) => {
  res.json({
    message: 'API MindStep funcionando',
  });
});

app.get('/api/protected', authMiddleware, (req, res) => {
  res.json({
    message: 'Rota protegida acessada com sucesso',
    userId: req.userId,
  });
});

module.exports = app;