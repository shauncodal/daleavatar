import { Router } from 'express';
import { runDummyAnalysis } from '../services/analysis.js';

const router = Router();

router.post('/:recordingId/run', async (req, res) => {
  try {
    const result = await runDummyAnalysis(req.params.recordingId);
    res.json({ ok: true, result });
  } catch (e) {
    res.status(500).json({ error: 'analysis_failed', detail: String(e) });
  }
});

export default router;

