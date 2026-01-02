# Contributing to Solana Mobile Account Tracker

Thank you for your interest in contributing! This file explains how to get started, the preferred workflow, and project conventions.

How to contribute

- Fork the repository and create a branch for your change: `git checkout -b feature/my-change`
- Keep changes focused and small; open separate PRs for unrelated work
- Run formatting and static analysis locally before submitting

Local checks

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

Commit messages

- Use clear descriptive commit messages. Example: `feat: add token metadata caching`

Pull requests

- Ensure the PR has a descriptive title and summary
- Link related issues if applicable
- Include screenshots for UI changes
- CI should pass before requesting review

Code style

- Use `dart format` for formatting
- Prefer readable variable names and small functions

Thank you for contributing — we appreciate your help improving this project!
