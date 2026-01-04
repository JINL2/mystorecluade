import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_animations.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../sale_product/presentation/utils/currency_formatter.dart';
import '../../../domain/entities/product.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Hero stats section showing Attributes, Cost, and Price
/// Optimized with staggered entrance animations for each column
class ProductHeroStats extends StatefulWidget {
  final Product product;
  final String currencySymbol;
  final int animationDelay;

  const ProductHeroStats({
    super.key,
    required this.product,
    required this.currencySymbol,
    this.animationDelay = 100,
  });

  @override
  State<ProductHeroStats> createState() => _ProductHeroStatsState();
}

class _ProductHeroStatsState extends State<ProductHeroStats>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    // Create staggered animations for 3 columns
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: TossAnimations.normal,
        vsync: this,
      );
    });

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: TossAnimations.enter),
      );
    }).toList();

    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: TossAnimations.enter),
      );
    }).toList();

    // Start staggered animations
    _startStaggeredAnimations();
  }

  void _startStaggeredAnimations() {
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: widget.animationDelay + (i * 50)),
        () {
          if (mounted) _controllers[i].forward();
        },
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: TossSpacing.space2,
        bottom: TossSpacing.space4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attributes column
          Expanded(
            child: _buildAnimatedColumn(
              index: 0,
              child: _buildAttributesColumn(),
            ),
          ),
          // Divider
          const GrayVerticalDivider(height: 50, horizontalMargin: 12),
          // Cost column
          Expanded(
            child: _buildAnimatedColumn(
              index: 1,
              child: _buildCostColumn(),
            ),
          ),
          // Divider
          Container(
            width: 1,
            height: 50,
            color: TossColors.gray200,
            margin: const EdgeInsets.only(left: 12, right: 8),
          ),
          // Price column
          Expanded(
            child: _buildAnimatedColumn(
              index: 2,
              child: _buildPriceColumn(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedColumn({
    required int index,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _controllers[index],
      builder: (context, _) => FadeTransition(
        opacity: _fadeAnimations[index],
        child: SlideTransition(
          position: _slideAnimations[index],
          child: child,
        ),
      ),
    );
  }

  Widget _buildAttributesColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attributes',
          style: TossTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: 2),
        if (widget.product.brandName != null)
          Text(
            '· ${widget.product.brandName}',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray900,
              height: 1.2,
            ),
          ),
        const SizedBox(height: 2),
        Text(
          '· ${widget.product.categoryName ?? 'Uncategorized'}',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray900,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCostColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cost',
          style: TossTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${widget.currencySymbol}${CurrencyFormatter.formatPrice(widget.product.costPrice)}',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray900,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price',
          style: TossTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${widget.currencySymbol}${CurrencyFormatter.formatPrice(widget.product.salePrice)}',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.primary,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
