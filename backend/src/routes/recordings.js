import { Router } from 'express';
import { getPool } from '../db/pool.js';
import { putObject } from '../services/storage.js';

const router = Router();

router.post('/init', async (_req, res) => {
  try {
  const pool = getPool();
    // First create a session
    const [sessionResult] = await pool.query(
      'INSERT INTO sessions (user_id, started_at) VALUES (?, NOW())',
      [null]
    );
    const sessionId = sessionResult.insertId;
    
    // Then create a recording linked to the session
  const [result] = await pool.query(
    'INSERT INTO recordings (session_id, status) VALUES (?, ?)',
      [sessionId, 'pending']
  );
    res.json({ id: result.insertId, sessionId });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/', async (_req, res) => {
  const pool = getPool();
  const [rows] = await pool.query(
    'SELECT r.id, r.status, r.duration_ms, r.created_at, a.summary_text FROM recordings r LEFT JOIN analysis a ON a.recording_id = r.id ORDER BY r.created_at DESC LIMIT 100'
  );
  res.json(rows);
});

router.get('/:id', async (req, res) => {
  const pool = getPool();
  const [rows] = await pool.query('SELECT * FROM recordings WHERE id = ?', [req.params.id]);
  if (!rows.length) return res.status(404).json({ error: 'not_found' });
  res.json(rows[0]);
});

router.post('/upload/:id', async (req, res) => {
  try {
  // expects base64 body { webmBase64: 'data:video/webm;base64,...' }
  const { webmBase64 } = req.body || {};
    if (!webmBase64) {
      return res.status(400).json({ error: 'missing_body' });
    }
    
  const [, b64] = webmBase64.split('base64,');
    if (!b64) {
      return res.status(400).json({ error: 'invalid_base64_format' });
    }
    
  const buf = Buffer.from(b64, 'base64');
    if (buf.length === 0) {
      return res.status(400).json({ error: 'empty_recording' });
    }
    
  const key = `recordings/${req.params.id}/composite.webm`;
    console.log(`[recordings] Uploading recording ${req.params.id}, size: ${buf.length} bytes`);
    
  await putObject({ key, body: buf, contentType: 'video/webm' });
    
  const pool = getPool();
  await pool.query('UPDATE recordings SET status = ?, size_bytes = ? WHERE id = ?', [
    'ready',
    buf.length,
    req.params.id
  ]);
    
    res.json({ ok: true, key, size: buf.length });
  } catch (error) {
    console.error('[recordings] Upload error:', error);
    res.status(500).json({ error: error.message });
  }
});

router.post('/:id/export', async (req, res) => {
  const pool = getPool();
  await pool.query('INSERT INTO exports (recording_id, target, status) VALUES (?, ?, ?)', [
    req.params.id,
    'third_party_stub',
    'queued'
  ]);
  res.json({ ok: true });
});

export default router;

