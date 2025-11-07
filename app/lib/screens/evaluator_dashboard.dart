import 'package:flutter/material.dart';
import 'member_details.dart';

class EvaluatorDashboardScreen extends StatelessWidget {
  const EvaluatorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Design colors from Figma
    const backgroundColor = Color(0xFF000000); // Black
    const cardBackground = Color(0xFF0A0E14); // Dark card
    const cardBorder = Color(0xFF1A2E23); // Border
    const textPrimary = Color(0xFFE8EAEF); // Primary text
    const textSecondary = Color(0xFFA1A7B8); // Secondary text
    const limeColor = Color(0xFFBEF264); // Lime-300
    const headerBorder = Color(0x33BEF264); // Lime with 20% opacity

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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 32,
                      child: Image.asset(
                        'assets/images/dale_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 44,
                      color: cardBorder,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Evaluator Dashboard',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: textPrimary,
                            letterSpacing: -0.44,
                          ),
                        ),
                        Text(
                          'Team Performance Analytics',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.settings, size: 16, color: textPrimary),
                      onPressed: () {
                        // TODO: Open settings panel
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Settings coming soon')),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, size: 16, color: textPrimary),
                      onPressed: () {
                        // Logout action
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.calendar_today, size: 16, color: textPrimary),
                            onPressed: () {
                              // TODO: Open date picker
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Date picker coming soon')),
                              );
                            },
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
                              onChanged: (String? newValue) {
                                // TODO: Update date range filter
                                if (newValue != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Filter changed to: $newValue')),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Show comparison view
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Comparison view coming soon')),
                              );
                            },
                            icon: Icon(Icons.compare_arrows, size: 16, color: textPrimary),
                            label: Text(
                              'Show Comparison',
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
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Export to CSV
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('CSV export coming soon')),
                              );
                            },
                            icon: Icon(Icons.download, size: 16, color: textPrimary),
                            label: Text(
                              'Export CSV',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                                letterSpacing: -0.15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Export to PDF
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('PDF export coming soon')),
                              );
                            },
                            icon: Icon(Icons.picture_as_pdf, size: 16, color: textPrimary),
                            label: Text(
                              'Export PDF',
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
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Team Performance Metrics
                  Text(
                    'Team Performance Metrics',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: textPrimary,
                      letterSpacing: -0.31,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Metrics Cards
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildMetricCard(
                        icon: Icons.people_outline,
                        label: 'Total Members',
                        value: '5',
                        valueColor: limeColor,
                      ),
                      _buildMetricCard(
                        icon: Icons.person_pin_circle_outlined,
                        label: 'Active Members',
                        value: '4',
                        valueColor: const Color(0xFF00BC7D),
                      ),
                      _buildMetricCard(
                        icon: Icons.bar_chart_outlined,
                        label: 'Average Score',
                        value: '75',
                        valueColor: const Color(0xFF10B981), // emerald-400
                      ),
                      _buildMetricCard(
                        icon: Icons.video_collection_outlined,
                        label: 'Total Recordings',
                        value: '83',
                        valueColor: const Color(0xFF2B7FFF),
                      ),
                      _buildMetricCard(
                        icon: Icons.timer_outlined,
                        label: 'Avg Recording Time',
                        value: '5.2 min',
                        valueColor: const Color(0xFFAD46FF),
                      ),
                      _buildMetricCard(
                        icon: Icons.task_alt_outlined,
                        label: 'Completion Rate',
                        value: '78%',
                        valueColor: const Color(0xFF00BBA7),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Alerts & Notifications
                  Row(
                    children: [
                      const Icon(Icons.notifications, size: 20, color: textPrimary),
                      const SizedBox(width: 8),
                      Text(
                        'Alerts & Notifications',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: textPrimary,
                          letterSpacing: -0.31,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0x1AFF6900), // orange with 10% opacity
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '3',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFF6900),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Alert Cards
                  Column(
                    children: [
                      _buildAlertCard(
                        context: context,
                        name: 'Emily Rodriguez',
                        priority: 'HIGH',
                        message: 'No activity in the last 24 hours. Average score dropped by 15% this week.',
                        timestamp: '3:14 PM • Nov 5',
                        priorityColor: const Color(0xFFFB2C36),
                      ),
                      const SizedBox(height: 12),
                      _buildAlertCard(
                        context: context,
                        name: 'Jessica Martinez',
                        priority: 'HIGH',
                        message: 'Hasn\'t completed a recording in 3 days. Below target completion rate.',
                        timestamp: '2:14 PM • Nov 5',
                        priorityColor: const Color(0xFFFB2C36),
                      ),
                      const SizedBox(height: 12),
                      _buildAlertCard(
                        context: context,
                        name: 'Michael Chen',
                        priority: 'MEDIUM',
                        message: 'Confidence scores consistently below 70% in last 5 recordings.',
                        timestamp: '4:14 PM • Nov 4',
                        priorityColor: const Color(0xFFF0B100),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Team Performance
                  Text(
                    'Team Performance',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: textPrimary,
                      letterSpacing: -0.31,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Team Member Cards
                  Column(
                    children: [
                      _buildTeamMemberCard(
                        context: context,
                        initials: 'SJ',
                        name: 'Sarah Johnson',
                        role: 'Sales Rep',
                        status: 'EXCELLING',
                        statusColor: const Color(0xFF00BC7D),
                        recordings: '24',
                        avgScore: '87',
                        avgScoreColor: const Color(0xFF00BC7D),
                        lastActive: '2 hours ago',
                      ),
                      const SizedBox(height: 12),
                      _buildTeamMemberCard(
                        context: context,
                        initials: 'MC',
                        name: 'Michael Chen',
                        role: 'Sales Rep',
                        status: 'ON-TRACK',
                        statusColor: const Color(0xFF2B7FFF),
                        recordings: '18',
                        avgScore: '76',
                        avgScoreColor: const Color(0xFF2B7FFF),
                        lastActive: '5 hours ago',
                      ),
                      const SizedBox(height: 12),
                      _buildTeamMemberCard(
                        context: context,
                        initials: 'ER',
                        name: 'Emily Rodriguez',
                        role: 'Sales Rep',
                        status: 'STRUGGLING',
                        statusColor: const Color(0xFFFF6900),
                        recordings: '8',
                        avgScore: '62',
                        avgScoreColor: const Color(0xFFFF6900),
                        lastActive: '1 day ago',
                      ),
                      const SizedBox(height: 12),
                      _buildTeamMemberCard(
                        context: context,
                        initials: 'DK',
                        name: 'David Kim',
                        role: 'Sales Rep',
                        status: 'EXCELLING',
                        statusColor: const Color(0xFF00BC7D),
                        recordings: '21',
                        avgScore: '82',
                        avgScoreColor: const Color(0xFF2B7FFF),
                        lastActive: '4 hours ago',
                      ),
                      const SizedBox(height: 12),
                      _buildTeamMemberCard(
                        context: context,
                        initials: 'JM',
                        name: 'Jessica Martinez',
                        role: 'Sales Rep',
                        status: 'STRUGGLING',
                        statusColor: const Color(0xFFFF6900),
                        recordings: '12',
                        avgScore: '68',
                        avgScoreColor: const Color(0xFFFF6900),
                        lastActive: '3 days ago',
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

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    const cardBackground = Color(0xFF0A0E14);
    const cardBorder = Color(0xFF1A2E23);
    const textSecondary = Color(0xFFA1A7B8);

    return Container(
      width: 205,
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
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required BuildContext context,
    required String name,
    required String priority,
    required String message,
    required String timestamp,
    required Color priorityColor,
  }) {
    const cardBackground = Color(0xFF0A0E14);
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: textPrimary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                        letterSpacing: -0.31,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color((priorityColor.value & 0x00FFFFFF) | 0x33000000),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: textSecondary,
                    letterSpacing: -0.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timestamp,
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
          TextButton(
            onPressed: () {
              // TODO: View alert details
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alert details coming soon')),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                    letterSpacing: -0.15,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16, color: textPrimary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard({
    required BuildContext context,
    required String initials,
    required String name,
    required String role,
    required String status,
    required Color statusColor,
    required String recordings,
    required String avgScore,
    required Color avgScoreColor,
    required String lastActive,
  }) {
    const cardBackground = Color(0xFF0A0E14);
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);
    const limeColor = Color(0xFFBEF264);

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: Color((limeColor.value & 0x00FFFFFF) | 0x33000000),
            child: Text(
              initials,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: limeColor,
                letterSpacing: -0.31,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name and Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                        letterSpacing: -0.31,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: Color((statusColor.value & 0x00FFFFFF) | 0x1A000000),
                        border: Border.all(
                          color: Color((statusColor.value & 0x00FFFFFF) | 0x33000000),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  role,
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
          ),
          // Stats - wrapped in Flexible to prevent overflow
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      recordings,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: limeColor,
                        letterSpacing: -0.31,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      'Recordings',
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          avgScore,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: avgScoreColor,
                            letterSpacing: -0.31,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          avgScoreColor == const Color(0xFF00BC7D) ? Icons.trending_up : Icons.trending_down,
                          size: 16,
                          color: avgScoreColor,
                        ),
                      ],
                    ),
                    Text(
                      'Avg Score',
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
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lastActive,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: textSecondary,
                          letterSpacing: -0.15,
                          height: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        'Last Active',
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
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MemberDetailsScreen(
                            memberId: '${name.toLowerCase().replaceAll(' ', '_')}',
                            memberName: name,
                            memberInitials: initials,
                            memberRole: role,
                            memberEmail: '${name.toLowerCase().replaceAll(' ', '.')}@company.com',
                            memberStatus: status,
                            memberStatusColor: statusColor,
                            joinedDate: 'Jan 15, 2024', // Mock date
                          ),
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
                      children: [
                        Flexible(
                          child: Text(
                            'View Details',
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
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16, color: textPrimary),
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
}

