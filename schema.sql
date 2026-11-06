-- role: READER, LIBRARIAN or ADMIN. ADMIN inherits all LIBRARIAN permissions (checked in the application).
CREATE TABLE account (
  account_id INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  role VARCHAR(15) NOT NULL,
  employee_code VARCHAR(20) UNIQUE,
  status VARCHAR(10) NOT NULL DEFAULT 'ACTIVE',
  failed_logins INT NOT NULL DEFAULT 0,
  locked_until DATETIME,
  created_at DATETIME NOT NULL,
  PRIMARY KEY (account_id),
  CHECK (role IN ('READER', 'LIBRARIAN', 'ADMIN')),
  CHECK (status IN ('ACTIVE', 'LOCKED'))
);

CREATE TABLE reader (
  reader_id INT NOT NULL AUTO_INCREMENT,
  account_id INT NOT NULL UNIQUE,
  card_number VARCHAR(20) NOT NULL UNIQUE,
  date_of_birth DATE,
  address VARCHAR(255),
  phone VARCHAR(15),
  reader_type VARCHAR(15) NOT NULL,
  issue_date DATE NOT NULL,
  expiry_date DATE NOT NULL,
  status VARCHAR(10) NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (reader_id),
  FOREIGN KEY (account_id) REFERENCES account(account_id),
  CHECK (reader_type IN ('STUDENT', 'TEACHER', 'OTHER')),
  CHECK (status IN ('ACTIVE', 'SUSPENDED', 'EXPIRED'))
);

CREATE TABLE category (
  category_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE,
  description VARCHAR(255),
  PRIMARY KEY (category_id)
);

CREATE TABLE publisher (
  publisher_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  address VARCHAR(255),
  PRIMARY KEY (publisher_id)
);

CREATE TABLE author (
  author_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  biography TEXT,
  PRIMARY KEY (author_id)
);

CREATE TABLE book (
  book_id INT NOT NULL AUTO_INCREMENT,
  isbn VARCHAR(20) NOT NULL UNIQUE,
  title VARCHAR(255) NOT NULL,
  publication_year SMALLINT,
  language VARCHAR(30),
  pages INT,
  description TEXT,
  category_id INT NOT NULL,
  publisher_id INT NOT NULL,
  PRIMARY KEY (book_id),
  FOREIGN KEY (category_id) REFERENCES category(category_id),
  FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

CREATE TABLE book_author (
  book_id INT,
  author_id INT,
  PRIMARY KEY (book_id, author_id),
  FOREIGN KEY (book_id) REFERENCES book(book_id),
  FOREIGN KEY (author_id) REFERENCES author(author_id)
);

CREATE TABLE book_copy (
  copy_id INT NOT NULL AUTO_INCREMENT,
  book_id INT NOT NULL,
  barcode VARCHAR(30) NOT NULL UNIQUE,
  shelf_location VARCHAR(30) NOT NULL,
  price DECIMAL(10,0) NOT NULL,
  status VARCHAR(12) NOT NULL DEFAULT 'AVAILABLE',
  PRIMARY KEY (copy_id),
  FOREIGN KEY (book_id) REFERENCES book(book_id),
  CHECK (status IN ('AVAILABLE', 'BORROWED', 'RESERVED', 'LOST', 'DAMAGED'))
);

CREATE TABLE loan (
  loan_id INT NOT NULL AUTO_INCREMENT,
  reader_id INT NOT NULL,
  copy_id INT NOT NULL,
  librarian_id INT NOT NULL,
  loan_date DATE NOT NULL,
  due_date DATE NOT NULL,
  return_date DATE,
  return_condition VARCHAR(10),
  renew_count INT NOT NULL DEFAULT 0,
  status VARCHAR(10) NOT NULL DEFAULT 'BORROWED',
  PRIMARY KEY (loan_id),
  FOREIGN KEY (reader_id) REFERENCES reader(reader_id),
  FOREIGN KEY (copy_id) REFERENCES book_copy(book_copy_id),
  FOREIGN KEY (librarian_id) REFERENCES account(account_id),
  CHECK (return_condition IN ('GOOD', 'DAMAGED', 'LOST')),
  CHECK (status IN ('BORROWED', 'OVERDUE', 'RETURNED'))
);

CREATE TABLE reservation (
  reservation_id INT NOT NULL AUTO_INCREMENT,
  reader_id INT NOT NULL,
  book_id INT NOT NULL,
  copy_id INT,
  reservation_date DATETIME NOT NULL,
  expiry_date DATETIME,
  status VARCHAR(10) NOT NULL DEFAULT 'WAITING',
  PRIMARY KEY (reservation_id),
  FOREIGN KEY (reader_id) REFERENCES reader(reader_id),
  FOREIGN KEY (book_id) REFERENCES book(book_id),
  FOREIGN KEY (copy_id) REFERENCES book_copy(book_copy_id),
  CHECK (status IN ('WAITING', 'READY', 'FULFILLED', 'CANCELLED', 'EXPIRED'))
);

CREATE TABLE fine (
  fine_id INT NOT NULL AUTO_INCREMENT,
  loan_id INT NOT NULL,
  amount DECIMAL(10,0) NOT NULL,
  reason VARCHAR(10) NOT NULL,
  issued_date DATE NOT NULL,
  status VARCHAR(10) NOT NULL DEFAULT 'UNPAID',
  paid_date DATE,
  receipt_no VARCHAR(20) UNIQUE,
  received_by INT,
  PRIMARY KEY (fine_id),
  FOREIGN KEY (loan_id) REFERENCES loan(loan_id),
  FOREIGN KEY (received_by) REFERENCES account(account_id),
  CHECK (reason IN ('LATE', 'DAMAGED', 'LOST')),
  CHECK (status IN ('UNPAID', 'PAID'))
);

CREATE TABLE notification (
  notification_id INT NOT NULL AUTO_INCREMENT,
  reader_id INT NOT NULL,
  type VARCHAR(20) NOT NULL,
  channel VARCHAR(10) NOT NULL DEFAULT 'EMAIL',
  message TEXT NOT NULL,
  status VARCHAR(10) NOT NULL DEFAULT 'PENDING',
  created_at DATETIME NOT NULL,
  sent_at DATETIME,
  PRIMARY KEY (notification_id),
  FOREIGN KEY (reader_id) REFERENCES reader(reader_id),
  CHECK (type IN ('DUE_SOON', 'OVERDUE', 'RESERVATION_READY')),
  CHECK (status IN ('PENDING', 'SENT', 'FAILED'))
);

CREATE TABLE setting (
  setting_key VARCHAR(40),
  setting_value VARCHAR(40) NOT NULL,
  updated_by INT NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (setting_key),
  FOREIGN KEY (updated_by) REFERENCES account(account_id),
  CHECK (setting_key IN ('LOAN_DAYS', 'MAX_BOOKS', 'MAX_RENEWALS', 'FINE_PER_DAY', 'HOLD_DAYS'))
);

CREATE TABLE audit_log (
  log_id BIGINT NOT NULL AUTO_INCREMENT,
  account_id INT NOT NULL,
  action VARCHAR(30) NOT NULL,
  entity VARCHAR(30) NOT NULL,
  entity_id VARCHAR(20),
  created_at DATETIME NOT NULL,
  PRIMARY KEY (log_id),
  FOREIGN KEY (account_id) REFERENCES account(account_id),
  CHECK (action IN ('CREATE', 'UPDATE', 'DELETE', 'LOGIN', 'LOAN', 'RETURN'))
);
