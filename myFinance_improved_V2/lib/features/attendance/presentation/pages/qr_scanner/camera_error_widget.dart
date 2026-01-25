import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Camera error widget that displays error message and retry button
/// Extracted from qr_scanner_page.dart for better modularity
class CameraErrorWidget extends StatelessWidget {
  final MobileScannerException error;
  final VoidCallback onRetry;

  const CameraErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  String _getCameraErrorMessage(MobileScannerException error) {
    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        return 'Camera is not ready.\nPlease try again.';
      case MobileScannerErrorCode.permissionDenied:
        return 'Camera permission denied.\nPlease allow camera access in Settings.';
      case MobileScannerErrorCode.unsupported:
        return 'Camera is not supported on this device.';
      default:
        return 'Failed to initialize camera.\nPlease restart the app.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Camera Error',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.white,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              _getCameraErrorMessage(error),
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray300,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            TossButton.primary(
              text: 'Retry',
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
