import 'package:flutter/material.dart';
import 'services/backend_api.dart';
import 'screens/session_live.dart';
import 'screens/recordings_list.dart';
import 'screens/session_lobby.dart';
import 'screens/settings.dart';

void main() {
  runApp(const DaleAvatarApp());
}

class DaleAvatarApp extends StatelessWidget {
  const DaleAvatarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DaleAvatar',
      theme: ThemeData(colorSchemeSeed: Colors.blue, brightness: Brightness.light),
      darkTheme: ThemeData(colorSchemeSeed: Colors.blue, brightness: Brightness.dark),
      home: const _HomeRouter(),
    );
  }
}

class _HomeRouter extends StatefulWidget {
  const _HomeRouter();

  @override
  State<_HomeRouter> createState() => _HomeRouterState();
}

class _HomeRouterState extends State<_HomeRouter> {
  int _index = 0;
  late final BackendApi _api;

  @override
  void initState() {
    super.initState();
    _api = BackendApi(const String.fromEnvironment('BACKEND_URL', defaultValue: 'http://localhost:4000'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DaleAvatar')),
      body: [
        const SessionLobbyScreen(),
        SessionLiveScreen(api: _api),
        RecordingsListScreen(api: _api),
        const SettingsScreen(),
      ][_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.login), label: 'Lobby'),
          NavigationDestination(icon: Icon(Icons.video_chat), label: 'Live'),
          NavigationDestination(icon: Icon(Icons.library_music), label: 'Recordings'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}

