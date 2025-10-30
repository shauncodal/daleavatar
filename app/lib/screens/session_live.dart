import 'package:flutter/material.dart';
import '../services/backend_api.dart';
import '../widgets/avatar_webview.dart';

class SessionLiveScreen extends StatefulWidget {
  final BackendApi api;
  const SessionLiveScreen({super.key, required this.api});

  @override
  State<SessionLiveScreen> createState() => _SessionLiveScreenState();
}

class _SessionLiveScreenState extends State<SessionLiveScreen> {
  String _log = '';
  int? _recordingId;
  final _webKey = GlobalKey<AvatarWebViewState>();

  void _onBridge(Map<String, dynamic> msg) {
    setState(() => _log += '\n${msg.toString()}');
  }

  Future<void> _start() async {
    final token = await widget.api.createSessionToken();
    // send token to webview; actual session start handled in bridge
    // ignore: invalid_use_of_protected_member
    await (_webKey.currentState)?.send({'type': 'start', 'token': token});
  }

  Future<void> _startRecording() async {
    final id = await widget.api.initRecording();
    setState(() => _recordingId = id);
    await (_webKey.currentState)?.send({'type': 'record_start', 'recordingId': id});
  }

  Future<void> _stopRecording() async {
    await (_webKey.currentState)?.send({'type': 'record_stop'});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AvatarWebView(
            key: _webKey,
            onMessage: _onBridge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ElevatedButton(onPressed: _start, child: const Text('Start Session')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _startRecording, child: const Text('Start Rec')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _stopRecording, child: const Text('Stop Rec')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () {}, child: const Text('STT (stub)')),
            ],
          ),
        ),
        SizedBox(
          height: 80,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Text(_log),
          ),
        ),
      ],
    );
  }
}

