-- Base de dados futura do LiDire MVP 1.0
-- Execute somente depois de criar o banco D1 real e configurar o binding DB.

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT,
  age INTEGER,
  phone TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS profiles (
  user_id TEXT PRIMARY KEY,
  name TEXT,
  email TEXT,
  age INTEGER,
  phone TEXT,
  address TEXT,
  profile_photo TEXT,
  currency TEXT NOT NULL DEFAULT 'BRL',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS commitments (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  title TEXT NOT NULL,
  date TEXT,
  time TEXT,
  location TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tasks (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  title TEXT NOT NULL,
  due_date TEXT,
  done INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shopping_items (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  quantity TEXT,
  done INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS hydration (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  date TEXT NOT NULL,
  amount_ml INTEGER DEFAULT 0,
  goal_ml INTEGER DEFAULT 2000
);

CREATE TABLE IF NOT EXISTS study_activities (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  title TEXT NOT NULL,
  subject TEXT,
  duration TEXT,
  notes TEXT,
  done INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS workouts (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  exercise TEXT NOT NULL,
  load TEXT,
  target_reps INTEGER,
  executed_reps INTEGER,
  done INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS transactions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  type TEXT NOT NULL,
  name TEXT NOT NULL,
  value REAL NOT NULL,
  date TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fixed_expenses (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  value REAL NOT NULL,
  due_day INTEGER,
  paid INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS objectives (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  deadline TEXT,
  target_value REAL DEFAULT 0,
  saved_value REAL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS family_groups (
  id TEXT PRIMARY KEY,
  owner_user_id TEXT NOT NULL,
  name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS family_members (
  id TEXT PRIMARY KEY,
  group_id TEXT NOT NULL,
  user_id TEXT,
  email TEXT,
  role TEXT DEFAULT 'member',
  status TEXT DEFAULT 'pending'
);


-- =========================================================
-- AUTENTICAÇÃO / SESSÕES
-- Criada para o fluxo Cadastro + Login do MVP 3.9.
-- As senhas nunca são armazenadas em texto puro.
-- =========================================================
CREATE TABLE IF NOT EXISTS user_sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  expires_at TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_seen_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_user_sessions_user
ON user_sessions(user_id);

CREATE INDEX IF NOT EXISTS idx_user_sessions_expires
ON user_sessions(expires_at);


-- Compartilhamento familiar e notificações (LiDire 6.4)
CREATE TABLE IF NOT EXISTS family_invites (
  id TEXT PRIMARY KEY, owner_user_id TEXT NOT NULL, invitee_name TEXT NOT NULL,
  invitee_email TEXT NOT NULL, permissions_json TEXT NOT NULL, token TEXT NOT NULL UNIQUE,
  status TEXT NOT NULL DEFAULT 'pending', created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_family_invites_owner ON family_invites(owner_user_id);
CREATE INDEX IF NOT EXISTS idx_family_invites_email ON family_invites(invitee_email);

CREATE TABLE IF NOT EXISTS family_notifications (
  id TEXT PRIMARY KEY, recipient_user_id TEXT NOT NULL, sender_user_id TEXT NOT NULL,
  sender_name TEXT NOT NULL, permissions_json TEXT NOT NULL, read INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_family_notifications_recipient ON family_notifications(recipient_user_id, created_at);
