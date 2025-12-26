import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Document list item widget
class TradeDocumentListItem extends StatelessWidget {
  final String name;
  final String type;
  final String? size;
  final DateTime? uploadedAt;
  final String? uploadedBy;
  final String status;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;

  const TradeDocumentListItem({
    super.key,
    required this.name,
    required this.type,
    this.size,
    this.uploadedAt,
    this.uploadedBy,
    this.status = 'uploaded',
    this.onTap,
    this.onDownload,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getDocumentColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Icon(
                _getDocumentIcon(),
                color: _getDocumentColor(),
                size: 22,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TossTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      _buildTypeChip(),
                      if (size != null) ...[
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          size!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                      if (uploadedAt != null) ...[
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          _formatDate(uploadedAt!),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            _buildStatusIndicator(),
            const SizedBox(width: TossSpacing.space2),
            if (onDownload != null)
              IconButton(
                onPressed: onDownload,
                icon: Icon(
                  Icons.download_outlined,
                  color: TossColors.gray500,
                  size: 20,
                ),
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                padding: EdgeInsets.zero,
              ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: TossColors.gray400,
                  size: 20,
                ),
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                padding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.toUpperCase(),
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray600,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'verified':
        color = TossColors.success;
        icon = Icons.verified_outlined;
        break;
      case 'pending':
        color = TossColors.warning;
        icon = Icons.hourglass_empty_outlined;
        break;
      case 'rejected':
        color = TossColors.error;
        icon = Icons.cancel_outlined;
        break;
      case 'uploading':
        color = TossColors.info;
        icon = Icons.cloud_upload_outlined;
        break;
      default:
        color = TossColors.gray400;
        icon = Icons.cloud_done_outlined;
    }

    return Icon(
      icon,
      color: color,
      size: 20,
    );
  }

  Color _getDocumentColor() {
    switch (type.toLowerCase()) {
      case 'pdf':
        return TossColors.error;
      case 'doc':
      case 'docx':
        return TossColors.primary;
      case 'xls':
      case 'xlsx':
        return TossColors.success;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return TossColors.info;
      default:
        return TossColors.gray500;
    }
  }

  IconData _getDocumentIcon() {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

/// Document upload button
class TradeDocumentUploadButton extends StatelessWidget {
  final String label;
  final String? hint;
  final bool isRequired;
  final VoidCallback? onTap;

  const TradeDocumentUploadButton({
    super.key,
    required this.label,
    this.hint,
    this.isRequired = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: TossColors.gray200,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_upload_outlined,
                color: TossColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                if (isRequired) ...[
                  const SizedBox(width: 4),
                  Text(
                    '*',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            if (hint != null) ...[
              const SizedBox(height: TossSpacing.space1),
              Text(
                hint!,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Document checklist widget
class TradeDocumentChecklist extends StatelessWidget {
  final String title;
  final List<DocumentChecklistItem> items;
  final VoidCallback? onUpload;

  const TradeDocumentChecklist({
    super.key,
    required this.title,
    required this.items,
    this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = items.where((i) => i.isCompleted).length;
    final progress = items.isEmpty ? 0.0 : completedCount / items.length;

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TossTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '$completedCount/${items.length}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: TossColors.gray200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? TossColors.success : TossColors.primary,
                    ),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map((item) => _buildChecklistItem(item)),
          if (onUpload != null)
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onUpload,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Upload Document'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TossColors.primary,
                    side: BorderSide(color: TossColors.primary),
                    padding: const EdgeInsets.symmetric(
                      vertical: TossSpacing.space3,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(DocumentChecklistItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: item.isCompleted
                  ? TossColors.success
                  : TossColors.gray200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.isCompleted ? Icons.check : Icons.remove,
              color: item.isCompleted ? TossColors.white : TossColors.gray400,
              size: 16,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.name,
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: item.isCompleted
                            ? TossColors.gray500
                            : TossColors.gray900,
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (item.isRequired) ...[
                      const SizedBox(width: 4),
                      Text(
                        '*',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.error,
                        ),
                      ),
                    ],
                  ],
                ),
                if (item.description != null)
                  Text(
                    item.description!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray400,
                    ),
                  ),
              ],
            ),
          ),
          if (item.isCompleted && item.fileName != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: TossColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
              child: Text(
                item.fileName!,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Document checklist item data class
class DocumentChecklistItem {
  final String name;
  final String? description;
  final bool isRequired;
  final bool isCompleted;
  final String? fileName;

  const DocumentChecklistItem({
    required this.name,
    this.description,
    this.isRequired = false,
    this.isCompleted = false,
    this.fileName,
  });
}
