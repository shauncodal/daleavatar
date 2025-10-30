CREATE TABLE IF NOT EXISTS users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sessions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT,
  heygen_session_id VARCHAR(128),
  started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ended_at TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS recordings (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  session_id BIGINT NOT NULL,
  composite_s3_key VARCHAR(512),
  webcam_s3_key VARCHAR(512),
  avatar_s3_key VARCHAR(512),
  duration_ms BIGINT,
  size_bytes BIGINT,
  status ENUM('pending','processing','ready','failed') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES sessions(id)
);

CREATE TABLE IF NOT EXISTS analysis (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  recording_id BIGINT NOT NULL,
  provider VARCHAR(64) DEFAULT 'dummy',
  payload_json JSON,
  summary_text TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (recording_id) REFERENCES recordings(id)
);

CREATE TABLE IF NOT EXISTS exports (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  recording_id BIGINT NOT NULL,
  target VARCHAR(64) NOT NULL,
  status ENUM('queued','sent','failed') DEFAULT 'queued',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (recording_id) REFERENCES recordings(id)
);

