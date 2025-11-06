import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authenticator_setup_modal.dart';
import 'manage_mfa_modal.dart';
import 'passkey_setup_modal.dart';

class SecurityModal extends StatefulWidget {
  const SecurityModal({super.key});

  @override
  State<SecurityModal> createState() => _SecurityModalState();
}

class _SecurityModalState extends State<SecurityModal> {
  bool _authenticatorActive = false;

  @override
  void initState() {
    super.initState();
    _checkAuthenticatorStatus();
  }

  Future<void> _checkAuthenticatorStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _authenticatorActive = prefs.getBool('authenticator_active') ?? false;
    });
  }

  Future<void> _onAuthenticatorSetupComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('authenticator_active', true);
    // Store the date when authenticator was added
    await prefs.setInt('authenticator_added_date', DateTime.now().millisecondsSinceEpoch);
    if (mounted) {
      setState(() {
        _authenticatorActive = true;
      });
    }
  }

  Future<void> _onAuthenticatorRemoved() async {
    // Refresh status to update UI
    await _checkAuthenticatorStatus();
    // The Security modal will automatically update to show the warning since authenticator is no longer active
  }

  @override
  Widget build(BuildContext context) {
    // Design colors
    const backgroundColor = Color(0xFF000000); // Black background
    const cardBackground = Color(0xFF0A0E14);
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);
    const orange400 = Color(0xFFFF6900);
    const tipsBg = Color(0x50141820); // rgba(20,24,32,0.5)

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 512,
        constraints: const BoxConstraints(maxHeight: 917),
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
                        Icons.security,
                        size: 24,
                        color: textPrimary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Security Settings',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                          letterSpacing: -0.4395,
                          height: 1.0, // 18px / 18px
                        ),
                      ),
                      const Spacer(),
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
                    'Protect your account with multi-factor authentication (MFA). We recommend enabling at least one additional security method.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textSecondary,
                      letterSpacing: -0.1504,
                      height: 1.43, // 20px / 14px
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
                    // Success Banner (when MFA is active) or Warning Card (when not)
                    if (_authenticatorActive) ...[
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          border: Border.all(
                            color: const Color(0xFF34D399), // emerald400
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 20,
                              color: Color(0xFF34D399), // emerald400
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your account is protected',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: textPrimary,
                                      letterSpacing: -0.3125,
                                      height: 1.5, // 24px / 16px
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Multi-factor authentication is active on your account.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: textSecondary,
                                      letterSpacing: -0.1504,
                                      height: 1.43, // 20px / 14px
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          border: Border.all(
                            color: orange400,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              size: 20,
                              color: orange400,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Additional security recommended',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: textPrimary,
                                      letterSpacing: -0.3125,
                                      height: 1.5, // 24px / 16px
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Add an extra layer of security to protect your account from unauthorized access.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: textSecondary,
                                      letterSpacing: -0.1504,
                                      height: 1.43, // 20px / 14px
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Authentication Methods Section
                    const Text(
                      'Authentication Methods',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: textPrimary,
                        letterSpacing: -0.3125,
                        height: 1.5, // 24px / 16px
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Authenticator App Card
                    _buildAuthMethodCard(
                      icon: Icons.phone_android,
                      title: 'Authenticator App',
                      description: 'Use an app like Google Authenticator or Authy to generate verification codes.',
                      isActive: _authenticatorActive,
                      onSetUp: () async {
                        await showDialog(
                          context: context,
                          builder: (dialogContext) => AuthenticatorSetupModal(
                            onSetupComplete: () {
                              _onAuthenticatorSetupComplete();
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        );
                        // Refresh state after returning from setup
                        await _checkAuthenticatorStatus();
                      },
                      onManage: () {
                        showDialog(
                          context: context,
                          builder: (context) => ManageMFAModal(
                            onRemoved: _onAuthenticatorRemoved,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // Passkey Card
                    _buildAuthMethodCard(
                      icon: Icons.fingerprint,
                      title: 'Passkey',
                      description: 'Sign in with your fingerprint, face, or device PIN for secure, password-free authentication.',
                      onSetUp: () {
                        showDialog(
                          context: context,
                          builder: (context) => PasskeySetupModal(
                            onSetupComplete: () {
                              // Refresh status after passkey setup
                              _checkAuthenticatorStatus();
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Security Tips Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: tipsBg,
                        border: Border.all(
                          color: cardBorder,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                size: 16,
                                color: textPrimary,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Security Tips',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: textPrimary,
                                  letterSpacing: -0.3125,
                                  height: 1.5, // 24px / 16px
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildSecurityTip(
                            'Enable multiple authentication methods for backup access',
                          ),
                          const SizedBox(height: 8),
                          _buildSecurityTip(
                            'Store recovery codes in a secure location',
                          ),
                          const SizedBox(height: 8),
                          _buildSecurityTip(
                            'Passkeys are the most secure and convenient option',
                          ),
                        ],
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

  Widget _buildAuthMethodCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onSetUp,
    bool isActive = false,
    VoidCallback? onManage,
  }) {
    const cardBackground = Color(0xFF0A0E14);
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);
    const lime300 = Color(0xFFBEF264);
    const emerald400 = Color(0xFF34D399);

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: cardBackground,
        border: Border.all(
          color: cardBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: lime300.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: lime300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: textPrimary,
                            letterSpacing: -0.3125,
                            height: 1.5, // 24px / 16px
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
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
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                        letterSpacing: -0.1504,
                        height: 1.43, // 20px / 14px
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: isActive
                ? TextButton(
                    onPressed: onManage ?? () {},
                    style: TextButton.styleFrom(
                      foregroundColor: textPrimary,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Manage',
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
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: textPrimary,
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: onSetUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lime300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Set Up',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: -0.1504,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTip(String text) {
    const textSecondary = Color(0xFFA1A7B8);
    const lime300 = Color(0xFFBEF264);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '•',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: lime300,
            letterSpacing: -0.1504,
            height: 1.43, // 20px / 14px
          ),
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
              height: 1.43, // 20px / 14px
            ),
          ),
        ),
      ],
    );
  }
}

