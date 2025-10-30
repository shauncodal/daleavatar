import { getPool } from '../db/pool.js';

export async function runDummyAnalysis(recordingId) {
  const summary = 'Overall positive engagement with moments of hesitation. Smiles detected at 00:12 and 02:03.';
  const payload = {
    microExpressions: [
      { t: 12.1, type: 'smile', intensity: 0.82 },
      { t: 36.4, type: 'brow_raise', intensity: 0.61 }
    ],
    tone: [
      { t: 5.0, sentiment: 'neutral' },
      { t: 22.0, sentiment: 'positive' }
    ],
    reactions: [
      { t: 18.5, event: 'user_interruption' },
      { t: 44.0, event: 'avatar_long_pause' }
    ]
  };
  const pool = getPool();
  await pool.query(
    'INSERT INTO analysis (recording_id, provider, payload_json, summary_text) VALUES (?, ?, ?, ?)',
    [recordingId, 'dummy', JSON.stringify(payload), summary]
  );
  return { summary, payload };
}

