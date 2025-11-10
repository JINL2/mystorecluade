import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../pages/qr_scanner_page.dart';

class QRScanButton extends StatelessWidget {
  final Function(Map<String, dynamic>) onQRScanResult;

  const QRScanButton({
    super.key,
    required this.onQRScanResult,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Material(
        color: TossColors.primary,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        child: InkWell(
          onTap: () async {
            HapticFeedback.mediumImpact();

            // Check today's shifts
            // Allow QR scanning even if no shift today
            // RPC will handle previous day shift check-out (for overnight workers)

            // Navigate to QR scanner page
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QRScannerPage(),
              ),
            );

            // If successfully checked in/out, update local state
            if (result != null && result is Map<String, dynamic>) {
              onQRScanResult(result);
            }
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  color: TossColors.white,
                  size: 24,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Scan QR',
                  style: TossTextStyles.labelLarge.copyWith(
                    color: TossColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
