import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ManageMFAModal extends StatefulWidget {
  final VoidCallback? onRemoved;

  const ManageMFAModal({super.key, this.onRemoved});

  @override
  State<ManageMFAModal> createState() => _ManageMFAModalState();
}

class _ManageMFAModalState extends State<ManageMFAModal> {
  DateTime? _addedDate;

  @override
  void initState() {
    super.initState();
    _loadAddedDate();
  }

  Future<void> _loadAddedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('authenticator_added_date');
    setState(() {
      _addedDate = timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : DateTime.now(); // Default to now if not set
    });
  }

  Future<void> _handleRemove() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          width: 512,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xFF000000),
            border: Border.all(
              color: const Color(0xFF1A2E23),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Remove authentication method?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE8EAEF),
                      letterSpacing: -0.4395,
                      height: 1.56, // 28px / 18px
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This action cannot be undone. You will need to set up this authentication method again if you want to use it in the future.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA1A7B8),
                      letterSpacing: -0.1504,
                      height: 1.43,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Warning section
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFF6900), // orange400
                        letterSpacing: -0.1504,
                        height: 1.43,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Warning: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: 'This is your only authentication method. Removing it may affect your account security.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Footer buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFE8EAEF),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 9,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.1504,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF87171), // red400
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: -0.1504,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('authenticator_active', false);
      await prefs.remove('authenticator_added_date');
      
      if (mounted) {
        // Close confirmation dialog
        Navigator.of(context).pop(); // Close confirmation dialog
        // Close manage modal
        Navigator.of(context).pop(); // Close manage modal
        // Call callback to update parent
        widget.onRemoved?.call();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authenticator app removed successfully'),
            backgroundColor: Color(0xFF34D399), // emerald400
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Design colors
    const backgroundColor = Color(0xFF000000);
    const cardBackground = Color(0xFF0A0E14);
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);
    const emerald400 = Color(0xFF34D399);
    const red400 = Color(0xFFF87171);
    const orange400 = Color(0xFFFF6900);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 512,
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: cardBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_android,
                        size: 24,
                        color: textPrimary,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Manage Authentication',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                            letterSpacing: -0.4395,
                            height: 1.0,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: textPrimary,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'View and manage your active authentication methods.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textSecondary,
                      letterSpacing: -0.1504,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(25, 16, 25, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Authenticator App Card
                    Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        border: Border.all(
                          color: cardBorder,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFBEF264).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.phone_android,
                              size: 20,
                              color: Color(0xFFBEF264),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Authenticator App',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: textPrimary,
                                        letterSpacing: -0.1504,
                                        height: 1.43,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: emerald400,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Active',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 12,
                                      color: textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _addedDate != null
                                          ? 'Added ${DateFormat('MMM d, yyyy').format(_addedDate!)}'
                                          : 'Added recently',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: textSecondary,
                                        letterSpacing: 0,
                                        height: 1.33,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextButton.icon(
                                  onPressed: _handleRemove,
                                  style: TextButton.styleFrom(
                                    foregroundColor: red400,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 11,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 16,
                                    color: red400,
                                  ),
                                  label: const Text(
                                    'Remove',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: red400,
                                      letterSpacing: -0.1504,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Warning Box
                    Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: orange400.withOpacity(0.1),
                        border: Border.all(
                          color: orange400,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: textPrimary,
                            letterSpacing: -0.1504,
                            height: 1.43,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Warning: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: 'This is your only authentication method. Consider adding a backup method before removing this one.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

