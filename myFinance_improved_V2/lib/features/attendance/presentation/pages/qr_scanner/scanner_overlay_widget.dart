import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import 'scanner_overlay_clipper.dart';

/// Scanner overlay widget that shows scanning instructions and processing state
/// Extracted from qr_scanner_page.dart for better modularity
class ScannerOverlayWidget extends StatelessWidget {
  final bool isProcessing;

  const ScannerOverlayWidget({
    super.key,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scanner frame overlay
        Container(
          decoration: BoxDecoration(
            color: TossColors.black.withValues(alpha: TossOpacity.scrim),
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: TossColors.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  ),
                ),
              ),

              // Instructions
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    if (isProcessing)
                      const TossLoadingView()
                    else
                      Text(
                        'Scan QR Code',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      isProcessing
                          ? 'Processing...'
                          : 'Position the QR code within the frame',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.white
                            .withValues(alpha: TossOpacity.modalBackdrop),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Mask with cutout
        ClipPath(
          clipper: const ScannerOverlayClipper(),
          child: Container(
            color: TossColors.black.withValues(alpha: TossOpacity.scrim),
          ),
        ),
      ],
    );
  }
}
