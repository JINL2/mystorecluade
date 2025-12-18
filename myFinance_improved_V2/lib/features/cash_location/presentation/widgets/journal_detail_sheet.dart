import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/utils/storage_url_helper.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/ai/index.dart';

import '../../../transaction_history/domain/entities/transaction.dart'
    show TransactionAttachment;
import '../../../transaction_history/presentation/widgets/attachment_fullscreen_viewer.dart';
import '../../domain/entities/stock_flow.dart';
import '../formatters/cash_location_formatters.dart';

class JournalDetailSheet extends StatelessWidget {
  const JournalDetailSheet({
    super.key,
    required this.flow,
    required this.currencySymbol,
    required this.formatTransactionAmount,
    required this.formatBalance,
  });

  final JournalFlow flow;
  final String currencySymbol;
  final String Function(double amount, String currencySymbol)
      formatTransactionAmount;
  final String Function(double amount, String currencySymbol) formatBalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space6,
              TossSpacing.space5,
              TossSpacing.space5,
              TossSpacing.space4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Journal Entry Details',
                    style: TossTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Card (prominent at top)
                  _buildAmountCard(context),

                  const SizedBox(height: TossSpacing.space4),

                  // Description Box (compact)
                  _buildDescriptionBox(context),

                  const SizedBox(height: TossSpacing.space4),

                  // Metadata - Compact design with icons
                  _buildMetadataSection(context),

                  // Attachments
                  if (flow.attachments.isNotEmpty) ...[
                    const SizedBox(height: TossSpacing.space4),
                    _buildAttachments(context),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  /// Amount card displayed prominently at top
  Widget _buildAmountCard(BuildContext context) {
    final isPositive = flow.flowAmount > 0;
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: isPositive
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : TossColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        children: [
          // Transaction Amount (big)
          Text(
            formatTransactionAmount(flow.flowAmount, currencySymbol),
            style: TossTextStyles.h1.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 28,
              color: isPositive
                  ? Theme.of(context).colorScheme.primary
                  : TossColors.error,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Transaction Amount',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          // Balance row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBalanceItem(
                  'Before', formatBalance(flow.balanceBefore, currencySymbol)),
              Container(
                width: 1,
                height: 30,
                color: TossColors.gray300,
              ),
              _buildBalanceItem(
                  'After', formatBalance(flow.balanceAfter, currencySymbol)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Description box with user description and AI description
  Widget _buildDescriptionBox(BuildContext context) {
    final hasUserDesc = flow.journalDescription.isNotEmpty ||
        (flow.counterAccount?.description.isNotEmpty == true);
    final hasAiDesc = flow.journalAiDescription != null &&
        flow.journalAiDescription!.isNotEmpty;

    if (!hasUserDesc && !hasAiDesc) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User description
          if (hasUserDesc) ...[
            Row(
              children: [
                const Icon(Icons.notes, size: 14, color: TossColors.gray500),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Description',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              flow.journalDescription.isNotEmpty
                  ? flow.journalDescription
                  : flow.counterAccount!.description,
              style: TossTextStyles.body.copyWith(
                fontSize: 14,
              ),
            ),
          ],

          // AI description
          if (hasAiDesc) ...[
            if (hasUserDesc) ...[
              const SizedBox(height: TossSpacing.space3),
              Container(height: 1, color: TossColors.gray200),
              const SizedBox(height: TossSpacing.space3),
            ],
            AiDescriptionInline(text: flow.journalAiDescription!),
          ],
        ],
      ),
    );
  }

  /// Compact metadata section with icons
  Widget _buildMetadataSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          // Account row
          _buildMetadataItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Account',
            value: flow.accountName,
          ),
          if (flow.counterAccount != null) ...[
            const SizedBox(height: TossSpacing.space2),
            _buildMetadataItem(
              icon: Icons.swap_horiz,
              label: 'Counter',
              value: flow.counterAccount!.accountName,
            ),
          ],
          const SizedBox(height: TossSpacing.space2),
          // Date & Time row (horizontal)
          Row(
            children: [
              Expanded(
                child: _buildMetadataItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: DateFormat('MMM d, yyyy')
                      .format(DateTime.parse(flow.createdAt)),
                  compact: true,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildMetadataItem(
                  icon: Icons.access_time_outlined,
                  label: 'Time',
                  value: CashLocationFormatters.formatJournalFlowTime(flow),
                  compact: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          // Created by row with profile image
          _buildCreatedByItem(context),
        ],
      ),
    );
  }

  /// Created by item with profile image
  Widget _buildCreatedByItem(BuildContext context) {
    final profileUrl = flow.createdBy.profileImage;
    final hasProfileImage = profileUrl != null && profileUrl.isNotEmpty;

    return Row(
      children: [
        // Profile image or default icon
        if (hasProfileImage)
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: TossColors.gray200, width: 1),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: StorageUrlHelper.toAuthenticatedUrl(profileUrl),
                httpHeaders: StorageUrlHelper.getAuthHeaders(),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: TossColors.gray100,
                  child: const Icon(Icons.person, size: 14, color: TossColors.gray400),
                ),
                errorWidget: (context, url, error) => Container(
                  color: TossColors.gray100,
                  child: const Icon(Icons.person, size: 14, color: TossColors.gray400),
                ),
              ),
            ),
          )
        else
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TossColors.gray100,
              border: Border.all(color: TossColors.gray200, width: 1),
            ),
            child: const Icon(Icons.person, size: 14, color: TossColors.gray400),
          ),
        const SizedBox(width: TossSpacing.space2),
        SizedBox(
          width: 60,
          child: Text(
            'By',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            flow.createdBy.fullName,
            style: TossTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Single metadata item with icon
  Widget _buildMetadataItem({
    required IconData icon,
    required String label,
    required String value,
    bool compact = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: TossColors.gray400,
        ),
        const SizedBox(width: TossSpacing.space2),
        if (!compact) ...[
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontSize: 12,
              ),
            ),
          ),
        ],
        Expanded(
          child: Text(
            value,
            style: TossTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Build attachments section (without AI Analysis Details)
  Widget _buildAttachments(BuildContext context) {
    final attachments = flow.attachments;
    final imageAttachments = attachments.where((a) => a.isImage).toList();
    final otherAttachments = attachments.where((a) => !a.isImage).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Icon(
              Icons.attach_file,
              size: 16,
              color: TossColors.gray500,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'Attachments',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
              child: Text(
                '${attachments.length}',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),

        // Image Gallery
        if (imageAttachments.isNotEmpty)
          _buildImageGallery(context, imageAttachments),

        // Other files (PDF, etc.)
        if (otherAttachments.isNotEmpty) ...[
          if (imageAttachments.isNotEmpty)
            const SizedBox(height: TossSpacing.space3),
          ...otherAttachments.map((attachment) => _buildFileItem(attachment)),
        ],
      ],
    );
  }

  /// Build image gallery (first image big + rest small)
  Widget _buildImageGallery(
      BuildContext context, List<JournalAttachment> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    final firstImage = images.first;
    final remainingImages =
        images.length > 1 ? images.sublist(1) : <JournalAttachment>[];

    return Column(
      children: [
        // First image - large (contain to show full image)
        GestureDetector(
          onTap: () => _openFullscreenViewer(context, images, 0),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(TossBorderRadius.md - 1),
              child: _buildNetworkImage(firstImage.fileUrl ?? '',
                  fit: BoxFit.contain),
            ),
          ),
        ),

        // Remaining images - small thumbnails
        if (remainingImages.isNotEmpty) ...[
          const SizedBox(height: TossSpacing.space2),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: remainingImages.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: TossSpacing.space2),
              itemBuilder: (context, index) {
                final image = remainingImages[index];
                final actualIndex = index + 1;

                return GestureDetector(
                  onTap: () => _openFullscreenViewer(context, images, actualIndex),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      border: Border.all(color: TossColors.gray200),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(TossBorderRadius.sm - 1),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildNetworkImage(image.fileUrl ?? '',
                              fit: BoxFit.cover),
                          // Show count overlay on last thumbnail if more than 4 images
                          if (index == 2 && remainingImages.length > 3)
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Text(
                                  '+${remainingImages.length - 3}',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  /// Open fullscreen image viewer
  void _openFullscreenViewer(
      BuildContext context, List<JournalAttachment> images, int initialIndex) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AttachmentFullscreenViewer(
          attachments: images.map((a) => _toTransactionAttachment(a)).toList(),
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  /// Build network image with loading and error states
  Widget _buildNetworkImage(String url, {BoxFit fit = BoxFit.cover}) {
    if (url.isEmpty) {
      return Container(
        color: TossColors.gray100,
        child: const Center(
          child: Icon(Icons.image_not_supported, color: TossColors.gray400),
        ),
      );
    }

    final authenticatedUrl = StorageUrlHelper.toAuthenticatedUrl(url);
    final authHeaders = StorageUrlHelper.getAuthHeaders();

    return CachedNetworkImage(
      imageUrl: authenticatedUrl,
      httpHeaders: authHeaders,
      fit: fit,
      placeholder: (context, url) => Container(
        color: TossColors.gray100,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: TossColors.gray400,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: TossColors.gray100,
        child: const Center(
          child: Icon(Icons.broken_image, color: TossColors.gray400),
        ),
      ),
    );
  }

  /// Convert JournalAttachment to TransactionAttachment for the fullscreen viewer
  TransactionAttachment _toTransactionAttachment(JournalAttachment attachment) {
    return TransactionAttachment(
      attachmentId: attachment.attachmentId,
      fileName: attachment.fileName,
      fileType: attachment.fileType,
      fileUrl: attachment.fileUrl,
      ocrText: attachment.ocrText,
      ocrStatus: attachment.ocrStatus,
    );
  }

  Widget _buildFileItem(JournalAttachment attachment) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          Icon(
            attachment.isPdf ? Icons.picture_as_pdf : Icons.insert_drive_file,
            size: 20,
            color: attachment.isPdf ? Colors.red : TossColors.gray500,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              attachment.fileName,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
