import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mobile_scanner/mobile_scanner.dart'; // Temporarily disabled
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
  // MobileScannerController cameraController = MobileScannerController();
  bool isProcessing = false;

  @override
  void dispose() {
    // cameraController.dispose();
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

      // Get current location
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      _showErrorDialog('Error getting location: $e');
      return null;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space6),
            Text(
              'QR Scanner Temporarily Unavailable',
              style: TossTextStyles.h2,
            ),
            const SizedBox(height: TossSpacing.space4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space8),
              child: Text(
                'The QR scanner is temporarily disabled due to library conflicts with Firebase. It will be re-enabled soon.',
                style: TossTextStyles.body,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: TossSpacing.space8),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: TossColors.white,
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}