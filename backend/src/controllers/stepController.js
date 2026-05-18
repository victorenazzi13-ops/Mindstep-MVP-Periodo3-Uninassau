const db = require('../config/database');

exports.createStep = (req, res) => {
  const { routine_id, title } = req.body;
  const userId = req.userId;

  db.query(
    'SELECT * FROM routines WHERE id = ? AND user_id = ?',
    [routine_id, userId],
    (err, routines) => {
      if (err) {
        return res.status(500).json(err);
      }

      if (routines.length === 0) {
        return res.status(403).json({
          message: 'Você não tem permissão para adicionar microetapas nesta rotina',
        });
      }

      db.query(
        'INSERT INTO steps (routine_id, title) VALUES (?, ?)',
        [routine_id, title],
        (err, result) => {
          if (err) {
            return res.status(500).json(err);
          }

          res.status(201).json({
            message: 'Microetapa criada com sucesso',
            id: result.insertId,
          });
        }
      );
    }
  );
};

exports.getSteps = (req, res) => {
  const { routine_id } = req.params;
  const userId = req.userId;

  db.query(
    `SELECT steps.*
     FROM steps
     INNER JOIN routines ON steps.routine_id = routines.id
     WHERE steps.routine_id = ? AND routines.user_id = ?`,
    [routine_id, userId],
    (err, results) => {
      if (err) {
        return res.status(500).json(err);
      }

      res.json(results);
    }
  );
};

exports.updateStep = (req, res) => {
  const { id } = req.params;
  const { title, done } = req.body;
  const userId = req.userId;

  db.query(
    `UPDATE steps
     INNER JOIN routines ON steps.routine_id = routines.id
     SET steps.title = ?, steps.done = ?
     WHERE steps.id = ? AND routines.user_id = ?`,
    [title, done, id, userId],
    (err, result) => {
      if (err) {
        return res.status(500).json(err);
      }

      if (result.affectedRows === 0) {
        return res.status(404).json({
          message: 'Microetapa não encontrada ou sem permissão',
        });
      }

      res.json({
        message: 'Microetapa atualizada com sucesso',
      });
    }
  );
};

exports.deleteStep = (req, res) => {
  const { id } = req.params;
  const userId = req.userId;

  db.query(
    `DELETE steps
     FROM steps
     INNER JOIN routines ON steps.routine_id = routines.id
     WHERE steps.id = ? AND routines.user_id = ?`,
    [id, userId],
    (err, result) => {
      if (err) {
        return res.status(500).json(err);
      }

      if (result.affectedRows === 0) {
        return res.status(404).json({
          message: 'Microetapa não encontrada ou sem permissão',
        });
      }

      res.json({
        message: 'Microetapa excluída com sucesso',
      });
    }
  );
};