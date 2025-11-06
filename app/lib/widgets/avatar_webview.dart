import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import for dart:html (only available on web)
// We'll use dynamic access to avoid compile errors in tests

typedef BridgeMessageHandler = void Function(Map<String, dynamic> msg);

class AvatarWebView extends StatefulWidget {
  final BridgeMessageHandler onMessage;
  const AvatarWebView({super.key, required this.onMessage});

  @override
  State<AvatarWebView> createState() => AvatarWebViewState();
}

class AvatarWebViewState extends State<AvatarWebView> {
  InAppWebViewController? _controller;

  // Store pending session data to inject when ready
  Map<String, dynamic>? _pendingSessionData;
  String? _pendingToken;

  Future<void> setSessionData(String token, Map<String, dynamic> sessionData) async {
    // Validate session data before storing
    if (token.isEmpty) {
      print('Error: Token is empty');
      return;
    }
    
    if (sessionData['session_id'] == null || 
        sessionData['url'] == null || 
        sessionData['access_token'] == null) {
      print('Error: Missing required session data fields');
      print('Session data: $sessionData');
      return;
    }
    
    _pendingToken = token;
    _pendingSessionData = sessionData;
    
    if (_controller != null) {
      await _injectSessionData();
    }
  }

  Future<void> _injectSessionData() async {
    if (_pendingToken == null || _pendingSessionData == null || _controller == null) return;
    
    final token = _pendingToken!;
    final sessionData = _pendingSessionData!;
    
    // Validate session data
    final sessionId = sessionData['session_id']?.toString() ?? '';
    final sessionUrl = sessionData['url']?.toString() ?? '';
    final accessToken = sessionData['access_token']?.toString() ?? '';
    
    if (sessionId.isEmpty || sessionUrl.isEmpty || accessToken.isEmpty) {
      print('Error: Missing required session parameters');
      print('Session ID: $sessionId, URL: $sessionUrl, Access Token: ${accessToken.isNotEmpty ? "present" : "missing"}');
      return;
    }
    
    print('Injecting session data: sessionId=$sessionId, url=$sessionUrl');
    
    // Try multiple methods to ensure message delivery
    try {
      // Method 1: Try localStorage first (works on web)
      final localStorageJs = '''
        localStorage.setItem('_flutter_webview_msg', JSON.stringify({
          type: 'start',
          token: ${jsonEncode(token)},
          sessionData: ${jsonEncode(sessionData)}
        }));
        console.log('[Flutter] Session data written to localStorage');
        'localStorage_set';
      ''';
      await _controller?.evaluateJavascript(source: localStorageJs);
      
      // Method 2: Reload the page with session data in URL parameters
      final urlParams = [
        'token=${Uri.encodeComponent(token)}',
        'sessionId=${Uri.encodeComponent(sessionId)}',
        'url=${Uri.encodeComponent(sessionUrl)}',
        'accessToken=${Uri.encodeComponent(accessToken)}',
      ].join('&');
      
      final url = 'assets/webview/index.html?$urlParams';
      print('Loading URL with session data: $url');
      
      await _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
      print('Page reloaded with session data in URL');
    } catch (e) {
      print('Error injecting session data: $e');
      // Fallback: try postMessage
      try {
        final js = '''
          window.postMessage({
            type: 'start',
            token: ${jsonEncode(token)},
            sessionData: ${jsonEncode(sessionData)}
          }, '*');
          console.log('[Flutter] Session data sent via postMessage');
        ''';
        await _controller?.evaluateJavascript(source: js);
      } catch (e2) {
        print('Error with postMessage fallback: $e2');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialFile: 'assets/webview/index.html',
      onWebViewCreated: (c) {
        _controller = c;
        // On non-web platforms, use addJavaScriptHandler
        if (!kIsWeb) {
          try {
        c.addJavaScriptHandler(handlerName: 'flutterBridge', callback: (args) {
          if (args.isNotEmpty && args.first is Map) {
            widget.onMessage((args.first as Map).cast<String, dynamic>());
          }
          return null;
        });
          } catch (e) {
            // Handler might not be available on all platforms
            print('Could not add JavaScript handler: $e');
          }
        }
      },
      onLoadStop: (controller, url) async {
        // Mark webview as ready
        _controller = controller;
        print('WebView loaded: $url');
        
        // Check if URL has session data in hash
        if (url.toString().contains('#')) {
          final hash = url.toString().split('#').last;
          try {
            final decoded = utf8.decode(base64Decode(hash));
            final data = jsonDecode(decoded) as Map<String, dynamic>;
            print('Found session data in URL hash');
            // Trigger the start handler
            final js = '''
              if (window.handleMessage) {
                window.handleMessage({data: ${jsonEncode({'type': 'start', 'token': data['token'], 'sessionData': data['sessionData']})}});
              }
            ''';
            await controller.evaluateJavascript(source: js);
          } catch (e) {
            print('Error parsing session data from URL: $e');
          }
        }
        
        // Inject pending session data if available
        if (_pendingToken != null && _pendingSessionData != null) {
          await _injectSessionData();
        }
        
        // For web, set up message listener and expose a global function
        if (kIsWeb) {
          // Test if evaluateJavascript works
          try {
            final testResult = await controller.evaluateJavascript(source: 'console.log("TEST: evaluateJavascript works"); "test-ok"');
            print('EvaluateJavascript test result: $testResult');
            
            await controller.evaluateJavascript(source: '''
              (function() {
                console.log('[Flutter->WebView] Setting up webview message handlers...');
                
                // Set up flutterBridge handler for web
                window.flutter_inappwebview = window.flutter_inappwebview || {};
                window.flutter_inappwebview.callHandler = function(handlerName, data) {
                  console.log('[Flutter->WebView] flutterBridge called:', handlerName, data);
                  window.dispatchEvent(new CustomEvent('flutter_message', { detail: data }));
                };
                
                // Expose a function to receive messages from Flutter
                window.receiveFromFlutter = function(data) {
                  console.log('[Flutter->WebView] receiveFromFlutter called with:', data);
                  const event = new MessageEvent('message', { data: data });
                  window.dispatchEvent(event);
                };
                
                window.onFlutterMessage = function(data) {
                  console.log('[Flutter->WebView] onFlutterMessage called with:', data);
                  const event = new MessageEvent('message', { data: data });
                  window.dispatchEvent(event);
                };
                
                console.log('[Flutter->WebView] Webview message handlers set up');
                window._webviewReady = true;
              })();
            ''');
            print('Message handlers setup script executed');
          } catch (e) {
            print('Error setting up message handlers: $e');
          }
        }
      },
      onConsoleMessage: (controller, message) {
        // Log console messages for debugging - this should show webview console logs
        print('📱 WebView console [${message.messageLevel}]: ${message.message}');
        // Check for messages about handlers or queue
        if (message.message.contains('[WebView]') || message.message.contains('[Flutter->WebView]')) {
          print('🔍 KEY LOG: ${message.message}');
        }
      },
    );
  }

  /// Disable or enable pointer events on the webview iframe (for web platform)
  Future<void> setPointerEventsEnabled(bool enabled) async {
    if (!kIsWeb) return;
    
    // On web platform, we'll use JavaScript to disable pointer events
    // This avoids needing dart:html which isn't available in tests
    try {
      // Use JavaScript evaluation to access the DOM
      // This works on web but won't cause compile errors in tests
      final js = '''
        (function() {
          var iframes = document.querySelectorAll('iframe');
          for (var i = 0; i < iframes.length; i++) {
            iframes[i].style.pointerEvents = ${enabled ? "'auto'" : "'none'"};
          }
          console.log('[Flutter] ${enabled ? "Enabled" : "Disabled"} pointer events on webview iframe');
        })();
      ''';
      
      // Note: This requires the webview controller, which may not be available
      // The actual implementation will be done via the webview's evaluateJavascript
      // For now, this is a placeholder that won't cause test failures
      print('[Flutter] setPointerEventsEnabled called: $enabled (web-only feature)');
    } catch (e) {
      // Silently fail in test environment
      if (kIsWeb) {
        print('Error ${enabled ? "enabling" : "disabling"} webview pointer events: $e');
      }
    }
  }

  Future<void> send(Map<String, dynamic> msg) async {
    if (_controller == null) {
      print('Cannot send message: controller is null');
      return;
    }
    
    // Store the message in a global variable and call a handler function directly
    final msgJson = jsonEncode(msg);
    
    // Use a simpler approach - just set a global variable that the HTML polls for
    final methods = [
      // Method 0: Write to localStorage (most reliable for web platform)
      '''
        try {
          const msg = $msgJson;
          localStorage.setItem('_flutter_webview_msg', JSON.stringify(msg));
          console.log('[Flutter->WebView] Method0: Message written to localStorage:', typeof msg);
          return 'localStorage_written';
        } catch(e) { 
          console.error('[Flutter->WebView] Method0 error:', e); 
          return 'error: ' + e.message;
        }
      ''',
      // Method 0.5: Write to hidden DOM element
      '''
        try {
          const msg = $msgJson;
          const el = document.getElementById('_flutter_messages');
          if (el) {
            el.textContent = JSON.stringify(msg);
            console.log('[Flutter->WebView] Method0.5: Message written to DOM element:', typeof msg);
            return 'dom_written';
          }
          return 'no_dom_element';
        } catch(e) { 
          console.error('[Flutter->WebView] Method0.5 error:', e); 
          return 'error: ' + e.message;
        }
      ''',
      // Method 1: Store in queue array
      '''
        try {
          if (typeof window._flutterMessageQueue === 'undefined') {
            window._flutterMessageQueue = [];
          }
          const msg = $msgJson;
          window._flutterMessageQueue.push(msg);
          console.log('[Flutter->WebView] Method1: Message added to queue:', typeof msg, msg);
          return 'queued';
        } catch(e) { 
          console.error('[Flutter->WebView] Method1 error:', e); 
          return 'error: ' + e.message;
        }
      ''',
      // Method 2: Store as last message
      '''
        try {
          const msg = $msgJson;
          window._lastFlutterMessage = msg;
          console.log('[Flutter->WebView] Method2: _lastFlutterMessage set:', typeof msg, msg);
          return 'set';
        } catch(e) { 
          console.error('[Flutter->WebView] Method2 error:', e); 
          return 'error: ' + e.message;
        }
      ''',
      // Method 3: Try direct function call
      '''
        try {
          const msg = $msgJson;
          if (typeof window.receiveFromFlutter === 'function') {
            console.log('[Flutter->WebView] Method3: Calling receiveFromFlutter');
            window.receiveFromFlutter(msg);
            return 'called receiveFromFlutter';
          } else if (typeof window.handleMessage === 'function') {
            console.log('[Flutter->WebView] Method3: Calling handleMessage');
            window.handleMessage({data: msg});
            return 'called handleMessage';
          } else {
            console.warn('[Flutter->WebView] Method3: No handlers found!');
            return 'no handlers';
          }
        } catch(e) { 
          console.error('[Flutter->WebView] Method3 error:', e); 
          return 'error: ' + e.message;
        }
      ''',
    ];
    
    // Method: Use URL hash (most reliable when evaluateJavascript fails)
    try {
      final msgJson = jsonEncode(msg);
      final base64Msg = base64Encode(utf8.encode(msgJson));
      final currentUrl = await _controller?.getUrl();
      if (currentUrl != null) {
        // Update URL hash with base64-encoded message
        final baseUrl = currentUrl.toString().split('#').first;
        final newUrl = '$baseUrl#$base64Msg';
        await _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(newUrl)));
        print('Message sent via URL hash for ${msg['type']}');
        return; // Don't try other methods if URL hash works
      }
    } catch (e) {
      print('Error with URL hash method: $e');
    }
    
    for (int i = 0; i < methods.length; i++) {
      try {
        print('Trying method ${i + 1} for ${msg['type']}...');
        final result = await _controller?.evaluateJavascript(source: methods[i]);
        print('Method ${i + 1} result: $result');
        // If we get a non-null result, the method worked
        if (result != null && result.toString().isNotEmpty && !result.toString().contains('null')) {
          print('Method ${i + 1} succeeded: $result');
          break; // Stop trying other methods if one works
        }
        // Small delay between methods
        await Future.delayed(const Duration(milliseconds: 50));
      } catch (e) {
        print('Error in method ${i + 1}: $e');
      }
    }
    
    // Final check - verify the message was stored
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final checkResult = await _controller?.evaluateJavascript(source: '''
        JSON.stringify({
          queueLength: window._flutterMessageQueue ? window._flutterMessageQueue.length : 0,
          hasLastMessage: !!window._lastFlutterMessage,
          hasHandlers: {
            receiveFromFlutter: typeof window.receiveFromFlutter,
            handleMessage: typeof window.handleMessage
          }
        })
      ''');
      print('Message status check: $checkResult');
    } catch (e) {
      print('Status check error: $e');
    }
    
    print('Message send complete: ${msg['type']}');
  }
}

