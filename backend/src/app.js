import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { loadConfig } from './util/env.js';
import streamRoutes from './routes/stream.js';
import recordingsRoutes from './routes/recordings.js';
import analysisRoutes from './routes/analysis.js';
import openaiRoutes from './routes/openai.js';

export function createApp() {
  const app = express();
  app.use(cors());
  app.use(express.json({ limit: '10mb' }));

  // validate env (log missing but don't crash in test)
  const config = loadConfig();
  if (!config.valid && process.env.NODE_ENV !== 'test') {
    // eslint-disable-next-line no-console
    console.warn('Missing env vars:', config.missing);
  }

  app.get('/health', (_req, res) => {
    res.json({ ok: true, service: 'daleavatar-backend' });
  });

  app.use('/api/stream', streamRoutes);
  app.use('/api/recordings', recordingsRoutes);
  app.use('/api/analysis', analysisRoutes);
  app.use('/api/openai', openaiRoutes);

  return app;
}

