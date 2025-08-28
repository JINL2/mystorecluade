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
                final currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                
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
                
                // Show success and navigate back
                if (mounted) {
                  // Determine if it was check-in or check-out based on result
                  final message = result['action'] == 'check_out' 
                    ? 'Check-out successful!' 
                    : 'Check-in successful!';
                    
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: TossColors.success,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  
                  // Wait a moment for user to see the message
                  await Future.delayed(const Duration(milliseconds: 500));
                  
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
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
              color: Colors.black.withOpacity(0.5),
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
                        const CircularProgressIndicator(
                          color: TossColors.white,
                        )
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
              color: Colors.black.withOpacity(0.5),
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