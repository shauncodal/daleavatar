import { Router } from 'express';
import { createSessionToken, newSession, startSession, keepAlive, speak } from '../services/heygen.js';

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
    
    if (!startRequest) {
      return res.status(400).json({ error: 'missing_startRequest', detail: 'startRequest is required' });
    }
    if (!token) {
      return res.status(400).json({ error: 'missing_token', detail: 'token is required' });
    }
    
    console.log('[API] new-session request:', JSON.stringify({ startRequest, token: token.substring(0, 20) + '...' }, null, 2));
    
    const data = await newSession({ startRequest, token });
    res.json(data);
  } catch (e) {
    const statusCode = e.response?.status || 500;
    // Capture full error details
    let errorDetail = e.message;
    if (e.response?.data) {
      errorDetail = typeof e.response.data === 'string' 
        ? e.response.data 
        : JSON.stringify(e.response.data);
      
      // Also log the full response for debugging
      console.error('[API] new-session error - Full HeyGen response:', JSON.stringify(e.response.data, null, 2));
    }
    
    console.error('[API] new-session error - Status:', statusCode);
    console.error('[API] new-session error - Detail:', errorDetail);
    console.error('[API] new-session error - Request payload that failed:', JSON.stringify(req.body?.startRequest, null, 2));
    
    res.status(statusCode).json({ 
      error: 'failed_to_start_session', 
      detail: errorDetail,
      statusCode: statusCode
    });
  }
});

router.post('/start-session', async (req, res) => {
  try {
    const { sessionId, token } = req.body || {};
    const data = await startSession({ sessionId, token });
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

