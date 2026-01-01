import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class ShipmentPage extends ConsumerWidget {
  final dynamic feature;

  const ShipmentPage({super.key, this.feature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TossScaffold(
      appBar: AppBar(
        title: const Text('Shipment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Shipment',
              style: TossTextStyles.h2,
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Register shipments and track delivery status',
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
