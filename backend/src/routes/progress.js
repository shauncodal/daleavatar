import { Router } from 'express';
import { getPool } from '../db/pool.js';
import { authenticateToken } from '../services/auth.js';

const router = Router();

// Update course progress (protected)
router.put('/:enrollmentId', authenticateToken, async (req, res) => {
  try {
    const { completionPercentage, currentStep } = req.body || {};
    const enrollmentId = req.params.enrollmentId;

    // Verify enrollment belongs to user
    const pool = getPool();
    const [enrollments] = await pool.query(
      'SELECT id, status FROM enrollments WHERE id = ? AND user_id = ?',
      [enrollmentId, req.user.userId]
    );

    if (enrollments.length === 0) {
      return res.status(404).json({ error: 'enrollment_not_found' });
    }

    const enrollment = enrollments[0];

    // Update progress
    const updates = [];
    const values = [];

    if (completionPercentage !== undefined) {
      updates.push('completion_percentage = ?');
      values.push(Math.max(0, Math.min(100, completionPercentage)));
    }

    if (currentStep !== undefined) {
      updates.push('current_step = ?');
      values.push(Math.max(0, currentStep));
    }

    if (updates.length === 0) {
      return res.status(400).json({ error: 'no_updates', detail: 'No progress fields to update' });
    }

    values.push(enrollmentId);

    await pool.query(
      `UPDATE course_progress SET ${updates.join(', ')}, last_accessed = NOW() WHERE enrollment_id = ?`,
      values
    );

    // Update enrollment status based on completion
    if (completionPercentage !== undefined) {
      let newStatus = enrollment.status;
      if (completionPercentage >= 100 && enrollment.status !== 'Completed') {
        newStatus = 'Completed';
        await pool.query(
          'UPDATE enrollments SET status = ?, completed_at = NOW() WHERE id = ?',
          [newStatus, enrollmentId]
        );
      } else if (completionPercentage > 0 && enrollment.status === 'Not Started') {
        newStatus = 'In Progress';
        await pool.query(
          'UPDATE enrollments SET status = ? WHERE id = ?',
          [newStatus, enrollmentId]
        );
      }
    }

    res.json({ ok: true });
  } catch (error) {
    console.error('[progress] Update error:', error);
    res.status(500).json({ error: 'progress_update_failed', detail: error.message });
  }
});

// Record a choice during scenario (protected)
router.post('/:enrollmentId/choices', authenticateToken, async (req, res) => {
  try {
    const { decisionPoint, choiceMade, choiceScore, feedback } = req.body || {};
    const enrollmentId = req.params.enrollmentId;

    if (!decisionPoint || !choiceMade) {
      return res.status(400).json({ error: 'missing_fields', detail: 'decisionPoint and choiceMade are required' });
    }

    // Verify enrollment belongs to user
    const pool = getPool();
    const [enrollments] = await pool.query(
      'SELECT id FROM enrollments WHERE id = ? AND user_id = ?',
      [enrollmentId, req.user.userId]
    );

    if (enrollments.length === 0) {
      return res.status(404).json({ error: 'enrollment_not_found' });
    }

    // Record choice
    const [result] = await pool.query(
      'INSERT INTO course_choices (enrollment_id, decision_point, choice_made, choice_score, feedback) VALUES (?, ?, ?, ?, ?)',
      [enrollmentId, decisionPoint, choiceMade, choiceScore || null, feedback || null]
    );

    res.status(201).json({ ok: true, choiceId: result.insertId });
  } catch (error) {
    console.error('[progress] Record choice error:', error);
    res.status(500).json({ error: 'choice_record_failed', detail: error.message });
  }
});

// Get analytics for a course (protected)
router.get('/:enrollmentId/analytics', authenticateToken, async (req, res) => {
  try {
    const enrollmentId = req.params.enrollmentId;

    // Verify enrollment belongs to user
    const pool = getPool();
    const [enrollments] = await pool.query(
      'SELECT id FROM enrollments WHERE id = ? AND user_id = ?',
      [enrollmentId, req.user.userId]
    );

    if (enrollments.length === 0) {
      return res.status(404).json({ error: 'enrollment_not_found' });
    }

    // Get choices
    const [choices] = await pool.query(
      'SELECT decision_point, choice_made, choice_score, feedback, created_at FROM course_choices WHERE enrollment_id = ? ORDER BY created_at',
      [enrollmentId]
    );

    // Get progress
    const [progress] = await pool.query(
      'SELECT completion_percentage, current_step, last_accessed FROM course_progress WHERE enrollment_id = ?',
      [enrollmentId]
    );

    // Calculate statistics
    const scores = choices.filter(c => c.choice_score !== null).map(c => c.choice_score);
    const averageScore = scores.length > 0 
      ? scores.reduce((a, b) => a + b, 0) / scores.length 
      : null;

    // Most common choices
    const choiceFrequency = {};
    choices.forEach(choice => {
      const key = `${choice.decision_point}:${choice.choice_made}`;
      choiceFrequency[key] = (choiceFrequency[key] || 0) + 1;
    });

    res.json({
      totalChoices: choices.length,
      averageScore: averageScore,
      completionPercentage: progress[0]?.completion_percentage || 0,
      choices: choices,
      mostCommonChoices: Object.entries(choiceFrequency)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 5)
        .map(([key, count]) => ({
          choice: key,
          count: count,
        })),
    });
  } catch (error) {
    console.error('[progress] Analytics error:', error);
    res.status(500).json({ error: 'analytics_fetch_failed', detail: error.message });
  }
});

export default router;

