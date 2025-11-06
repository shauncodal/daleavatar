import axios from 'axios';

const HEYGEN_API = 'https://api.heygen.com';

export async function createSessionToken() {
  const { data } = await axios.post(
    `${HEYGEN_API}/v1/streaming.create_token`,
    {},
    { headers: { 'x-api-key': process.env.HEYGEN_API_KEY } }
  );
  return data?.data?.token || data?.token;
}

export async function newSession({ startRequest, token }) {
  // Validate required fields
  if (!startRequest.avatarName) {
    throw new Error('avatarName is required');
  }
  if (!startRequest.quality) {
    throw new Error('quality is required');
  }

  // Build request payload, only including defined fields
  const payload = {
    version: 'v2',
    video_encoding: 'H264',
    source: 'sdk',
    avatar_name: startRequest.avatarName || startRequest.avatar_id,
    quality: startRequest.quality,
  };

  // Voice settings - only include if voice object exists and has content
  if (startRequest.voice && (startRequest.voice.voiceId || startRequest.voice.rate !== undefined || startRequest.voice.emotion)) {
    payload.voice = {};
    if (startRequest.voice.voiceId) payload.voice.voice_id = startRequest.voice.voiceId;
    if (startRequest.voice.rate !== undefined) payload.voice.rate = startRequest.voice.rate;
    if (startRequest.voice.emotion) payload.voice.emotion = startRequest.voice.emotion;
    if (startRequest.voice.elevenlabsSettings) payload.voice.elevenlabs_settings = startRequest.voice.elevenlabsSettings;
  }

  // Knowledge base
  if (startRequest.knowledgeId) payload.knowledge_base_id = startRequest.knowledgeId;
  if (startRequest.knowledgeBase) payload.knowledge_base = startRequest.knowledgeBase;

  // STT settings - format properly (HeyGen expects lowercase provider names)
  if (startRequest.sttSettings) {
    const provider = (startRequest.sttSettings.provider || 'deepgram').toLowerCase();
    payload.stt_settings = {
      provider: provider,
      confidence: startRequest.sttSettings.confidence !== undefined ? startRequest.sttSettings.confidence : 0.55,
    };
  }

  // Language
  if (startRequest.language) payload.language = startRequest.language;

  // Voice chat transport - convert to boolean for LiveKit transport
  if (startRequest.voiceChatTransport !== undefined) {
    const transport = String(startRequest.voiceChatTransport).toUpperCase();
    payload.ia_is_livekit_transport = transport === 'LIVEKIT';
  }

  // Silence response
  if (startRequest.useSilencePrompt !== undefined) {
    payload.silence_response = Boolean(startRequest.useSilencePrompt);
  }

  // Activity idle timeout
  if (startRequest.activityIdleTimeout) {
    payload.activity_idle_timeout = Number(startRequest.activityIdleTimeout);
  }

  console.log('[HeyGen] newSession request payload:', JSON.stringify(payload, null, 2));

  try {
    const { data } = await axios.post(
      `${HEYGEN_API}/v1/streaming.new`,
      payload,
      {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      }
    );
    console.log('[HeyGen] newSession response:', JSON.stringify(data, null, 2));
    
    // HeyGen API returns { data: { session_id, access_token, url, ... } }
    // We need to extract and normalize the response
    const responseData = data?.data || data;
    
    // Ensure we return the expected fields
    const normalized = {
      session_id: responseData?.session_id || responseData?.sessionId,
      access_token: responseData?.access_token || responseData?.accessToken,
      url: responseData?.url,
      is_paid: responseData?.is_paid ?? responseData?.isPaid ?? false,
      session_duration_limit: responseData?.session_duration_limit || responseData?.sessionDurationLimit,
    };
    
    // Validate that we have all required fields
    if (!normalized.session_id || !normalized.access_token || !normalized.url) {
      console.error('[HeyGen] Response missing required fields:', normalized);
      throw new Error(`Invalid response from HeyGen: missing session_id, access_token, or url`);
    }
    
    console.log('[HeyGen] normalized response:', JSON.stringify(normalized, null, 2));
    return normalized;
  } catch (error) {
    const errorDetail = error.response?.data || error.message;
    console.error('[HeyGen] newSession error:', JSON.stringify(errorDetail, null, 2));
    throw error;
  }
}

export async function startSession({ sessionId, token }) {
  const { data } = await axios.post(
    `${HEYGEN_API}/v1/streaming.start`,
    { session_id: sessionId },
    {
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    }
  );
  return data?.data || data;
}

export async function keepAlive({ token }) {
  const { data } = await axios.post(
    `${HEYGEN_API}/v1/streaming.keepalive`,
    {},
    { headers: { Authorization: `Bearer ${token}` } }
  );
  return data;
}

export async function speak({ token, text, taskType = 'REPEAT' }) {
  const { data } = await axios.post(
    `${HEYGEN_API}/v1/streaming.speak`,
    { text, task_type: taskType },
    { headers: { Authorization: `Bearer ${token}` } }
  );
  return data;
}

