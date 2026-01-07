import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../domain/entities/cash_transaction_enums.dart';
import '../../domain/entities/transaction_confirm_types.dart';
import 'transaction_confirm/transaction_confirm_widgets.dart';

// Re-export for backward compatibility (prevents DCM false positive)
export '../../domain/entities/transaction_confirm_types.dart';

/// Transaction Confirmation Dialog
/// Shows transaction story and allows memo/photo attachment
class TransactionConfirmDialog extends StatefulWidget {
  final TransactionConfirmData data;
  final String currencySymbol;

  const TransactionConfirmDialog({
    super.key,
    required this.data,
    this.currencySymbol = '₩',
  });

  /// Show the dialog and return result
  static Future<TransactionConfirmResult?> show(
    BuildContext context,
    TransactionConfirmData data, {
    String currencySymbol = '₩',
  }) {
    return showModalBottomSheet<TransactionConfirmResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => TransactionConfirmDialog(
        data: data,
        currencySymbol: currencySymbol,
      ),
    );
  }

  @override
  State<TransactionConfirmDialog> createState() =>
      _TransactionConfirmDialogState();
}

class _TransactionConfirmDialogState extends State<TransactionConfirmDialog> {
  final _memoController = TextEditingController();
  final _memoFocusNode = FocusNode();
  List<XFile> _attachments = [];
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImage = false;
  DebtCategory _selectedDebtCategory = DebtCategory.account;

  @override
  void dispose() {
    _memoController.dispose();
    _memoFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage || _attachments.length >= 3) return;

    setState(() => _isPickingImage = true);

    try {
      final images = await _picker.pickMultiImage(
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
        limit: 3 - _attachments.length,
      );

      if (images.isNotEmpty) {
        setState(() {
          _attachments = [..._attachments, ...images].take(3).toList();
        });
      }
    } catch (_) {
      // Silent fail
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<void> _takePhoto() async {
    if (_isPickingImage || _attachments.length >= 3) return;

    setState(() => _isPickingImage = true);

    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          _attachments = [..._attachments, image];
        });
      }
    } catch (_) {
      // Silent fail
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments = [..._attachments]..removeAt(index);
    });
  }

  void _onConfirm() {
    Navigator.pop(
      context,
      TransactionConfirmResult(
        confirmed: true,
        memo: _memoController.text.trim().isEmpty
            ? null
            : _memoController.text.trim(),
        attachments: _attachments,
        debtCategory: widget.data.type == ConfirmTransactionType.debt
            ? _selectedDebtCategory
            : null,
      ),
    );
  }

  void _onCancel() {
    Navigator.pop(
      context,
      const TransactionConfirmResult(confirmed: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: TossAnimations.normal,
      curve: TossAnimations.decelerate,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xxl),
            topRight: Radius.circular(TossBorderRadius.xxl),
          ),
          boxShadow: TossShadows.bottomSheet,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            const SizedBox(height: TossSpacing.space3),
            Container(
              width: TossSpacing.space9,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TossSpacing.space4,
                TossSpacing.space3,
                TossSpacing.space4,
                TossSpacing.space2,
              ),
              child: Text(
                'Confirm Transaction',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction Story Card
                    TransactionStoryCard(
                      data: widget.data,
                      currencySymbol: widget.currencySymbol,
                    ),

                    // Debt Category Selector (only for debt transactions)
                    if (widget.data.type == ConfirmTransactionType.debt) ...[
                      const SizedBox(height: TossSpacing.space3),
                      _buildDebtCategorySelector(),
                    ],

                    const SizedBox(height: TossSpacing.space4),

                    // Memo Section
                    MemoSection(
                      controller: _memoController,
                      focusNode: _memoFocusNode,
                    ),

                    const SizedBox(height: TossSpacing.space3),

                    // Attachments
                    if (_attachments.isNotEmpty) ...[
                      AttachmentsSection(
                        attachments: _attachments,
                        onRemove: _removeAttachment,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                    ],

                    // Photo buttons
                    PhotoButtons(
                      canAddMore: _attachments.length < 3,
                      isPickingImage: _isPickingImage,
                      onPickGallery: _pickImage,
                      onTakePhoto: _takePhoto,
                    ),

                    const SizedBox(height: TossSpacing.space4),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Container(
              padding: const EdgeInsets.fromLTRB(
                TossSpacing.space4,
                TossSpacing.space3,
                TossSpacing.space4,
                TossSpacing.space3,
              ),
              decoration: const BoxDecoration(
                color: TossColors.white,
                border: Border(
                  top: BorderSide(color: TossColors.gray100),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TossButton.secondary(
                      text: 'Cancel',
                      onPressed: _onCancel,
                      fullWidth: true,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    flex: 2,
                    child: TossButton.primary(
                      text: 'Confirm',
                      onPressed: _onConfirm,
                      fullWidth: true,
                      leadingIcon: const Icon(Icons.check),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height:
                  MediaQuery.of(context).padding.bottom + TossSpacing.space2,
            ),
          ],
        ),
      ),
    );
  }

  /// Build debt category selector widget
  Widget _buildDebtCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Debt Category',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            children: DebtCategory.values.map((category) {
              final isSelected = _selectedDebtCategory == category;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedDebtCategory = category);
                  },
                  child: AnimatedContainer(
                    duration: TossAnimations.normal,
                    padding: const EdgeInsets.symmetric(
                      vertical: TossSpacing.space2,
                      horizontal: TossSpacing.space2,
                    ),
                    margin: EdgeInsets.only(
                      right: category == DebtCategory.account
                          ? TossSpacing.space2
                          : 0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? TossColors.gray700
                          : TossColors.white,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      border: Border.all(
                        color: isSelected
                            ? TossColors.gray700
                            : TossColors.gray300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          category.label,
                          style: TossTextStyles.body.copyWith(
                            color: isSelected
                                ? TossColors.white
                                : TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: TossSpacing.space1 / 2),
                        Text(
                          category.labelKo,
                          style: TossTextStyles.small.copyWith(
                            color: isSelected
                                ? TossColors.gray300
                                : TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
