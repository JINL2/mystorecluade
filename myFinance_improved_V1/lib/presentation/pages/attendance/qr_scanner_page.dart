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
              if (isProcessing) return;
              
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;
              
              final String? code = barcodes.first.rawValue;
              if (code == null) return;
              
              setState(() {
                isProcessing = true;
              });
              
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
                });
                return;
              }
              final userId = user.id;
              
              try {
                // Parse QR code data (expecting format: "STORE_ID|TIMESTAMP")
                final parts = code.split('|');
                if (parts.length != 2) {
                  throw Exception('Invalid QR code format');
                }
                
                final storeId = parts[0];
                final timestamp = parts[1];
                
                // Submit attendance
                final attendanceService = ref.read(attendanceServiceProvider);
                final requestDate = DateTime.parse(timestamp);
                await attendanceService.updateShiftRequest(
                  userId: userId,
                  storeId: storeId,
                  requestDate: '${requestDate.year}-${requestDate.month.toString().padLeft(2, '0')}-${requestDate.day.toString().padLeft(2, '0')}',
                  timestamp: timestamp,
                  lat: position.latitude,
                  lng: position.longitude,
                );
                
                // Show success and navigate back
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Check-in successful!'),
                      backgroundColor: TossColors.success,
                    ),
                  );
                  Navigator.pop(context, true);
                }
              } catch (e) {
                _showErrorDialog('Failed to process QR code: ${e.toString()}');
              } finally {
                setState(() {
                  isProcessing = false;
                });
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