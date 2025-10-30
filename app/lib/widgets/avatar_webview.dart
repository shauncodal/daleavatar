import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

typedef BridgeMessageHandler = void Function(Map<String, dynamic> msg);

class AvatarWebView extends StatefulWidget {
  final BridgeMessageHandler onMessage;
  const AvatarWebView({super.key, required this.onMessage});

  @override
  State<AvatarWebView> createState() => AvatarWebViewState();
}

class AvatarWebViewState extends State<AvatarWebView> {
  InAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialFile: 'assets/webview/index.html',
      onWebViewCreated: (c) {
        _controller = c;
        c.addJavaScriptHandler(handlerName: 'flutterBridge', callback: (args) {
          if (args.isNotEmpty && args.first is Map) {
            widget.onMessage((args.first as Map).cast<String, dynamic>());
          }
          return null;
        });
      },
    );
  }

  Future<void> send(Map<String, dynamic> msg) async {
    final js = 'window.postMessage(' + jsonEncode(msg) + ', "*")';
    await _controller?.evaluateJavascript(source: js);
  }
}

