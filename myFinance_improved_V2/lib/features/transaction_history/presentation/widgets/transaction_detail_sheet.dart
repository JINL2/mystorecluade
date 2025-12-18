import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/utils/number_formatter.dart';
import 'package:myfinance_improved/core/utils/storage_url_helper.dart';
import 'package:myfinance_improved/core/utils/text_utils.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/ai/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_card.dart';

import '../../domain/entities/transaction.dart';
import 'attachment_fullscreen_viewer.dart';

class TransactionDetailSheet extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailSheet({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final debitLines = transaction.lines.where((l) => l.isDebit).toList();
    final creditLines = transaction.lines.where((l) => !l.isDebit).toList();

    return TossBottomSheet(
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            
            const SizedBox(height: TossSpacing.space4),
            
            // Transaction Info Card
            _buildTransactionInfoCard(),
            
            const SizedBox(height: TossSpacing.space4),
            
            // Debit Section
            if (debitLines.isNotEmpty) ...[
              _buildSectionHeader('Debit', TossColors.primary, debitLines),
              const SizedBox(height: TossSpacing.space3),
              ...debitLines.map((line) => _buildLineDetail(line, true)),
              const SizedBox(height: TossSpacing.space4),
            ],
            
            // Credit Section
            if (creditLines.isNotEmpty) ...[
              _buildSectionHeader('Credit', TossColors.textPrimary, creditLines),
              const SizedBox(height: TossSpacing.space3),
              ...creditLines.map((line) => _buildLineDetail(line, false)),
              const SizedBox(height: TossSpacing.space4),
            ],
            
            // Balance Check
            _buildBalanceCheck(),
            
            const SizedBox(height: TossSpacing.space4),
            
            // Metadata
            _buildMetadata(),
            
            // Attachments
            if (transaction.attachments.isNotEmpty) ...[
              const SizedBox(height: TossSpacing.space4),
              _buildAttachments(context),
            ],
            
            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM d, yyyy • HH:mm').format(transaction.createdAt),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Row(
                children: [
                  Text(
                    'JRN-${transaction.journalNumber.substring(0, 8).toUpperCase()}',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  _buildStatusBadge(
                    transaction.journalType.toUpperCase(),
                    TossColors.gray600,
                  ),
                  if (transaction.isDraft) ...[
                    const SizedBox(width: TossSpacing.space1),
                    _buildStatusBadge('DRAFT', TossColors.warning),
                  ],
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.copy,
            size: 20,
            color: TossColors.gray500,
          ),
          tooltip: 'Copy journal number',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: 'JRN-${transaction.journalNumber.substring(0, 8).toUpperCase()}'));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Journal number copied'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            color: TossColors.gray700,
          ),
          tooltip: 'Close',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTransactionInfoCard() {
    final hasUserDesc = transaction.description.isNotEmpty;
    final hasAiDesc = transaction.aiDescription != null && transaction.aiDescription!.isNotEmpty;

    return TossCard(
      backgroundColor: TossColors.gray50,
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Amount - Primary info at top
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total Amount',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${transaction.currencySymbol}${_formatCurrency(transaction.totalAmount)}',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.textPrimary,
                ),
              ),
            ],
          ),
          // Descriptions section (compact)
          if (hasUserDesc || hasAiDesc) ...[
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Description
                  if (hasUserDesc) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.edit_note, size: 14, color: TossColors.gray400),
                        const SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            transaction.description,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (hasAiDesc) const SizedBox(height: TossSpacing.space2),
                  ],
                  // AI Description (summary)
                  if (hasAiDesc)
                    AiDescriptionInline(text: transaction.aiDescription!),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color, List<TransactionLine> lines) {
    final total = lines.fold(0.0, (sum, line) => sum + (line.isDebit ? line.debit : line.credit));
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              title,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
              child: Text(
                '${lines.length} items',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        Text(
          '${transaction.currencySymbol}${_formatCurrency(total)}',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildLineDetail(TransactionLine line, bool isDebit) {
    final amount = isDebit ? line.debit : line.credit;
    final color = isDebit ? TossColors.primary : TossColors.textPrimary;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account and Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.accountName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getAccountTypeLabel(line.accountType),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isDebit ? '+' : '-'}${_formatCurrency(amount)}',
                style: TossTextStyles.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          // Cash Location
          if (line.cashLocation != null) ...[
            const SizedBox(height: TossSpacing.space2),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
              child: Row(
                children: [
                  Icon(
                    _getCashLocationIcon(line.cashLocation!['type'] as String? ?? ''),
                    size: 14,
                    color: TossColors.primary,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    'Cash Location: ',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontSize: 11,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      line.displayLocation,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Counterparty
          if (line.counterparty != null) ...[
            const SizedBox(height: TossSpacing.space2),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 14,
                  color: TossColors.gray400,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  '${line.counterparty!['type'] as String? ?? ''}: ',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                    fontSize: 11,
                  ),
                ),
                Text(
                  line.displayCounterparty,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
          
          // Line Description
          if (line.description != null && line.description!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space2),
            Text(
              line.description!.withoutTrailingDate,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }

  Widget _buildBalanceCheck() {
    final totalDebit = transaction.totalDebit;
    final totalCredit = transaction.totalCredit;
    final isBalanced = (totalDebit - totalCredit).abs() < 0.01;
    
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: TossColors.gray200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isBalanced ? Icons.check_circle : Icons.error,
                size: 16,
                color: TossColors.gray600,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                isBalanced ? 'Balanced' : 'Unbalanced',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            'D: ${_formatCurrency(totalDebit)} | C: ${_formatCurrency(totalCredit)}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontSize: 11,
              fontFamily: 'JetBrains Mono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadata() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metadata',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        _buildMetadataRow('Created by', transaction.createdByName),
        if (transaction.storeName != null && transaction.storeName!.isNotEmpty)
          _buildMetadataRow('Store', transaction.storeName!, color: TossColors.gray700),
        _buildMetadataRow('Currency', '${transaction.currencyCode} (${transaction.currencySymbol})'),
        _buildMetadataRow('Type', transaction.journalType),
        if (transaction.isDraft)
          _buildMetadataRow('Status', 'Draft', color: TossColors.gray700),
      ],
    );
  }

  Widget _buildMetadataRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            value,
            style: TossTextStyles.caption.copyWith(
              color: color ?? TossColors.gray700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments(BuildContext context) {
    final attachments = transaction.attachments;
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

        // Image Gallery (Option 3: First image big + rest small)
        if (imageAttachments.isNotEmpty)
          _buildImageGallery(context, imageAttachments),

        // Other files (PDF, etc.)
        if (otherAttachments.isNotEmpty) ...[
          if (imageAttachments.isNotEmpty)
            const SizedBox(height: TossSpacing.space3),
          ...otherAttachments.map((attachment) => _buildFileItem(attachment)),
        ],

        // Per-image AI Analysis Details
        if (attachments.any((a) => a.hasOcr)) ...[
          const SizedBox(height: TossSpacing.space4),
          AiAnalysisDetailsBox(
            items: attachments
                .where((a) => a.hasOcr)
                .map((a) => a.ocrText!)
                .toList(),
          ),
        ],
      ],
    );
  }

  /// Build image gallery with first image large, rest small
  Widget _buildImageGallery(
    BuildContext context,
    List<TransactionAttachment> images,
  ) {
    if (images.isEmpty) return const SizedBox.shrink();

    final firstImage = images.first;
    final remainingImages = images.length > 1 ? images.sublist(1) : <TransactionAttachment>[];

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
              child: _buildNetworkImage(firstImage.fileUrl ?? '', fit: BoxFit.contain),
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
              separatorBuilder: (_, __) => const SizedBox(width: TossSpacing.space2),
              itemBuilder: (context, index) {
                final image = remainingImages[index];
                final actualIndex = index + 1; // +1 because first image is separate

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
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm - 1),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildNetworkImage(image.fileUrl ?? '', fit: BoxFit.cover),
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

  /// Build network image with loading and error states
  /// Automatically handles authenticated URLs for private Supabase storage
  Widget _buildNetworkImage(String url, {BoxFit fit = BoxFit.cover}) {
    if (url.isEmpty) {
      return Container(
        color: TossColors.gray100,
        child: const Center(
          child: Icon(Icons.image_not_supported, color: TossColors.gray400),
        ),
      );
    }

    // Convert to authenticated URL and get auth headers
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

  /// Build file item for non-image attachments
  Widget _buildFileItem(TransactionAttachment attachment) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: attachment.isPdf
                  ? TossColors.error.withValues(alpha: 0.1)
                  : TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
            child: Icon(
              attachment.isPdf ? Icons.picture_as_pdf : Icons.insert_drive_file,
              size: 20,
              color: attachment.isPdf ? TossColors.error : TossColors.gray500,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.fileName,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  attachment.fileExtension.toUpperCase(),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray400,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.open_in_new,
            size: 16,
            color: TossColors.gray400,
          ),
        ],
      ),
    );
  }

  /// Open fullscreen image viewer
  void _openFullscreenViewer(
    BuildContext context,
    List<TransactionAttachment> images,
    int initialIndex,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => AttachmentFullscreenViewer(
          attachments: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  IconData _getCashLocationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'bank':
        return Icons.account_balance;
      case 'register':
        return Icons.point_of_sale;
      case 'vault':
        return Icons.lock;
      case 'wallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.place;
    }
  }

  String _getAccountTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'asset':
        return 'Asset';
      case 'liability':
        return 'Liability';
      case 'equity':
        return 'Equity';
      case 'income':
        return 'Income';
      case 'expense':
        return 'Expense';
      default:
        return type;
    }
  }

  String _formatCurrency(double amount) {
    return NumberFormatter.formatCurrencyDecimal(amount.abs(), '', decimalPlaces: 2);
  }
}