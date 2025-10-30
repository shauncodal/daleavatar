import OpenAI from 'openai';

const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

export async function respondWithAssistant({ messages, model = 'gpt-4o-mini' }) {
  const chat = await client.chat.completions.create({
    model,
    messages,
    temperature: 0.7
  });
  const text = chat.choices?.[0]?.message?.content || '';
  return { text };
}

