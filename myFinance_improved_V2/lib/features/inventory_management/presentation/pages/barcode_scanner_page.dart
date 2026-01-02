// Presentation Page: Barcode Scanner
// Full-screen barcode scanner with camera access

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Barcode Scanner Page - Full screen scanner with camera
class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  MobileScannerController? _controller;
  bool _hasPermission = false;
  bool _isInitialized = false;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    // Listen for permission changes
    _controller!.start().then((_) {
      if (mounted) {
        setState(() {
          _hasPermission = true;
          _isInitialized = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _hasPermission = false;
          _isInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      _hasScanned = true;
      HapticFeedback.mediumImpact();

      // Return the scanned barcode
      Navigator.pop(context, barcodes.first.rawValue);
    }
  }

  void _openSettings() {
    // Open app settings for camera permission
    _controller?.stop();
    // Use platform channel or app_settings package
  }

  void _enterManually() {
    Navigator.pop(context, 'MANUAL_ENTRY');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      body: Column(
        children: [
          // App Bar (always white background)
          _buildAppBar(darkMode: false),
          // Scanner View
          Expanded(
            child: _buildScannerView(),
          ),
          // Bottom instruction (always show)
          _buildBottomInstruction(),
        ],
      ),
    );
  }

  Widget _buildAppBar({bool darkMode = false}) {
    final textColor = darkMode ? TossColors.white : TossColors.gray900;
    final subtleColor = darkMode ? TossColors.gray300 : TossColors.gray600;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: textColor,
              ),
            ),
            // Title
            Text(
              'Scan barcode',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            // Enter Manually button
            TossButton.textButton(
              text: 'Enter Manually',
              textColor: subtleColor,
              onPressed: _enterManually,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    if (!_isInitialized) {
      return Container(
        color: TossColors.black,
        child: Center(
          child: TossLoadingView.inline(color: TossColors.white),
        ),
      );
    }

    if (!_hasPermission) {
      return _buildPermissionDeniedView();
    }

    final controller = _controller;
    if (controller == null) {
      return _buildPermissionDeniedView();
    }

    return Container(
      color: TossColors.black,
      child: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: controller,
            onDetect: _onBarcodeDetected,
          ),
          // Overlay with scanner frame
          _buildScannerOverlay(),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Container(
      color: TossColors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Scanner frame corners (decorative)
            _buildScannerFrame(),
            const SizedBox(height: 32),
            // Permission message
            Text(
              'Camera access is required to scan barcodes.',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: _buildScannerFrame(),
    );
  }

  Widget _buildScannerFrame() {
    const frameSize = 280.0;
    const cornerLength = 40.0;
    const cornerWidth = 4.0;
    const cornerColor = TossColors.white;

    return SizedBox(
      width: frameSize,
      height: frameSize,
      child: Stack(
        children: [
          // Top-left corner
          Positioned(
            top: 0,
            left: 0,
            child: _buildCorner(
              cornerLength,
              cornerWidth,
              cornerColor,
              topLeft: true,
            ),
          ),
          // Top-right corner
          Positioned(
            top: 0,
            right: 0,
            child: _buildCorner(
              cornerLength,
              cornerWidth,
              cornerColor,
              topRight: true,
            ),
          ),
          // Bottom-left corner
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildCorner(
              cornerLength,
              cornerWidth,
              cornerColor,
              bottomLeft: true,
            ),
          ),
          // Bottom-right corner
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildCorner(
              cornerLength,
              cornerWidth,
              cornerColor,
              bottomRight: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(
    double length,
    double width,
    Color color, {
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return SizedBox(
      width: length,
      height: length,
      child: CustomPaint(
        painter: _CornerPainter(
          width: width,
          color: color,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }

  Widget _buildBottomInstruction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: TossColors.white,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Barcode icon
            const Icon(
              Icons.view_week_outlined,
              size: 24,
              color: TossColors.gray600,
            ),
            const SizedBox(width: 12),
            // Instruction text
            Expanded(
              child: Text(
                'Place the barcode inside the frame for scanning',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for drawing corner brackets
class _CornerPainter extends CustomPainter {
  final double width;
  final Color color;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  _CornerPainter({
    required this.width,
    required this.color,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (topLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (topRight) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (bottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else if (bottomRight) {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
