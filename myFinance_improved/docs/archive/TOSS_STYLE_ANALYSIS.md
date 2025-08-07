# Toss-Style UI/UX Analysis & Integration

## Toss Design Principles

### Core Characteristics
1. **Minimalist & Clean**: White space, clear hierarchy, no visual clutter
2. **Micro-interactions**: Subtle animations and feedback
3. **Bold Typography**: Clear, confident text hierarchy
4. **Soft Shadows**: Layered depth with subtle shadows
5. **Rounded Corners**: Friendly, approachable feel
6. **Single Actions**: One primary action per screen
7. **Progressive Disclosure**: Information revealed as needed
8. **Delightful Details**: Thoughtful touches that surprise users

## Your Theme Analysis

### Color Palette (OKLCH)
Your theme uses OKLCH color space which is excellent for:
- Perceptually uniform color transitions
- Better color mixing
- Consistent lightness across hues

### Current Colors
```
Light Mode:
- Primary: oklch(0.6231 0.1880 259.8145) - Blue/Purple
- Secondary: oklch(0.9670 0.0029 264.5419) - Near white
- Destructive: oklch(0.6368 0.2078 25.3313) - Red/Orange
- Background: Pure white
- Foreground: Dark gray

Dark Mode:
- Maintains primary color consistency
- Good contrast ratios
- Accent: oklch(0.3791 0.1378 265.5222) - Purple
```

### Typography
- Sans: Inter (Excellent choice - clean, modern)
- Serif: Source Serif 4
- Mono: JetBrains Mono

### Spacing & Radius
- Base radius: 0.375rem (6px) - Could be increased for Toss style
- Spacing unit: 0.25rem (4px)

## Toss-Style Adaptations

### 1. Enhanced Color Usage
```dart
// Toss-style color principles
class TossColors {
  // Keep your primary but use sparingly
  static const primary = Color(0xFF5B5FCF); // Your OKLCH primary converted
  
  // Toss uses lots of grays for hierarchy
  static const gray50 = Color(0xFFFAFAFA);
  static const gray100 = Color(0xFFF5F5F5);
  static const gray200 = Color(0xFFE5E5E5);
  static const gray300 = Color(0xFFD4D4D4);
  static const gray400 = Color(0xFFA3A3A3);
  static const gray500 = Color(0xFF737373);
  static const gray600 = Color(0xFF525252);
  static const gray700 = Color(0xFF404040);
  static const gray800 = Color(0xFF262626);
  static const gray900 = Color(0xFF171717);
  
  // Status colors - more muted than typical
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  
  // Toss signature: Blue for links/actions
  static const link = Color(0xFF3B82F6);
  
  // Background colors for cards/sections
  static const surface1 = Color(0xFFFBFBFB);
  static const surface2 = Color(0xFFF8F8F8);
}
```

### 2. Typography System (Toss-style)
```dart
class TossTextStyles {
  // Display - Used sparingly for impact
  static const display = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02,
    height: 1.1,
  );
  
  // Headlines - Clear hierarchy
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 1.2,
  );
  
  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.3,
  );
  
  static const h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );
  
  // Body - Optimized for readability
  static const bodyLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.6,
  );
  
  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
  );
  
  static const bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );
  
  // Labels
  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.02,
    height: 1.3,
  );
  
  // Caption
  static const caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.02,
    height: 1.3,
    color: TossColors.gray500,
  );
}
```

### 3. Spacing System (Toss-style)
```dart
class TossSpacing {
  static const space0 = 0.0;
  static const space1 = 4.0;
  static const space2 = 8.0;
  static const space3 = 12.0;
  static const space4 = 16.0;
  static const space5 = 20.0;
  static const space6 = 24.0;
  static const space7 = 28.0;
  static const space8 = 32.0;
  static const space10 = 40.0;
  static const space12 = 48.0;
  static const space16 = 64.0;
  static const space20 = 80.0;
  static const space24 = 96.0;
}
```

### 4. Border Radius (Softer, Toss-style)
```dart
class TossBorderRadius {
  static const none = 0.0;
  static const xs = 6.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const full = 999.0;
}
```

### 5. Shadows (Toss signature shadows)
```dart
class TossShadows {
  // Toss uses very subtle shadows
  static const shadow1 = BoxShadow(
    color: Color(0x05000000),
    offset: Offset(0, 1),
    blurRadius: 2,
  );
  
  static const shadow2 = BoxShadow(
    color: Color(0x08000000),
    offset: Offset(0, 2),
    blurRadius: 8,
  );
  
  static const shadow3 = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(0, 4),
    blurRadius: 16,
  );
  
  static const shadow4 = BoxShadow(
    color: Color(0x0D000000),
    offset: Offset(0, 8),
    blurRadius: 24,
  );
}
```

## Toss-Style Components

### 1. Bottom Sheet Actions
```dart
// Toss's signature bottom sheet for actions
class TossBottomSheet extends StatelessWidget {
  final String title;
  final List<TossActionItem> actions;
  
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<TossActionItem> actions,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => TossBottomSheet(
        title: title,
        actions: actions,
      ),
    );
  }
}
```

### 2. Single Action Buttons
```dart
// Large, prominent CTAs
class TossPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
```

### 3. Card with Micro-interactions
```dart
class TossCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  
  @override
  _TossCardState createState() => _TossCardState();
}

class _TossCardState extends State<TossCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              boxShadow: [TossShadows.shadow2],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
```

### 4. Amount Input (Toss-style)
```dart
class TossAmountInput extends StatelessWidget {
  final TextEditingController controller;
  final String currency;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '얼마를 보낼까요?', // "How much to send?"
          style: TossTextStyles.h2,
        ),
        SizedBox(height: TossSpacing.space4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: TossTextStyles.display,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: TossTextStyles.display.copyWith(
                    color: TossColors.gray300,
                  ),
                ),
              ),
            ),
            Text(
              currency,
              style: TossTextStyles.h1.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
        Divider(
          color: TossColors.gray200,
          thickness: 2,
        ),
      ],
    );
  }
}
```

### 5. List Item (Toss-style)
```dart
class TossListItem extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final String? trailing;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              SizedBox(width: TossSpacing.space4),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      subtitle!,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing!,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
            ],
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Animation Patterns

### 1. Page Transitions
```dart
class TossPageTransition extends PageRouteBuilder {
  final Widget child;
  
  TossPageTransition({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            
            var offsetAnimation = animation.drive(tween);
            
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
```

### 2. Micro-interactions
```dart
// Number counting animation
class AnimatedCounter extends StatelessWidget {
  final double value;
  final Duration duration;
  
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      builder: (context, value, child) {
        return Text(
          NumberFormat.currency(symbol: '₩').format(value),
          style: TossTextStyles.h1,
        );
      },
    );
  }
}
```

## Design Patterns

### 1. Progressive Disclosure
- Show only essential information first
- Reveal details on tap/scroll
- Use expandable sections

### 2. Single Primary Action
- One main CTA per screen
- Secondary actions in menu/settings
- Clear visual hierarchy

### 3. Contextual Help
- Inline tooltips
- First-time user guidance
- Smart defaults

### 4. Delightful Feedback
- Success animations
- Haptic feedback
- Sound effects (optional)