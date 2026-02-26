-- ============================================================
--  Library Management System — MySQL Schema
--  Run:  mysql -u root -p < schema.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS library_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE library_db;

-- ──────────────────────────────────────────
--  1. USERS
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  user_id      INT           PRIMARY KEY AUTO_INCREMENT,
  first_name   VARCHAR(50)   NOT NULL,
  last_name    VARCHAR(50)   NOT NULL,
  email        VARCHAR(100)  UNIQUE NOT NULL,
  username     VARCHAR(20)   UNIQUE NOT NULL,
  password     VARCHAR(255)  NOT NULL,          -- BCrypt hash
  avatar       VARCHAR(10)   DEFAULT '📚',
  dob          DATE,
  country      VARCHAR(60),
  bio          TEXT,
  reading_goal INT           DEFAULT 12,
  pref_format  ENUM('online','pdf','epub'),
  joined_date  DATETIME      DEFAULT CURRENT_TIMESTAMP,
  is_active    BOOLEAN       DEFAULT TRUE
);

-- ──────────────────────────────────────────
--  2. BOOKS
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS books (
  book_id      INT           PRIMARY KEY AUTO_INCREMENT,
  title        VARCHAR(255)  NOT NULL,
  author       VARCHAR(150),
  year_pub     INT,
  genre        VARCHAR(80),
  cover_url    VARCHAR(500),
  read_url     VARCHAR(500),
  pdf_url      VARCHAR(500),
  epub_url     VARCHAR(500),
  source       ENUM('gutenberg','archive','openlibrary','std') DEFAULT 'gutenberg',
  description  TEXT,
  added_date   DATETIME      DEFAULT CURRENT_TIMESTAMP
);

-- ──────────────────────────────────────────
--  3. FAVOURITES
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS favourites (
  fav_id     INT       PRIMARY KEY AUTO_INCREMENT,
  user_id    INT       NOT NULL,
  book_id    INT       NOT NULL,
  saved_on   DATETIME  DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
  UNIQUE KEY unique_fav (user_id, book_id)
);

-- ──────────────────────────────────────────
--  4. READING HISTORY
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reading_history (
  history_id  INT      PRIMARY KEY AUTO_INCREMENT,
  user_id     INT      NOT NULL,
  book_id     INT      NOT NULL,
  started_on  DATETIME DEFAULT CURRENT_TIMESTAMP,
  finished_on DATETIME,
  status      ENUM('reading','finished','dropped') DEFAULT 'reading',
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
  UNIQUE KEY unique_history (user_id, book_id)
);

-- ──────────────────────────────────────────
--  5. USER GENRE PREFERENCES
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS user_genres (
  user_id  INT         NOT NULL,
  genre    VARCHAR(80) NOT NULL,
  PRIMARY KEY (user_id, genre),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ──────────────────────────────────────────
--  6. NOTIFICATIONS
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notifications (
  notif_id   INT  PRIMARY KEY AUTO_INCREMENT,
  user_id    INT  NOT NULL,
  notif_type ENUM('new_genre','newsletter','goal_reminder'),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ──────────────────────────────────────────
--  7. SEED DATA — Books
-- ──────────────────────────────────────────
INSERT INTO books (title, author, year_pub, genre, cover_url, read_url, pdf_url, epub_url, source, description) VALUES
('Pride and Prejudice','Jane Austen',1813,'Classic Literature','https://covers.openlibrary.org/b/id/9255566-L.jpg','https://www.gutenberg.org/ebooks/1342','https://www.gutenberg.org/files/1342/1342-pdf.pdf','https://www.gutenberg.org/ebooks/1342.epub.images','gutenberg','A witty romantic novel following Elizabeth Bennet.'),
('Sense and Sensibility','Jane Austen',1811,'Classic Literature','https://covers.openlibrary.org/b/id/8739782-L.jpg','https://www.gutenberg.org/ebooks/161','https://www.gutenberg.org/files/161/161-pdf.pdf','https://www.gutenberg.org/ebooks/161.epub.images','gutenberg','The story of the Dashwood sisters as they come of age and seek love.'),
('Emma','Jane Austen',1815,'Classic Literature','https://covers.openlibrary.org/b/id/8237136-L.jpg','https://www.gutenberg.org/ebooks/158','https://www.gutenberg.org/files/158/158-pdf.pdf','https://www.gutenberg.org/ebooks/158.epub.images','gutenberg','A novel about youthful hubris and romantic misunderstandings.'),
('1984','George Orwell',1949,'Classic Literature','https://covers.openlibrary.org/b/id/7222246-L.jpg','https://archive.org/details/nineteeneightyfo0000orwe','https://archive.org/download/nineteeneightyfo0000orwe/nineteeneightyfo0000orwe.pdf',NULL,'archive','Dystopian social science fiction under the surveillance state of Big Brother.'),
('Animal Farm','George Orwell',1945,'Classic Literature','https://covers.openlibrary.org/b/id/8739596-L.jpg','https://www.gutenberg.org/ebooks/5765','https://www.gutenberg.org/files/5765/5765-pdf.pdf','https://www.gutenberg.org/ebooks/5765.epub.images','gutenberg','An allegorical novella reflecting events of the Russian Revolution.'),
('The Great Gatsby','F. Scott Fitzgerald',1925,'Classic Literature','https://covers.openlibrary.org/b/id/8231856-L.jpg','https://www.gutenberg.org/ebooks/64317','https://www.gutenberg.org/files/64317/64317-pdf.pdf','https://www.gutenberg.org/ebooks/64317.epub.images','gutenberg','A novel of the Jazz Age exploring decadence and idealism.'),
('Frankenstein','Mary Shelley',1818,'Classic Literature','https://covers.openlibrary.org/b/id/8775398-L.jpg','https://www.gutenberg.org/ebooks/84','https://www.gutenberg.org/files/84/84-pdf.pdf','https://www.gutenberg.org/ebooks/84.epub.images','gutenberg','A Gothic novel about scientist Victor Frankenstein and his creation.'),
('Dracula','Bram Stoker',1897,'Classic Literature','https://covers.openlibrary.org/b/id/8810475-L.jpg','https://www.gutenberg.org/ebooks/345','https://www.gutenberg.org/files/345/345-pdf.pdf','https://www.gutenberg.org/ebooks/345.epub.images','gutenberg','The quintessential vampire novel introducing Count Dracula.'),
('The Adventures of Sherlock Holmes','Arthur Conan Doyle',1892,'Adventure & Mystery','https://covers.openlibrary.org/b/id/8739161-L.jpg','https://www.gutenberg.org/ebooks/1661','https://www.gutenberg.org/files/1661/1661-pdf.pdf','https://www.gutenberg.org/ebooks/1661.epub.images','gutenberg','Twelve stories featuring the brilliant detective Sherlock Holmes.'),
('Treasure Island','Robert Louis Stevenson',1883,'Adventure & Mystery','https://covers.openlibrary.org/b/id/8739597-L.jpg','https://www.gutenberg.org/ebooks/120','https://www.gutenberg.org/files/120/120-pdf.pdf','https://www.gutenberg.org/ebooks/120.epub.images','gutenberg','Jim Hawkins embarks on a swashbuckling adventure for buried pirate treasure.'),
('Around the World in Eighty Days','Jules Verne',1872,'Adventure & Mystery','https://covers.openlibrary.org/b/id/8231860-L.jpg','https://www.gutenberg.org/ebooks/103','https://www.gutenberg.org/files/103/103-pdf.pdf','https://www.gutenberg.org/ebooks/103.epub.images','gutenberg','Phileas Fogg bets he can circumnavigate the globe in 80 days.'),
('Robinson Crusoe','Daniel Defoe',1719,'Adventure & Mystery','https://covers.openlibrary.org/b/id/8739601-L.jpg','https://www.gutenberg.org/ebooks/521','https://www.gutenberg.org/files/521/521-pdf.pdf','https://www.gutenberg.org/ebooks/521.epub.images','gutenberg','The classic survival story of a man shipwrecked on a remote island.'),
('On the Origin of Species','Charles Darwin',1859,'Science & Philosophy','https://covers.openlibrary.org/b/id/8232500-L.jpg','https://www.gutenberg.org/ebooks/1228','https://www.gutenberg.org/files/1228/1228-pdf.pdf','https://www.gutenberg.org/ebooks/1228.epub.images','gutenberg','Darwin''s seminal work on evolution by natural selection.'),
('The Republic','Plato',-380,'Science & Philosophy','https://covers.openlibrary.org/b/id/8232520-L.jpg','https://www.gutenberg.org/ebooks/1497','https://www.gutenberg.org/files/1497/1497-pdf.pdf','https://www.gutenberg.org/ebooks/1497.epub.images','gutenberg','Plato''s Socratic dialogue on justice and the just city-state.'),
('Meditations','Marcus Aurelius',180,'Science & Philosophy','https://covers.openlibrary.org/b/id/8232560-L.jpg','https://www.gutenberg.org/ebooks/2680','https://www.gutenberg.org/files/2680/2680-pdf.pdf','https://www.gutenberg.org/ebooks/2680.epub.images','gutenberg','Personal writings by the Roman Emperor on Stoic philosophy.'),
('Alice''s Adventures in Wonderland','Lewis Carroll',1865,'Children & Fantasy','https://covers.openlibrary.org/b/id/8739620-L.jpg','https://www.gutenberg.org/ebooks/11','https://www.gutenberg.org/files/11/11-pdf.pdf','https://www.gutenberg.org/ebooks/11.epub.images','gutenberg','Alice falls through a rabbit hole into a whimsical world.'),
('The Wonderful Wizard of Oz','L. Frank Baum',1900,'Children & Fantasy','https://covers.openlibrary.org/b/id/8739622-L.jpg','https://www.gutenberg.org/ebooks/55','https://www.gutenberg.org/files/55/55-pdf.pdf','https://www.gutenberg.org/ebooks/55.epub.images','gutenberg','Dorothy is swept to the magical Land of Oz.'),
('Grimm''s Fairy Tales','Brothers Grimm',1812,'Children & Fantasy','https://covers.openlibrary.org/b/id/8739628-L.jpg','https://www.gutenberg.org/ebooks/2591','https://www.gutenberg.org/files/2591/2591-pdf.pdf','https://www.gutenberg.org/ebooks/2591.epub.images','gutenberg','Classic collection of fairy tales including Cinderella and Snow White.'),
('The Autobiography of Benjamin Franklin','Benjamin Franklin',1791,'Biography & History','https://covers.openlibrary.org/b/id/8740000-L.jpg','https://www.gutenberg.org/ebooks/20203','https://www.gutenberg.org/files/20203/20203-pdf.pdf','https://www.gutenberg.org/ebooks/20203.epub.images','gutenberg','Franklin''s self-written account of his rise to become one of America''s founders.'),
('The Complete Works of Shakespeare','William Shakespeare',1623,'Poetry & Drama','https://covers.openlibrary.org/b/id/8232900-L.jpg','https://www.gutenberg.org/ebooks/100','https://www.gutenberg.org/files/100/100-pdf.pdf','https://www.gutenberg.org/ebooks/100.epub.images','gutenberg','Complete plays, sonnets, and poems by Shakespeare.');
