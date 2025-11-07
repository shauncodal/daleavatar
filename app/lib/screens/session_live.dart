import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../services/backend_api.dart';
import '../widgets/avatar_webview.dart';
import 'analysis_loading_screen.dart';

class SessionLiveScreen extends StatefulWidget {
  final BackendApi api;
  final bool showAppBar;
  const SessionLiveScreen({super.key, required this.api, this.showAppBar = true});

  @override
  State<SessionLiveScreen> createState() => _SessionLiveScreenState();
}

class _SessionLiveScreenState extends State<SessionLiveScreen> {
  bool _isSimulationActive = false;
  int? _recordingId; // Used for recording tracking
  final _webKey = GlobalKey<AvatarWebViewState>();

  // Figma Design Colors
  static const backgroundColor = Color(0xFF000000); // Black
  static const cardBackground = Color(0xFF0A0E14); // Dark card
  static const cardBorder = Color(0xFF1A2E23); // Border color
  static const panelBackground = Color(0xFF141820); // Panel background
  static const textPrimary = Color(0xFFE8EAEF); // Primary text
  static const textSecondary = Color(0xFFA1A7B8); // Secondary text
  static const lime300 = Color(0xFFBEF264); // Lime-300

  Future<void> _startSimulation() async {
    try {
      setState(() => _isSimulationActive = true);
      
      // Get session token
      final token = await widget.api.createSessionToken();
      
      // Send backend URL to webview
      // ignore: invalid_use_of_protected_member
      await (_webKey.currentState)?.send({
        'type': 'backend_base',
        'url': 'http://localhost:4000'
      });
      
      // Create start request
      final startRequest = {
        'avatarName': 'Elenora_IT_Sitting_public',
        'quality': 'low',
        'knowledgeId': 'ecfd9a25389b4079b31b2f0629ab8ca7',
      };
      
      // Start session
      final sessionData = await widget.api.startSession(token, startRequest);
      
      // Validate session data
      if (sessionData['session_id'] == null || sessionData['url'] == null || sessionData['access_token'] == null) {
        setState(() => _isSimulationActive = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to start session')),
          );
        }
        return;
      }
      
      // Send session info to webview
      try {
        // ignore: invalid_use_of_protected_member
        final state = _webKey.currentState;
        if (state != null) {
          await state.setSessionData(token, sessionData);
          // Start recording automatically when simulation starts
          await _startRecording();
          // Start voice chat automatically
          await Future.delayed(const Duration(seconds: 2));
          // ignore: invalid_use_of_protected_member
          await (_webKey.currentState)?.send({'type': 'start_voice_chat'});
        }
      } catch (e) {
        // Fallback: try sending via regular send method
        // ignore: invalid_use_of_protected_member
        await (_webKey.currentState)?.send({
          'type': 'start',
          'token': token,
          'sessionData': sessionData,
        });
      }
    } catch (e) {
      setState(() => _isSimulationActive = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _stopSimulation() async {
    debugPrint('🔴 [STOP SIMULATION] ========== _stopSimulation called ==========');
    print('🔴 [STOP SIMULATION] ========== _stopSimulation called ==========');
    
    if (!mounted) return;
    
    // Stop recording first
    await _stopRecording();
    // Then stop the session
    // ignore: invalid_use_of_protected_member
    await (_webKey.currentState)?.send({'type': 'stop'});
    
    // Generate default recording name based on current date/time
    final now = DateTime.now();
    final recordingName = 'Simulation ${_formatDate(now)} - ${_formatTime(now)}';
    
    // Create recording data for navigation
    final recordingData = {
      'id': _recordingId ?? 0,
      'name': recordingName,
      'created_at': now.toIso8601String(),
      'status': 'ready',
      'duration_ms': 0, // Will be updated when recording is processed
    };
    
    // Navigate directly to loading screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AnalysisLoadingScreen(
            recordingId: _recordingId ?? 0,
            recording: recordingData,
          ),
        ),
      );
    }
  }
  
  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }
  
  String _formatTime(DateTime date) {
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _startRecording() async {
    try {
      final id = await widget.api.initRecording();
      setState(() => _recordingId = id);
      // ignore: invalid_use_of_protected_member
      await (_webKey.currentState)?.send({'type': 'record_start', 'recordingId': id});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording error: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    // ignore: invalid_use_of_protected_member
    await (_webKey.currentState)?.send({'type': 'record_stop'});
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Main content area
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Column(
                    children: [
                      // Video panels - webview handles both videos responsively
                      Expanded(
                        child: _isSimulationActive
                            ? Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: panelBackground,
                                      border: Border.all(color: cardBorder),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: AvatarWebView(
                                          key: _webKey,
                                          onMessage: (msg) {
                                            // Handle messages if needed
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : (isMobile
                                ? Column(
                                    children: [
                                      Expanded(child: _buildVideoContainer(isLeft: true)),
                                      SizedBox(height: 24),
                                      Expanded(child: _buildVideoContainer(isLeft: false)),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(child: _buildVideoContainer(isLeft: true)),
                                      SizedBox(width: 24),
                                      Expanded(child: _buildVideoContainer(isLeft: false)),
                                    ],
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
              // Control bar
              _buildControlBar(),
            ],
          ),
          // Exit button
          Positioned(
            left: 16,
            bottom: 88, // Above control bar
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    'http://localhost:4000/assets/4eb729752ccb6b2b8a87b59deb64187ccfe2b1e1.svg',
                    width: 16,
                    height: 16,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: textPrimary,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Exit',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textPrimary,
                      letterSpacing: -0.1504,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildVideoContainer({required bool isLeft}) {
    return Container(
      decoration: BoxDecoration(
        color: panelBackground,
        border: Border.all(color: cardBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _buildPlaceholder(isLeft),
    );
  }

  Widget _buildPlaceholder(bool isLeft) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isLeft ? 64 : 96,
            height: isLeft ? 64 : 96,
            decoration: BoxDecoration(
              color: textSecondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isLeft
                  ? Image.network(
                      'http://localhost:4000/assets/e007e7276845e1f0a7a3084ba94b6728e233e73a.svg',
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.videocam,
                          size: 32,
                          color: textSecondary,
                        );
                      },
                    )
                  : const Text(
                      '🎭',
                      style: TextStyle(
                        fontSize: 36,
                        height: 1.0,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isLeft
                ? 'Click "Start Simulation" to begin'
                : 'Avatar Standby',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: textSecondary,
              letterSpacing: -0.1504,
            ),
          ),
          if (isLeft) ...[
            const SizedBox(height: 4),
            Text(
              'Camera will start automatically',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: textSecondary.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: cardBackground,
        border: Border(
          top: BorderSide(color: cardBorder, width: 1),
        ),
      ),
      child: Center(
        child: _isSimulationActive
            ? ElevatedButton(
                onPressed: () {
                  debugPrint('🟢 [BUTTON] ========== Stop Simulation button PRESSED ==========');
                  print('🟢 [BUTTON] ========== Stop Simulation button PRESSED ==========');
                  try {
                    _stopSimulation();
                  } catch (e, stackTrace) {
                    debugPrint('❌ [BUTTON] ERROR calling _stopSimulation: $e');
                    print('❌ [BUTTON] ERROR calling _stopSimulation: $e');
                    debugPrint('❌ [BUTTON] Stack trace: $stackTrace');
                    print('❌ [BUTTON] Stack trace: $stackTrace');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  minimumSize: const Size(169.766, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stop, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Stop Simulation',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.1504,
                      ),
                    ),
                  ],
                ),
              )
            : ElevatedButton(
                onPressed: _startSimulation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: lime300,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  minimumSize: const Size(169.766, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'http://localhost:4000/assets/4f3e9354fda0c61d64630d0fc899b11a365d960b.svg',
                      width: 16,
                      height: 16,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.play_arrow,
                          size: 16,
                          color: Colors.black,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Start Simulation',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.1504,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
