import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/core/utils/storage_url_helper.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../domain/entities/transaction.dart';

/// Fullscreen image viewer with swipe navigation
class AttachmentFullscreenViewer extends StatefulWidget {
  final List<TransactionAttachment> attachments;
  final int initialIndex;

  const AttachmentFullscreenViewer({
    super.key,
    required this.attachments,
    this.initialIndex = 0,
  });

  @override
  State<AttachmentFullscreenViewer> createState() =>
      _AttachmentFullscreenViewerState();
}

class _AttachmentFullscreenViewerState
    extends State<AttachmentFullscreenViewer> {
  late PageController _pageController;
  late int _currentIndex;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Set to fullscreen immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      // Reset zoom when changing pages
      _transformationController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageAttachments =
        widget.attachments.where((a) => a.isImage).toList();

    return Scaffold(
      backgroundColor: TossColors.black,
      body: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: imageAttachments.length,
            itemBuilder: (context, index) {
              final attachment = imageAttachments[index];
              return _buildZoomableImage(attachment);
            },
          ),

          // Top bar with close button and counter
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      TossColors.black.withValues(alpha: 0.6),
                      TossColors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close button
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: TossColors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),

                    // Page indicator
                    if (imageAttachments.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space1,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Text(
                          '${_currentIndex + 1} / ${imageAttachments.length}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // Placeholder for balance
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // Bottom bar with file name
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      TossColors.black.withValues(alpha: 0.6),
                      TossColors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // File name
                    Text(
                      imageAttachments[_currentIndex].fileName,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.white.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Page dots indicator
                    if (imageAttachments.length > 1) ...[
                      const SizedBox(height: TossSpacing.space3),
                      _buildPageIndicator(imageAttachments.length),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomableImage(TransactionAttachment attachment) {
    // Convert to authenticated URL and get auth headers
    final authenticatedUrl = StorageUrlHelper.toAuthenticatedUrl(attachment.fileUrl);
    final authHeaders = StorageUrlHelper.getAuthHeaders();

    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 1.0,
        maxScale: 4.0,
        child: Center(
          child: authenticatedUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: authenticatedUrl,
                  httpHeaders: authHeaders,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: TossLoadingView.inline(color: TossColors.white),
                  ),
                  errorWidget: (context, url, error) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.broken_image,
                        color: TossColors.gray400,
                        size: 64,
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      Text(
                        'Failed to load image',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                    ],
                  ),
                )
              : const Icon(
                  Icons.image_not_supported,
                  color: TossColors.gray400,
                  size: 64,
                ),
        ),
      ),
    );
  }

  void _handleDoubleTap() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();

    if (currentScale > 1.0) {
      // Zoom out to 1x
      _transformationController.value = Matrix4.identity();
    } else {
      // Zoom in to 2x
      _transformationController.value = Matrix4.identity()..scale(2.0);
    }
  }

  Widget _buildPageIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: TossAnimations.normal,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: index == _currentIndex ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == _currentIndex ? TossColors.white : TossColors.white.withValues(alpha: 0.38),
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
      ),
    );
  }
}
