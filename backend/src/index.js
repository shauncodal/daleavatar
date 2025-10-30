import { createApp } from './app.js';
import assistantLoopRoutes from './routes/assistant_loop.js';

const app = createApp();
app.use('/api/assistant-loop', assistantLoopRoutes);

const port = Number(process.env.PORT || 4000);
app.listen(port, () => {
  // eslint-disable-next-line no-console
  console.log(`API listening on http://localhost:${port}`);
});

