import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../domain/entities/currency.dart';
import '../../../domain/entities/denomination.dart';
import '../../providers/denomination_providers.dart';

/// Currency header widget displaying currency info and denomination summary
class CurrencyHeader extends ConsumerWidget {
  final Currency currency;
  final bool isExpanded;

  const CurrencyHeader({
    super.key,
    required this.currency,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final denominationsAsync = ref.watch(effectiveDenominationListProvider(currency.id));

    return denominationsAsync.when(
      data: (denominations) => _buildHeaderContent(denominations),
      loading: () => _buildHeaderContent([]),
      error: (_, __) => _buildHeaderContent([]),
    );
  }

  Widget _buildHeaderContent(List<Denomination> denominations) {
    final rangeText = _calculateRangeText(denominations);

    return Row(
      children: [
        // Currency flag and info
        _buildFlagContainer(),
        const SizedBox(width: TossSpacing.space4),
        Expanded(
          child: _buildCurrencyInfo(denominations, rangeText),
        ),
        // Expand/collapse icon
        _buildExpandIcon(),
      ],
    );
  }

  Widget _buildFlagContainer() {
    return Container(
      width: TossSpacing.iconXXL,
      height: TossSpacing.iconXXL,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Center(
        child: Text(
          currency.flagEmoji,
          style: TossTextStyles.h3,
        ),
      ),
    );
  }

  Widget _buildCurrencyInfo(List<Denomination> denominations, String rangeText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              currency.code,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              '- ${currency.name}',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          currency.fullName,
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            _buildDenominationCountBadge(denominations.length),
            const SizedBox(width: TossSpacing.space3),
            Text(
              rangeText,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDenominationCountBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        '$count denominations',
        style: TossTextStyles.caption.copyWith(
          color: TossColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildExpandIcon() {
    return AnimatedRotation(
      turns: isExpanded ? 0.5 : 0,
      duration: TossAnimations.slow,
      child: const Icon(
        Icons.keyboard_arrow_down,
        color: TossColors.gray400,
      ),
    );
  }

  String _calculateRangeText(List<Denomination> denominations) {
    if (denominations.isEmpty) return '';

    final values = denominations.map((d) => d.value).toList()..sort();
    final minValue = values.first;
    final maxValue = values.last;

    if (currency.code == 'USD' || currency.code == 'CAD' || currency.code == 'AUD') {
      if (minValue < 1.0) {
        return '${(minValue * 100).toInt()}¢ - ${currency.symbol}${maxValue.toInt()}';
      } else {
        return '${currency.symbol}${minValue.toInt()} - ${currency.symbol}${maxValue.toInt()}';
      }
    } else if (currency.code == 'EUR' || currency.code == 'GBP') {
      if (minValue < 1.0) {
        return '${(minValue * 100).toInt()}¢ - ${currency.symbol}${maxValue.toInt()}';
      } else {
        return '${currency.symbol}${minValue.toInt()} - ${currency.symbol}${maxValue.toInt()}';
      }
    } else {
      // For currencies like KRW, JPY that don't have smaller denominations
      return '${currency.symbol}${minValue.toInt()} - ${currency.symbol}${maxValue.toInt()}';
    }
  }
}
