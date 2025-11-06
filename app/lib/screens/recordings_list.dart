import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../services/backend_api.dart';
import 'recording_detail.dart';

class RecordingsListScreen extends StatefulWidget {
  final BackendApi api;
  final bool showAppBar;
  const RecordingsListScreen({super.key, required this.api, this.showAppBar = true});

  @override
  State<RecordingsListScreen> createState() => _RecordingsListScreenState();
}

class _RecordingsListScreenState extends State<RecordingsListScreen> {
  List<dynamic> _items = const [];
  bool _loading = false;

  // Figma Design Colors
  static const backgroundColor = Color(0xFF000000); // Black
  static const cardBackground = Color(0xFF0A0E14); // Dark card
  static const cardBorder = Color(0xFF1A2E23); // Border color
  static const textPrimary = Color(0xFFE8EAEF); // Primary text
  static const textSecondary = Color(0xFFA1A7B8); // Secondary text
  static const lime300 = Color(0xFFBEF264); // Lime-300
  static const emerald400 = Color(0xFF00BC7D); // Emerald-400
  static const blue400 = Color(0xFF2B7FFF); // Blue-400
  static const amber400 = Color(0xFFF0B100); // Amber-400
  static const orange400 = Color(0xFFFF6900); // Orange-400

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await widget.api.listRecordings();
      setState(() {
        _items = (res['items'] as List);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading recordings: $e')),
        );
      }
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateStr);
      return intl.DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return 'Unknown time';
    try {
      final date = DateTime.parse(dateStr);
      return intl.DateFormat('h:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDuration(int? durationMs) {
    if (durationMs == null) return '0:00';
    final seconds = durationMs ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getScoreColor(int score) {
    if (score >= 85) return emerald400;
    if (score >= 75) return amber400;
    if (score >= 65) return orange400;
    return textSecondary;
  }

  Map<String, dynamic> _getMockScores(Map<String, dynamic> recording) {
    // Mock scores based on recording ID or use actual data if available
    final id = recording['id'] as int? ?? 0;
    return {
      'overall': 80 + (id % 15),
      'engagement': 85 + (id % 10),
      'confidence': 75 + (id % 15),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: widget.showAppBar ? _buildAppBar(isMobile: isMobile) : null,
      body: _loading && _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 103.5,
                  vertical: isMobile ? 24 : 88,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Cards Row
                    _buildStatsRow(isMobile: isMobile),
                    const SizedBox(height: 24),
                    // All Recordings Title
                    const Text(
                      'All Recordings',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textPrimary,
                        letterSpacing: -0.3125,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Recordings List
                    if (_items.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(64),
                          child: Column(
                            children: [
                              const Icon(Icons.video_library_outlined, size: 64, color: textSecondary),
                              const SizedBox(height: 16),
                              const Text(
                                'No recordings yet',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._items.map((recording) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildRecordingCard(recording as Map<String, dynamic>, isMobile: isMobile),
                          )),
                  ],
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar({bool isMobile = false}) {
    return AppBar(
      backgroundColor: cardBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: isMobile
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 20,
                color: textPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: textPrimary,
                  ),
                  SizedBox(width: 8),
                  Text(
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
      title: const Text(
        'Past Recordings',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
          letterSpacing: -0.3125,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: cardBorder,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow({bool isMobile = false}) {
    final totalSessions = _items.length;
    final avgScore = _items.isEmpty
        ? 0
        : (_items.map((r) => _getMockScores(r as Map<String, dynamic>)['overall'] as int).reduce((a, b) => a + b) /
            _items.length)
            .round();
    final totalDuration = _items.isEmpty
        ? 0
        : _items.map((r) => (r as Map<String, dynamic>)['duration_ms'] as int? ?? 0).reduce((a, b) => a + b);
    final totalMinutes = totalDuration ~/ 60000;
    final totalSeconds = (totalDuration % 60000) ~/ 1000;

    if (isMobile) {
      return Column(
        children: [
          _buildStatCard(
            icon: Icons.video_library,
            iconColor: lime300,
            iconBgColor: lime300.withOpacity(0.1),
            label: 'Total Sessions',
            value: totalSessions.toString(),
            valueColor: lime300,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            icon: Icons.assessment,
            iconColor: emerald400,
            iconBgColor: emerald400.withOpacity(0.1),
            label: 'Average Score',
            value: avgScore.toString(),
            valueColor: emerald400,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            icon: Icons.access_time,
            iconColor: blue400,
            iconBgColor: blue400.withOpacity(0.1),
            label: 'Total Practice Time',
            value: '$totalMinutes min $totalSeconds sec',
            valueColor: blue400,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.video_library,
            iconColor: lime300,
            iconBgColor: lime300.withOpacity(0.1),
            label: 'Total Sessions',
            value: totalSessions.toString(),
            valueColor: lime300,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.assessment,
            iconColor: emerald400,
            iconBgColor: emerald400.withOpacity(0.1),
            label: 'Average Score',
            value: avgScore.toString(),
            valueColor: emerald400,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.access_time,
            iconColor: blue400,
            iconBgColor: blue400.withOpacity(0.1),
            label: 'Total Practice Time',
            value: '$totalMinutes min $totalSeconds sec',
            valueColor: blue400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      height: 74,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: textSecondary,
                    letterSpacing: 0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: valueColor,
                    letterSpacing: -0.3125,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingCard(Map<String, dynamic> recording, {bool isMobile = false}) {
    final scores = _getMockScores(recording);
    final dateStr = _formatDate(recording['created_at']?.toString());
    final timeStr = _formatTime(recording['created_at']?.toString());
    final duration = _formatDuration(recording['duration_ms'] as int?);
    final title = 'Simulation ${dateStr} - $timeStr';

    if (isMobile) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: textPrimary,
                      letterSpacing: -0.3125,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: emerald400.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'COMPLETE',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: emerald400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildMetadataItem(Icons.calendar_today, dateStr),
                _buildMetadataItem(Icons.access_time, timeStr),
                _buildMetadataItem(Icons.play_circle_outline, duration),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreColumn('Overall', scores['overall'] as int),
                _buildScoreColumn('Engagement', scores['engagement'] as int),
                _buildScoreColumn('Confidence', scores['confidence'] as int),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RecordingDetailScreen(recording: recording),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View Report',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                        letterSpacing: -0.1504,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
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

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          // Left side - Title and metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: textPrimary,
                          letterSpacing: -0.3125,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: emerald400.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'COMPLETE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: emerald400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  children: [
                    _buildMetadataItem(Icons.calendar_today, dateStr),
                    _buildMetadataItem(Icons.access_time, timeStr),
                    _buildMetadataItem(Icons.play_circle_outline, duration),
                  ],
                ),
              ],
            ),
          ),
          // Right side - Scores and button
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScoreColumn('Overall', scores['overall'] as int),
                const SizedBox(width: 16),
                _buildScoreColumn('Engagement', scores['engagement'] as int),
                const SizedBox(width: 16),
                _buildScoreColumn('Confidence', scores['confidence'] as int),
                const SizedBox(width: 16),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RecordingDetailScreen(recording: recording),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'View Report',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                              letterSpacing: -0.1504,
                              height: 1.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 14,
          color: textSecondary,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: textSecondary,
              letterSpacing: -0.1504,
              height: 1.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreColumn(String label, int score) {
    final color = _getScoreColor(score);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          child: Text(
            score.toString(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: color,
              letterSpacing: -0.3125,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 16,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: textSecondary,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
