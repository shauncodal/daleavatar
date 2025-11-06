import { Router } from 'express';
import { getPool } from '../db/pool.js';
import { hashPassword, verifyPassword, generateToken, authenticateToken } from '../services/auth.js';

const router = Router();

// Register a new user
router.post('/register', async (req, res) => {
  try {
    const { email, name, password } = req.body || {};
    
    if (!email || !password) {
      return res.status(400).json({ error: 'missing_fields', detail: 'Email and password are required' });
    }

    const pool = getPool();
    
    // Check if user already exists
    const [existing] = await pool.query('SELECT id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(409).json({ error: 'user_exists', detail: 'User with this email already exists' });
    }

    // Create user
    const passwordHash = hashPassword(password);
    const [result] = await pool.query(
      'INSERT INTO users (email, name, password_hash) VALUES (?, ?, ?)',
      [email, name || null, passwordHash]
    );

    const token = generateToken(result.insertId, email);

    res.status(201).json({
      user: { id: result.insertId, email, name },
      token
    });
  } catch (error) {
    console.error('[auth] Register error:', error);
    res.status(500).json({ error: 'registration_failed', detail: error.message });
  }
});

// Login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body || {};
    
    if (!email || !password) {
      return res.status(400).json({ error: 'missing_fields', detail: 'Email and password are required' });
    }

    const pool = getPool();
    const [users] = await pool.query(
      'SELECT id, email, name, password_hash FROM users WHERE email = ?',
      [email]
    );

    if (users.length === 0) {
      return res.status(401).json({ error: 'invalid_credentials', detail: 'Invalid email or password' });
    }

    const user = users[0];
    
    if (!user.password_hash || !verifyPassword(password, user.password_hash)) {
      return res.status(401).json({ error: 'invalid_credentials', detail: 'Invalid email or password' });
    }

    const token = generateToken(user.id, user.email);

    res.json({
      user: { id: user.id, email: user.email, name: user.name },
      token
    });
  } catch (error) {
    console.error('[auth] Login error:', error);
    res.status(500).json({ error: 'login_failed', detail: error.message });
  }
});

// Get current user profile (protected)
router.get('/me', authenticateToken, async (req, res) => {
  try {
    const pool = getPool();
    const [users] = await pool.query(
      'SELECT id, email, name, profile_settings, created_at FROM users WHERE id = ?',
      [req.user.userId]
    );

    if (users.length === 0) {
      return res.status(404).json({ error: 'user_not_found' });
    }

    res.json(users[0]);
  } catch (error) {
    console.error('[auth] Get profile error:', error);
    res.status(500).json({ error: 'profile_fetch_failed', detail: error.message });
  }
});

// Update profile
router.put('/profile', authenticateToken, async (req, res) => {
  try {
    const { name, profileSettings } = req.body || {};
    const pool = getPool();

    const updates = [];
    const values = [];

    if (name !== undefined) {
      updates.push('name = ?');
      values.push(name);
    }

    if (profileSettings !== undefined) {
      updates.push('profile_settings = ?');
      values.push(JSON.stringify(profileSettings));
    }

    if (updates.length === 0) {
      return res.status(400).json({ error: 'no_updates', detail: 'No fields to update' });
    }

    values.push(req.user.userId);

    await pool.query(
      `UPDATE users SET ${updates.join(', ')} WHERE id = ?`,
      values
    );

    res.json({ ok: true });
  } catch (error) {
    console.error('[auth] Update profile error:', error);
    res.status(500).json({ error: 'profile_update_failed', detail: error.message });
  }
});

// Change password
router.post('/change-password', authenticateToken, async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body || {};
    
    if (!currentPassword || !newPassword) {
      return res.status(400).json({ error: 'missing_fields', detail: 'Current and new passwords are required' });
    }

    const pool = getPool();
    const [users] = await pool.query(
      'SELECT password_hash FROM users WHERE id = ?',
      [req.user.userId]
    );

    if (users.length === 0) {
      return res.status(404).json({ error: 'user_not_found' });
    }

    const user = users[0];
    if (!user.password_hash || !verifyPassword(currentPassword, user.password_hash)) {
      return res.status(401).json({ error: 'invalid_password', detail: 'Current password is incorrect' });
    }

    const newPasswordHash = hashPassword(newPassword);
    await pool.query(
      'UPDATE users SET password_hash = ? WHERE id = ?',
      [newPasswordHash, req.user.userId]
    );

    res.json({ ok: true });
  } catch (error) {
    console.error('[auth] Change password error:', error);
    res.status(500).json({ error: 'password_change_failed', detail: error.message });
  }
});

export default router;

