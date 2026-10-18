-- Idempotent seed data: works in H2 and MySQL, safe on repeated start with an existing volume.
INSERT INTO authors (first_name, last_name, email)
SELECT 'Leo', 'Tolstoy', 'leo.tolstoy@example.com' FROM (SELECT 1 AS x) AS seed
WHERE NOT EXISTS (SELECT 1 FROM authors WHERE email = 'leo.tolstoy@example.com');

INSERT INTO authors (first_name, last_name, email)
SELECT 'Fyodor', 'Dostoevsky', 'fyodor.dostoevsky@example.com' FROM (SELECT 1 AS x) AS seed
WHERE NOT EXISTS (SELECT 1 FROM authors WHERE email = 'fyodor.dostoevsky@example.com');

INSERT INTO books (title, slug, description, published_year, author_id, created_at, updated_at)
SELECT 'Crime and Punishment', 'crime-and-punishment', 'A novel about Raskolnikov.', 1866,
       (SELECT id FROM authors WHERE email = 'fyodor.dostoevsky@example.com'),
       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM (SELECT 1 AS x) AS seed
WHERE NOT EXISTS (SELECT 1 FROM books WHERE slug = 'crime-and-punishment');
