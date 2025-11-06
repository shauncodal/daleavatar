import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:intl/intl.dart' as intl;

class StopSimulationModal extends StatefulWidget {
  final Function(String recordingName)? onConfirm;
  final VoidCallback onCancel;

  const StopSimulationModal({
    super.key,
    this.onConfirm,
    required this.onCancel,
  });

  @override
  State<StopSimulationModal> createState() => _StopSimulationModalState();
}

class _StopSimulationModalState extends State<StopSimulationModal> {
  final _nameController = TextEditingController();

  // Figma Design Colors
  static const backgroundColor = Color(0xFF000000); // Black
  static const cardBorder = Color(0xFF1A2E23); // Border color
  static const textPrimary = Color(0xFFE8EAEF); // Primary text
  static const textSecondary = Color(0xFFA1A7B8); // Secondary text
  static const red400 = Color(0xFFEF4444); // Red-400

  @override
  void initState() {
    super.initState();
    // Set default recording name based on current date/time
    final now = DateTime.now();
    _nameController.text = 'Simulation ${intl.DateFormat('MMM d').format(now)} - ${intl.DateFormat('h:mm a').format(now)}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      if (widget.onConfirm != null) {
        widget.onConfirm!(name);
      }
      Navigator.of(context).pop(name);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a recording name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔵 [STOP MODAL] ========== build() called ==========');
    print('🔵 [STOP MODAL] ========== build() called ==========');
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Prevent taps on the modal content from dismissing
      },
      child: Container(
              width: 512,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 48,
                maxHeight: MediaQuery.of(context).size.height - 48,
              ),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: cardBorder, width: 1),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon Section
            Center(
              child: Image.network(
                'http://localhost:4000/assets/db8a99c5e24d85ce035d6b1eef035f6b21d6f1ee.svg',
                width: 48,
                height: 48,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: red400.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 32,
                      color: red400,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            const Center(
              child: Text(
                'Stop Simulation?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                  letterSpacing: -0.4395,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Description
            const Center(
              child: Text(
                'Your session will be analyzed and results will be generated.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: textSecondary,
                  letterSpacing: -0.1504,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            
            // Recording Name Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recording Name',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                    letterSpacing: -0.1504,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: cardBorder.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _nameController,
                    enabled: true,
                    readOnly: false,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleConfirm(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: textPrimary,
                      letterSpacing: -0.1504,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Enter recording name...',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textSecondary,
                        letterSpacing: -0.1504,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Button Group
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint('🟡 [STOP MODAL] Cancel button pressed');
                      print('🟡 [STOP MODAL] Cancel button pressed');
                      widget.onCancel();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: textPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                        letterSpacing: -0.1504,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red400,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save & Stop',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: -0.1504,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

