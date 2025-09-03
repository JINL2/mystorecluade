import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_loading_view.dart';

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
      barrierDismissible: false,
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
  
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: TossColors.black.withOpacity(0.7),
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: TossColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: TossColors.success,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              // Success Message
              Text(
                message,
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM dd, yyyy • HH:mm').format(DateTime.now()),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
    
    // Auto close after 2 seconds and return to previous screen
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        Navigator.of(context).pop(true); // Return to previous screen with success result
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
                setState(() {
                  isProcessing = false;
                });
                return;
              }
              
              // Process attendance
              final user = ref.read(authStateProvider);
              if (user == null) {
                _showErrorDialog('User not authenticated');
                setState(() {
                  isProcessing = false;
                  hasScanned = false;
                });
                // Restart camera on error
                await cameraController.start();
                return;
              }
              final userId = user.id;
              
              try {
                // QR code contains only the store_id (e.g., "d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff")
                final storeId = code.trim();
                
                // Validate store ID format (UUID)
                final uuidRegex = RegExp(
                  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
                );
                
                if (!uuidRegex.hasMatch(storeId)) {
                  throw Exception('Invalid store ID format');
                }
                
                // Get current date and time
                final now = DateTime.now();
                final requestDate = DateFormat('yyyy-MM-dd').format(now);
                // Use ISO 8601 format for the time parameter
                final currentTime = now.toIso8601String();
                
                // Submit attendance
                final attendanceService = ref.read(attendanceServiceProvider);
                
                final result = await attendanceService.updateShiftRequest(
                  userId: userId,
                  storeId: storeId,
                  requestDate: requestDate,
                  timestamp: currentTime,
                  lat: position.latitude,
                  lng: position.longitude,
                );
                
                // Check if the RPC call was successful
                if (result == null) {
                  throw Exception('Failed to update shift request. Please try again.');
                }
                
                // Force refresh the attendance provider to update the activity list
                await ref.read(shiftOverviewProvider.notifier).refresh();
                
                // Invalidate any cached data to ensure fresh fetch
                ref.invalidate(currentShiftProvider);
                
                // Add a small delay to ensure data is refreshed
                await Future.delayed(const Duration(milliseconds: 300));
                
                // Show success popup
                if (mounted) {
                  // Determine if it was check-in or check-out based on result
                  String message = 'Check-in Successful';
                  
                  // Check various possible response formats from the RPC
                  // The RPC might return different formats depending on the action
                  {
                    // Check for action field
                    final action = result['action']?.toString().toLowerCase() ?? '';
                    final type = result['type']?.toString().toLowerCase() ?? '';
                    final status = result['status']?.toString().toLowerCase() ?? '';
                    final checkinTime = result['actual_start_time'];
                    final checkoutTime = result['actual_end_time'];
                    
                    if (action.contains('out') || type.contains('out') || 
                        status.contains('out') || checkoutTime != null) {
                      message = 'Check-out Successful';
                    } else if (checkinTime != null && checkoutTime == null) {
                      message = 'Check-in Successful';
                    }
                  }
                  
                  // Show the success dialog
                  _showSuccessDialog(message);
                }
              } catch (e) {
                _showErrorDialog('Failed to process QR code: ${e.toString()}');
                
                // Reset state and restart camera on error
                setState(() {
                  isProcessing = false;
                  hasScanned = false;
                });
                await cameraController.start();
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
                      borderRadius: BorderRadius.circular(16),
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