import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendApi {
  final String baseUrl;
  BackendApi(this.baseUrl);

  Future<String> createSessionToken() async {
    final res = await http.post(Uri.parse('$baseUrl/api/stream/session-token'));
    final body = jsonDecode(res.body);
    return body['token'];
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
}

