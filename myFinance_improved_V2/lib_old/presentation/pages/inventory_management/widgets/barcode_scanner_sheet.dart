import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class BarcodeScannerSheet extends StatefulWidget {
  const BarcodeScannerSheet({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerSheet> createState() => _BarcodeScannerSheetState();
}

class _BarcodeScannerSheetState extends State<BarcodeScannerSheet> {
  final _barcodeController = TextEditingController();
  bool _isScanning = false;

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _startScanning() async {
    setState(() => _isScanning = true);
    
    // TODO: Implement actual barcode scanning using mobile_scanner package
    // For now, simulate scanning
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isScanning = false);
      // Simulate a scanned barcode
      _barcodeController.text = '8801234567890';
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space2),
            width: TossSpacing.space10,
            height: TossSpacing.space1,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Scan Barcode',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: Icon(TossIcons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Scanner View
          Expanded(
            child: _isScanning
                ? _buildScanningView()
                : _buildManualEntryView(),
          ),
          
          // Action Buttons
          Padding(
            padding: EdgeInsets.only(
              left: TossSpacing.space4,
              right: TossSpacing.space4,
              bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
            ),
            child: Column(
              children: [
                if (!_isScanning) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _startScanning,
                      icon: Icon(Icons.qr_code_scanner),
                      label: Text('Start Scanning'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        foregroundColor: TossColors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: TossSpacing.space3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_barcodeController.text.isNotEmpty) {
                          Navigator.pop(context, _barcodeController.text);
                        }
                      },
                      child: Text('Use Entered Barcode'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: TossSpacing.space3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningView() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Camera preview placeholder
              Container(
                color: TossColors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Scanning animation
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: TossColors.primary,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            ),
                          ),
                          // Scanning line animation
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: -100, end: 100),
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, value),
                                child: Container(
                                  width: 200,
                                  height: 2,
                                  color: TossColors.primary,
                                ),
                              );
                            },
                            onEnd: () {
                              // Restart animation
                              if (_isScanning && mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Scanning...',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.white,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      Text(
                        'Position barcode within frame',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Cancel button
              Positioned(
                bottom: TossSpacing.space4,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _isScanning = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.error,
                      foregroundColor: TossColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space6,
                        vertical: TossSpacing.space3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
                      ),
                    ),
                    child: Text('Cancel Scanning'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildManualEntryView() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Instructions
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.primary.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: TossColors.primary,
                  size: 20,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'You can scan a barcode using your camera or enter it manually below',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Manual entry field
          TextFormField(
            controller: _barcodeController,
            decoration: InputDecoration(
              labelText: 'Barcode Number',
              hintText: 'Enter barcode manually',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              prefixIcon: Icon(Icons.edit),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(20),
            ],
            autofocus: true,
          ),
          
          const SizedBox(height: TossSpacing.space3),
          
          // Common barcode formats info
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Common Barcode Formats',
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                _buildBarcodeFormatRow('EAN-13', '13 digits', '8801234567890'),
                _buildBarcodeFormatRow('UPC-A', '12 digits', '012345678905'),
                _buildBarcodeFormatRow('Code 128', 'Variable', 'ABC-123-XYZ'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeFormatRow(String format, String length, String example) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              format,
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              length,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              example,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}