import 'package:flutter/material.dart';

class RecordingDetailScreen extends StatelessWidget {
  final int id;
  const RecordingDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recording #$id')),
      body: const Center(
        child: Text('Playback and analysis results coming soon'),
      ),
    );
  }
}

