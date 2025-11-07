import 'package:flutter/material.dart';
import 'services/backend_api.dart';
import 'services/auth_service.dart';
import 'screens/student_dashboard.dart';
import 'screens/evaluator_dashboard.dart';
import 'screens/session_lobby.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/security_modal.dart';

void main() {
  runApp(const DaleAvatarApp());
}

class DaleAvatarApp extends StatelessWidget {
  const DaleAvatarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DaleAvatar',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
      ),
      home: const _HomeRouter(),
    );
  }
}

class _HomeRouter extends StatefulWidget {
  const _HomeRouter();

  @override
  State<_HomeRouter> createState() => _HomeRouterState();
}

enum AuthScreen { login, register, forgotPassword }

enum DashboardType { student, evaluator }

const String _kLogoAsset = 'assets/images/dale_logo.png';

class _HomeRouterState extends State<_HomeRouter> {
  bool _showSettingsPanel = false;
  bool _showNotificationsPanel = false;
  bool _showProfilePanel = false;
  String? _userName;
  int _unreadNotificationsCount = 2; // Mock for now
  late final BackendApi _api;
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  bool _isLoadingAuth = true;
  AuthScreen _currentAuthScreen = AuthScreen.login;
  DashboardType _dashboardType = DashboardType.student;

  @override
  void initState() {
    super.initState();
    _api = BackendApi(const String.fromEnvironment('BACKEND_URL', defaultValue: 'http://localhost:4000'));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkAuthState();
    });
  }

  Future<void> _checkAuthState() async {
    await _authService.loadAuthState();
    setState(() {
      _isAuthenticated = _authService.isAuthenticated;
      _userName = _authService.userName;
      _isLoadingAuth = false;
    });

    if (_isAuthenticated && _authService.authToken != null) {
      _api.setAuthToken(_authService.authToken);
    }
  }

  Future<void> _handleDemoLogin() async {
    await _authService.demoLogin();
    setState(() {
      _isAuthenticated = true;
      _userName = _authService.userName;
      _dashboardType = DashboardType.student;
    });
  }

  Future<void> _handleEvaluatorLogin() async {
    await _authService.demoLogin();
    setState(() {
      _isAuthenticated = true;
      _userName = _authService.userName;
      _dashboardType = DashboardType.evaluator;
    });
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    _api.setAuthToken(null);
    setState(() {
      _isAuthenticated = false;
      _userName = null;
      _showSettingsPanel = false;
      _showNotificationsPanel = false;
      _showProfilePanel = false;
    });
  }

  void _toggleSettingsPanel() {
    setState(() {
      _showSettingsPanel = !_showSettingsPanel;
      _showNotificationsPanel = false;
      _showProfilePanel = false;
    });
  }

  void _closeSettingsPanel() {
    setState(() {
      _showSettingsPanel = false;
    });
  }

  void _toggleNotificationsPanel() {
    setState(() {
      _showNotificationsPanel = !_showNotificationsPanel;
      _showSettingsPanel = false;
      _showProfilePanel = false;
    });
  }

  void _closeNotificationsPanel() {
    setState(() {
      _showNotificationsPanel = false;
    });
  }

  void _toggleProfilePanel() {
    setState(() {
      _showProfilePanel = !_showProfilePanel;
      _showSettingsPanel = false;
      _showNotificationsPanel = false;
    });
  }

  void _closeProfilePanel() {
    setState(() {
      _showProfilePanel = false;
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0A0E14), // cardBackground
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Container(
        height: 63,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // User icon/name - clickable to open profile
            GestureDetector(
              onTap: _toggleProfilePanel,
              child: Container(
                height: 36,
                child: Row(
                  children: [
                    // Avatar circle
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBEF264), // lime300
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _userName?.substring(0, 1).toUpperCase() ?? 'U',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            letterSpacing: -0.3125,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _userName ?? 'User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFE8EAEF), // textPrimary
                        letterSpacing: -0.3125,
                      ),
                    ),
                    if (_authService.isDemoMode)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          height: 22,
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF22D3EE), // cyan400
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'DEMO',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF22D3EE), // cyan400
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Right side icons
            Row(
              children: [
                // Notifications icon
                Stack(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.notifications_outlined,
                          size: 16,
                          color: Color(0xFFE8EAEF), // textPrimary
                        ),
                        onPressed: _toggleNotificationsPanel,
                      ),
                    ),
                    if (_unreadNotificationsCount > 0)
                      Positioned(
                        right: 4,
                        top: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF87171), // red-400
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _unreadNotificationsCount > 9 ? '9+' : '$_unreadNotificationsCount',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                // Settings icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.settings,
                      size: 16,
                      color: Color(0xFFE8EAEF), // textPrimary
                    ),
                    onPressed: _toggleSettingsPanel,
                  ),
                ),
                const SizedBox(width: 8),
                // Logout icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.logout,
                      size: 16,
                      color: Color(0xFFE8EAEF), // textPrimary
                    ),
                    onPressed: _handleLogout,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFBEF264).withOpacity(0.2), // lime300 with opacity
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking auth state
    if (_isLoadingAuth) {
      return const AppSplashScreen(logoAssetPath: _kLogoAsset);
    }

    // Show auth screens if not authenticated
    if (!_isAuthenticated) {
      switch (_currentAuthScreen) {
        case AuthScreen.login:
          return LoginScreen(
            onLoginSuccess: () async {
              // Refresh auth state after login
              await _checkAuthState();
              setState(() => _dashboardType = DashboardType.student);
            },
            onDemoLogin: _handleDemoLogin,
            onEvaluatorLogin: _handleEvaluatorLogin,
            onRegister: () => setState(() => _currentAuthScreen = AuthScreen.register),
            onForgotPassword: () => setState(() => _currentAuthScreen = AuthScreen.forgotPassword),
          );
        case AuthScreen.register:
          return RegisterScreen(
            onRegisterSuccess: () async {
              // Refresh auth state after registration
              await _checkAuthState();
            },
            onBackToLogin: () => setState(() => _currentAuthScreen = AuthScreen.login),
          );
        case AuthScreen.forgotPassword:
          return ForgotPasswordScreen(
            onBackToLogin: () => setState(() => _currentAuthScreen = AuthScreen.login),
            onResetSuccess: () => setState(() => _currentAuthScreen = AuthScreen.login),
          );
      }
    }

    // Show main app if authenticated
    return Stack(
      children: [
        Scaffold(
          appBar: _dashboardType == DashboardType.evaluator ? null : _buildAppBar(),
          body: _dashboardType == DashboardType.evaluator
              ? const EvaluatorDashboardScreen()
              : StudentDashboardScreen(api: _api, showAppBar: false), // Dashboard is now the landing page
        ),
        // Settings panel (slide out from right)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: 0,
          bottom: 0,
          right: _showSettingsPanel ? 0 : -400,
          width: 400,
          child: Material(
            elevation: 8,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E14), // cardBackground
                border: const Border(
                  left: BorderSide(
                    color: Color(0xFF1A2E23), // cardBorder
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(-2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Settings header
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Color(0x1ABEF264), // lime300.withOpacity(0.1)
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF1A2E23), // cardBorder
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.settings_outlined,
                          size: 20,
                          color: Color(0xFFE8EAEF), // textPrimary
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Avatar Settings',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFE8EAEF), // textPrimary
                            letterSpacing: -0.3125,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 16,
                            color: Color(0xFFE8EAEF),
                          ),
                          onPressed: _closeSettingsPanel,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Settings content
                  const Expanded(
                    child: SessionLobbyScreen(),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Notifications panel (slide out from right)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: 0,
          bottom: 0,
          right: _showNotificationsPanel ? 0 : -400,
          width: 400,
          child: Material(
            elevation: 8,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E14), // cardBackground
                border: const Border(
                  left: BorderSide(
                    color: Color(0xFF1A2E23), // cardBorder
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(-2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Notifications header
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Color(0x1ABEF264), // lime300.withOpacity(0.1)
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF1A2E23), // cardBorder
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          size: 20,
                          color: Color(0xFFE8EAEF), // textPrimary
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFE8EAEF), // textPrimary
                            letterSpacing: -0.3125,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 16,
                            color: Color(0xFFE8EAEF),
                          ),
                          onPressed: _closeNotificationsPanel,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Notifications content
                  Expanded(
                    child: _buildNotificationsContent(),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Profile panel (slide out from left)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: 0,
          bottom: 0,
          left: _showProfilePanel ? 0 : -400,
          width: 400,
          child: Material(
            elevation: 8,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E14), // cardBackground
                border: const Border(
                  right: BorderSide(
                    color: Color(0xFF1A2E23), // cardBorder
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: _buildProfilePanel(),
            ),
          ),
        ),
        // Overlay to close panels
        if (_showSettingsPanel || _showNotificationsPanel || _showProfilePanel)
          Positioned(
            left: _showProfilePanel ? 400 : 0,
            top: 0,
            right: (_showSettingsPanel || _showNotificationsPanel) ? 400 : 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showSettingsPanel = false;
                  _showNotificationsPanel = false;
                  _showProfilePanel = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationsContent() {
    // Mock notifications - in real app, load from API
    final mockNotifications = [
      {
        'type': 'announcement',
        'title': 'New Course Available',
        'message': 'Advanced Sales Techniques is now available in your course library.',
        'isRead': false,
        'time': '2 hours ago',
      },
      {
        'type': 'instructor_message',
        'title': 'Feedback from Instructor',
        'message': 'Great job on your recent role-play session! Your objection handling has improved significantly.',
        'isRead': false,
        'time': '5 hours ago',
      },
      {
        'type': 'achievement',
        'title': 'Achievement Unlocked',
        'message': 'You have completed 5 consecutive days of training! Keep up the great work.',
        'isRead': false,
        'time': '1 day ago',
      },
      {
        'type': 'system',
        'title': 'Welcome to DALE',
        'message': 'Start your journey to becoming a sales expert. Check out your first course!',
        'isRead': true,
        'time': '2 days ago',
      },
      {
        'type': 'system',
        'title': 'System Maintenance',
        'message': 'Scheduled maintenance on Sunday, 2 AM - 4 AM EST. Plan accordingly.',
        'isRead': true,
        'time': '3 days ago',
      },
      {
        'type': 'assignment',
        'title': 'New Assignment',
        'message': 'Complete the Cold Calling module by next Friday for feedback.',
        'isRead': true,
        'time': '4 days ago',
      },
    ];

    // Design colors
    const backgroundColor = Color(0xFF0A0E14); // cardBackground
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);
    const lime300 = Color(0xFFBEF264);
    const emerald400 = Color(0xFF34D399);
    const orange400 = Color(0xFFFF6900);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      itemCount: mockNotifications.length,
      itemBuilder: (context, index) {
        final notification = mockNotifications[index];
        final isRead = notification['isRead'] as bool;
        final type = notification['type'] as String;

        // Icon and color based on type
        IconData iconData;
        Color iconBgColor;
        Color iconColor;
        switch (type) {
          case 'announcement':
            iconData = Icons.campaign;
            iconBgColor = orange400.withOpacity(0.2);
            iconColor = orange400;
            break;
          case 'instructor_message':
            iconData = Icons.message;
            iconBgColor = lime300.withOpacity(0.2);
            iconColor = lime300;
            break;
          case 'achievement':
            iconData = Icons.emoji_events;
            iconBgColor = emerald400.withOpacity(0.2);
            iconColor = emerald400;
            break;
          case 'assignment':
            iconData = Icons.assignment;
            iconBgColor = lime300.withOpacity(0.2);
            iconColor = lime300;
            break;
          default: // system
            iconData = Icons.info_outline;
            iconBgColor = textSecondary.withOpacity(0.2);
            iconColor = textSecondary;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 130,
          decoration: BoxDecoration(
            color: isRead ? backgroundColor : const Color(0x0DBEF264), // lime300.withOpacity(0.05)
            border: Border.all(
              color: cardBorder,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(17),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title row with unread indicator
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] as String,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                              letterSpacing: -0.1504,
                              height: 1.43, // 20px line height / 14px font size
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: lime300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Message
                    Text(
                      notification['message'] as String,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                        letterSpacing: -0.1504,
                        height: 1.43, // 20px line height / 14px font size
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Time
                    Text(
                      notification['time'] as String,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                        letterSpacing: 0,
                        height: 1.33, // 16px line height / 12px font size
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfilePanel() {
    // Design colors
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);
    const lime300 = Color(0xFFBEF264);
    const red400 = Color(0xFFF87171);

    return Column(
      children: [
        // Profile header
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0x1ABEF264), // lime300.withOpacity(0.1)
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF1A2E23), // cardBorder
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 20,
                color: textPrimary,
              ),
              const SizedBox(width: 12),
              const Text(
                'Profile',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: textPrimary,
                  letterSpacing: -0.3125,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 16,
                  color: textPrimary,
                ),
                onPressed: _closeProfilePanel,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
            ],
          ),
        ),
        // Profile content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile section
                SizedBox(
                  height: 236,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: lime300.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _userName?.substring(0, 1).toUpperCase() ?? 'U',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 48,
                              fontWeight: FontWeight.w400,
                              color: lime300,
                              letterSpacing: 0.3516,
                              height: 1.0, // 48px line height / 48px font size
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        _userName ?? 'User',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: textPrimary,
                          letterSpacing: -0.3125,
                          height: 1.5, // 24px line height / 16px font size
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Subtitle
                      const Text(
                        'Rising Star',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: textSecondary,
                          letterSpacing: -0.3125,
                          height: 1.5, // 24px line height / 16px font size
                        ),
                      ),
                    ],
                  ),
                ),
                // Menu items
                Column(
                  children: [
                    // Edit Profile
                    _buildProfileMenuItem(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profile',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit profile coming soon')),
                        );
                      },
                    ),
                    // Change Password
                    _buildProfileMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Change password coming soon')),
                        );
                      },
                    ),
                    // Account Settings
                    _buildProfileMenuItem(
                      icon: Icons.person_pin_outlined,
                      title: 'Account Settings',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account settings coming soon')),
                        );
                      },
                    ),
                    // Security
                    _buildProfileMenuItem(
                      icon: Icons.security,
                      title: 'Security',
                      onTap: () {
                        _closeProfilePanel();
                        showDialog(
                          context: context,
                          builder: (context) => const SecurityModal(),
                        );
                      },
                    ),
                    // Divider
                    Container(
                      height: 1,
                      color: cardBorder,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 16),
                    // Help & Support
                    _buildProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Help & support coming soon')),
                        );
                      },
                    ),
                    // About
                    _buildProfileMenuItem(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('About coming soon')),
                        );
                      },
                    ),
                    // Divider
                    Container(
                      height: 1,
                      color: cardBorder,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 16),
                    // Sign Out
                    _buildProfileMenuItem(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      titleColor: red400,
                      onTap: _handleLogout,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    const textPrimary = Color(0xFFE8EAEF);
    const cardBorder = Color(0xFF1A2E23);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: titleColor ?? textPrimary,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: titleColor ?? textPrimary,
                    letterSpacing: -0.3125,
                    height: 1.5, // 24px line height / 16px font size
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: cardBorder,
            ),
          ],
        ),
      ),
    );
  }
}

class AppSplashScreen extends StatelessWidget {
  final String logoAssetPath;

  const AppSplashScreen({super.key, required this.logoAssetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF141820),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF1A2E23),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Image.asset(
                logoAssetPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFBEF264)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Preparing your simulation experience...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFA1A7B8),
                    letterSpacing: -0.15,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

