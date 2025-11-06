import 'package:flutter/material.dart';
import 'session_lobby.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SessionLobbyScreen(), // Show avatar settings panel
    );
  }
}

