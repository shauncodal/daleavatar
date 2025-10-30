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
  const { data } = await axios.post(
    `${HEYGEN_API}/v1/streaming.new`,
    startRequest,
    {
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    }
  );
  return data;
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

