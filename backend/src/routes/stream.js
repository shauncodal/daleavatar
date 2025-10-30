import { Router } from 'express';
import { createSessionToken, newSession, keepAlive, speak } from '../services/heygen.js';

const router = Router();

router.post('/session-token', async (_req, res) => {
  try {
    const token = await createSessionToken();
    res.json({ token });
  } catch (e) {
    res.status(500).json({ error: 'failed_to_create_token', detail: String(e) });
  }
});

router.post('/new-session', async (req, res) => {
  try {
    const { startRequest, token } = req.body || {};
    const data = await newSession({ startRequest, token });
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: 'failed_to_start_session', detail: String(e) });
  }
});

router.post('/keepalive', async (req, res) => {
  try {
    const { token } = req.body || {};
    const data = await keepAlive({ token });
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: 'failed_to_keepalive', detail: String(e) });
  }
});

router.post('/speak', async (req, res) => {
  try {
    const { token, text, taskType } = req.body || {};
    const data = await speak({ token, text, taskType });
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: 'failed_to_speak', detail: String(e) });
  }
});

export default router;

