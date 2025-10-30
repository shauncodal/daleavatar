import { Router } from 'express';
import { getPool } from '../db/pool.js';
import { putObject } from '../services/storage.js';

const router = Router();

router.post('/init', async (_req, res) => {
  const pool = getPool();
  const [result] = await pool.query(
    'INSERT INTO recordings (session_id, status) VALUES (?, ?)',
    [null, 'pending']
  );
  res.json({ id: result.insertId });
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
  // expects base64 body { webmBase64: 'data:video/webm;base64,...' }
  const { webmBase64 } = req.body || {};
  if (!webmBase64) return res.status(400).json({ error: 'missing_body' });
  const [, b64] = webmBase64.split('base64,');
  const buf = Buffer.from(b64, 'base64');
  const key = `recordings/${req.params.id}/composite.webm`;
  await putObject({ key, body: buf, contentType: 'video/webm' });
  const pool = getPool();
  await pool.query('UPDATE recordings SET status = ?, size_bytes = ? WHERE id = ?', [
    'ready',
    buf.length,
    req.params.id
  ]);
  res.json({ ok: true, key });
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

