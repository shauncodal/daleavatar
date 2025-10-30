import 'package:flutter/material.dart';

class SessionLobbyScreen extends StatelessWidget {
  const SessionLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Device Check'),
        const SizedBox(height: 8),
        const Text('Configure avatar, voice, knowledge (coming soon)'),
      ],
    );
  }
}

