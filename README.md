DaleAvatar Monorepo

- backend/: Node.js (JavaScript) API server for HeyGen/OpenAI/S3/MySQL
- app/: Flutter app (Web/Desktop/iOS/Android) — placeholder, to be initialized

Setup

1) Backend
   - cd backend
   - cp env.example .env (fill in keys)
   - npm i
   - npm run start

2) Database
   - Apply schema: backend/src/db/schema.sql

3) Flutter App
   - cd app
   - flutter pub get
   - flutter run -d chrome --dart-define=BACKEND_URL=http://localhost:4000

Tests
   - Backend: cd backend && npm test

