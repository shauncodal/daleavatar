import 'package:flutter/material.dart';
import '../services/backend_api.dart';

class RecordingsListScreen extends StatefulWidget {
  final BackendApi api;
  const RecordingsListScreen({super.key, required this.api});

  @override
  State<RecordingsListScreen> createState() => _RecordingsListScreenState();
}

class _RecordingsListScreenState extends State<RecordingsListScreen> {
  List<dynamic> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await widget.api.listRecordings();
    setState(() => _items = (res['items'] as List));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (ctx, i) {
          final it = _items[i] as Map<String, dynamic>;
          return ListTile(
            title: Text('Recording #${it['id']} — ${it['status']}'),
            subtitle: Text(it['summary_text']?.toString() ?? ''),
          );
        },
      ),
    );
  }
}

