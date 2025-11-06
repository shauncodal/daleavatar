import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'add_note_modal.dart';

class RecordingDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recording;
  const RecordingDetailScreen({super.key, required this.recording});

  @override
  State<RecordingDetailScreen> createState() => _RecordingDetailScreenState();
}

class _RecordingDetailScreenState extends State<RecordingDetailScreen> {
  List<Map<String, String>> _notes = [
    {'timestamp': '0:45', 'note': 'Good opening - warm and confident'},
    {'timestamp': '2:18', 'note': 'Need to work on active listening here'},
  ];

  // Figma Design Colors
  static const backgroundColor = Color(0xFF000000); // Black
  static const cardBackground = Color(0xFF0A0E14); // Dark card
  static const cardBorder = Color(0xFF1A2E23); // Border color
  static const textPrimary = Color(0xFFE8EAEF); // Primary text
  static const textSecondary = Color(0xFFA1A7B8); // Secondary text
  static const lime300 = Color(0xFFBEF264); // Lime-300
  static const emerald400 = Color(0xFF00BC7D); // Emerald-400
  static const blue400 = Color(0xFF2B7FFF); // Blue-400
  static const purple400 = Color(0xFFAD46FF); // Purple-400
  static const orange400 = Color(0xFFFF6900); // Orange-400
  static const cyan400 = Color(0xFF00BBA7); // Cyan-400
  static const red400 = Color(0xFFFB2C36); // Red-400
  static const amber400 = Color(0xFFD08700); // Amber-400

  // Mocked sales performance data
  Map<String, dynamic> _generateMockReport() {
    return {
      'engagement': {
        'questionsAsked': 12,
        'responsesGiven': 8,
        'interruptions': 2,
        'listeningTime': 65, // percentage
        'talkingTime': 35, // percentage
        'engagementScore': 87,
      },
      'tone': {
        'confidence': 78,
        'enthusiasm': 82,
        'pace': 68, // words per minute
        'professionalism': 88,
        'friendliness': 75,
      },
      'mistakes': [
        {
          'type': 'Interrupted Customer',
          'severity': 'high',
          'description': 'You interrupted the customer while they were explaining their needs. Allow customers to finish their thoughts before responding.',
          'timestamp': '00:45',
          'impact': 'May have caused frustration and hindered rapport building',
        },
        {
          'type': 'Missed Objection Handling',
          'severity': 'medium',
          'description': 'Customer raised a pricing concern that wasn\'t fully addressed. Practice acknowledging objections directly.',
          'timestamp': '02:18',
          'impact': 'Could lead to lost opportunity if not addressed',
        },
        {
          'type': 'Speaking Too Quickly',
          'severity': 'medium',
          'description': 'Your speaking pace increased to 95 WPM during the product explanation. Try to maintain a steady pace of 60-70 WPM.',
          'timestamp': '03:22',
          'impact': 'May reduce comprehension and appear rushed',
        },
      ],
      'insights': [
        {
          'title': 'Excellent Opening',
          'description': 'Your introduction was warm and professional, establishing rapport quickly. You successfully built trust in the first 30 seconds.',
          'score': 'positive',
        },
        {
          'title': 'Strong Product Knowledge',
          'description': 'You demonstrated deep understanding of the product features and benefits, answering questions confidently.',
          'score': 'positive',
        },
        {
          'title': 'Work on Active Listening',
          'description': 'Practice pausing before responding to show you\'re processing what the customer said. This builds trust and prevents interruptions.',
          'score': 'improvement',
        },
        {
          'title': 'Strengthen Closing Technique',
          'description': 'You made only one closing attempt. Consider using trial closes throughout the conversation to gauge interest.',
          'score': 'improvement',
        },
      ],
      'keyMetrics': {
        'totalDuration': '4:32',
        'speakingRatio': '35% You / 65% Customer',
        'objectionHandling': '2 of 3 addressed',
        'closingAttempts': 1,
        'engagementScore': 87,
        'confidenceScore': 78,
        'overallScore': 82,
        'rapportScore': 72,
        'questionQuality': 85,
      },
    };
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateStr);
      return intl.DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTitle(String? dateStr) {
    if (dateStr == null) return 'Simulation';
    try {
      final date = DateTime.parse(dateStr);
      return 'Simulation ${intl.DateFormat('MMM d').format(date)} - ${intl.DateFormat('h:mm a').format(date)}';
    } catch (e) {
      return 'Simulation';
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = _generateMockReport();
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 103.5,
          vertical: isMobile ? 24 : 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recording Playback & Notes Section
            _buildPlaybackSection(context, isMobile),
            const SizedBox(height: 24),
            
            // Report Header Card
            _buildReportHeader(context, report),
            const SizedBox(height: 24),
            
            // Key Metrics Grid
            _buildKeyMetrics(context, report, isMobile),
            const SizedBox(height: 24),
            
            // Engagement Analysis
            _buildEngagementAnalysis(context, report),
            const SizedBox(height: 24),
            
            // Tone & Delivery
            _buildToneDelivery(context, report),
            const SizedBox(height: 24),
            
            // Areas for Improvement
            _buildAreasForImprovement(context, report),
            const SizedBox(height: 24),
            
            // Key Insights
            _buildKeyInsights(context, report),
            const SizedBox(height: 24),
            
            // Sales Performance
            _buildSalesPerformance(context, report),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final title = _formatTitle(widget.recording['created_at']?.toString());
    
    return AppBar(
      backgroundColor: cardBackground,
      elevation: 0,
      leading: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.arrow_back,
              size: 16,
              color: textPrimary,
            ),
            const SizedBox(width: 8),
            const Text(
              'Back',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textPrimary,
                letterSpacing: -0.1504,
              ),
            ),
          ],
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
          letterSpacing: -0.3125,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {
            // Share functionality
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6.5),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.share,
                size: 16,
                color: textPrimary,
              ),
              const SizedBox(width: 8),
              const Text(
                'Share',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                  letterSpacing: -0.1504,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildPlaybackSection(BuildContext context, bool isMobile) {
    return isMobile
        ? Column(
            children: [
              _buildVideoPlayer(context),
              const SizedBox(height: 12),
              _buildNotesPanel(context),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildVideoPlayer(context),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 368,
                child: _buildNotesPanel(context),
              ),
            ],
          );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recording Playback',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimary,
            letterSpacing: -0.3125,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 548,
          decoration: BoxDecoration(
            color: cardBackground,
            border: Border.all(color: cardBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            children: [
              // Placeholder video area
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: lime300.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_circle_outline,
                        size: 48,
                        color: lime300,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Simulated Recording Playback',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textPrimary,
                        letterSpacing: -0.1504,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '0:00 / 4:32',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Controls at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            '0:00',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFF141820),
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: lime300,
                                    borderRadius: BorderRadius.circular(1000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            '4:32',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.skip_previous, size: 16, color: textPrimary),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.play_arrow, size: 16, color: textPrimary),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.fullscreen, size: 16, color: textPrimary),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Notes',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: textPrimary,
                letterSpacing: -0.3125,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Get current playback time (mock for now, would be actual video time)
                final currentTime = '0:00'; // TODO: Get actual video playback time
                
                showDialog(
                  context: context,
                  builder: (context) => AddNoteModal(
                    currentTimestamp: currentTime,
                    onSaveNote: (timestamp, note) {
                      setState(() {
                        _notes.add({
                          'timestamp': timestamp,
                          'note': note,
                        });
                      });
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lime300,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Add Note',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.1504,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: _notes.map((note) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildNoteCard(note['timestamp']!, note['note']!),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNoteCard(String timestamp, String note) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: cardBackground,
        border: Border.all(color: cardBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timestamp,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: lime300,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16, color: textSecondary),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: textPrimary,
              letterSpacing: -0.1504,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportHeader(BuildContext context, Map<String, dynamic> report) {
    final dateStr = _formatDate(widget.recording['created_at']?.toString());
    final duration = report['keyMetrics']['totalDuration'];
    
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: cardBackground,
        border: Border.all(color: cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: textSecondary,
                      letterSpacing: -0.1504,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Duration: $duration minutes',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: textSecondary,
                  letterSpacing: -0.1504,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: emerald400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'COMPLETE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildScoreColumn('Engagement', report['engagement']['engagementScore'] as int),
              const SizedBox(width: 32),
              _buildScoreColumn('Confidence', report['tone']['confidence'] as int),
              const SizedBox(width: 32),
              _buildScoreColumn('Overall', report['keyMetrics']['overallScore'] as int),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(String label, int score) {
    return Column(
      children: [
        Text(
          score.toString(),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: emerald400,
            letterSpacing: -0.3125,
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
          ),
        ),
      ],
    );
  }

  Widget _buildKeyMetrics(BuildContext context, Map<String, dynamic> report, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Metrics',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimary,
            letterSpacing: -0.3125,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: isMobile ? 1 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            _buildMetricCard('Engagement Score', report['engagement']['engagementScore'] as int, blue400),
            _buildMetricCard('Confidence Level', report['tone']['confidence'] as int, emerald400),
            _buildMetricCard('Rapport Building', report['keyMetrics']['rapportScore'] as int, purple400),
            _buildMetricCard('Question Quality', report['keyMetrics']['questionQuality'] as int, cyan400),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardBackground,
        border: Border.all(color: cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: color,
                  letterSpacing: -0.3125,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: textSecondary,
                  letterSpacing: -0.1504,
                ),
              ),
            ],
          ),
          const Icon(Icons.trending_up, size: 20, color: textSecondary),
        ],
      ),
    );
  }

  Widget _buildEngagementAnalysis(BuildContext context, Map<String, dynamic> report) {
    final engagement = report['engagement'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Engagement Analysis',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimary,
            letterSpacing: -0.3125,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            color: cardBackground,
            border: Border.all(color: cardBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _buildProgressBar('Listening Time', engagement['listeningTime'] as int, blue400),
              const SizedBox(height: 40),
              _buildProgressBar('Talking Time', engagement['talkingTime'] as int, orange400),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 140.867),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem('Questions Asked', engagement['questionsAsked'] as int),
                    _buildStatItem('Responses Given', engagement['responsesGiven'] as int),
                    _buildStatItem('Interruptions', engagement['interruptions'] as int),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: textPrimary,
                letterSpacing: -0.1504,
              ),
            ),
            Text(
              '$value%',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: textPrimary,
                letterSpacing: -0.1504,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF141820),
            borderRadius: BorderRadius.circular(1000),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: emerald400,
            letterSpacing: -0.3125,
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
          ),
        ),
      ],
    );
  }

  Widget _buildToneDelivery(BuildContext context, Map<String, dynamic> report) {
    final tone = report['tone'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tone & Delivery',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimary,
            letterSpacing: -0.3125,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            color: cardBackground,
            border: Border.all(color: cardBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _buildProgressBar('Confidence', tone['confidence'] as int, emerald400),
              const SizedBox(height: 36),
              _buildProgressBar('Enthusiasm', tone['enthusiasm'] as int, orange400),
              const SizedBox(height: 36),
              _buildProgressBar('Professionalism', tone['professionalism'] as int, blue400),
              const SizedBox(height: 36),
              _buildProgressBar('Friendliness', tone['friendliness'] as int, purple400),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Speaking Pace',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: textPrimary,
                      letterSpacing: -0.1504,
                    ),
                  ),
                  Text(
                    '${tone['pace']} WPM',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: textPrimary,
                      letterSpacing: -0.3125,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAreasForImprovement(BuildContext context, Map<String, dynamic> report) {
    final mistakes = report['mistakes'] as List;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Areas for Improvement',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimary,
            letterSpacing: -0.3125,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: mistakes.map((mistake) {
            Color bgColor;
            Color borderColor;
            Color textColor;
            
            switch (mistake['severity']) {
              case 'high':
                bgColor = red400.withOpacity(0.1);
                borderColor = red400.withOpacity(0.2);
                textColor = red400;
                break;
              case 'medium':
                bgColor = orange400.withOpacity(0.1);
                borderColor = orange400.withOpacity(0.2);
                textColor = orange400;
                break;
              default:
                bgColor = amber400.withOpacity(0.1);
                borderColor = amber400.withOpacity(0.2);
                textColor = amber400;
            }
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning, size: 24, color: textColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mistake['type'],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: textColor,
                            letterSpacing: -0.3125,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mistake['description'],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: textPrimary,
                            letterSpacing: -0.1504,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Time: ${mistake['timestamp']}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Impact: ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: textSecondary,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                mistake['impact'],
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKeyInsights(BuildContext context, Map<String, dynamic> report) {
    final insights = report['insights'] as List;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Insights',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimary,
            letterSpacing: -0.3125,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: insights.map((insight) {
            final isPositive = insight['score'] == 'positive';
            final bgColor = isPositive ? emerald400.withOpacity(0.1) : orange400.withOpacity(0.1);
            final borderColor = isPositive ? emerald400.withOpacity(0.2) : orange400.withOpacity(0.2);
            final textColor = isPositive ? emerald400 : orange400;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isPositive ? Icons.check_circle : Icons.info,
                    size: 24,
                    color: textColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          insight['title'],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                            letterSpacing: -0.4395,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          insight['description'],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: textPrimary,
                            letterSpacing: -0.1504,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSalesPerformance(BuildContext context, Map<String, dynamic> report) {
    final metrics = report['keyMetrics'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sales Performance',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimary,
            letterSpacing: -0.3125,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            color: cardBackground,
            border: Border.all(color: cardBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _buildSalesMetric('Total Duration', metrics['totalDuration']),
              const Divider(color: cardBorder, height: 1),
              _buildSalesMetric('Speaking Ratio', metrics['speakingRatio']),
              const Divider(color: cardBorder, height: 1),
              _buildSalesMetric('Objection Handling', metrics['objectionHandling']),
              const Divider(color: cardBorder, height: 1),
              _buildSalesMetric('Closing Attempts', '${metrics['closingAttempts']} attempt${metrics['closingAttempts'] != 1 ? 's' : ''}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSalesMetric(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
              letterSpacing: -0.3125,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: textPrimary,
              letterSpacing: -0.3125,
            ),
          ),
        ],
      ),
    );
  }
}
