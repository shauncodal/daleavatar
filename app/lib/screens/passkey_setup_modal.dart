import 'package:flutter/material.dart';

class PasskeySetupModal extends StatefulWidget {
  final VoidCallback? onSetupComplete;

  const PasskeySetupModal({super.key, this.onSetupComplete});

  @override
  State<PasskeySetupModal> createState() => _PasskeySetupModalState();
}

class _PasskeySetupModalState extends State<PasskeySetupModal> {
  int _currentStep = 0; // 0: Info, 1: Name Input, 2: Success
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {}); // Rebuild to update button state
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Design colors
    const backgroundColor = Color(0xFF000000);
    const cardBackground = Color(0xFF0A0E14);
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);
    const lime300 = Color(0xFFBEF264);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 512,
        constraints: const BoxConstraints(maxHeight: 700),
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
                        Icons.fingerprint,
                        size: 24,
                        color: textPrimary,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Set Up Passkey',
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
                    'Use your device\'s biometric authentication for secure sign-in',
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
                  children: [
                    if (_currentStep == 0) ...[
                      // Step 1: Info
                      // Large Icon and Description
                      Column(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: lime300.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.fingerprint,
                              size: 48,
                              color: lime300,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'What are passkeys?',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: textPrimary,
                              letterSpacing: -0.3125,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Passkeys let you sign in using your fingerprint, face recognition, or device PIN. They\'re more secure than passwords and faster to use.',
                            textAlign: TextAlign.center,
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
                      const SizedBox(height: 16),
                      // Benefits Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Benefits:',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: textPrimary,
                              letterSpacing: -0.1504,
                              height: 1.43,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildBenefitItem('More secure than passwords'),
                          const SizedBox(height: 8),
                          _buildBenefitItem('No need to remember complex passwords'),
                          const SizedBox(height: 8),
                          _buildBenefitItem('Faster sign-in with biometrics'),
                          const SizedBox(height: 8),
                          _buildBenefitItem('Protected against phishing attacks'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Alert Box
                      Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          border: Border.all(
                            color: cardBorder,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'You\'ll be prompted to verify your identity using your device\'s biometric authentication.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: textSecondary,
                            letterSpacing: -0.1504,
                            height: 1.43,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: textPrimary,
                                side: const BorderSide(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 9),
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
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() => _currentStep = 1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lime300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                              ),
                              child: const Text(
                                'Continue',
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
                    ] else if (_currentStep == 1) ...[
                      // Step 2: Name Input
                      // Alert Box
                      Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          border: Border.all(
                            color: cardBorder,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Give your passkey a name to help you identify it later.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: textSecondary,
                                  letterSpacing: -0.1504,
                                  height: 1.43,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name Input
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Passkey Name',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                              letterSpacing: -0.1504,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _nameController,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: textPrimary,
                                letterSpacing: -0.1504,
                                height: 1.0,
                              ),
                              decoration: InputDecoration(
                                hintText: 'e.g., My iPhone, Work Laptop',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: textSecondary,
                                  letterSpacing: -0.1504,
                                ),
                                filled: false,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Choose a name that helps you remember which device this passkey is for.',
                            style: TextStyle(
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
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() => _currentStep = 0);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: textPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.1504,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _nameController.text.isEmpty
                                  ? null
                                  : () async {
                                      // TODO: Implement actual passkey creation with the name
                                      // For now, simulate creation delay then show success
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      if (mounted) {
                                        setState(() => _currentStep = 2);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lime300,
                                disabledBackgroundColor: lime300.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                              ),
                              child: const Text(
                                'Create Passkey',
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
                    ] else if (_currentStep == 2) ...[
                      // Step 3: Success
                      Column(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: const Color(0xFF34D399).withOpacity(0.1), // emerald400
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle_outline,
                              size: 48,
                              color: Color(0xFF34D399), // emerald400
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Passkey created successfully!',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: textPrimary,
                              letterSpacing: -0.3125,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'You can now use your passkey to sign in to DALE.',
                            textAlign: TextAlign.center,
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
                      const SizedBox(height: 16),
                      // Passkey Name Display
                      Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          border: Border.all(
                            color: cardBorder,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Passkey name:',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textSecondary,
                                letterSpacing: -0.1504,
                                height: 1.43,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _nameController.text.isEmpty ? 'Unnamed Passkey' : _nameController.text,
                              style: const TextStyle(
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
                      const SizedBox(height: 16),
                      const Text(
                        'You can manage your passkeys anytime from the Security settings.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textSecondary,
                          letterSpacing: -0.1504,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onSetupComplete?.call();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lime300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Done',
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    const textSecondary = Color(0xFFA1A7B8);
    const lime300 = Color(0xFFBEF264);

    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 16,
          color: lime300,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textSecondary,
              letterSpacing: -0.1504,
              height: 1.43,
            ),
          ),
        ),
      ],
    );
  }
}

