import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';

class ProformaInvoicePage extends ConsumerWidget {
  final dynamic feature;

  const ProformaInvoicePage({super.key, this.feature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TossScaffold(
      appBar: AppBar(
        title: const Text('Proforma Invoice'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Proforma Invoice',
              style: TossTextStyles.h2,
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Create and manage proforma invoices for buyers',
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
