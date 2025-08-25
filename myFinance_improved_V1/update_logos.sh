#!/bin/bash

# MyFinance Logo Update Script
# This script helps complete the logo replacement process

echo "========================================="
echo "MyFinance Logo Update Process"
echo "========================================="

# Navigate to project directory
cd /Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1

echo ""
echo "Step 1: New logo files created ✓"
echo "- logo_myfinance_icon.svg"
echo "- logo_myfinance_horizontal.svg"
echo "- logo_myfinance_horizontal_white.svg"
echo "- logo_myfinance_monogram.svg"
echo "- logo_myfinance_stacked.svg"

echo ""
echo "Step 2: Updated pubspec.yaml configuration ✓"

echo ""
echo "Step 3: Generate app icons and splash screens"
echo "Running Flutter commands..."

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Generate launcher icons
echo "Generating launcher icons..."
flutter pub run flutter_launcher_icons

# Generate splash screens
echo "Generating splash screens..."
flutter pub run flutter_native_splash:create

echo ""
echo "Step 4: Rebuild the application"
echo "You can now run your app with the new logos using:"
echo "  flutter run"

echo ""
echo "========================================="
echo "Logo Update Complete!"
echo "========================================="
echo ""
echo "Notes:"
echo "1. The new MyFinance logos use the dollar sign ($) symbol"
echo "2. The text 'MyFinance' uses the same font style as 'Storebase'"
echo "3. The primary brand color remains #0064FF (blue)"
echo "4. Old Storebase logo files are still in the directory (can be deleted if not needed)"
echo ""
echo "To manually update any remaining logo references in your code:"
echo "  - Search for 'logo_storebase' and replace with 'logo_myfinance'"
echo "  - Check any custom widgets that might reference the old logos"
