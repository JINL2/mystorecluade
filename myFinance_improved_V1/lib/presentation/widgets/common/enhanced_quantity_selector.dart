import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

/// Enhanced quantity selector with proper touch targets, haptic feedback,
/// and smooth user experience optimized for mobile touch interfaces.
/// 
/// Features:
/// - 56px minimum touch targets (exceeds WCAG 2.1 48px requirement)
/// - Haptic feedback on all interactions
/// - Visual press animations and micro-interactions  
/// - Long-press support for rapid quantity changes
/// - Debouncing to prevent accidental over-tapping
/// - Smart layout: [－] [quantity] [＋]
/// - Accessibility labels and semantic markup
/// - Configurable max quantity with visual warnings
/// - Real-time value change callbacks
class EnhancedQuantitySelector extends StatefulWidget {
  /// Current quantity value (0 or higher)
  final int quantity;
  
  /// Callback fired when quantity changes
  final ValueChanged<int> onQuantityChanged;
  
  /// Maximum allowed quantity (default: 999)
  final int maxQuantity;
  
  /// Minimum allowed quantity (default: 0)
  final int minQuantity;
  
  /// Whether the selector is enabled (default: true)
  final bool enabled;
  
  /// Custom step size for quantity changes (default: 1)
  final int step;
  
  /// Long press acceleration settings
  final Duration longPressDelay;
  final Duration longPressInterval;
  
  /// Visual customization
  final double? width;
  final Color? primaryColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  
  /// Accessibility settings
  final String? semanticLabel;
  final String? decrementSemanticLabel;
  final String? incrementSemanticLabel;
  
  /// Display style options
  final bool showAddToCartState;
  final String addToCartText;
  final bool compactMode;
  
  const EnhancedQuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.maxQuantity = 999,
    this.minQuantity = 0,
    this.enabled = true,
    this.step = 1,
    this.longPressDelay = const Duration(milliseconds: 500),
    this.longPressInterval = const Duration(milliseconds: 100),
    this.width,
    this.primaryColor,
    this.backgroundColor,
    this.padding,
    this.semanticLabel,
    this.decrementSemanticLabel,
    this.incrementSemanticLabel,
    this.showAddToCartState = false,
    this.addToCartText = 'Add to cart',
    this.compactMode = false,
  });

  @override
  State<EnhancedQuantitySelector> createState() => _EnhancedQuantitySelectorState();
}

class _EnhancedQuantitySelectorState extends State<EnhancedQuantitySelector>
    with TickerProviderStateMixin {
  
  // Animation controllers
  late AnimationController _decrementAnimationController;
  late AnimationController _incrementAnimationController;
  late AnimationController _quantityAnimationController;
  
  // Animations
  late Animation<double> _decrementScaleAnimation;
  late Animation<double> _incrementScaleAnimation;
  late Animation<double> _quantityScaleAnimation;
  
  // Long press management
  Timer? _longPressTimer;
  Timer? _debounceTimer;
  bool _isLongPressing = false;
  
  // State management
  int _pendingQuantity = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _pendingQuantity = widget.quantity;
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Decrement button animation
    _decrementAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _decrementScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _decrementAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Increment button animation
    _incrementAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _incrementScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _incrementAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Quantity display animation
    _quantityAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _quantityScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _quantityAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(EnhancedQuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _pendingQuantity = widget.quantity;
      if (oldWidget.quantity != widget.quantity) {
        _animateQuantityChange();
      }
    }
  }

  @override
  void dispose() {
    _decrementAnimationController.dispose();
    _incrementAnimationController.dispose();
    _quantityAnimationController.dispose();
    _longPressTimer?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _animateQuantityChange() {
    if (_isAnimating) return;
    _isAnimating = true;
    
    _quantityAnimationController.forward().then((_) {
      _quantityAnimationController.reverse().then((_) {
        _isAnimating = false;
      });
    });
  }

  void _handleDecrement() {
    if (!widget.enabled || _pendingQuantity <= widget.minQuantity) return;
    
    HapticFeedback.lightImpact();
    _decrementAnimationController.forward().then((_) {
      _decrementAnimationController.reverse();
    });
    
    _debouncedQuantityChange(_pendingQuantity - widget.step);
  }

  void _handleIncrement() {
    if (!widget.enabled || _pendingQuantity >= widget.maxQuantity) return;
    
    HapticFeedback.lightImpact();
    _incrementAnimationController.forward().then((_) {
      _incrementAnimationController.reverse();
    });
    
    _debouncedQuantityChange(_pendingQuantity + widget.step);
  }

  void _debouncedQuantityChange(int newQuantity) {
    _debounceTimer?.cancel();
    _pendingQuantity = newQuantity.clamp(widget.minQuantity, widget.maxQuantity);
    
    setState(() {}); // Update UI immediately
    
    // Debounce the callback to prevent rapid-fire updates
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        widget.onQuantityChanged(_pendingQuantity);
        _animateQuantityChange();
      }
    });
  }

  void _startLongPress({required bool isIncrement}) {
    if (_isLongPressing) return;
    
    _isLongPressing = true;
    HapticFeedback.mediumImpact();
    
    _longPressTimer = Timer(widget.longPressDelay, () {
      if (!_isLongPressing) return;
      
      // Start rapid changes
      Timer.periodic(widget.longPressInterval, (timer) {
        if (!_isLongPressing || !mounted) {
          timer.cancel();
          return;
        }
        
        final currentQuantity = _pendingQuantity;
        final newQuantity = isIncrement 
            ? currentQuantity + widget.step 
            : currentQuantity - widget.step;
            
        if (newQuantity < widget.minQuantity || newQuantity > widget.maxQuantity) {
          HapticFeedback.heavyImpact(); // Indicate limit reached
          timer.cancel();
          _isLongPressing = false;
          return;
        }
        
        HapticFeedback.selectionClick();
        _debouncedQuantityChange(newQuantity);
      });
    });
  }

  void _endLongPress() {
    _isLongPressing = false;
    _longPressTimer?.cancel();
  }

  Color get _primaryColor => widget.primaryColor ?? TossColors.primary;
  Color get _backgroundColor => widget.backgroundColor ?? TossColors.gray100;

  @override
  Widget build(BuildContext context) {
    // Handle "Add to cart" state when quantity is 0
    if (widget.showAddToCartState && _pendingQuantity == 0) {
      return _buildAddToCartButton();
    }

    return Semantics(
      label: widget.semanticLabel ?? 'Quantity selector',
      value: '$_pendingQuantity',
      child: Container(
        width: widget.width,
        padding: widget.padding,
        child: widget.compactMode ? _buildCompactSelector() : _buildFullSelector(),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.width ?? 140,
      height: 48,
      child: ElevatedButton(
        onPressed: widget.enabled ? () => _handleIncrement() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.button),
          ),
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
        ),
        child: Text(
          widget.addToCartText,
          style: TossTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFullSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          onPressed: _handleDecrement,
          onLongPress: () => _startLongPress(isIncrement: false),
          onLongPressEnd: _endLongPress,
          icon: Icons.remove,
          semanticLabel: widget.decrementSemanticLabel ?? 'Decrease quantity',
          enabled: widget.enabled && _pendingQuantity > widget.minQuantity,
          animation: _decrementScaleAnimation,
        ),
        SizedBox(width: TossSpacing.space2),
        _buildQuantityDisplay(),
        SizedBox(width: TossSpacing.space2),
        _buildActionButton(
          onPressed: _handleIncrement,
          onLongPress: () => _startLongPress(isIncrement: true),
          onLongPressEnd: _endLongPress,
          icon: Icons.add,
          semanticLabel: widget.incrementSemanticLabel ?? 'Increase quantity',
          enabled: widget.enabled && _pendingQuantity < widget.maxQuantity,
          animation: _incrementScaleAnimation,
        ),
      ],
    );
  }

  Widget _buildCompactSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCompactButton(
          onPressed: _handleDecrement,
          icon: Icons.remove,
          enabled: widget.enabled && _pendingQuantity > widget.minQuantity,
        ),
        Container(
          width: 40,
          height: 32,
          margin: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
          decoration: BoxDecoration(
            color: _primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _quantityScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _quantityScaleAnimation.value,
                  child: Text(
                    '$_pendingQuantity',
                    style: TossTextStyles.body.copyWith(
                      color: _primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        _buildCompactButton(
          onPressed: _handleIncrement,
          icon: Icons.add,
          enabled: widget.enabled && _pendingQuantity < widget.maxQuantity,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required VoidCallback onLongPress,
    required VoidCallback onLongPressEnd,
    required IconData icon,
    required String semanticLabel,
    required bool enabled,
    required Animation<double> animation,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      enabled: enabled,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: animation.value,
            child: GestureDetector(
              onTap: enabled ? onPressed : null,
              onLongPressStart: enabled ? (_) => onLongPress() : null,
              onLongPressEnd: enabled ? (_) => onLongPressEnd() : null,
              onLongPressCancel: enabled ? onLongPressEnd : null,
              child: Container(
                width: 56, // Exceeds WCAG 48px requirement
                height: 56,
                decoration: BoxDecoration(
                  color: enabled 
                      ? (animation.value < 1.0 
                          ? _primaryColor.withValues(alpha: 0.15)
                          : _primaryColor.withValues(alpha: 0.1))
                      : TossColors.gray200,
                  shape: BoxShape.circle,
                  boxShadow: enabled && animation.value < 1.0 
                      ? [
                          BoxShadow(
                            color: _primaryColor.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  icon,
                  color: enabled ? _primaryColor : TossColors.gray400,
                  size: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(TossBorderRadius.full),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? TossColors.gray200 : TossColors.gray100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? TossColors.gray700 : TossColors.gray400,
        ),
      ),
    );
  }

  Widget _buildQuantityDisplay() {
    return AnimatedBuilder(
      animation: _quantityScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _quantityScaleAnimation.value,
          child: Container(
            width: 56,
            height: 48,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: _pendingQuantity >= widget.maxQuantity 
                    ? TossColors.warning
                    : TossColors.gray200,
                width: _pendingQuantity >= widget.maxQuantity ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_pendingQuantity',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _pendingQuantity >= widget.maxQuantity 
                        ? TossColors.warning
                        : TossColors.gray900,
                  ),
                ),
                if (_pendingQuantity >= widget.maxQuantity)
                  Text(
                    'max',
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.warning,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}