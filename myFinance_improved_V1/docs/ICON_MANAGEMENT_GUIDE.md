# 🎨 Icon Management Guide

## Overview
MyFinance uses a flexible 3-tier icon system that supports Material Icons, SVG assets, and remote icons.

## Icon Priority System

```
1. Remote URL (from database) → Highest Priority
2. Local SVG/PNG assets → Medium Priority  
3. Material Icons → Fallback
```

## Directory Structure

```
assets/
├── icons/
│   ├── features/        # Feature-specific icons
│   │   ├── dashboard.svg
│   │   ├── attendance.svg
│   │   └── inventory.svg
│   ├── categories/      # Transaction category icons
│   │   ├── food.svg
│   │   ├── transport.svg
│   │   └── shopping.svg
│   └── actions/         # Action icons
│       ├── add.svg
│       ├── edit.svg
│       └── delete.svg
```

## Database Schema

```sql
-- features table
icon_key TEXT    -- Maps to AppIcons registry (e.g., 'dashboard', 'attendance')
icon_url TEXT    -- Optional remote icon URL (overrides icon_key)
```

## Usage Examples

### 1. Basic Icon Usage

```dart
import 'package:myfinance_improved/core/constants/app_icons.dart';

// Get icon by key
AppIcons.getIcon('dashboard', size: 24, color: Colors.blue)

// Get icon with remote URL fallback
AppIcons.getIcon(
  'custom_feature',
  iconUrl: 'https://example.com/icon.png',
  size: 32,
)
```

### 2. Feature Grid with Icons

```dart
import 'package:myfinance_improved/presentation/widgets/common/feature_grid_item.dart';

// Use in a grid
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    spacing: 16,
  ),
  itemBuilder: (context, index) {
    return FeatureGridItem(
      feature: features[index], // From Supabase
    );
  },
)
```

### 3. Feature List with Icons

```dart
// Use in a list
ListView.builder(
  itemBuilder: (context, index) {
    return FeatureListTile(
      feature: features[index],
    );
  },
)
```

## Adding New Icons

### Step 1: Add SVG/PNG to Assets

Place your icon file in the appropriate folder:
- Features: `assets/icons/features/`
- Categories: `assets/icons/categories/`
- Actions: `assets/icons/actions/`

### Step 2: Register in AppIcons

```dart
// In app_icons.dart
static const Map<String, String> _assetIcons = {
  'your_new_icon': 'assets/icons/features/your_new_icon.svg',
  // ...
};

static const Map<String, IconData> _materialIcons = {
  'your_new_icon': Icons.your_fallback_icon,
  // ...
};
```

### Step 3: Update Database

```sql
UPDATE features 
SET icon_key = 'your_new_icon' 
WHERE name = 'Your Feature Name';
```

## Icon Formats

### Recommended Specifications

**SVG Icons (Preferred)**
- Size: 24x24 or 48x48 viewport
- Format: Optimized SVG
- Colors: Use currentColor for theming
- File size: < 5KB

**PNG Icons**
- Sizes: Provide @1x, @2x, @3x
- Format: PNG-24 with transparency
- Dimensions: 48x48, 96x96, 144x144

**Remote Icons**
- Format: PNG, JPG, WebP
- CDN recommended for performance
- Implement caching strategy

## Icon Selection UI

For admin/settings screens where users can select icons:

```dart
IconSelector(
  selectedIcon: currentIconKey,
  onIconSelected: (iconKey) {
    // Update in database
    updateFeatureIcon(iconKey);
  },
)
```

## Performance Considerations

1. **SVG Optimization**: Use SVGO to optimize SVG files
2. **Caching**: Remote icons are cached using CachedNetworkImage
3. **Lazy Loading**: Icons are loaded on-demand
4. **Fallbacks**: Always provide Material icon fallbacks

## Best Practices

### ✅ DO
- Use consistent icon style (outline or filled)
- Provide fallback icons for all features
- Test icons in both light and dark themes
- Keep icon keys descriptive and lowercase
- Cache remote icons appropriately

### ❌ DON'T
- Mix different icon styles in the same context
- Use icons larger than necessary
- Hardcode icon paths in widgets
- Skip fallback implementations
- Use unoptimized SVG files

## Testing Icons

```dart
// Test icon availability
if (AppIcons.hasIcon('dashboard')) {
  // Icon exists
}

// Get all available icons
final allIcons = AppIcons.availableIcons;
```

## Migration from Old System

If migrating from hardcoded icons:

1. Run SQL migration: `sql/add_icon_support_to_features.sql`
2. Update feature widgets to use `AppIcons.getIcon()`
3. Replace Material Icons with icon keys in database
4. Test all features for proper icon display

## Troubleshooting

**Icon not showing?**
1. Check if icon_key exists in AppIcons registry
2. Verify asset path in pubspec.yaml
3. Run `flutter pub get` after adding new assets
4. Check console for loading errors

**Remote icon slow?**
1. Optimize image size (< 50KB recommended)
2. Use CDN for better performance
3. Check CachedNetworkImage configuration

**Wrong icon displayed?**
1. Verify icon_key in database
2. Check for typos in icon key
3. Clear app cache if using remote icons