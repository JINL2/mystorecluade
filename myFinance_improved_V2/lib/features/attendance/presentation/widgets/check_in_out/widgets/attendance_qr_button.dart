import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../pages/qr_scanner_page.dart';

/// QR scanner button widget for check-in/check-out
///
/// Displays a prominent button that navigates to QR scanner page
/// Handles the result callback for successful scans
class AttendanceQRButton extends StatelessWidget {
  final Function(Map<String, dynamic>)? onScanResult;

  const AttendanceQRButton({
    super.key,
    this.onScanResult,
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

            // Navigate to QR scanner page
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QRScannerPage(),
              ),
            );

            // If successfully checked in/out, notify parent
            if (result != null && result is Map<String, dynamic>) {
              onScanResult?.call(result);
            }
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  color: TossColors.white,
                  size: 24,
                ),
                const SizedBox(width: TossSpacing.space3),
                Text(
                  'Scan QR Code',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.white,
                    fontWeight: FontWeight.w600,
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
