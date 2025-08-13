# 🚀 Quick Start Guide

Welcome to MyFinance! This guide will get you up and running in 15 minutes.

## Prerequisites

- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.2.0 or higher)
- VS Code or Android Studio
- Git
- Node.js (for some tooling)

## 1. Clone the Repository

```bash
git clone https://github.com/yourorg/myfinance-improved.git
cd myfinance-improved
```

## 2. Install Dependencies

```bash
# Install Flutter dependencies
flutter pub get

# Install pre-commit hooks (optional)
npm install

# Generate code (for Riverpod, Freezed, etc.)
flutter pub run build_runner build --delete-conflicting-outputs
```

## 3. Environment Setup

Create a `.env` file in the project root:

```env
# Supabase Configuration
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# Environment
ENVIRONMENT=development
```

## 4. Run the Application

```bash
# Check Flutter setup
flutter doctor

# List available devices
flutter devices

# Run on default device
flutter run

# Run with specific flavor
flutter run --flavor development
```

## 5. VS Code Setup

Install recommended extensions:
- Flutter
- Dart
- Error Lens
- GitLens
- Flutter Riverpod Snippets

## 📱 Running on Different Platforms

### iOS
```bash
cd ios && pod install
flutter run -d iPhone
```

### Android
```bash
flutter run -d android
```

### Web
```bash
flutter run -d chrome
```

## 🎨 Viewing Component Library

We use Storybook for component development:

```bash
# Start Storybook (coming soon)
npm run storybook
```

## 🧪 Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 📁 Project Structure Overview

```
lib/
├── core/           # Core functionality, themes, utils
├── data/           # Data layer (API, models, repositories)
├── domain/         # Business logic
├── presentation/   # UI layer (pages, widgets, providers)
└── main.dart       # Entry point
```

## 🎯 Next Steps

1. **Explore the UI**: Run the app and navigate through screens
2. **Read Architecture**: [Architecture Guide](../architecture/ARCHITECTURE.md)
3. **Understand Styling**: [Toss Design System](../design-system/TOSS_STYLE_ANALYSIS.md)
4. **Learn State Management**: [State Management Guide](../architecture/STATE_MANAGEMENT.md)

## 🔥 Hot Tips

### Hot Reload
- Save file: `Cmd+S` (Mac) / `Ctrl+S` (Windows)
- Hot reload: `r` in terminal
- Hot restart: `R` in terminal

### Debugging
- Set breakpoints in VS Code
- Use Flutter Inspector for UI debugging
- Check `flutter logs` for device logs

### Performance
- Use `flutter run --profile` for performance testing
- Enable performance overlay with `P` in debug mode

## 🆘 Troubleshooting

### Common Issues

**Dependencies not found**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**iOS build fails**
```bash
cd ios
pod deintegrate
pod install
```

**Android build fails**
```bash
cd android
./gradlew clean
```

## 📚 Useful Commands

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Update dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```

## 🤝 Getting Help

- Check [Documentation Hub](../../INDEX.md)
- Ask in #myfinance-dev Slack channel
- Create a GitHub issue
- Review [FAQ](../FAQ.md)

---

Ready to start coding? Check out our [Component Guide](../components/COMPONENT_GUIDE.md) to create your first Toss-style component! 🎉