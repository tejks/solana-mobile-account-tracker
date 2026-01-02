<div align="center">
	<img src="assets/logo/phone.svg" alt="phone icon" width="150" height="150" />

  <h2 align="center">Solana Mobile Account Tracker</h2>
</div>

</br>

This repository contains a lightweight Flutter application for inspecting local Solana accounts, token balances, and token metadata. It's designed as a developer-friendly utility and a starting point for building wallet-inspection tools.

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the App](#running-the-app)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Overview

The Solana Mobile Account Tracker is a platform-adaptive Flutter app that reads and displays local Solana accounts and token holdings. It provides quick inspection capabilities for token metadata (name, symbol, decimals) and exposes a small set of utilities used throughout the UI.

## Key Features

1. Account listing and quick balance overview
2. Token metadata inspection and simple presentation utilities
3. Cubit-based state management for predictable UI state
4. Cross-platform support: Android, iOS, Linux, macOS, Windows, Web

## Technologies Used

- Flutter & Dart
- Cubit (Bloc family) for state management
- Platform build targets: Android, iOS, Linux, macOS, Windows, Web
- JSON token catalog in `assets/tokens.json`

## Prerequisites

You need the following installed to build and run this project locally:

- Flutter (stable channel). See https://docs.flutter.dev/get-started/install
- Platform toolchains for your target(s) (Android SDK, Xcode for iOS/macOS, etc.)

## Installation

Clone the repository and fetch dependencies:

```bash
git clone <your-repo-url>
cd solana-mobile-account-tracker
flutter pub get
```

## Running the App

Run the app on your connected device or emulator:

```bash
flutter run
```

Build examples:

```bash
# Android release APK
flutter build apk --release

# Web
flutter build web
```

## Project Structure

- `lib/` — application source code (models, cubits, screens, widgets)
- `assets/tokens.json` — token metadata used by the app
- `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/` — platform-specific projects
- `test/` — widget and unit tests

Main entry point: `lib/main.dart`

Solana helpers and client code: `lib/solana.dart`

State management: `lib/cubit/` (accounts, tokens, solana client cubits)

## Contributing

Contributions and issues are welcome. Please follow the guidelines in `CONTRIBUTING.md` and respect the `CODE_OF_CONDUCT.md`.

Common checks before opening a PR:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

## License

This project is licensed under the MIT License — see `LICENSE` for details.
