const express = require('express');
const router = express.Router();

const stepController = require('../controllers/stepController');
const authMiddleware = require('../middlewares/authMiddleware');

router.post('/', authMiddleware, stepController.createStep);
router.get('/:routine_id', authMiddleware, stepController.getSteps);
router.put('/:id', authMiddleware, stepController.updateStep);
router.delete('/:id', authMiddleware, stepController.deleteStep);

module.exports = router;