const express = require('express');
const router = express.Router();

const routineController = require('../controllers/routineController');
const authMiddleware = require('../middlewares/authMiddleware');

router.post('/', authMiddleware, routineController.createRoutine);
router.get('/', authMiddleware, routineController.getRoutines);
router.put('/:id', authMiddleware, routineController.updateRoutine);
router.delete('/:id', authMiddleware, routineController.deleteRoutine);

module.exports = router;