# HeyGen Integration - Based on Official SDK

This implementation follows the official HeyGen StreamingAvatarSDK pattern.

## Architecture

### Video Streaming: LiveKit (WebRTC)
- Uses LiveKit Room for real-time avatar video stream
- Connects to HeyGen's LiveKit server using session URL and access token
- Video tracks are subscribed and displayed in the avatar video element

### Voice Chat: WebSocket + Protobuf
- WebSocket connection to HeyGen for bidirectional audio communication
- Audio is encoded using protobuf (pipecat.Frame format)
- Sends user audio to HeyGen for real-time conversation

## Flow

1. **Create Token**: `POST /v1/streaming.create_token`
2. **Create Session**: `POST /v1/streaming.new` with avatar config
   - Returns: `session_id`, `access_token`, `url` (LiveKit URL)
3. **Start Session**: `POST /v1/streaming.start` with session_id
4. **Connect LiveKit**: Connect to the LiveKit room using URL and access_token
5. **Connect WebSocket**: Connect to HeyGen WebSocket for voice chat
6. **Start Voice Chat**: Begin capturing and sending audio

## Configuration Required

In `app/lib/screens/session_live.dart`, update:

```dart
final startRequest = {
  'avatarName': 'your-heygen-avatar-id',  // Required
  'quality': 'low',                        // 'low', 'medium', or 'high'
  'voice': {
    'voiceId': 'your-heygen-voice-id',    // Required
    'rate': 1.0,                          // Optional: 0.5-1.5
    'emotion': 'friendly',                // Optional
  },
  // Optional:
  // 'language': 'en',
  // 'sttSettings': {'provider': 'deepgram', 'confidence': 0.55},
  // 'knowledgeId': 'your-knowledge-id',
};
```

## How to Get Avatar/Voice IDs

1. Go to https://labs.heygen.com/interactive-avatar
2. Click "Select Avatar" to see available avatars and their IDs
3. Or create your own avatar and get the ID
4. Voice IDs are available in your HeyGen dashboard

## Testing

1. Update `avatarName` and `voiceId` in `session_live.dart`
2. Run the Flutter app
3. Click "Start Session" - this will:
   - Create token
   - Create session
   - Connect LiveKit (video)
   - Connect WebSocket (voice)
4. Click "Start Voice Chat" - this enables two-way conversation
5. The avatar video should appear in the left video element
6. Your webcam appears in the right video element

## Current Implementation Status

✅ Token creation  
✅ Session creation with proper format  
✅ LiveKit connection setup  
✅ WebSocket connection for voice chat  
✅ Audio capture and sending (simplified - needs protobuf schema)  
⏳ Full protobuf encoding (currently using raw PCM, needs pipecat.json schema)  

## Next Steps

1. **Copy pipecat.json** from StreamingAvatarSDK to properly encode protobuf messages
2. **Test with real avatar/voice IDs**
3. **Verify LiveKit video stream appears**
4. **Test two-way conversation**

## Notes

- The protobuf schema (pipecat.json) is needed for proper audio encoding
- Currently using simplified audio sending - will work but not optimal
- LiveKit handles all the WebRTC complexity automatically
- The WebSocket is used for text messages and events, not the video stream

