const express = require('express');
const cors = require('cors');
require('dotenv').config();

const authRoutes = require('./routes/authRoutes');
const routineRoutes = require('./routes/routineRoutes');
const authMiddleware = require('./middlewares/authMiddleware');
const stepRoutes = require('./routes/stepRoutes');

const app = express();

app.use(cors());
app.use(express.json());
app.use('/api/routines', routineRoutes);
app.use('/api/steps', stepRoutes);

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