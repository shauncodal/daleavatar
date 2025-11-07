import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'comments_modal.dart';
import 'recording_detail.dart';

class MemberDetailsScreen extends StatelessWidget {
  final String memberId;
  final String memberName;
  final String memberInitials;
  final String memberRole;
  final String memberEmail;
  final String memberStatus;
  final Color memberStatusColor;
  final String joinedDate;

  const MemberDetailsScreen({
    super.key,
    required this.memberId,
    required this.memberName,
    required this.memberInitials,
    required this.memberRole,
    required this.memberEmail,
    required this.memberStatus,
    required this.memberStatusColor,
    required this.joinedDate,
  });

  @override
  Widget build(BuildContext context) {
    // Design colors from Figma
    const backgroundColor = Color(0xFF000000); // Black
    const cardBackground = Color(0xFF0A0E14); // Dark card
    const cardBorder = Color(0xFF1A2E23); // Border
    const textPrimary = Color(0xFFE8EAEF); // Primary text
    const textSecondary = Color(0xFFA1A7B8); // Secondary text
    const limeColor = Color(0xFFBEF264); // Lime-300
    const headerBorder = Color(0xFF1A2E23); // Border

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: cardBackground,
              border: Border(
                bottom: BorderSide(
                  color: headerBorder,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, size: 16, color: textPrimary),
                    label: Text(
                      'Back to Team',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ),
                ),
                // Title (centered)
                Expanded(
                  child: Center(
                    child: Text(
                      'Team Member Details',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textPrimary,
                        letterSpacing: -0.31,
                      ),
                    ),
                  ),
                ),
                // Right spacer
                SizedBox(width: 136),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(103.5, 24, 103.5, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Card
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Color((limeColor.value & 0x00FFFFFF) | 0x33000000),
                          child: Text(
                            memberInitials,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: limeColor,
                              letterSpacing: -0.45,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    memberName,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: textPrimary,
                                      letterSpacing: -0.31,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Color((memberStatusColor.value & 0x00FFFFFF) | 0x1A000000),
                                      border: Border.all(
                                        color: Color((memberStatusColor.value & 0x00FFFFFF) | 0x33000000),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      memberStatus,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: memberStatusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                memberRole,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: textSecondary,
                                  letterSpacing: -0.31,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                memberEmail,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: textSecondary,
                                  letterSpacing: -0.15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Joined $joinedDate',
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
                        // Message Button
                        TextButton.icon(
                          onPressed: () {
                            // Message action
                          },
                          icon: Icon(Icons.message_outlined, size: 16, color: textPrimary),
                          label: Text(
                            'Message',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Performance Overview Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Performance Overview',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: textPrimary,
                          letterSpacing: -0.31,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.calendar_today, size: 16, color: textPrimary),
                            onPressed: () {},
                          ),
                          Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.transparent),
                            ),
                            child: DropdownButton<String>(
                              value: 'Last 30 Days',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: textPrimary,
                                letterSpacing: -0.15,
                              ),
                              underline: Container(),
                              icon: Icon(Icons.arrow_drop_down, size: 16, color: textPrimary),
                              items: ['Last 7 Days', 'Last 30 Days', 'Last 90 Days'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Performance Metrics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildPerformanceMetricCard(
                          icon: Icons.video_collection_outlined,
                          label: 'Total Recordings',
                          value: '4',
                          valueColor: limeColor,
                          period: 'Last 30 Days',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPerformanceMetricCard(
                          icon: Icons.bar_chart_outlined,
                          label: 'Average Score',
                          value: '65',
                          valueColor: const Color(0xFF00BC7D),
                          period: null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPerformanceMetricCard(
                          icon: Icons.people_outline,
                          label: 'Avg Engagement',
                          value: '63',
                          valueColor: const Color(0xFF2B7FFF),
                          period: null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPerformanceMetricCard(
                          icon: Icons.self_improvement_outlined,
                          label: 'Avg Confidence',
                          value: '59',
                          valueColor: const Color(0xFFAD46FF),
                          period: null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Past Recordings
                  Text(
                    'Past Recordings',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: textPrimary,
                      letterSpacing: -0.31,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Recording Cards (mock data)
                  Column(
                    children: [
                      _buildRecordingCard(
                        context: context,
                        title: 'Q4 Product Pitch Practice',
                        status: 'COMPLETED',
                        date: 'Nov 3, 2025',
                        time: '2:30 PM',
                        duration: '4:32',
                        overallScore: '68',
                        engagementScore: '65',
                        confidenceScore: '60',
                        commentCount: 1,
                      ),
                      const SizedBox(height: 12),
                      _buildRecordingCard(
                        context: context,
                        title: 'Customer Objection Handling',
                        status: 'COMPLETED',
                        date: 'Oct 30, 2025',
                        time: '10:15 AM',
                        duration: '5:18',
                        overallScore: '62',
                        engagementScore: '58',
                        confidenceScore: '55',
                        commentCount: 2,
                      ),
                      const SizedBox(height: 12),
                      _buildRecordingCard(
                        context: context,
                        title: 'Discovery Call Simulation',
                        status: 'COMPLETED',
                        date: 'Oct 28, 2025',
                        time: '9:00 AM',
                        duration: '6:45',
                        overallScore: '71',
                        engagementScore: '72',
                        confidenceScore: '68',
                        commentCount: 0,
                      ),
                      const SizedBox(height: 12),
                      _buildRecordingCard(
                        context: context,
                        title: 'Cold Call Practice',
                        status: 'COMPLETED',
                        date: 'Oct 25, 2025',
                        time: '1:20 PM',
                        duration: '3:15',
                        overallScore: '58',
                        engagementScore: '55',
                        confidenceScore: '52',
                        commentCount: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    String? period,
  }) {
    const cardBackground = Color(0xFF0A0E14);
    const cardBorder = Color(0xFF1A2E23);
    const textSecondary = Color(0xFFA1A7B8);

    return Container(
      padding: const EdgeInsets.all(17),
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
              Icon(icon, size: 14, color: textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.normal,
              color: valueColor,
              letterSpacing: 0.07,
            ),
          ),
          if (period != null) ...[
            const SizedBox(height: 16),
            Text(
              period,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecordingCard({
    required BuildContext context,
    required String title,
    required String status,
    required String date,
    required String time,
    required String duration,
    required String overallScore,
    required String engagementScore,
    required String confidenceScore,
    required int commentCount,
  }) {
    const cardBackground = Color(0xFF0A0E14);
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);
    const limeColor = Color(0xFFBEF264);

    // Determine overall score color based on value
    final int overallInt = int.tryParse(overallScore) ?? 0;
    final Color overallColor = overallInt >= 70
        ? const Color(0xFF2B7FFF)
        : overallInt >= 60
            ? const Color(0xFFFF6900)
            : const Color(0xFFFF6900);

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
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textPrimary,
                        letterSpacing: -0.31,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0x1A00BC7D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF00BC7D),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        letterSpacing: -0.15,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 14, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        letterSpacing: -0.15,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Duration: $duration',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Scores - wrapped in Flexible to prevent overflow
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      overallScore,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: overallColor,
                        letterSpacing: -0.31,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      'Overall',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      engagementScore,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        letterSpacing: -0.31,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      'Engagement',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      confidenceScore,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        letterSpacing: -0.31,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      'Confidence',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Actions - wrapped in Flexible to prevent overflow
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextButton.icon(
                    onPressed: () {
                      // Create recording map for the detail screen
                      // Format date to ISO format for proper parsing
                      String formattedDate;
                      try {
                        // Parse date string like "Nov 3, 2025" or "Oct 30, 2025"
                        final parsedDate = intl.DateFormat('MMM d, yyyy').parse(date);
                        formattedDate = parsedDate.toIso8601String();
                      } catch (e) {
                        // Fallback: use current date if parsing fails
                        formattedDate = DateTime.now().toIso8601String();
                      }
                      
                      final recording = {
                        'id': title.toLowerCase().replaceAll(' ', '_'),
                        'title': title,
                        'created_at': formattedDate,
                        'duration': duration,
                        'overall_score': int.tryParse(overallScore) ?? 0,
                        'engagement_score': int.tryParse(engagementScore) ?? 0,
                        'confidence_score': int.tryParse(confidenceScore) ?? 0,
                        'status': status.toLowerCase(),
                      };
                      
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
                    icon: Icon(Icons.description_outlined, size: 16, color: textPrimary),
                    label: Flexible(
                      child: Text(
                        'View Report',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textPrimary,
                          letterSpacing: -0.15,
                          height: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CommentsModal(
                          recordingTitle: title,
                          recordingDate: date,
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: Icon(Icons.comment_outlined, size: 16, color: textPrimary),
                    label: Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Comments',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                                letterSpacing: -0.15,
                                height: 1.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (commentCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: limeColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '$commentCount',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
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
}

