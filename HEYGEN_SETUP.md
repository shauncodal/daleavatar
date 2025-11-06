# HeyGen Streaming Avatar Setup

## What Was Implemented

✅ **Backend Integration:**
- Token creation endpoint (`/api/stream/session-token`)
- Session start endpoint (`/api/stream/new-session`)
- Speak command endpoint (`/api/stream/speak`)
- Keepalive endpoint (`/api/stream/keepalive`)

✅ **Frontend Integration:**
- WebView with HeyGen connection logic
- WebSocket/WebRTC handling for avatar video stream
- Audio capture from user's microphone
- Two-way conversation setup (sending audio, receiving video)
- Composite video recording (avatar + webcam side-by-side)

## Current Status

The implementation supports multiple connection methods:
1. **Direct Video URL** - If HeyGen returns a `video_url`
2. **WebSocket Stream** - If HeyGen provides a `websocket_url`
3. **WebRTC Connection** - If HeyGen uses SDP/WebRTC

## What You Need to Configure

### 1. HeyGen Session Start Request

The `startRequest` in `session_live.dart` is currently empty. You need to add HeyGen-specific parameters. Common fields include:

```dart
final startRequest = {
  'avatar_id': 'your-avatar-id',      // Required: Your HeyGen avatar ID
  'voice_id': 'your-voice-id',        // Required: Voice ID for the avatar
  'background': '#000000',            // Optional: Background color
  // Add other required fields per HeyGen API docs
};
```

**To find these values:**
- Log into your HeyGen dashboard
- Navigate to Avatars → Find your avatar → Get the avatar ID
- Navigate to Voices → Find your voice → Get the voice ID

### 2. Test the Connection

1. **Start the Flutter app:**
   ```bash
   cd app
   flutter run -d chrome --dart-define=BACKEND_URL=http://localhost:4000
   ```

2. **Open the Live tab** and click "Start Session"

3. **Check the log output** in the app - it will show:
   - Token creation
   - Session start response
   - WebSocket connection status
   - Any errors

4. **Look at the browser console** (if running on web) for detailed WebSocket messages

### 3. Verify HeyGen API Response

The code will log the session response. Check what HeyGen actually returns:
- If it returns `sdp_answer` → WebRTC will be used
- If it returns `websocket_url` → WebSocket will be used
- If it returns `video_url` → Direct video URL will be used

### 4. Two-Way Conversation

For two-way conversation to work:

1. **User audio capture** ✅ Already implemented
   - Webcam microphone is captured
   - Audio is sent to HeyGen via WebSocket

2. **Avatar video stream** ⏳ Depends on HeyGen response
   - Code handles WebSocket, WebRTC, or direct video URL
   - Video appears in the left video element

3. **Speech-to-Text** ⚠️ Not yet implemented
   - The "STT (stub)" button is a placeholder
   - You may need to integrate a speech-to-text service (e.g., OpenAI Whisper)

4. **Text-to-Speech via HeyGen** ✅ Implemented
   - Use the "Speak" button to test
   - Or integrate with OpenAI for conversational responses

## Troubleshooting

### Avatar not showing
1. Check browser console for errors
2. Verify the session response format matches what the code expects
3. Check HeyGen API documentation for the exact response format
4. Verify your HeyGen API key is valid

### Audio not working
1. Grant microphone permissions in the browser
2. Check if `userMediaStream` is captured (see log)
3. Verify WebSocket is receiving audio data

### WebSocket connection fails
1. Check HeyGen API docs for correct WebSocket URL format
2. Verify the token is valid
3. Check CORS settings if running on web

## Next Steps

1. **Configure avatar_id and voice_id** in `session_live.dart`
2. **Test the session start** and check the response format
3. **Adjust WebSocket handling** if HeyGen uses a different format
4. **Add speech-to-text** for automatic transcription of user speech
5. **Integrate OpenAI** for conversational responses (see `assistant_loop.js`)

## Reference Links

- [HeyGen API Documentation](https://docs.heygen.com)
- Check your HeyGen dashboard for avatar IDs and voice IDs
- Verify your API key has streaming permissions

