import 'package:flutter/material.dart';
import 'dart:async';
import 'recording_detail.dart';

class AnalysisLoadingScreen extends StatefulWidget {
  final int recordingId;
  final Map<String, dynamic> recording;
  
  const AnalysisLoadingScreen({
    super.key,
    required this.recordingId,
    required this.recording,
  });

  @override
  State<AnalysisLoadingScreen> createState() => _AnalysisLoadingScreenState();
}

class _AnalysisLoadingScreenState extends State<AnalysisLoadingScreen> {
  int _currentStep = 0;
  double _progress = 0.0;
  Timer? _progressTimer;
  Timer? _navigationTimer;

  // Figma Design Colors
  static const backgroundColor = Color(0xFF000000); // Black
  static const lime300 = Color(0xFFBEF264); // Lime-300

  @override
  void initState() {
    super.initState();
    _startProgress();
    // Navigate to report after 5 seconds
    _navigationTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RecordingDetailScreen(recording: widget.recording),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _startProgress() {
    // Animate progress over 5 seconds
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          _progress += 0.01; // 1% per 50ms = 5 seconds total
          
          // Step 1: Analyzing (0-50%)
          if (_progress >= 0.5 && _currentStep == 0) {
            _currentStep = 1;
          }
          
          if (_progress >= 1.0) {
            _progress = 1.0;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Opacity(
              opacity: 0.649,
              child: Image.network(
                'http://localhost:4000/assets/3228caccabcd097b00e036963ce56e4e2efef6da.png',
                width: 160,
                height: 160,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: lime300.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: lime300,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 38.931),
            
            // "Performance..." text
            Opacity(
              opacity: 0.907,
              child: _AnimatedDots(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedDots extends StatefulWidget {
  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  static const lime300 = Color(0xFFBEF264); // Lime-300

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dots = (_controller.value * 3).floor() % 4;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Performance',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 30,
                fontWeight: FontWeight.normal,
                color: lime300,
                letterSpacing: 0.3955,
              ),
            ),
            Opacity(
              opacity: 0.85,
              child: Text(
                '.' * dots,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                  color: lime300,
                  letterSpacing: 0.3955,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

