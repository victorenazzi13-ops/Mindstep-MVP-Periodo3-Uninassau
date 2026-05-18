const db = require('../config/database');

exports.createStep = (req, res) => {
  const { routine_id, title } = req.body;

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
};

exports.getSteps = (req, res) => {
  const { routine_id } = req.params;

  db.query(
    'SELECT * FROM steps WHERE routine_id = ?',
    [routine_id],
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

  db.query(
    'UPDATE steps SET title = ?, done = ? WHERE id = ?',
    [title, done, id],
    (err, result) => {
      if (err) {
        return res.status(500).json(err);
      }

      res.json({
        message: 'Microetapa atualizada com sucesso',
      });
    }
  );
};

exports.deleteStep = (req, res) => {
  const { id } = req.params;

  db.query(
    'DELETE FROM steps WHERE id = ?',
    [id],
    (err, result) => {
      if (err) {
        return res.status(500).json(err);
      }

      res.json({
        message: 'Microetapa excluída com sucesso',
      });
    }
  );
};