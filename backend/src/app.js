import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { loadConfig } from './util/env.js';
import streamRoutes from './routes/stream.js';
import recordingsRoutes from './routes/recordings.js';
import analysisRoutes from './routes/analysis.js';
import openaiRoutes from './routes/openai.js';
import authRoutes from './routes/auth.js';
import coursesRoutes from './routes/courses.js';
import dashboardRoutes from './routes/dashboard.js';
import progressRoutes from './routes/progress.js';
import notificationsRoutes from './routes/notifications.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export function createApp() {
  const app = express();
  app.use(cors());
  // Increased limit for video uploads (base64 encoding adds ~33% overhead)
  app.use(express.json({ limit: '50mb' }));
  app.use(express.urlencoded({ limit: '50mb', extended: true }));

  // Serve static assets (SVG, PNG, etc.) from assets directory
  const assetsPath = join(__dirname, '..', 'assets');
  app.use('/assets', express.static(assetsPath, {
    setHeaders: (res, path) => {
      // Set proper content type for SVG files
      if (path.endsWith('.svg')) {
        res.setHeader('Content-Type', 'image/svg+xml');
      }
    },
  }));

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
  app.use('/api/auth', authRoutes);
  app.use('/api/courses', coursesRoutes);
  app.use('/api/dashboard', dashboardRoutes);
  app.use('/api/progress', progressRoutes);
  app.use('/api/notifications', notificationsRoutes);

  return app;
}

