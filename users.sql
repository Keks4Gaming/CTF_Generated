CREATE DATABASE IF NOT EXISTS pwnbox
    DEFAULT CHARACTER SET = 'utf8mb4'
    DEFAULT COLLATE = 'utf8mb4_unicode_ci';

USE pwnbox;

CREATE TABLE IF NOT EXISTS users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    username VARCHAR(32) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_username (username),
    UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS posts (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id INT UNSIGNED NOT NULL,
    title VARCHAR(140) NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_posts_user_id (user_id),
    FULLTEXT KEY ft_posts_title_body (title, body),
    CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO users (username, email, password, role) VALUES
    ('admin', 'admin@pwnbox.local', 'admin123!', 'admin'),
    ('attacker', 'attacker@pwnbox.local', 'attacker123!', 'user'),
    ('alice', 'alice@pwnbox.local', 'password123', 'user'),
    ('bob', 'bob@pwnbox.local', 'password123', 'user'),
    ('carol', 'carol@pwnbox.local', 'password123', 'user'),
    ('dave', 'dave@pwnbox.local', 'password123', 'user'),
    ('erin', 'erin@pwnbox.local', 'password123', 'user'),
    ('frank', 'frank@pwnbox.local', 'password123', 'user'),
    ('grace', 'grace@pwnbox.local', 'password123', 'user'),
    ('heidi', 'heidi@pwnbox.local', 'password123', 'user');