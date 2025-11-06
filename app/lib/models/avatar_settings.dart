class AvatarSettings {
  // Avatar configuration
  String avatarName;
  AvatarQuality quality;
  
  // Voice settings
  String? voiceId;
  double voiceRate; // 0.5 to 1.5
  VoiceEmotion? voiceEmotion;
  
  // Knowledge base
  String? knowledgeId;
  String? knowledgeBase; // Custom system prompt
  
  // STT settings
  STTProvider sttProvider;
  double sttConfidence; // 0.0 to 1.0
  
  // Language
  String language;
  
  // Voice chat transport
  VoiceChatTransport voiceChatTransport;
  
  // Session settings
  int activityIdleTimeout; // seconds (30-3600)
  bool useSilencePrompt;
  
  AvatarSettings({
    this.avatarName = 'Elenora_IT_Sitting_public',
    this.quality = AvatarQuality.low,
    this.voiceId,
    this.voiceRate = 1.0,
    this.voiceEmotion,
    this.knowledgeId,
    this.knowledgeBase,
    this.sttProvider = STTProvider.deepgram,
    this.sttConfidence = 0.55,
    this.language = 'en',
    this.voiceChatTransport = VoiceChatTransport.websocket,
    this.activityIdleTimeout = 120,
    this.useSilencePrompt = false,
  });

  // Convert to Map for JSON serialization
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'avatarName': avatarName,
      'quality': quality.name,
      'voiceRate': voiceRate,
      'sttProvider': sttProvider.name,
      'sttConfidence': sttConfidence,
      'language': language,
      'voiceChatTransport': voiceChatTransport.name,
      'activityIdleTimeout': activityIdleTimeout,
      'useSilencePrompt': useSilencePrompt,
    };
    
    if (voiceId != null) map['voiceId'] = voiceId;
    if (voiceEmotion != null) map['voiceEmotion'] = voiceEmotion!.name;
    if (knowledgeId != null) map['knowledgeId'] = knowledgeId;
    if (knowledgeBase != null) map['knowledgeBase'] = knowledgeBase;
    
    return map;
  }

  // Create from Map
  factory AvatarSettings.fromJson(Map<String, dynamic> json) {
    return AvatarSettings(
      avatarName: json['avatarName'] ?? 'Elenora_IT_Sitting_public',
      quality: AvatarQuality.values.firstWhere(
        (q) => q.name == json['quality'],
        orElse: () => AvatarQuality.low,
      ),
      voiceId: json['voiceId'],
      voiceRate: (json['voiceRate'] ?? 1.0).toDouble(),
      voiceEmotion: json['voiceEmotion'] != null
          ? VoiceEmotion.values.firstWhere(
              (e) => e.name == json['voiceEmotion'],
              orElse: () => VoiceEmotion.friendly,
            )
          : null,
      knowledgeId: json['knowledgeId'],
      knowledgeBase: json['knowledgeBase'],
      sttProvider: STTProvider.values.firstWhere(
        (p) => p.name == json['sttProvider'],
        orElse: () => STTProvider.deepgram,
      ),
      sttConfidence: (json['sttConfidence'] ?? 0.55).toDouble(),
      language: json['language'] ?? 'en',
      voiceChatTransport: VoiceChatTransport.values.firstWhere(
        (t) => t.name == json['voiceChatTransport'],
        orElse: () => VoiceChatTransport.websocket,
      ),
      activityIdleTimeout: json['activityIdleTimeout'] ?? 120,
      useSilencePrompt: json['useSilencePrompt'] ?? false,
    );
  }

  // Convert to HeyGen SDK StartAvatarRequest format
  Map<String, dynamic> toStartRequest() {
    final request = <String, dynamic>{
      'avatarName': avatarName,
      'quality': quality.name,
    };

    // Add voice settings only if voiceId is provided
    if (voiceId != null && voiceId!.isNotEmpty) {
      final voice = <String, dynamic>{
        'voiceId': voiceId,
        'rate': voiceRate,
      };
      if (voiceEmotion != null) {
        voice['emotion'] = voiceEmotion!.name.toUpperCase();
      }
      request['voice'] = voice;
    }

    // Add STT settings
    request['sttSettings'] = {
      'provider': sttProvider.name.toUpperCase(),
      'confidence': sttConfidence,
    };

    // Only add optional fields if they have values
    if (language.isNotEmpty) {
      request['language'] = language;
    }

    request['voiceChatTransport'] = voiceChatTransport.name.toUpperCase();
    request['activityIdleTimeout'] = activityIdleTimeout;

    if (knowledgeId != null && knowledgeId!.isNotEmpty) {
      request['knowledgeId'] = knowledgeId;
    }

    if (knowledgeBase != null && knowledgeBase!.isNotEmpty) {
      request['knowledgeBase'] = knowledgeBase;
    }

    return request;
  }

  AvatarSettings copyWith({
    String? avatarName,
    AvatarQuality? quality,
    String? voiceId,
    double? voiceRate,
    VoiceEmotion? voiceEmotion,
    String? knowledgeId,
    String? knowledgeBase,
    STTProvider? sttProvider,
    double? sttConfidence,
    String? language,
    VoiceChatTransport? voiceChatTransport,
    int? activityIdleTimeout,
    bool? useSilencePrompt,
  }) {
    return AvatarSettings(
      avatarName: avatarName ?? this.avatarName,
      quality: quality ?? this.quality,
      voiceId: voiceId ?? this.voiceId,
      voiceRate: voiceRate ?? this.voiceRate,
      voiceEmotion: voiceEmotion ?? this.voiceEmotion,
      knowledgeId: knowledgeId ?? this.knowledgeId,
      knowledgeBase: knowledgeBase ?? this.knowledgeBase,
      sttProvider: sttProvider ?? this.sttProvider,
      sttConfidence: sttConfidence ?? this.sttConfidence,
      language: language ?? this.language,
      voiceChatTransport: voiceChatTransport ?? this.voiceChatTransport,
      activityIdleTimeout: activityIdleTimeout ?? this.activityIdleTimeout,
      useSilencePrompt: useSilencePrompt ?? this.useSilencePrompt,
    );
  }
}

enum AvatarQuality {
  low,    // 500kbps, 360p
  medium, // 1000kbps, 480p
  high,   // 2000kbps, 720p
}

enum VoiceEmotion {
  excited,
  serious,
  friendly,
  soothing,
  broadcaster,
}

enum STTProvider {
  deepgram,
  // Add other providers as needed
}

enum VoiceChatTransport {
  websocket,
  // Add other transports as needed
}

