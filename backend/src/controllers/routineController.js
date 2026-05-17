const db = require('../config/database');

exports.createRoutine = (req, res) => {
  const { title, description } = req.body;
  const userId = req.userId;

  db.query(
    'INSERT INTO routines (user_id, title, description) VALUES (?, ?, ?)',
    [userId, title, description],
    (err, result) => {
      if (err) {
        return res.status(500).json(err);
      }

      res.status(201).json({
        message: 'Rotina criada com sucesso',
        id: result.insertId,
      });
    }
  );
};

exports.getRoutines = (req, res) => {
  const userId = req.userId;

  db.query(
    'SELECT * FROM routines WHERE user_id = ? ORDER BY created_at DESC',
    [userId],
    (err, results) => {
      if (err) {
        return res.status(500).json(err);
      }

      res.json(results);
    }
  );
};

exports.updateRoutine = (req, res) => {
  const { id } = req.params;
  const { title, description } = req.body;
  const userId = req.userId;

  db.query(
    'UPDATE routines SET title = ?, description = ? WHERE id = ? AND user_id = ?',
    [title, description, id, userId],
    (err, result) => {
      if (err) {
        return res.status(500).json(err);
      }

      if (result.affectedRows === 0) {
        return res.status(404).json({
          message: 'Rotina não encontrada',
        });
      }

      res.json({
        message: 'Rotina atualizada com sucesso',
      });
    }
  );
};

exports.deleteRoutine = (req, res) => {
  const { id } = req.params;
  const userId = req.userId;

  db.query(
    'DELETE FROM routines WHERE id = ? AND user_id = ?',
    [id, userId],
    (err, result) => {
      if (err) {
        return res.status(500).json(err);
      }

      if (result.affectedRows === 0) {
        return res.status(404).json({
          message: 'Rotina não encontrada',
        });
      }

      res.json({
        message: 'Rotina excluída com sucesso',
      });
    }
  );
};