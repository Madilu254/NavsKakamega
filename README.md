# navs_kakamega

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Examinations database configuration

The `Examinations` Java application reads its database settings from environment
variables. `DB_PASSWORD` is required; `DB_URL` defaults to
`jdbc:mysql://localhost:3306/studentperformance`, and `DB_USER` defaults to
`root`. For example, in PowerShell:

```powershell
$env:DB_URL = "jdbc:mysql://localhost:3306/studentperformance"
$env:DB_USER = "root"
$env:DB_PASSWORD = "<your database password>"
```

Keep database credentials out of source control.
