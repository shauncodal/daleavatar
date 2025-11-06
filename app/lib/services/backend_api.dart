import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendApi {
  final String baseUrl;
  String? _authToken;

  BackendApi(this.baseUrl);

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<String> createSessionToken() async {
    final res = await http.post(Uri.parse('$baseUrl/api/stream/session-token'));
    final body = jsonDecode(res.body);
    return body['token'];
  }

  Future<Map<String, dynamic>> startSession(String token, Map<String, dynamic> startRequest) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/stream/new-session'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'startRequest': startRequest}),
    );
    
    if (res.statusCode != 200) {
      final errorBody = jsonDecode(res.body);
      throw Exception('Failed to start session: ${errorBody['error']} - ${errorBody['detail']}');
    }
    
    final body = jsonDecode(res.body);
    
    // Normalize response to ensure correct field names
    return {
      'session_id': body['session_id'] ?? body['sessionId'],
      'access_token': body['access_token'] ?? body['accessToken'],
      'url': body['url'],
      'is_paid': body['is_paid'] ?? body['isPaid'] ?? false,
    };
  }

  Future<void> callStartSession(String sessionId, String token) async {
    await http.post(
      Uri.parse('$baseUrl/api/stream/start-session'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sessionId': sessionId, 'token': token}),
    );
  }

  Future<void> sendSpeak(String token, String text, {String taskType = 'REPEAT'}) async {
    await http.post(
      Uri.parse('$baseUrl/api/stream/speak'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'text': text, 'taskType': taskType}),
    );
  }

  Future<Map<String, dynamic>> listRecordings() async {
    final res = await http.get(Uri.parse('$baseUrl/api/recordings'));
    return {'items': jsonDecode(res.body)};
  }

  Future<int> initRecording() async {
    final res = await http.post(Uri.parse('$baseUrl/api/recordings/init'));
    final body = jsonDecode(res.body);
    return body['id'] as int;
  }

  Future<void> uploadCompositeWebm(int id, String dataUrl) async {
    await http.post(Uri.parse('$baseUrl/api/recordings/upload/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'webmBase64': dataUrl}));
  }

  // Auth methods
  Future<Map<String, dynamic>> register(String email, String password, {String? name}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
    );
    
    if (res.statusCode != 201) {
      final errorBody = jsonDecode(res.body);
      throw Exception('Registration failed: ${errorBody['error']} - ${errorBody['detail']}');
    }
    
    final body = jsonDecode(res.body);
    if (body['token'] != null) {
      setAuthToken(body['token']);
    }
    return body;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    
    if (res.statusCode != 200) {
      final errorBody = jsonDecode(res.body);
      throw Exception('Login failed: ${errorBody['error']} - ${errorBody['detail']}');
    }
    
    final body = jsonDecode(res.body);
    if (body['token'] != null) {
      setAuthToken(body['token']);
    }
    return body;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/auth/me'),
      headers: _getHeaders(),
    );
    
    if (res.statusCode != 200) {
      final errorBody = jsonDecode(res.body);
      throw Exception('Failed to get profile: ${errorBody['error']}');
    }
    
    return jsonDecode(res.body);
  }

  Future<void> updateProfile({String? name, Map<String, dynamic>? profileSettings}) async {
    final res = await http.put(
      Uri.parse('$baseUrl/api/auth/profile'),
      headers: _getHeaders(),
      body: jsonEncode({'name': name, 'profileSettings': profileSettings}),
    );
    
    if (res.statusCode != 200) {
      final errorBody = jsonDecode(res.body);
      throw Exception('Failed to update profile: ${errorBody['error']}');
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/change-password'),
      headers: _getHeaders(),
      body: jsonEncode({'currentPassword': currentPassword, 'newPassword': newPassword}),
    );
    
    if (res.statusCode != 200) {
      final errorBody = jsonDecode(res.body);
      throw Exception('Failed to change password: ${errorBody['error']}');
    }
  }

  // Course methods
  Future<List<dynamic>> listCourses() async {
    final res = await http.get(Uri.parse('$baseUrl/api/courses'));
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch courses');
    }
    return jsonDecode(res.body) as List;
  }

  Future<Map<String, dynamic>> getCourse(int courseId) async {
    final res = await http.get(Uri.parse('$baseUrl/api/courses/$courseId'));
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch course');
    }
    return jsonDecode(res.body);
  }

  Future<void> enrollInCourse(int courseId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/courses/$courseId/enroll'),
      headers: _getHeaders(),
    );
    
    if (res.statusCode != 201 && res.statusCode != 200) {
      final errorBody = jsonDecode(res.body);
      throw Exception('Enrollment failed: ${errorBody['error']}');
    }
  }

  Future<List<dynamic>> getUserEnrollments() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/courses/user/enrollments'),
      headers: _getHeaders(),
    );
    
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch enrollments');
    }
    return jsonDecode(res.body) as List;
  }

  // Dashboard methods
  Future<Map<String, dynamic>> getDashboard() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/dashboard'),
      headers: _getHeaders(),
    );
    
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch dashboard');
    }
    return jsonDecode(res.body);
  }

  // Progress methods
  Future<void> updateProgress(int enrollmentId, {double? completionPercentage, int? currentStep}) async {
    final res = await http.put(
      Uri.parse('$baseUrl/api/progress/$enrollmentId'),
      headers: _getHeaders(),
      body: jsonEncode({
        if (completionPercentage != null) 'completionPercentage': completionPercentage,
        if (currentStep != null) 'currentStep': currentStep,
      }),
    );
    
    if (res.statusCode != 200) {
      throw Exception('Failed to update progress');
    }
  }

  Future<void> recordChoice(int enrollmentId, String decisionPoint, String choiceMade, {int? choiceScore, String? feedback}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/progress/$enrollmentId/choices'),
      headers: _getHeaders(),
      body: jsonEncode({
        'decisionPoint': decisionPoint,
        'choiceMade': choiceMade,
        if (choiceScore != null) 'choiceScore': choiceScore,
        if (feedback != null) 'feedback': feedback,
      }),
    );
    
    if (res.statusCode != 201) {
      throw Exception('Failed to record choice');
    }
  }

  Future<Map<String, dynamic>> getAnalytics(int enrollmentId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/progress/$enrollmentId/analytics'),
      headers: _getHeaders(),
    );
    
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch analytics');
    }
    return jsonDecode(res.body);
  }

  // Notification methods
  Future<List<dynamic>> getNotifications({bool unreadOnly = false, int limit = 50}) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/notifications?unread_only=$unreadOnly&limit=$limit'),
      headers: _getHeaders(),
    );
    
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch notifications');
    }
    return jsonDecode(res.body) as List;
  }

  Future<void> markNotificationRead(int notificationId) async {
    final res = await http.put(
      Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
      headers: _getHeaders(),
    );
    
    if (res.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  Future<void> markAllNotificationsRead() async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/notifications/read-all'),
      headers: _getHeaders(),
    );
    
    if (res.statusCode != 200) {
      throw Exception('Failed to mark all notifications as read');
    }
  }
}

