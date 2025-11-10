import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/providers/auth_providers.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../domain/entities/attendance_location.dart';
import '../../domain/validators/store_id_validator.dart';
import '../providers/attendance_providers.dart';

class QRScannerPage extends ConsumerStatefulWidget {
  const QRScannerPage({super.key});

  @override
  ConsumerState<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends ConsumerState<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    returnImage: false,
  );
  bool isProcessing = false;
  bool hasScanned = false; // Add flag to prevent multiple scans
  bool isShowingDialog = false; // Add flag to prevent multiple dialogs

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
        await _showErrorDialog('Location services are disabled. Please enable location services.');
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          await _showErrorDialog('Location permissions are denied. Please allow location access.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await _showErrorDialog('Location permissions are permanently denied. Please enable in settings.');
        return null;
      }

      // Get current location
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      await _showErrorDialog('Error getting location: $e');
      return null;
    }
  }

  Future<void> _showErrorDialog(String message) async {
    // Prevent showing multiple dialogs at once
    if (isShowingDialog) return;

    setState(() {
      isShowingDialog = true;
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossDialog.error(
        title: 'Error',
        message: message,
        primaryButtonText: 'OK',
        onPrimaryPressed: () {
          context.pop(); // Close dialog
          context.pop(); // Return to attendance page
        },
        dismissible: false,
      ),
    );

    // After dialog is closed, user should be back at attendance page
    // No need to reset flags or restart camera
  }
  
  void _showSuccessDialog(String message, Map<String, dynamic> resultData) {
    // Show TossDialog.success with auto-dismiss
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossDialog.success(
        title: message,
        subtitle: DateTimeUtils.format(DateTime.now()),
        primaryButtonText: 'OK',
        onPrimaryPressed: () {
          context.pop(); // Close dialog
          Navigator.of(context).pop(resultData); // Return to previous screen with result data
        },
        dismissible: false,
      ),
    );

    // Auto close after 2 seconds and return to previous screen with result data
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pop(); // Close dialog
        Navigator.of(context).pop(resultData); // Return to previous screen with result data
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.black,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              // Prevent multiple scans
              if (isProcessing || hasScanned) return;
              
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;
              
              final String? code = barcodes.first.rawValue;
              if (code == null || code.isEmpty) return;
              
              setState(() {
                isProcessing = true;
                hasScanned = true; // Mark as scanned
              });
              
              // Stop the camera to prevent further scans
              await cameraController.stop();
              
              // Haptic feedback
              HapticFeedback.mediumImpact();
              
              // Get current location
              final Position? position = await _getCurrentLocation();
              if (position == null) {
                // Error dialog already shown in _getCurrentLocation
                // User will be returned to attendance page
                return;
              }

              // Process attendance
              final authStateAsync = ref.read(authStateProvider);
              final user = authStateAsync.value;
              if (user == null) {
                await _showErrorDialog('User not authenticated');
                // User will be returned to attendance page
                return;
              }
              final userId = user.id;
              
              try {
                // QR code contains only the store_id (e.g., "d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff")
                final storeId = code.trim();

                // Validate store ID format using domain validator
                final validationError = StoreIdValidator.validateWithMessage(storeId);
                if (validationError != null) {
                  throw Exception(validationError);
                }
                
                // Get current date and time
                final now = DateTime.now();
                final requestDate = DateTimeUtils.toDateOnly(now);
                // Convert to UTC for database storage
                final currentTime = DateTimeUtils.toUtc(now);
                
                // Submit attendance using check in use case
                final checkInShift = ref.read(checkInShiftProvider);

                final result = await checkInShift(
                  userId: userId,
                  storeId: storeId,
                  requestDate: requestDate,
                  timestamp: currentTime,
                  location: AttendanceLocation(
                    latitude: position.latitude,
                    longitude: position.longitude,
                  ),
                );

                // Check if the RPC call was successful (strongly typed)
                if (result == null) {
                  throw Exception('Failed to update shift request. Please try again.');
                }

                // Add a small delay for UX
                await Future<void>.delayed(const Duration(milliseconds: 100));

                // Show success popup
                if (mounted) {
                  // Determine if it was check-in or check-out based on result
                  final checkoutTime = result.actualEndTime;
                  final checkinTime = result.actualStartTime;

                  String message = 'Check-in Successful';
                  if (checkoutTime != null) {
                    message = 'Check-out Successful';
                  }

                  // Prepare data to pass back to attendance page
                  final checkInOutData = <String, dynamic>{
                    'shift_card_data': result,
                    'message': message,
                    'request_date': requestDate,
                    'timestamp': currentTime,
                    'action': message.contains('out') ? 'check_out' : 'check_in',
                  };

                  // Show the success dialog with result data
                  _showSuccessDialog(message, checkInOutData);
                }
              } catch (e) {
                // Show error and return to attendance page
                await _showErrorDialog('Failed to process QR code: ${e.toString()}');
                // No need to reset state or restart camera - user will be back at attendance page
              }
            },
          ),
          
          // Scanner overlay
          Container(
            decoration: BoxDecoration(
              color: TossColors.black.withOpacity(0.5),
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
                          color: TossColors.white.withOpacity(0.8),
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
            clipper: _ScannerOverlayClipper(),
            child: Container(
              color: TossColors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for scanner overlay with cutout
class _ScannerOverlayClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..fillType = PathFillType.evenOdd;
    
    // Add outer rectangle
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Calculate center cutout position
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    const cutoutSize = 280.0;
    const borderRadius = 16.0;
    
    // Add rounded rectangle cutout
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: cutoutSize,
          height: cutoutSize,
        ),
        const Radius.circular(borderRadius),
      ),
    );
    
    return path;
  }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}