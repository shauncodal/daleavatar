import { Router } from 'express';
import { respondWithAssistant } from '../services/openai.js';

const router = Router();

router.post('/respond', async (req, res) => {
  try {
    const { messages, model } = req.body || {};
    const { text } = await respondWithAssistant({ messages, model });
    res.json({ text });
  } catch (e) {
    res.status(500).json({ error: 'openai_failed', detail: String(e) });
  }
});

export default router;

