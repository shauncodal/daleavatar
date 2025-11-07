import 'package:flutter/material.dart';

class AddNoteModal extends StatefulWidget {
  final String currentTimestamp;
  final Function(String timestamp, String note)? onSaveNote;

  const AddNoteModal({
    super.key,
    required this.currentTimestamp,
    this.onSaveNote,
  });

  @override
  State<AddNoteModal> createState() => _AddNoteModalState();
}

class _AddNoteModalState extends State<AddNoteModal> {
  final _noteController = TextEditingController();
  final _timestampController = TextEditingController();
  
  // Figma Design Colors
  static const backgroundColor = Color(0xFF000000); // Black
  static const cardBorder = Color(0xFF1A2E23); // Border color
  static const textPrimary = Color(0xFFE8EAEF); // Primary text
  static const textSecondary = Color(0xFFA1A7B8); // Secondary text
  static const lime300 = Color(0xFFBEF264); // Lime-300
  static const inputBackground = Color(0xFF141820); // Input background

  @override
  void initState() {
    super.initState();
    _timestampController.text = widget.currentTimestamp;
  }

  @override
  void dispose() {
    _noteController.dispose();
    _timestampController.dispose();
    super.dispose();
  }

  void _handleCurrentTime() {
    // Format current time as MM:SS
    final now = DateTime.now();
    final seconds = now.second + (now.minute * 60);
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final formatted = '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
    setState(() {
      _timestampController.text = formatted;
    });
  }

  void _handleSave() {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a note')),
      );
      return;
    }
    
    widget.onSaveNote?.call(_timestampController.text, _noteController.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 512,
        constraints: const BoxConstraints(maxWidth: double.infinity),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: cardBorder),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            // Close button
            Positioned(
              right: 17,
              top: 17,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 16,
                  color: textPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Note',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                          letterSpacing: -0.4395,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add a timestamped note to this recording at ${widget.currentTimestamp}',
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
                  
                  const SizedBox(height: 16),
                  
                  // Timestamp Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Timestamp',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textPrimary,
                          letterSpacing: -0.1504,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: inputBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _timestampController,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: textPrimary,
                                  letterSpacing: -0.1504,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: _handleCurrentTime,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                              minimumSize: const Size(112.562, 32),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Current Time',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                                letterSpacing: -0.1504,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Note Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Note',
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
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _noteController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: textPrimary,
                            letterSpacing: -0.1504,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your note here...',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: textSecondary,
                              letterSpacing: -0.1504,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(12),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Footer Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                          minimumSize: const Size(79.352, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lime300,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(99.117, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Save Note',
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
          ],
        ),
      ),
    );
  }
}

