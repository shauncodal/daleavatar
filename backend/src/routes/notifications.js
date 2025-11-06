import { Router } from 'express';
import { getPool } from '../db/pool.js';
import { authenticateToken } from '../services/auth.js';

const router = Router();

// Get user notifications (protected)
router.get('/', authenticateToken, async (req, res) => {
  try {
    const pool = getPool();
    const userId = req.user.userId;
    const { limit = 50, unread_only: unreadOnly } = req.query;

    let query = 'SELECT id, type, title, message, is_read, created_at FROM notifications WHERE user_id = ?';
    const params = [userId];

    if (unreadOnly === 'true') {
      query += ' AND is_read = FALSE';
    }

    query += ' ORDER BY created_at DESC LIMIT ?';
    params.push(parseInt(limit));

    const [notifications] = await pool.query(query, params);

    res.json(notifications);
  } catch (error) {
    console.error('[notifications] List error:', error);
    res.status(500).json({ error: 'notifications_fetch_failed', detail: error.message });
  }
});

// Mark notification as read (protected)
router.put('/:id/read', authenticateToken, async (req, res) => {
  try {
    const pool = getPool();
    const userId = req.user.userId;
    const notificationId = req.params.id;

    // Verify notification belongs to user
    const [notifications] = await pool.query(
      'SELECT id FROM notifications WHERE id = ? AND user_id = ?',
      [notificationId, userId]
    );

    if (notifications.length === 0) {
      return res.status(404).json({ error: 'notification_not_found' });
    }

    await pool.query(
      'UPDATE notifications SET is_read = TRUE WHERE id = ?',
      [notificationId]
    );

    res.json({ ok: true });
  } catch (error) {
    console.error('[notifications] Mark read error:', error);
    res.status(500).json({ error: 'notification_update_failed', detail: error.message });
  }
});

// Mark all notifications as read (protected)
router.post('/read-all', authenticateToken, async (req, res) => {
  try {
    const pool = getPool();
    const userId = req.user.userId;

    await pool.query(
      'UPDATE notifications SET is_read = TRUE WHERE user_id = ? AND is_read = FALSE',
      [userId]
    );

    res.json({ ok: true });
  } catch (error) {
    console.error('[notifications] Mark all read error:', error);
    res.status(500).json({ error: 'notifications_update_failed', detail: error.message });
  }
});

export default router;

