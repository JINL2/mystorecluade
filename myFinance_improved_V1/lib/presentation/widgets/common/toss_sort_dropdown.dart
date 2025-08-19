import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/core/themes/toss_animations.dart';

class TossSortDropdown<T> extends StatefulWidget {
  final T selectedValue;
  final List<TossSortOption<T>> options;
  final bool ascending;
  final ValueChanged<T> onSortChanged;
  final ValueChanged<bool> onDirectionChanged;
  final String? label;

  const TossSortDropdown({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.ascending,
    required this.onSortChanged,
    required this.onDirectionChanged,
    this.label,
  });

  @override
  State<TossSortDropdown<T>> createState() => _TossSortDropdownState<T>();
}

class _TossSortDropdownState<T> extends State<TossSortDropdown<T>>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.fast,
      vsync: this,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _selectOption(T value) {
    widget.onSortChanged(value);
    _toggleDropdown();
  }

  void _toggleDirection() {
    widget.onDirectionChanged(!widget.ascending);
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = widget.options.firstWhere(
      (option) => option.value == widget.selectedValue,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TossTextStyles.labelLarge.copyWith(
              color: TossColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
        ],
        
        // Main dropdown button
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            height: TossSpacing.inputHeightLG,
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              boxShadow: TossShadows.card,
              border: _isExpanded
                  ? Border.all(color: TossColors.primary, width: 1)
                  : null,
            ),
            child: Row(
              children: [
                // Sort icon
                Icon(
                  Icons.sort,
                  size: TossSpacing.iconSM,
                  color: TossColors.textSecondary,
                ),
                SizedBox(width: TossSpacing.space2),
                
                // Selected option
                Expanded(
                  child: Text(
                    selectedOption.label,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                // Direction button
                GestureDetector(
                  onTap: _toggleDirection,
                  child: Container(
                    padding: EdgeInsets.all(TossSpacing.space1),
                    child: Icon(
                      widget.ascending
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: TossSpacing.iconSM,
                      color: TossColors.primary,
                    ),
                  ),
                ),
                
                SizedBox(width: TossSpacing.space1),
                
                // Expand arrow
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159,
                      child: Icon(
                        Icons.expand_more,
                        size: TossSpacing.iconSM,
                        color: TossColors.textSecondary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        
        // Dropdown options
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _expandAnimation.value,
                child: child,
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: TossSpacing.space1),
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              boxShadow: TossShadows.dropdown,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.options.map((option) {
                final isSelected = option.value == widget.selectedValue;
                
                return Material(
                  color: TossColors.transparent,
                  child: InkWell(
                    onTap: () => _selectOption(option.value),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                        vertical: TossSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? TossColors.primary.withOpacity(0.1)
                            : TossColors.transparent,
                      ),
                      child: Row(
                        children: [
                          if (option.icon != null) ...[
                            Icon(
                              option.icon,
                              size: TossSpacing.iconXS,
                              color: isSelected
                                  ? TossColors.primary
                                  : TossColors.textSecondary,
                            ),
                            SizedBox(width: TossSpacing.space2),
                          ],
                          
                          Expanded(
                            child: Text(
                              option.label,
                              style: TossTextStyles.body.copyWith(
                                color: isSelected
                                    ? TossColors.primary
                                    : TossColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          
                          if (isSelected)
                            Icon(
                              Icons.check,
                              size: TossSpacing.iconXS,
                              color: TossColors.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class TossSortOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const TossSortOption({
    required this.value,
    required this.label,
    this.icon,
  });
}