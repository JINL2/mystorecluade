import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class CommercialInvoicePage extends ConsumerWidget {
  final dynamic feature;

  const CommercialInvoicePage({super.key, this.feature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: TossAppBar(
        title: 'Commercial Invoice',
        backgroundColor: TossColors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: TossSpacing.icon4XL,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Commercial Invoice',
              style: TossTextStyles.h2,
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Create commercial invoices for bank submission',
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
