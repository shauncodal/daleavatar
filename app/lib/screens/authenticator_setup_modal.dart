import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticatorSetupModal extends StatefulWidget {
  final VoidCallback? onSetupComplete;
  
  const AuthenticatorSetupModal({super.key, this.onSetupComplete});

  @override
  State<AuthenticatorSetupModal> createState() => _AuthenticatorSetupModalState();
}

class _AuthenticatorSetupModalState extends State<AuthenticatorSetupModal> {
  int _currentStep = 0; // 0: App Selection, 1: QR Code, 2: Verification, 3: Success
  final TextEditingController _codeController = TextEditingController();
  bool _isVerifying = false;
  
  // Mock recovery codes
  final List<String> _recoveryCodes = [
    '9K4L-2M8N-5P7Q',
    '3R6T-8Y2W-1X5Z',
    '7B4N-9M3K-2L6P',
    '5Q8R-4T7Y-6W3X',
    '1Z2X-5C8V-9B4N',
    '6M3K-7L2P-8Q5R',
    '4Y7T-3W6X-2Z5C',
    '8V9B-4N5M-3K7L',
  ];

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // Mock QR code secret for demo
  final String _secretKey = 'JBSWY3DPEHPK3PXP'; // Base32 encoded secret

  @override
  Widget build(BuildContext context) {
    // Design colors
    const backgroundColor = Color(0xFF000000);
    const cardBackground = Color(0xFF0A0E14);
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);
    const lime300 = Color(0xFFBEF264);
    const emerald400 = Color(0xFF34D399);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 512,
        constraints: const BoxConstraints(maxHeight: 800),
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
              child: Row(
                children: [
                  const Icon(
                    Icons.phone_android,
                    size: 24,
                    color: textPrimary,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Set Up Authenticator App',
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
            ),
            // Step indicator (show for steps 1-3, not step 4)
            if (_currentStep < 3)
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: _buildStepIndicator(_currentStep + 1, 4),
              ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentStep == 0) ...[
                      // Step 1: App Selection
                      const SizedBox(height: 24),
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
                                'Install an authenticator app on your mobile device to get started.',
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
                      // Recommended Apps Section
                      const Text(
                        'Recommended Apps:',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: textPrimary,
                          letterSpacing: -0.3125,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // App List
                      Column(
                        children: [
                          _buildAppOption(
                            'Google Authenticator',
                            isPopular: true,
                          ),
                          const SizedBox(height: 8),
                          _buildAppOption(
                            'Microsoft Authenticator',
                            isPopular: true,
                          ),
                          const SizedBox(height: 8),
                          _buildAppOption(
                            'Authy',
                            isPopular: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Download any of these apps from your device\'s app store, then continue to the next step.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textSecondary,
                          letterSpacing: -0.1504,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
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
                      // Step 2: QR Code Setup
                      const SizedBox(height: 24),
                      const Text(
                        'Scan QR Code',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: textPrimary,
                          letterSpacing: -0.3125,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Open your authenticator app (Google Authenticator, Authy, etc.) and scan this QR code.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textSecondary,
                          letterSpacing: -0.1504,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // QR Code Container
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: cardBorder,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code_scanner,
                                  size: 80,
                                  color: Colors.grey[800],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'QR Code',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Secret Key (Manual Entry)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          border: Border.all(
                            color: cardBorder,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Can\'t scan? Enter this code manually:',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: textSecondary,
                                letterSpacing: -0.1504,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(
                                        color: cardBorder,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: SelectableText(
                                      _secretKey,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: textPrimary,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: lime300,
                                  ),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: _secretKey));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Secret key copied to clipboard'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => _currentStep = 2);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lime300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Next: Verify Code',
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
                    ] else if (_currentStep == 2) ...[
                      // Step 3: Verification
                      const SizedBox(height: 24),
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
                                'Enter the 6-digit code from your authenticator app to verify.',
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
                      // Verification Code Input
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Verification Code',
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
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: textPrimary,
                                letterSpacing: 1.4,
                                height: 1.0,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: '000000',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: textSecondary,
                                  letterSpacing: 1.4,
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
                              onChanged: (value) {
                                setState(() {}); // Rebuild to update button state
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Enter the 6-digit code shown in your authenticator app for DALE.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textSecondary,
                          letterSpacing: -0.1504,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() => _currentStep = 1);
                                _codeController.clear();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: textPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 16,
                                color: textPrimary,
                              ),
                              label: const Text(
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
                              onPressed: (_codeController.text.length == 6 && !_isVerifying)
                                  ? () async {
                                      setState(() => _isVerifying = true);
                                      
                                      // Simulate verification
                                      await Future.delayed(const Duration(seconds: 1));
                                      
                                      if (mounted) {
                                        setState(() {
                                          _isVerifying = false;
                                          _currentStep = 3;
                                        });
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lime300,
                                disabledBackgroundColor: lime300.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                              ),
                              child: _isVerifying
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                      ),
                                    )
                                  : const Text(
                                      'Verify',
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
                    ] else if (_currentStep == 3) ...[
                      // Step 4: Success with Recovery Codes
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: emerald400,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Authenticator app verified! Save these recovery codes in a secure place.',
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
                      // Recovery Codes Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recovery Codes',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: textPrimary,
                                  letterSpacing: -0.1504,
                                  height: 1.43,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  final allCodes = _recoveryCodes.join('\n');
                                  Clipboard.setData(ClipboardData(text: allCodes));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Recovery codes copied to clipboard'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: textPrimary,
                                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(
                                  Icons.copy,
                                  size: 16,
                                  color: textPrimary,
                                ),
                                label: const Text(
                                  'Copy All',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.1504,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Recovery Codes Grid
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141820),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 3.5,
                              ),
                              itemCount: _recoveryCodes.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(
                                      color: cardBorder,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: SelectableText(
                                      _recoveryCodes[index],
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: textPrimary,
                                        letterSpacing: 0,
                                        height: 1.43,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Each code can be used once to sign in if you lose access to your authenticator app.',
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
                      // Important Warning
                      Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6900).withOpacity(0.1),
                          border: Border.all(
                            color: const Color(0xFFFF6900),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Important:',
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
                            const Text(
                              'Store these codes in a secure location. You won\'t be able to see them again.',
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

  Widget _buildStepIndicator(int currentStep, int totalSteps) {
    const textSecondary = Color(0xFFA1A7B8);
    const lime300 = Color(0xFFBEF264);
    const cardBorder = Color(0xFF1A2E23);

    return Row(
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: isCompleted || isActive
                        ? lime300
                        : cardBorder,
                  ),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted || isActive
                      ? lime300
                      : cardBorder,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.black,
                        )
                      : Text(
                          '$stepNumber',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.black : textSecondary,
                          ),
                        ),
                ),
              ),
              if (index < totalSteps - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? lime300
                          : cardBorder,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAppOption(String appName, {required bool isPopular}) {
    const textPrimary = Color(0xFFE8EAEF);
    const cardBorder = Color(0xFF1A2E23);
    const emerald400 = Color(0xFF34D399);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      decoration: BoxDecoration(
        border: Border.all(
          color: cardBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            appName,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: textPrimary,
              letterSpacing: -0.3125,
              height: 1.5,
            ),
          ),
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: emerald400,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Popular',
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
    );
  }
}

