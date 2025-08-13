# 🧩 Component Development Guide

This guide explains how to create, test, and document components in the MyFinance Toss-style system.

## Component Philosophy

### Toss Design Principles
1. **Single Responsibility** - Each component does one thing well
2. **Micro-interactions** - Delightful feedback on every interaction
3. **Accessibility First** - WCAG AA compliant by default
4. **Performance** - 60fps animations, minimal rebuilds
5. **Reusability** - Configurable but not complicated

## Creating a New Component

### 1. Component Structure

```dart
// lib/presentation/widgets/toss/toss_example_widget.dart

import 'package:flutter/material.dart';
import 'package:myfinance/core/themes/toss_colors.dart';
import 'package:myfinance/core/themes/toss_text_styles.dart';
import 'package:myfinance/core/themes/toss_spacing.dart';

/// Brief description of what this component does.
/// 
/// Example:
/// ```dart
/// TossExampleWidget(
///   title: 'Hello',
///   onTap: () => print('Tapped'),
/// )
/// ```
class TossExampleWidget extends StatefulWidget {
  /// Primary text to display
  final String title;
  
  /// Optional subtitle
  final String? subtitle;
  
  /// Callback when tapped
  final VoidCallback? onTap;
  
  /// Whether the widget is in a loading state
  final bool isLoading;
  
  const TossExampleWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isLoading = false,
  });
  
  @override
  State<TossExampleWidget> createState() => _TossExampleWidgetState();
}

class _TossExampleWidgetState extends State<TossExampleWidget>
    with SingleTickerProviderStateMixin {
  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }
  
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _animationController.forward() : null,
      onTapUp: widget.onTap != null ? (_) => _animationController.reverse() : null,
      onTapCancel: widget.onTap != null ? () => _animationController.reverse() : null,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildContent(),
        ),
      ),
    );
  }
  
  Widget _buildContent() {
    // Component content here
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        boxShadow: TossShadows.shadow2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TossTextStyles.body,
          ),
          if (widget.subtitle != null) ...[
            SizedBox(height: TossSpacing.space1),
            Text(
              widget.subtitle!,
              style: TossTextStyles.caption,
            ),
          ],
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
```

### 2. Component Checklist

- [ ] **Naming**: Prefix with `Toss` for Toss-style components
- [ ] **Documentation**: Add dartdoc comments with examples
- [ ] **Parameters**: Use named parameters with clear types
- [ ] **Defaults**: Provide sensible defaults
- [ ] **Null Safety**: Handle null cases gracefully
- [ ] **Animations**: Add micro-interactions (100-300ms)
- [ ] **Accessibility**: Include semantic labels
- [ ] **Theme**: Use theme colors and text styles
- [ ] **Testing**: Write widget tests
- [ ] **Performance**: Use `const` constructors where possible

## Animation Guidelines

### Standard Durations
```dart
class TossAnimationDurations {
  static const instant = Duration(milliseconds: 0);
  static const fast = Duration(milliseconds: 100);
  static const normal = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 300);
  static const verySlow = Duration(milliseconds: 500);
}
```

### Common Animations
```dart
// Touch feedback
Transform.scale(
  scale: _scaleAnimation.value, // 1.0 → 0.98
  child: child,
)

// Fade in
FadeTransition(
  opacity: _fadeAnimation, // 0.0 → 1.0
  child: child,
)

// Slide up
SlideTransition(
  position: _slideAnimation, // Offset(0, 1) → Offset(0, 0)
  child: child,
)

// Shadow reduction on press
AnimatedContainer(
  duration: TossAnimationDurations.fast,
  decoration: BoxDecoration(
    boxShadow: isPressed ? TossShadows.shadow1 : TossShadows.shadow2,
  ),
)
```

### Curves
```dart
// Standard curves
Curves.easeOutCubic    // Default for most animations
Curves.easeInOut       // For continuous animations
Curves.elasticOut      // For playful bounce effects
Curves.fastOutSlowIn   // Material-style animations
```

## Component Patterns

### 1. Interactive Card Pattern
```dart
class TossInteractiveCard extends StatefulWidget {
  // Combines:
  // - Touch feedback (scale)
  // - Shadow animation
  // - Ripple effect
  // - Haptic feedback
}
```

### 2. Loading State Pattern
```dart
Widget build(BuildContext context) {
  if (widget.isLoading) {
    return Shimmer.fromColors(
      baseColor: TossColors.gray100,
      highlightColor: TossColors.gray50,
      child: _buildContent(),
    );
  }
  return _buildContent();
}
```

### 3. Empty State Pattern
```dart
class TossEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? action;
  final IconData icon;
  
  // Includes:
  // - Friendly illustration
  // - Clear message
  // - Optional action button
}
```

### 4. Bottom Sheet Pattern
```dart
class TossBottomSheet extends StatelessWidget {
  // Always includes:
  // - Handle indicator
  // - Rounded top corners
  // - Proper padding for safe area
  // - Smooth slide animation
}
```

## Accessibility

### Required Attributes
```dart
Semantics(
  label: 'Send money button',
  hint: 'Double tap to send money',
  button: true,
  enabled: widget.isEnabled,
  child: TossPrimaryButton(...),
)
```

### Focus Management
```dart
Focus(
  autofocus: widget.autofocus,
  focusNode: _focusNode,
  onFocusChange: (hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });
  },
  child: ...,
)
```

### Contrast Ratios
- Normal text: 4.5:1 minimum
- Large text: 3:1 minimum
- Use `TossColors` which are pre-validated

## Testing Components

### Widget Test Template
```dart
// test/presentation/widgets/toss/toss_example_widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:myfinance/presentation/widgets/toss/toss_example_widget.dart';

void main() {
  group('TossExampleWidget', () {
    testWidgets('renders correctly with required props', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossExampleWidget(
              title: 'Test Title',
            ),
          ),
        ),
      );
      
      expect(find.text('Test Title'), findsOneWidget);
    });
    
    testWidgets('handles tap correctly', (tester) async {
      var tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossExampleWidget(
              title: 'Test',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(TossExampleWidget));
      await tester.pumpAndSettle();
      
      expect(tapped, isTrue);
    });
    
    testWidgets('shows loading state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossExampleWidget(
              title: 'Test',
              isLoading: true,
            ),
          ),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### Golden Tests
```dart
testWidgets('matches design', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: TossTheme.light,
      home: Scaffold(
        body: TossExampleWidget(
          title: 'Golden Test',
          subtitle: 'This should match design',
        ),
      ),
    ),
  );
  
  await expectLater(
    find.byType(TossExampleWidget),
    matchesGoldenFile('goldens/toss_example_widget.png'),
  );
});
```

## Documentation

### Component Documentation Template
```markdown
# TossExampleWidget

Brief description of the component's purpose.

## Usage

```dart
TossExampleWidget(
  title: 'Hello World',
  subtitle: 'Optional subtitle',
  onTap: () => print('Tapped!'),
)
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| title | String | required | Primary text |
| subtitle | String? | null | Optional subtitle |
| onTap | VoidCallback? | null | Tap handler |
| isLoading | bool | false | Loading state |

## Examples

### Basic Usage
[Code example]

### With Loading State
[Code example]

### In a List
[Code example]

## Design Specifications

- Touch target: 44x44 minimum
- Animation: 100ms scale on tap
- Shadow: TossShadows.shadow2
- Border radius: 12px
- Padding: 16px

## Accessibility

- Semantic label included
- Keyboard navigable
- Screen reader compatible
- WCAG AA compliant
```

## Component Categories

### Input Components
- `TossTextField`
- `TossAmountInput`
- `TossSearchBar`
- `TossDatePicker`

### Display Components
- `TossCard`
- `TossInfoCard`
- `TossTransactionItem`
- `TossEmptyState`

### Navigation Components
- `TossBottomSheet`
- `TossTabBar`
- `TossSegmentedControl`

### Feedback Components
- `TossToast`
- `TossSnackBar`
- `TossLoadingIndicator`
- `TossSuccessAnimation`

### Action Components
- `TossPrimaryButton`
- `TossTextButton`
- `TossIconButton`
- `TossFloatingActionButton`

## Performance Tips

1. **Use const constructors** wherever possible
2. **Avoid rebuilding** static content
3. **Optimize images** with proper sizing
4. **Lazy load** heavy components
5. **Profile regularly** with Flutter DevTools

## Common Pitfalls

❌ **Don't**:
- Over-animate (too many simultaneous animations)
- Ignore platform differences
- Hard-code colors or text styles
- Create overly complex components
- Skip accessibility

✅ **Do**:
- Keep animations under 300ms
- Test on both iOS and Android
- Use theme values
- Create focused, single-purpose components
- Include semantic labels

## Resources

- [Toss Design System](../design-system/TOSS_STYLE_ANALYSIS.md)
- [Theme Reference](../design-system/THEME_SYSTEM.md)
- [Component Library](./TOSS_COMPONENT_LIBRARY.md)
- [Flutter Best Practices](https://flutter.dev/docs/development/ui/widgets)

---

Need help? Ask in #myfinance-dev or check our [component examples](./examples/)! 🚀