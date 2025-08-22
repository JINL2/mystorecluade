#!/bin/bash

# Setup script for iOS App Store deployment

echo "🚀 Setting up iOS deployment for Storebase..."

# Copy the .p8 key file from Downloads
echo "📋 Copying API key file..."
cp ~/Downloads/AuthKey*.p8 ./ios/ 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ API key copied successfully"
else
    echo "⚠️  Could not find API key in Downloads. Please copy manually:"
    echo "   cp ~/Downloads/AuthKey_KBD7W26AL2.p8 ./ios/"
fi

# Clean and prepare
echo "🧹 Cleaning build..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔨 Building iOS release..."
flutter build ios --release

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Open Xcode: open ios/Runner.xcworkspace"
echo "2. Select 'Any iOS Device (arm64)' as target"
echo "3. Product → Archive"
echo "4. Distribute App → App Store Connect → Upload"