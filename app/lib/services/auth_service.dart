import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _keyIsAuthenticated = 'is_authenticated';
  static const String _keyIsDemoMode = 'is_demo_mode';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyAuthToken = 'auth_token';

  bool _isAuthenticated = false;
  bool _isDemoMode = false;
  String? _userName;
  String? _userEmail;
  String? _authToken;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isDemoMode => _isDemoMode;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get authToken => _authToken;

  // Load auth state from shared preferences
  Future<void> loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool(_keyIsAuthenticated) ?? false;
    _isDemoMode = prefs.getBool(_keyIsDemoMode) ?? false;
    _userName = prefs.getString(_keyUserName);
    _userEmail = prefs.getString(_keyUserEmail);
    _authToken = prefs.getString(_keyAuthToken);
  }

  // Login with credentials
  Future<void> login(String email, String password) async {
    // In real app, call API here
    // For now, just simulate login
    final prefs = await SharedPreferences.getInstance();
    
    _isAuthenticated = true;
    _isDemoMode = false;
    _userEmail = email;
    _userName = email.split('@')[0]; // Use email prefix as name
    _authToken = 'token_${DateTime.now().millisecondsSinceEpoch}';

    await prefs.setBool(_keyIsAuthenticated, true);
    await prefs.setBool(_keyIsDemoMode, false);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserName, _userName!);
    await prefs.setString(_keyAuthToken, _authToken!);
  }

  // Demo login
  Future<void> demoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    
    _isAuthenticated = true;
    _isDemoMode = true;
    _userName = 'Demo User';
    _userEmail = 'demo@daleavatar.com';
    _authToken = 'demo_token';

    await prefs.setBool(_keyIsAuthenticated, true);
    await prefs.setBool(_keyIsDemoMode, true);
    await prefs.setString(_keyUserEmail, _userEmail!);
    await prefs.setString(_keyUserName, _userName!);
    await prefs.setString(_keyAuthToken, _authToken!);
  }

  // Register new user
  Future<void> register(String name, String email, String password) async {
    // In real app, call API here
    // For now, just simulate registration and login
    final prefs = await SharedPreferences.getInstance();
    
    _isAuthenticated = true;
    _isDemoMode = false;
    _userName = name;
    _userEmail = email;
    _authToken = 'token_${DateTime.now().millisecondsSinceEpoch}';

    await prefs.setBool(_keyIsAuthenticated, true);
    await prefs.setBool(_keyIsDemoMode, false);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyAuthToken, _authToken!);
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    _isAuthenticated = false;
    _isDemoMode = false;
    _userName = null;
    _userEmail = null;
    _authToken = null;

    await prefs.remove(_keyIsAuthenticated);
    await prefs.remove(_keyIsDemoMode);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyAuthToken);
  }
}

