import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_animations.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';
import '../models/homepage_models.dart';

class FeatureCard extends StatefulWidget {
  const FeatureCard({
    super.key,
    required this.feature,
    required this.onTap,
  });

  final Feature feature;
  final VoidCallback onTap;

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: UIConstants.quickAnimationMs),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: UIConstants.scaleDefault,
      end: UIConstants.tapScaleDown,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  Widget _buildIcon() {
    return Container(
      width: UIConstants.featureIconContainerCompact,
      height: UIConstants.featureIconContainerCompact,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: TossColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
      ),
      child: DynamicIcon(
        iconKey: widget.feature.iconKey,
        size: UIConstants.featureIconSize,
        color: TossColors.primary,
        useDefaultColor: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(UIConstants.contentPadding),
              decoration: BoxDecoration(
                color: TossColors.background,
                borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
                border: Border.all(
                  color: TossColors.gray200,
                  width: UIConstants.borderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.gray900.withOpacity(0.04),
                    offset: const Offset(0, UIConstants.cardShadowOffset),
                    blurRadius: UIConstants.cardShadowBlur,
                    spreadRadius: UIConstants.cardShadowSpread,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with background
                  _buildIcon(),
                  
                  SizedBox(height: TossSpacing.space3),
                  
                  // Title with better typography
                  Text(
                    widget.feature.featureName,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                      fontSize: UIConstants.textSizeCompact,
                      height: UIConstants.lineHeightStandard,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: UIConstants.featureNameMaxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}