# Group 05 Test Report

## Scope

Manual and automated checks for the Java adaptation of the Northbridge Public Library HTML prototype. Test cases are maintained in `Test_Cases.csv`, which Excel can open. Current coverage is for the dashboard, catalog search, seeded data, and basic borrow/return actions.

## Environment

- Java 17, Maven 3.9+
- Docker / Docker Compose
- Python 3.11+ and pytest for HTTP smoke tests
- Browser: current Chrome or Firefox
- Defect tracking: Jira, Bugzilla, or Mantis (record project/team tracker and issue keys before release)

## How to execute

```sh
mvn test
# Start application separately, then:
python -m pip install pytest requests
pytest -q tests
```

Or run the application with `docker compose up --build`, then run the pytest smoke tests from the host.

## Results template

| Test ID | Expected | Actual | Result | Defect ID |
|---|---|---|---|---|
| TC01 | Dashboard responds and displays library heading | Fill after execution | Not run | — |
| TC02 | Search for Atomic returns Atomic Habits | Fill after execution | Not run | — |
| TC03 | Search with no matches shows empty state | Fill after execution | Not run | — |
| TC04 | Borrowing an available copy reduces availability | Fill after execution | Not run | — |
| TC05 | Borrowing an unavailable copy is rejected | Fill after execution | Not run | — |
| TC06 | Return action reports when there are no active loans | Fill after execution | Not run | — |

No test execution is claimed by this report; record actual results and attach screenshots/logs when executed.
