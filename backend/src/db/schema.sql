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

-- Course/Scenario Management Tables
CREATE TABLE IF NOT EXISTS courses (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  scenario_id VARCHAR(128) UNIQUE NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  difficulty ENUM('Easy','Medium','Hard') DEFAULT 'Medium',
  avatar_image VARCHAR(512),
  tips_json JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS enrollments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  course_id BIGINT NOT NULL,
  status ENUM('Not Started','In Progress','Completed','Archived') DEFAULT 'Not Started',
  enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY unique_enrollment (user_id, course_id)
);

CREATE TABLE IF NOT EXISTS course_progress (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  enrollment_id BIGINT NOT NULL,
  completion_percentage DECIMAL(5,2) DEFAULT 0.00,
  current_step INT DEFAULT 0,
  last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE,
  UNIQUE KEY unique_progress (enrollment_id)
);

CREATE TABLE IF NOT EXISTS course_choices (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  enrollment_id BIGINT NOT NULL,
  decision_point VARCHAR(255) NOT NULL,
  choice_made TEXT,
  choice_score INT,
  feedback TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS notifications (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  type ENUM('announcement','instructor_message','system','progress') DEFAULT 'system',
  title VARCHAR(255) NOT NULL,
  message TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_unread (user_id, is_read)
);

-- Extend users table with authentication
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS password_hash VARCHAR(255) NULL,
ADD COLUMN IF NOT EXISTS profile_settings JSON NULL;

