# Group 05 — Java Library Management System

A Java/Spring Boot adaptation of the provided Northbridge Library HTML prototype. It includes a responsive dashboard, seeded book catalog/search, loan summary, and simple borrow/return actions. This is a classroom prototype; user authentication, durable database integration, complete role authorization, fines, and reservations are not yet production features.

## Run with Docker

```sh
docker compose up --build
```

Open http://localhost:8080. Stop with `docker compose down`.

## Run and test locally

Requires Java 17 and Maven 3.9+.

```sh
mvn spring-boot:run
mvn test
```

The Spring Boot JUnit tests cover initial catalog data and title search. The `tests/` Python/pytest suite contains HTTP smoke tests for a running local instance. Start the server before running `pytest -q tests`.

## Excel-compatible test cases

Open `testing/Test_Cases.csv` in Microsoft Excel. It is UTF-8 CSV test case data (not a binary `.xlsx` workbook); save as `.xlsx` in Excel if that format is required by the course.

## Project contents

- `src/main/java`: Spring Boot application, web controller, and library service.
- `src/main/resources/templates`: Thymeleaf dashboard and catalog search views.
- `src/test/java`: Java unit/context tests.
- `tests`: Python/pytest HTTP smoke checks.
- `testing`: test case spreadsheet source and test report.
- `docs`: tool usage and sample task assignment evidence.

## Notes on source examples

The supplied HTML is used as the UI and seed-data reference. The supplied SQL schema is preserved as a design reference in `docs/schema-reference.sql`; this prototype uses in-memory sample data rather than claiming SQL persistence. The original schema has foreign keys referencing `book_copy(book_copy_id)`, while its declared key is `copy_id`; review that mismatch before using it as a migration.
