import 'package:flutter/material.dart';
import '../services/backend_api.dart';
import '../models/enrollment.dart';
import '../models/course.dart';
import 'session_live.dart';
import 'recordings_list.dart';

class StudentDashboardScreen extends StatefulWidget {
  final BackendApi api;
  final bool showAppBar;
  const StudentDashboardScreen({super.key, required this.api, this.showAppBar = true});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  bool _loading = true;
  List<Enrollment> _enrollments = [];
  double _overallProgress = 0.0;
  Map<String, dynamic>? _nextTask;
  Map<String, dynamic>? _statistics;
  String? _userName;

  // Figma Design Colors
  static const backgroundColor = Color(0xFF000000); // Black
  static const cardBackground = Color(0xFF0A0E14); // Dark card
  static const cardBorder = Color(0xFF1A2E23); // Border color
  static const textPrimary = Color(0xFFE8EAEF); // Primary text
  static const textSecondary = Color(0xFFA1A7B8); // Secondary text
  static const lime300 = Color(0xFFBEF264); // Lime-300
  static const emerald400 = Color(0xFF34D399); // Emerald-400
  static const teal400 = Color(0xFF2DD4BF); // Teal-400
  static const cyan400 = Color(0xFF22D3EE); // Cyan-400
  static const darkSurface = Color(0xFF141820); // Dark surface

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() => _loading = true);
    
    try {
      try {
        final dashboard = await widget.api.getDashboard();
        setState(() {
          _enrollments = (dashboard['enrollments'] as List)
              .map((e) => Enrollment.fromJson(e))
              .toList();
          _overallProgress = (dashboard['progress']?['overallPercentage'] as num?)?.toDouble() ?? 0.0;
          _nextTask = dashboard['nextTask'];
          _statistics = dashboard['statistics'];
          _userName = dashboard['user']?['name'] ?? 'Student';
          _loading = false;
        });
      } catch (e) {
        _loadMockData();
      }
    } catch (e) {
      _loadMockData();
    }
  }

  void _loadMockData() {
    setState(() {
      _enrollments = _getMockEnrollments();
      _overallProgress = 68.5;
      _nextTask = {
        'title': 'Complete Cold Calling Module',
        'dueDate': 'Nov 5, 2025',
        'courseId': 1,
      };
      _userName = 'Sarah Johnson';
      _statistics = {
        'totalRecordings': 12,
        'averages': {
          'engagementScore': 87,
          'tone': {
            'confidence': 85,
            'enthusiasm': 78,
            'clarity': 90,
            'professionalism': 88,
            'friendliness': 82,
          },
          'metrics': {
            'questionQuality': 86,
            'objectionHandling': 79,
            'rapportScore': 91,
          },
        },
        'evaluatorFeedbackAverage': 92,
        'totalEvaluations': 8,
      };
      _loading = false;
    });
  }

  List<Enrollment> _getMockEnrollments() {
    return [
      Enrollment(
        enrollmentId: 1,
        course: Course(
          id: 1,
          scenarioId: 'cold-call',
          title: 'Cold Calling Mastery',
          description: 'Module 3: Handling Objections',
          difficulty: 'Hard',
          avatarImage: '📞',
        ),
        status: 'In Progress',
        progress: Progress(completionPercentage: 65.0, currentStep: 3),
        enrolledAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Enrollment(
        enrollmentId: 2,
        course: Course(
          id: 2,
          scenarioId: 'price-negotiation',
          title: 'Financial Product Knowledge',
          description: 'Module 2: Investment Products',
          difficulty: 'Hard',
          avatarImage: '💰',
        ),
        status: 'In Progress',
        progress: Progress(completionPercentage: 45.0, currentStep: 2),
        enrolledAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(color: lime300),
        ),
      );
    }

    // Detect screen width for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768; // Tablet breakpoint

    return Scaffold(
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        color: lime300,
        backgroundColor: cardBackground,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 1152),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 24 : 103.5,
                  isMobile ? 88 : 88,
                  isMobile ? 24 : 103.5,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Header Section
                    _buildWelcomeHeader(isMobile: isMobile),
                    
                    const SizedBox(height: 24),
                    
                    // Stats Cards - Grid on mobile, Row on desktop
                    isMobile ? _buildStatsGrid() : _buildStatsRow(),
                    
                    const SizedBox(height: 24),
                    
                    // Action Cards - Stacked on mobile, Row on desktop
                    isMobile ? _buildActionCardsColumn() : _buildActionCardsRow(),
                    
                    const SizedBox(height: 24),
                    
                    // Past Recordings Card
                    _buildPastRecordingsCard(isMobile: isMobile),
                    
                    const SizedBox(height: 24),
                    
                    // Progress and Achievements - Stacked on mobile, Row on desktop
                    isMobile
                        ? Column(
                            children: [
                              _buildProgressCard(),
                              const SizedBox(height: 24),
                              _buildAchievementsCard(),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildProgressCard()),
                              const SizedBox(width: 24),
                              Expanded(child: _buildAchievementsCard()),
                            ],
                          ),
                    
                    const SizedBox(height: 24),
                    
                    // Performance Analytics - Responsive layout
                    _buildPerformanceAnalytics(isMobile: isMobile),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $_userName! 👋',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 24 : 24,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            height: 1.5,
            letterSpacing: 0.0703,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You\'re on a 7-day streak! Keep the momentum going.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 16 : 16,
            fontWeight: FontWeight.normal,
            color: textSecondary,
            height: isMobile ? 1.5 : 1.5,
            letterSpacing: -0.31,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('7', 'Day Streak', Icons.local_fire_department, lime300)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('24', 'Lessons Done', Icons.book, emerald400)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('12.5h', 'Learning Time', Icons.access_time, teal400)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('2450', 'Total Points', Icons.stars, cyan400)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCardsColumn() {
    return Column(
      children: [
        _buildActionCard(
          icon: Icons.play_circle_filled,
          title: 'Try Interactive Demo',
          subtitle: 'Experience real sales scenarios',
          buttonText: 'Start Demo',
          iconColor: lime300,
          borderColor: lime300.withOpacity(0.3),
          buttonColor: lime300,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SessionLiveScreen(api: widget.api),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          icon: Icons.school,
          title: 'Continue Learning',
          subtitle: 'Pick up where you left off',
          buttonText: 'Resume',
          iconColor: textPrimary,
          borderColor: cardBorder,
          buttonColor: Colors.transparent,
          onPressed: () {
            if (_enrollments.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SessionLiveScreen(api: widget.api),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          icon: Icons.psychology,
          title: 'Practice with AI',
          subtitle: 'Sharpen your skills with AI roleplay',
          buttonText: 'Practice',
          iconColor: textPrimary,
          borderColor: cardBorder,
          buttonColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SessionLiveScreen(api: widget.api),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('7', 'Day Streak', Icons.local_fire_department, lime300)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('24', 'Lessons Done', Icons.book, emerald400)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('12.5h', 'Learning Time', Icons.access_time, teal400)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('2450', 'Total Points', Icons.stars, cyan400)),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      padding: const EdgeInsets.all(17),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  color: iconColor,
                  height: 1.33,
                  letterSpacing: 0.0703,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: textSecondary,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCardsRow() {
    return Row(
      children: [
        Expanded(child: _buildActionCard(
          icon: Icons.play_circle_filled,
          title: 'Try Interactive Demo',
          subtitle: 'Experience real sales scenarios',
          buttonText: 'Start Demo',
          iconColor: lime300,
          borderColor: lime300.withOpacity(0.3),
          buttonColor: lime300,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SessionLiveScreen(api: widget.api),
              ),
            );
          },
        )),
        const SizedBox(width: 16),
        Expanded(child: _buildActionCard(
          icon: Icons.school,
          title: 'Continue Learning',
          subtitle: 'Pick up where you left off',
          buttonText: 'Resume',
          iconColor: textPrimary,
          borderColor: cardBorder,
          buttonColor: Colors.transparent,
          onPressed: () {
            if (_enrollments.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SessionLiveScreen(api: widget.api),
                ),
              );
            }
          },
        )),
        const SizedBox(width: 16),
        Expanded(child: _buildActionCard(
          icon: Icons.psychology,
          title: 'Practice with AI',
          subtitle: 'Sharpen your skills with AI roleplay',
          buttonText: 'Practice',
          iconColor: textPrimary,
          borderColor: cardBorder,
          buttonColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SessionLiveScreen(api: widget.api),
              ),
            );
          },
        )),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required Color iconColor,
    required Color borderColor,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor == lime300 
                      ? iconColor.withOpacity(0.2) 
                      : darkSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textPrimary,
                        height: 1.5,
                        letterSpacing: -0.31,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        height: 1.43,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonColor == lime300 ? Colors.black : textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: buttonColor == lime300 ? Colors.black : textPrimary,
                      letterSpacing: -0.15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: buttonColor == lime300 ? Colors.black : textPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastRecordingsCard({bool isMobile = false}) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: darkSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.video_library,
                  size: 24,
                  color: textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Past Recordings',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textPrimary,
                        letterSpacing: -0.3125,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Review your previous sessions',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        letterSpacing: -0.1504,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecordingsListScreen(api: widget.api),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textPrimary,
                      letterSpacing: -0.1504,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: textPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, size: 20, color: textPrimary),
              const SizedBox(width: 8),
              const Text(
                'Your Progress',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: textPrimary,
                  letterSpacing: -0.31,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Overall Completion
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Completion',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: textPrimary,
                  letterSpacing: -0.31,
                ),
              ),
              Text(
                '${_overallProgress.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: lime300,
                  letterSpacing: -0.31,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: _overallProgress / 100,
              minHeight: 10,
              backgroundColor: lime300.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(lime300),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '32% until next level',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: textSecondary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Points to Next Milestone
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: darkSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Points to Next Milestone',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textPrimary,
                        letterSpacing: -0.15,
                      ),
                    ),
                    const Text(
                      '550 pts',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: lime300,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.55,
                    minHeight: 8,
                    backgroundColor: lime300.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(lime300),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Next Up
          const Text(
            'Next Up:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: textPrimary,
              letterSpacing: -0.15,
            ),
          ),
          const SizedBox(height: 8),
          if (_nextTask != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 1),
              decoration: BoxDecoration(
                color: cardBorder,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: lime300.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.task_alt, size: 20, color: textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nextTask!['title'] ?? 'Continue learning',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: textPrimary,
                            letterSpacing: -0.15,
                          ),
                        ),
                        if (_nextTask!['dueDate'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Due ${_nextTask!['dueDate']}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard() {
    final achievements = [
      {
        'icon': Icons.local_fire_department,
        'title': '7-Day Streak!',
        'description': 'Keep up the momentum',
        'time': 'Today',
        'iconBg': cyan400.withOpacity(0.2),
        'iconColor': cyan400,
        'borderColor': cardBorder,
      },
      {
        'icon': Icons.workspace_premium,
        'title': 'Module Master',
        'description': 'Completed Prospecting Fundamentals',
        'time': '2 days ago',
        'iconBg': emerald400.withOpacity(0.2),
        'iconColor': emerald400,
        'borderColor': cardBorder,
      },
      {
        'icon': Icons.flash_on,
        'title': 'Fast Learner',
        'description': 'Completed 5 lessons in one day',
        'time': '5 days ago',
        'iconBg': lime300.withOpacity(0.2),
        'iconColor': lime300,
        'borderColor': cardBorder,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, size: 20, color: textPrimary),
              const SizedBox(width: 8),
              const Text(
                'Recent Achievements',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: textPrimary,
                  letterSpacing: -0.31,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...achievements.map((achievement) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: achievement['borderColor'] as Color),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: achievement['iconBg'] as Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      achievement['icon'] as IconData,
                      size: 20,
                      color: achievement['iconColor'] as Color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: textPrimary,
                            letterSpacing: -0.15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement['description'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement['time'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPerformanceAnalytics({bool isMobile = false}) {
    if (_statistics == null) return const SizedBox.shrink();

    final stats = _statistics!;
    final averages = stats['averages'] as Map<String, dynamic>?;
    if (averages == null) return const SizedBox.shrink();

    final tone = averages['tone'] as Map<String, dynamic>? ?? {};
    final metrics = averages['metrics'] as Map<String, dynamic>? ?? {};
    final engagementScore = averages['engagementScore'] as int?;
    final evaluatorAvg = stats['evaluatorFeedbackAverage'] as int?;
    final totalRecordings = stats['totalRecordings'] as int? ?? 0;
    final totalEvaluations = stats['totalEvaluations'] as int? ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, size: isMobile ? 24 : 24, color: textPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Performance Analytics',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textPrimary,
                        letterSpacing: -0.31,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Based on $totalRecordings recordings and $totalEvaluations evaluations',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Engagement and Evaluator Cards - Stacked on mobile, Row on desktop
          isMobile
              ? Column(
                  children: [
                    _buildStatCardLarge(
                      '${engagementScore ?? 0}%',
                      'Engagement Score',
                      Icons.people,
                      lime300,
                      isMobile: isMobile,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCardLarge(
                      '${evaluatorAvg ?? 0}%',
                      'Evaluator Feedback',
                      Icons.star,
                      emerald400,
                      isMobile: isMobile,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildStatCardLarge(
                      '${engagementScore ?? 0}%',
                      'Engagement Score',
                      Icons.people,
                      lime300,
                      isMobile: isMobile,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCardLarge(
                      '${evaluatorAvg ?? 0}%',
                      'Evaluator Feedback',
                      Icons.star,
                      emerald400,
                      isMobile: isMobile,
                    )),
                  ],
                ),
          
          const SizedBox(height: 24),
          
          // Tone & Delivery and Key Metrics - Stacked on mobile, side by side on desktop
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tone & Delivery',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: textPrimary,
                            letterSpacing: -0.31,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (tone['confidence'] != null)
                          _buildStatRow('Confidence', '${tone['confidence']}%', emerald400),
                        if (tone['enthusiasm'] != null)
                          _buildStatRow('Enthusiasm', '${tone['enthusiasm']}%', cyan400),
                        if (tone['clarity'] != null)
                          _buildStatRow('Clarity', '${tone['clarity']}%', lime300),
                        if (tone['professionalism'] != null)
                          _buildStatRow('Professionalism', '${tone['professionalism']}%', emerald400),
                        if (tone['friendliness'] != null)
                          _buildStatRow('Friendliness', '${tone['friendliness']}%', textPrimary),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Key Metrics',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: textPrimary,
                            letterSpacing: -0.31,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (metrics['questionQuality'] != null)
                          _buildStatRow('Question Quality', '${metrics['questionQuality']}%', textPrimary),
                        if (metrics['objectionHandling'] != null)
                          _buildStatRow('Objection Handling', '${metrics['objectionHandling']}%', cyan400),
                        if (metrics['rapportScore'] != null)
                          _buildStatRow('Rapport Score', '${metrics['rapportScore']}%', emerald400),
                      ],
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tone & Delivery',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: textPrimary,
                              letterSpacing: -0.31,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (tone['confidence'] != null)
                            _buildStatRow('Confidence', '${tone['confidence']}%', emerald400),
                          if (tone['enthusiasm'] != null)
                            _buildStatRow('Enthusiasm', '${tone['enthusiasm']}%', cyan400),
                          if (tone['clarity'] != null)
                            _buildStatRow('Clarity', '${tone['clarity']}%', lime300),
                          if (tone['professionalism'] != null)
                            _buildStatRow('Professionalism', '${tone['professionalism']}%', emerald400),
                          if (tone['friendliness'] != null)
                            _buildStatRow('Friendliness', '${tone['friendliness']}%', textPrimary),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Key Metrics',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: textPrimary,
                              letterSpacing: -0.31,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (metrics['questionQuality'] != null)
                            _buildStatRow('Question Quality', '${metrics['questionQuality']}%', textPrimary),
                          if (metrics['objectionHandling'] != null)
                            _buildStatRow('Objection Handling', '${metrics['objectionHandling']}%', cyan400),
                          if (metrics['rapportScore'] != null)
                            _buildStatRow('Rapport Score', '${metrics['rapportScore']}%', emerald400),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildStatCardLarge(String value, String label, IconData icon, Color color, {bool isMobile = false}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 30 : 30,
                  fontWeight: FontWeight.normal,
                  color: color,
                  height: 1.2,
                  letterSpacing: 0.3955,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: textPrimary,
                  letterSpacing: -0.15,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(icon, size: isMobile ? 32 : 32, color: color),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: textPrimary,
              letterSpacing: -0.31,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
            decoration: BoxDecoration(
              color: color == textPrimary 
                  ? const Color(0x661A2E23) 
                  : color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color == textPrimary ? textPrimary : color,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
