import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  final VoidCallback onBackToLogin;

  const RegisterScreen({
    super.key,
    required this.onRegisterSuccess,
    required this.onBackToLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (mounted) {
        widget.onRegisterSuccess();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Design colors from Figma
    const backgroundColor = Color(0xFF000000); // Black background
    const cardBackground = Color(0xFF0A0E14); // Dark card background
    const cardBorder = Color(0x3334D399); // Emerald-400 with 20% opacity (0.2)
    const textPrimary = Color(0xFFE8EAEF); // Primary text
    const textSecondary = Color(0xFFA1A7B8); // Secondary text
    const limeColor = Color(0xFFBEF264); // Lime-300
    const emeraldColor = Color(0xFF34D399); // Emerald-400
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
                  const SizedBox(height: 50),
                  
                  // Logo/Image
                  SizedBox(
                    width: 192,
                    height: 153,
                    child: Image.network(
                      'http://localhost:4000/assets/aca899cc6e347e28f97ce9acd2e639a261a0e8fb.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.account_circle,
                          size: 192,
                          color: textPrimary,
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Registration Card
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
                                'Create Account',
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
                                'Join thousands of sales professionals',
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
                        
                        // Form Fields
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Full Name Field
                              _buildInputField(
                                controller: _nameController,
                                label: 'Full Name',
                                hint: 'John Doe',
                                iconPath: 'http://localhost:4000/assets/edf5b71909344e0117d1849a5daa23e9d600788e.svg',
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                textColor: textPrimary,
                                hintColor: textSecondary,
                                labelColor: textPrimary,
                              ),
                              
                              const SizedBox(height: 16),
                              
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
                              
                              // Company Field
                              _buildInputField(
                                controller: _companyController,
                                label: 'Company',
                                hint: 'Your Company',
                                iconPath: 'http://localhost:4000/assets/5999e6e006c174bcd5ad202434530508c53765f5.svg',
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  // Company is optional, so no validation required
                                  return null;
                                },
                                textColor: textPrimary,
                                hintColor: textSecondary,
                                labelColor: textPrimary,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Password Field
                              _buildPasswordField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: '••••••••',
                                iconPath: 'http://localhost:4000/assets/62e0968f32ca5c317f204c214deaf8f8402fbabe.svg',
                                obscureText: _obscurePassword,
                                onToggleVisibility: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                textColor: textPrimary,
                                hintColor: textSecondary,
                                labelColor: textPrimary,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Confirm Password Field
                              _buildPasswordField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                hint: '••••••••',
                                iconPath: 'http://localhost:4000/assets/62e0968f32ca5c317f204c214deaf8f8402fbabe.svg',
                                obscureText: _obscureConfirmPassword,
                                onToggleVisibility: () {
                                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                textColor: textPrimary,
                                hintColor: textSecondary,
                                labelColor: textPrimary,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Create Account Button
                              SizedBox(
                                width: double.infinity,
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: emeraldColor,
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
                                          'Create Account',
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: textSecondary,
                                    letterSpacing: -0.15,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                TextButton(
                                  onPressed: widget.onBackToLogin,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 24),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: limeColor,
                                      letterSpacing: -0.31,
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
                  
                  const SizedBox(height: 24),
                  
                  // Terms Text
                  Text(
                    'By signing up, you agree to our Terms of Service',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 100),
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
                      IconData icon;
                      if (label.contains('Name') || label.contains('Full')) {
                        icon = Icons.person_outlined;
                      } else if (label.contains('Email')) {
                        icon = Icons.email_outlined;
                      } else if (label.contains('Company')) {
                        icon = Icons.business_outlined;
                      } else {
                        icon = Icons.lock_outlined;
                      }
                      return Icon(
                        icon,
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String iconPath,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
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
            obscureText: obscureText,
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
                        Icons.lock_outlined,
                        size: 20,
                        color: hintColor,
                      );
                    },
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: hintColor,
                ),
                onPressed: onToggleVisibility,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
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
