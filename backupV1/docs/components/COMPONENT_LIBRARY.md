# Reusable Component Library Design

## Component Categories

### 1. Button Components

#### AppButton
Primary button component with multiple variants and sizes.

```dart
// lib/presentation/widgets/common/app_button.dart

enum ButtonVariant { primary, secondary, tertiary, danger, ghost }
enum ButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  
  const AppButton({
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
  });
  
  // Implementation with theme-aware styling
}

// Usage examples:
AppButton(
  text: 'Submit',
  onPressed: () {},
  variant: ButtonVariant.primary,
  leadingIcon: Icons.check,
)

AppButton(
  text: 'Delete',
  onPressed: () {},
  variant: ButtonVariant.danger,
  size: ButtonSize.small,
)
```

#### IconButton
Consistent icon button implementation.

```dart
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;
  
  // Implementation
}
```

### 2. Input Components

#### AppTextField
Versatile text input with validation support.

```dart
// lib/presentation/widgets/common/app_text_field.dart

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  
  const AppTextField({
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.focusNode,
  });
}

// Currency input variant
class CurrencyTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String currency;
  final ValueChanged<double>? onChanged;
  
  // Implementation with currency formatting
}

// Date picker variant
class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  
  // Implementation with date picker
}
```

#### AppDropdown
Consistent dropdown implementation.

```dart
class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final Widget? prefix;
  
  // Implementation
}
```

### 3. Card Components

#### AppCard
Flexible card component for various content types.

```dart
// lib/presentation/widgets/common/app_card.dart

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? elevation;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  
  const AppCard({
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.onTap,
    this.borderRadius,
  });
}

// Transaction card variant
class TransactionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final VoidCallback? onTap;
  
  // Implementation with consistent styling
}

// Summary card variant
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final String? subtitle;
  final double? trend;
  
  // Implementation with trend indicators
}
```

### 4. List Components

#### AppListTile
Enhanced list tile with consistent styling.

```dart
class AppListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final Color? selectedColor;
  
  // Implementation
}

// Financial list item variant
class FinancialListItem extends StatelessWidget {
  final String title;
  final double amount;
  final String? category;
  final DateTime? date;
  final Widget? leading;
  final VoidCallback? onTap;
  
  // Implementation with amount formatting
}
```

### 5. Loading & Empty States

#### LoadingIndicator
Consistent loading states.

```dart
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  
  const LoadingIndicator({
    this.message,
    this.size = 40.0,
    this.color,
  });
}

// Full screen loading
class LoadingScreen extends StatelessWidget {
  final String? message;
  
  // Implementation with backdrop
}
```

#### EmptyState
Informative empty states.

```dart
class EmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final Widget? action;
  
  // Implementation with illustration
}
```

### 6. Navigation Components

#### AppBottomNavBar
Customizable bottom navigation.

```dart
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<BottomNavItem> items;
  
  // Implementation
}

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  
  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
```

#### AppDrawer
Consistent navigation drawer.

```dart
class AppDrawer extends StatelessWidget {
  final User user;
  final Company? selectedCompany;
  final VoidCallback onLogout;
  
  // Implementation with user info and navigation
}
```

### 7. Dialog & Sheet Components

#### AppDialog
Consistent dialog implementation.

```dart
class AppDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? content;
  final List<Widget> actions;
  
  // Implementation
  
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? description,
    Widget? content,
    List<Widget>? actions,
  }) {
    // Show dialog implementation
  }
}
```

#### AppBottomSheet
Flexible bottom sheet.

```dart
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showHandle;
  final double? height;
  
  // Implementation
  
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
  }) {
    // Show bottom sheet implementation
  }
}
```

### 8. Financial Components

#### AmountDisplay
Formatted amount display.

```dart
class AmountDisplay extends StatelessWidget {
  final double amount;
  final String? currency;
  final TextStyle? style;
  final bool showSign;
  final bool useColor;
  
  // Implementation with formatting and coloring
}
```

#### PercentageChange
Percentage change indicator.

```dart
class PercentageChange extends StatelessWidget {
  final double percentage;
  final bool showArrow;
  final TextStyle? style;
  
  // Implementation with arrow indicators
}
```

#### CurrencySelector
Currency selection widget.

```dart
class CurrencySelector extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;
  final List<String>? availableCurrencies;
  
  // Implementation
}
```

### 9. Chart Components

#### MiniChart
Small inline charts.

```dart
class MiniChart extends StatelessWidget {
  final List<double> data;
  final ChartType type;
  final Color? color;
  final double height;
  final double width;
  
  // Implementation with fl_chart
}

enum ChartType { line, bar, pie }
```

#### FinancialChart
Full-featured financial charts.

```dart
class FinancialChart extends StatelessWidget {
  final List<FinancialData> data;
  final ChartType type;
  final String? title;
  final bool showLegend;
  final bool showGrid;
  
  // Implementation
}
```

### 10. Utility Components

#### AppDivider
Consistent divider styling.

```dart
class AppDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  
  // Implementation
}
```

#### AppChip
Versatile chip component.

```dart
class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onDeleted;
  final bool selected;
  final Color? color;
  
  // Implementation
}
```

#### Badge
Notification badges.

```dart
class AppBadge extends StatelessWidget {
  final Widget child;
  final String? value;
  final Color? color;
  final bool show;
  
  // Implementation
}
```

## Component Usage Guidelines

### 1. Consistency
- Always use theme colors and text styles
- Follow spacing system from theme
- Maintain consistent behavior across components

### 2. Accessibility
- Include semantic labels
- Ensure proper contrast ratios
- Support screen readers
- Provide keyboard navigation

### 3. Responsiveness
- Components adapt to different screen sizes
- Text scales appropriately
- Touch targets meet minimum size requirements

### 4. Performance
- Use const constructors where possible
- Implement proper dispose methods
- Avoid unnecessary rebuilds
- Use keys for list items

### 5. Testing
- Each component has unit tests
- Widget tests for interactions
- Golden tests for visual regression

## Example Implementation

```dart
// Example of a complete component implementation
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final backgroundColor = _getBackgroundColor(theme);
    final foregroundColor = _getForegroundColor(theme);
    final padding = _getPadding();
    final textStyle = _getTextStyle(theme);
    
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          elevation: variant == ButtonVariant.ghost ? 0 : AppElevations.elevation2,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: _getIconSize()),
                    const SizedBox(width: AppSpacing.space2),
                  ],
                  Text(text, style: textStyle),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: AppSpacing.space2),
                    Icon(trailingIcon, size: _getIconSize()),
                  ],
                ],
              ),
      ),
    );
  }
  
  Color _getBackgroundColor(ThemeData theme) {
    switch (variant) {
      case ButtonVariant.primary:
        return theme.colorScheme.primary;
      case ButtonVariant.secondary:
        return theme.colorScheme.secondary;
      case ButtonVariant.tertiary:
        return theme.colorScheme.tertiary;
      case ButtonVariant.danger:
        return theme.colorScheme.error;
      case ButtonVariant.ghost:
        return Colors.transparent;
    }
  }
  
  Color _getForegroundColor(ThemeData theme) {
    switch (variant) {
      case ButtonVariant.ghost:
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.onPrimary;
    }
  }
  
  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }
  
  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
        return 40;
      case ButtonSize.large:
        return 48;
    }
  }
  
  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
  
  TextStyle _getTextStyle(ThemeData theme) {
    switch (size) {
      case ButtonSize.small:
        return theme.textTheme.labelMedium!;
      case ButtonSize.medium:
        return theme.textTheme.labelLarge!;
      case ButtonSize.large:
        return theme.textTheme.titleMedium!;
    }
  }
}
```