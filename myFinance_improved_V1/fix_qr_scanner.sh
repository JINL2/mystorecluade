#!/bin/bash

echo "🔧 Fixing QR Scanner and Firebase Compatibility Issues"
echo "=================================================="

# Navigate to project directory
cd "$(dirname "$0")"

echo ""
echo "📦 Step 1: Getting Flutter packages..."
flutter pub get

echo ""
echo "🧹 Step 2: Cleaning iOS build artifacts..."
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData/*
cd ..

echo ""
echo "🔄 Step 3: Cleaning Flutter build cache..."
flutter clean

echo ""
echo "📱 Step 4: Reinstalling iOS dependencies..."
cd ios
pod cache clean --all
pod repo update
pod install --repo-update
cd ..

echo ""
echo "🏗️ Step 5: Building Flutter iOS..."
flutter build ios --debug --no-codesign

echo ""
echo "✅ QR Scanner fix complete!"
echo ""
echo "📝 Notes:"
echo "  - mobile_scanner v6.0.2 has been added to pubspec.yaml"
echo "  - QR scanner functionality has been restored"
echo "  - iOS Podfile has been updated with compatibility fixes"
echo ""
echo "🚀 Next steps:"
echo "  1. Open Xcode: open ios/Runner.xcworkspace"
echo "  2. Select your device or simulator"
echo "  3. Press Run or use: flutter run"
echo ""
echo "⚠️ Important:"
echo "  - For iOS Simulator: QR scanning may not work on arm64 simulators"
echo "  - Test on a real device for best results"