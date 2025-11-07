import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onBackToLogin;
  final VoidCallback onResetSuccess;

  const ForgotPasswordScreen({
    super.key,
    required this.onBackToLogin,
    required this.onResetSuccess,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _emailSent = true;
    });

    // Auto go back after showing success
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onResetSuccess();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Design colors from Figma
    const backgroundColor = Color(0xFF000000); // Black background
    const cardBackground = Color(0xFF0A0E14); // Dark card background
    const cardBorder = Color(0x33BEF264); // Lime-300 with 20% opacity (0.2)
    const textPrimary = Color(0xFFE8EAEF); // Primary text
    const textSecondary = Color(0xFFA1A7B8); // Secondary text
    const limeColor = Color(0xFFBEF264); // Lime-300
    const dividerColor = Color(0xFF1A2E23); // Border divider

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 150),
                  
                  // Logo/Image
                  SizedBox(
                    width: 192,
                    height: 153,
                    child: Image.asset(
                      'assets/images/dale_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Reset Password Card
                  Container(
                    width: 448,
                    constraints: const BoxConstraints(maxWidth: double.infinity),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: cardBorder,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: textPrimary,
                                  letterSpacing: -0.31,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Enter your email to receive a reset link',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: textSecondary,
                                  letterSpacing: -0.31,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Form Content
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_emailSent) ...[
                                // Success message
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.green),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Reset link sent to ${_emailController.text}',
                                          style: const TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                // Email Field
                                _buildInputField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hint: 'you@example.com',
                                  iconPath: 'http://localhost:4000/assets/746b11dc029d6d3e3824c13b7cd3730493b2aee9.svg',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                  textColor: textPrimary,
                                  hintColor: textSecondary,
                                  labelColor: textPrimary,
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Send Reset Link Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 36,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleResetPassword,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: limeColor,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                            ),
                                          )
                                        : Text(
                                            'Send Reset Link',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              letterSpacing: -0.15,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Card Footer
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: TextButton(
                              onPressed: widget.onBackToLogin,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(108, 20),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: Image.network(
                                      'http://localhost:4000/assets/44b7201e88dd1367b8b09a8f9353febdc4915210.svg',
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.arrow_back,
                                          size: 16,
                                          color: limeColor,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Back to login',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: limeColor,
                                      letterSpacing: -0.15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String iconPath,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    required Color textColor,
    required Color hintColor,
    required Color labelColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: labelColor,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.transparent,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: textColor,
              letterSpacing: -0.15,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: hintColor,
                letterSpacing: -0.15,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.network(
                    iconPath,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: hintColor,
                      );
                    },
                  ),
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
