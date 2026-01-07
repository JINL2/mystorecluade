import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/icon_mapper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// QR Code Section Widget
///
/// Displays a button to view store QR code.
class QRCodeSection extends StatelessWidget {
  final Map<String, dynamic> store;

  const QRCodeSection({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showStoreQRCode(context);
      },
      child: TossWhiteCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            Container(
              width: TossSpacing.iconXL,
              height: TossSpacing.iconXL,
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                IconMapper.getIcon('qrCode'),
                color: TossColors.primary,
                size: TossSpacing.iconMD,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                'View My Store QR Code',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
            ),
            Icon(
              IconMapper.getIcon('chevronRight'),
              color: TossColors.gray400,
              size: TossSpacing.iconSM,
            ),
          ],
        ),
      ),
    );
  }

  /// Show Store QR Code Dialog
  void _showStoreQRCode(BuildContext context) {
    final storeId = store['store_id'] as String? ?? '';
    final storeName = store['store_name'] as String? ?? 'Store';
    final qrKey = GlobalKey();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        title: Text(
          storeName,
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: TossFontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: qrKey,
              child: Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: QrImageView(
                    data: storeId,
                    version: QrVersions.auto,
                    backgroundColor: TossColors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                ),
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Scan this QR code to access store',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TossButton.textButton(
            onPressed: () => Navigator.pop(dialogContext),
            text: 'Close',
            textColor: TossColors.gray600,
          ),
          TossButton.textButton(
            onPressed: () =>
                _saveQRCodeToGallery(dialogContext, qrKey, storeName),
            text: 'Save Photo',
            textColor: TossColors.primary,
          ),
        ],
      ),
    );
  }

  /// Save QR Code to device gallery
  Future<void> _saveQRCodeToGallery(
    BuildContext context,
    GlobalKey qrKey,
    String storeName,
  ) async {
    try {
      final boundary =
          qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('QR code not found');
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to convert image');
      }

      final pngBytes = byteData.buffer.asUint8List();
      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 100,
        name: '${storeName}_QR_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (context.mounted) {
        final resultMap = Map<String, dynamic>.from(result as Map);
        final success = resultMap['isSuccess'] == true;
        if (success) {
          TossToast.success(context, 'QR code saved to gallery');
        } else {
          TossToast.error(context, 'Failed to save QR code');
        }
      }
    } catch (e) {
      if (context.mounted) {
        TossToast.error(context, 'Failed to save: $e');
      }
    }
  }
}
