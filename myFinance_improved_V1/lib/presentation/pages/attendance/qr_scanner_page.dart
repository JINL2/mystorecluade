import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/attendance_provider.dart';

class QRScannerPage extends ConsumerStatefulWidget {
  const QRScannerPage({super.key});

  @override
  ConsumerState<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends ConsumerState<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isProcessing = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog('Location services are disabled. Please enable location services.');
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog('Location permissions are denied. Please allow location access.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog('Location permissions are permanently denied. Please enable in settings.');
        return null;
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      _showErrorDialog('Failed to get current location. Please try again.');
      return null;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: TossColors.error,
              size: 24,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Error',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String action) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: TossColors.success,
              size: 24,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Success',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          'Successfully $action!',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return to attendance page with success
            },
            child: Text(
              'OK',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processQRCode(String storeId) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    try {
      // Stop scanning
      cameraController.stop();

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const CircularProgressIndicator(),
          ),
        ),
      );

      // Get location
      final position = await _getCurrentLocation();
      Navigator.pop(context); // Close loading

      if (position == null) {
        setState(() {
          isProcessing = false;
        });
        cameraController.start();
        return;
      }

      // Get user ID from auth state
      final authState = ref.read(authStateProvider);
      final userId = authState?.id;

      if (userId == null) {
        _showErrorDialog('User not logged in. Please login and try again.');
        setState(() {
          isProcessing = false;
        });
        cameraController.start();
        return;
      }

      // Get current time for display
      final now = DateTime.now();
      final displayTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      // Show confirmation dialog with current time
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              'Confirm Check-in/out',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Current Time',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      displayTime,
                      style: TossTextStyles.h1.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Do you want to proceed with this time?',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Confirm',
                style: TossTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      // If user cancelled, restart scanning
      if (confirmed != true) {
        setState(() {
          isProcessing = false;
        });
        cameraController.start();
        return;
      }

      // Show loading again for API call
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const CircularProgressIndicator(),
          ),
        ),
      );

      // Get fresh timestamp for the actual API call
      final apiNow = DateTime.now();
      final requestDate = '${apiNow.year}-${apiNow.month.toString().padLeft(2, '0')}-${apiNow.day.toString().padLeft(2, '0')}';
      final timestamp = '${apiNow.year}-${apiNow.month.toString().padLeft(2, '0')}-${apiNow.day.toString().padLeft(2, '0')} ${apiNow.hour.toString().padLeft(2, '0')}:${apiNow.minute.toString().padLeft(2, '0')}:${apiNow.second.toString().padLeft(2, '0')}';

      // Call the RPC function
      final service = ref.read(attendanceServiceProvider);
      final result = await service.updateShiftRequest(
        userId: userId,
        storeId: storeId,
        requestDate: requestDate,
        timestamp: timestamp,
        lat: position.latitude,
        lng: position.longitude,
      );

      Navigator.pop(context); // Close loading

      if (result != null) {
        // Determine if it was check-in or check-out based on the response
        // You might need to adjust this based on the actual response structure
        final action = result['action'] ?? 'checked in';
        _showSuccessDialog(action);
      } else {
        _showErrorDialog('Failed to process check-in/out. Please try again.');
        setState(() {
          isProcessing = false;
        });
        cameraController.start();
      }
    } catch (e) {
      print('Error processing QR code: $e');
      _showErrorDialog('An error occurred. Please try again.');
      setState(() {
        isProcessing = false;
      });
      cameraController.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Scan QR Code',
          style: TossTextStyles.h3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null && !isProcessing) {
                  print('QR Code detected: $code');
                  HapticFeedback.mediumImpact();
                  _processQRCode(code);
                  break;
                }
              }
            },
          ),
          
          // Overlay with scan area
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space5,
                vertical: TossSpacing.space3,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Point camera at the store QR code',
                      style: TossTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'QR code will be scanned automatically',
                    style: TossTextStyles.caption.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}