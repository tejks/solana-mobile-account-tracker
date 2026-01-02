# Solana Mobile Account Tracker

Professional account tracker for Solana wallets — Flutter app for inspecting local accounts, tokens, and basic token metadata.

**Status:** Draft · Local development ready

**Highlights**

- Lightweight Flutter UI to manage and inspect Solana accounts and token balances
- Includes token metadata and presentation utilities
- Ready for CI and contribution (see files in `.github/`)

**Repository layout (important files)**

- `lib/` — main application code and cubits
- `assets/` — static files (e.g., `tokens.json`)
- `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/` — platform build projects
- `test/` — basic widget tests

**Preview**
Add a screenshot or short demo GIF here to showcase the app UI (place images in `assets/` and reference them below).

---

**Table of contents**

- Purpose
- Features
- Quick Start
- Development
- Testing & CI
- Project structure
- Contributing
- License

---

**Purpose**

This project is a focused mobile/desktop Flutter application to help users track local Solana accounts and tokens — useful as a lightweight wallet inspector and developer reference for token metadata and account balances.

**Features**

- View local accounts and token holdings
- Token metadata inspection (name, symbol, decimals)
- Simple, responsive Flutter UI with cubit-based state management

---

**Quick Start (for developers)**

Prerequisites

- Install Flutter (stable channel). See: https://docs.flutter.dev/get-started/install
- Ensure platform toolchains are installed for your target (Android, iOS, Linux, macOS, Windows)

Clone

```bash
git clone <your-repo-url>
cd solana-mobile-account-tracker
```

Install dependencies

```bash
flutter pub get
```

Run on device / emulator

```bash
flutter run
```

Build (example, Android)

```bash
flutter build apk --release
```

---

**Development**

- Code style: run `dart format .` before commits
- Static analysis: `flutter analyze`
- State management: cubit (see `lib/cubit/`)
- Main entry point: `lib/main.dart`
- Solana helpers: `lib/solana.dart`

**Common commands**

```bash
# get deps
flutter pub get

# analyze
flutter analyze

# run tests
flutter test

# format
dart format .
```

---

**Testing & CI**

This repository includes a basic GitHub Actions workflow to run `flutter pub get`, `flutter analyze`, and `flutter test` on push and pull requests. See `.github/workflows/flutter.yml`.

---

**Project structure**

- `lib/` — application source (models, cubits, screens, widgets)
- `assets/tokens.json` — token list used by the app
- `test/` — widget tests

---

**Contributing**

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) and follow the included templates for issues and pull requests.

---

**License**

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

---

If you'd like, I can add a polished demo screenshot and update the repository badges (CI, license, pub.dev) once you provide the repo URL and optional screenshots.
