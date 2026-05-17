const db = require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

exports.register = async (req, res) => {
  const { name, email, password } = req.body;

  db.query(
    'SELECT * FROM users WHERE email = ?',
    [email],
    async (err, result) => {
      if (result.length > 0) {
        return res.status(400).json({
          message: 'Email já cadastrado',
        });
      }

      const hashedPassword = await bcrypt.hash(password, 10);

      db.query(
        'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
        [name, email, hashedPassword],
        (err) => {
          if (err) {
            return res.status(500).json(err);
          }

          res.status(201).json({
            message: 'Usuário criado com sucesso',
          });
        }
      );
    }
  );
};

exports.login = (req, res) => {
  const { email, password } = req.body;

  db.query(
    'SELECT * FROM users WHERE email = ?',
    [email],
    async (err, result) => {
      if (result.length === 0) {
        return res.status(400).json({
          message: 'Usuário não encontrado',
        });
      }

      const user = result[0];

      const validPassword = await bcrypt.compare(password, user.password);

      if (!validPassword) {
        return res.status(401).json({
          message: 'Senha inválida',
        });
      }

      const token = jwt.sign(
        {
          id: user.id,
          email: user.email,
        },
        process.env.JWT_SECRET,
        {
          expiresIn: '1d',
        }
      );

      res.json({
        message: 'Login realizado com sucesso',
        token,
      });
    }
  );
};