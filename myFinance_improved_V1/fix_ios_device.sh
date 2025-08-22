#!/bin/bash

echo "🔧 iOS Device Connection Fix Script"
echo "===================================="

# Step 1: Kill conflicting processes
echo "1. Killing conflicting processes..."
killall Xcode 2>/dev/null
killall Simulator 2>/dev/null
sudo killall -9 com.apple.CoreSimulator.CoreSimulatorService 2>/dev/null

# Step 2: Reset device connections
echo "2. Resetting device connections..."
xcrun devicectl list devices

# Step 3: Clean Flutter
echo "3. Cleaning Flutter project..."
flutter clean
flutter pub get

# Step 4: Build for iOS
echo "4. Building iOS app..."
flutter build ios --debug --no-codesign

# Step 5: List available devices
echo "5. Available devices:"
flutter devices

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "Now please:"
echo "1. Enable Developer Mode on your iPhone:"
echo "   Settings → Privacy & Security → Developer Mode → ON"
echo "2. After restart, unlock iPhone and tap 'Turn On'"
echo "3. Connect USB and tap 'Trust' on iPhone"
echo "4. Run: flutter run"