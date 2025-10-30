import { Router } from 'express';
import { respondWithAssistant } from '../services/openai.js';
import { speak } from '../services/heygen.js';

const router = Router();

router.post('/message', async (req, res) => {
  try {
    const { transcript, token } = req.body || {};
    const { text } = await respondWithAssistant({
      messages: [
        { role: 'system', content: 'You are a helpful sales assistant.' },
        { role: 'user', content: transcript || '' }
      ]
    });
    await speak({ token, text, taskType: 'REPEAT' });
    res.json({ reply: text });
  } catch (e) {
    res.status(500).json({ error: 'assistant_loop_failed', detail: String(e) });
  }
});

export default router;

