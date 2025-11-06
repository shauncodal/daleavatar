import { Router } from 'express';
import { getPool } from '../db/pool.js';
import { authenticateToken } from '../services/auth.js';

const router = Router();

// Get all courses (public)
router.get('/', async (_req, res) => {
  try {
    const pool = getPool();
    const [courses] = await pool.query(
      'SELECT id, scenario_id, title, description, difficulty, avatar_image, tips_json FROM courses ORDER BY id'
    );

    // Parse tips_json for each course
    const formattedCourses = courses.map(course => ({
      ...course,
      tips: course.tips_json ? JSON.parse(course.tips_json) : []
    }));

    res.json(formattedCourses);
  } catch (error) {
    console.error('[courses] List error:', error);
    res.status(500).json({ error: 'courses_fetch_failed', detail: error.message });
  }
});

// Get course by ID
router.get('/:id', async (req, res) => {
  try {
    const pool = getPool();
    const [courses] = await pool.query(
      'SELECT id, scenario_id, title, description, difficulty, avatar_image, tips_json FROM courses WHERE id = ?',
      [req.params.id]
    );

    if (courses.length === 0) {
      return res.status(404).json({ error: 'course_not_found' });
    }

    const course = courses[0];
    course.tips = course.tips_json ? JSON.parse(course.tips_json) : [];

    res.json(course);
  } catch (error) {
    console.error('[courses] Get error:', error);
    res.status(500).json({ error: 'course_fetch_failed', detail: error.message });
  }
});

// Enroll in a course (protected)
router.post('/:id/enroll', authenticateToken, async (req, res) => {
  try {
    const pool = getPool();
    const userId = req.user.userId;
    const courseId = req.params.id;

    // Check if course exists
    const [courses] = await pool.query('SELECT id FROM courses WHERE id = ?', [courseId]);
    if (courses.length === 0) {
      return res.status(404).json({ error: 'course_not_found' });
    }

    // Check if already enrolled
    const [existing] = await pool.query(
      'SELECT id FROM enrollments WHERE user_id = ? AND course_id = ?',
      [userId, courseId]
    );

    if (existing.length > 0) {
      return res.status(409).json({ error: 'already_enrolled', detail: 'User is already enrolled in this course' });
    }

    // Create enrollment
    const [enrollmentResult] = await pool.query(
      'INSERT INTO enrollments (user_id, course_id, status) VALUES (?, ?, ?)',
      [userId, courseId, 'Not Started']
    );

    // Initialize progress
    await pool.query(
      'INSERT INTO course_progress (enrollment_id, completion_percentage, current_step) VALUES (?, 0, 0)',
      [enrollmentResult.insertId]
    );

    res.status(201).json({ ok: true, enrollmentId: enrollmentResult.insertId });
  } catch (error) {
    console.error('[courses] Enroll error:', error);
    res.status(500).json({ error: 'enrollment_failed', detail: error.message });
  }
});

// Get user's enrollments (protected)
router.get('/user/enrollments', authenticateToken, async (req, res) => {
  try {
    const pool = getPool();
    const userId = req.user.userId;

    const [enrollments] = await pool.query(
      `SELECT e.id, e.course_id, e.status, e.enrolled_at, e.completed_at,
              c.title, c.description, c.difficulty, c.avatar_image,
              cp.completion_percentage, cp.current_step, cp.last_accessed
       FROM enrollments e
       JOIN courses c ON e.course_id = c.id
       LEFT JOIN course_progress cp ON cp.enrollment_id = e.id
       WHERE e.user_id = ?
       ORDER BY e.enrolled_at DESC`,
      [userId]
    );

    // Format enrollments
    const formatted = enrollments.map(enrollment => ({
      enrollmentId: enrollment.id,
      course: {
        id: enrollment.course_id,
        title: enrollment.title,
        description: enrollment.description,
        difficulty: enrollment.difficulty,
        avatarImage: enrollment.avatar_image,
      },
      status: enrollment.status,
      progress: {
        completionPercentage: parseFloat(enrollment.completion_percentage || 0),
        currentStep: enrollment.current_step || 0,
        lastAccessed: enrollment.last_accessed,
      },
      enrolledAt: enrollment.enrolled_at,
      completedAt: enrollment.completed_at,
    }));

    res.json(formatted);
  } catch (error) {
    console.error('[courses] Get enrollments error:', error);
    res.status(500).json({ error: 'enrollments_fetch_failed', detail: error.message });
  }
});

export default router;

