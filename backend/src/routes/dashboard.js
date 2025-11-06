import { Router } from 'express';
import { getPool } from '../db/pool.js';
import { authenticateToken } from '../services/auth.js';

const router = Router();

// Get dashboard data (protected)
router.get('/', authenticateToken, async (req, res) => {
  try {
    const pool = getPool();
    const userId = req.user.userId;

    // Get user info
    const [users] = await pool.query(
      'SELECT id, email, name, profile_settings FROM users WHERE id = ?',
      [userId]
    );
    const user = users[0];

    // Get enrollments with progress
    const [enrollments] = await pool.query(
      `SELECT e.id, e.course_id, e.status, e.enrolled_at,
              c.title, c.description, c.difficulty, c.avatar_image,
              cp.completion_percentage, cp.current_step, cp.last_accessed
       FROM enrollments e
       JOIN courses c ON e.course_id = c.id
       LEFT JOIN course_progress cp ON cp.enrollment_id = e.id
       WHERE e.user_id = ?
       ORDER BY cp.last_accessed DESC, e.enrolled_at DESC
       LIMIT 10`,
      [userId]
    );

    // Calculate overall progress
    let totalProgress = 0;
    let activeCourses = 0;
    enrollments.forEach(enrollment => {
      if (enrollment.status === 'In Progress' || enrollment.status === 'Not Started') {
        totalProgress += parseFloat(enrollment.completion_percentage || 0);
        activeCourses++;
      }
    });
    const overallProgress = activeCourses > 0 ? totalProgress / activeCourses : 0;

    // Get next upcoming task (course with earliest last_accessed that's not completed)
    const [nextTask] = await pool.query(
      `SELECT e.id, c.title, c.id as course_id, cp.last_accessed
       FROM enrollments e
       JOIN courses c ON e.course_id = c.id
       LEFT JOIN course_progress cp ON cp.enrollment_id = e.id
       WHERE e.user_id = ? AND e.status IN ('Not Started', 'In Progress')
       ORDER BY cp.last_accessed ASC, e.enrolled_at ASC
       LIMIT 1`,
      [userId]
    );

    // Get unread notifications count
    const [notifCount] = await pool.query(
      'SELECT COUNT(*) as count FROM notifications WHERE user_id = ? AND is_read = FALSE',
      [userId]
    );
    const unreadCount = notifCount[0]?.count || 0;

    // Format enrollments
    const formattedEnrollments = enrollments.map(enrollment => ({
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
    }));

    // Get recording statistics from analysis
    const [analyses] = await pool.query(
      `SELECT a.payload_json 
       FROM analysis a
       JOIN recordings r ON a.recording_id = r.id
       JOIN sessions s ON r.session_id = s.id
       WHERE s.user_id = ? AND a.payload_json IS NOT NULL
       ORDER BY a.created_at DESC
       LIMIT 100`,
      [userId]
    );

    // Aggregate statistics from recordings
    const recordingStats = {
      totalRecordings: 0,
      engagement: { total: 0, count: 0 },
      tone: {
        confidence: { total: 0, count: 0 },
        enthusiasm: { total: 0, count: 0 },
        clarity: { total: 0, count: 0 },
        professionalism: { total: 0, count: 0 },
        friendliness: { total: 0, count: 0 },
      },
      metrics: {
        questionQuality: { total: 0, count: 0 },
        objectionHandling: { total: 0, count: 0 },
        rapportScore: { total: 0, count: 0 },
      },
    };

    analyses.forEach(analysis => {
      try {
        const payload = typeof analysis.payload_json === 'string' 
          ? JSON.parse(analysis.payload_json) 
          : analysis.payload_json;
        
        if (payload?.engagement) {
          recordingStats.totalRecordings++;
          if (payload.engagement.engagementScore !== undefined) {
            recordingStats.engagement.total += payload.engagement.engagementScore;
            recordingStats.engagement.count++;
          }
        }
        
        if (payload?.tone) {
          Object.keys(recordingStats.tone).forEach(key => {
            if (payload.tone[key] !== undefined) {
              recordingStats.tone[key].total += payload.tone[key];
              recordingStats.tone[key].count++;
            }
          });
        }
        
        if (payload?.keyMetrics) {
          Object.keys(recordingStats.metrics).forEach(key => {
            if (payload.keyMetrics[key] !== undefined) {
              recordingStats.metrics[key].total += payload.keyMetrics[key];
              recordingStats.metrics[key].count++;
            }
          });
        }
      } catch (e) {
        // Skip invalid JSON
      }
    });

    // Calculate averages
    const averages = {
      engagementScore: recordingStats.engagement.count > 0 
        ? Math.round(recordingStats.engagement.total / recordingStats.engagement.count) 
        : null,
      tone: {},
      metrics: {},
    };

    Object.keys(recordingStats.tone).forEach(key => {
      if (recordingStats.tone[key].count > 0) {
        averages.tone[key] = Math.round(recordingStats.tone[key].total / recordingStats.tone[key].count);
      }
    });

    Object.keys(recordingStats.metrics).forEach(key => {
      if (recordingStats.metrics[key].count > 0) {
        averages.metrics[key] = Math.round(recordingStats.metrics[key].total / recordingStats.metrics[key].count);
      }
    });

    // Get evaluator feedback averages from course_choices
    const [choices] = await pool.query(
      `SELECT cc.choice_score 
       FROM course_choices cc
       JOIN enrollments e ON cc.enrollment_id = e.id
       WHERE e.user_id = ? AND cc.choice_score IS NOT NULL`,
      [userId]
    );

    let evaluatorFeedbackAvg = null;
    if (choices.length > 0) {
      const totalScore = choices.reduce((sum, c) => sum + (c.choice_score || 0), 0);
      evaluatorFeedbackAvg = Math.round(totalScore / choices.length);
    }

    res.json({
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
      },
      enrollments: formattedEnrollments,
      progress: {
        overallPercentage: Math.round(overallProgress),
        activeCourses: activeCourses,
      },
      nextTask: nextTask.length > 0 ? {
        courseId: nextTask[0].course_id,
        title: nextTask[0].title,
        enrollmentId: nextTask[0].id,
      } : null,
      notifications: {
        unreadCount: unreadCount,
      },
      statistics: {
        totalRecordings: recordingStats.totalRecordings,
        averages: averages,
        evaluatorFeedbackAverage: evaluatorFeedbackAvg,
        totalEvaluations: choices.length,
      },
    });
  } catch (error) {
    console.error('[dashboard] Get error:', error);
    res.status(500).json({ error: 'dashboard_fetch_failed', detail: error.message });
  }
});

export default router;

