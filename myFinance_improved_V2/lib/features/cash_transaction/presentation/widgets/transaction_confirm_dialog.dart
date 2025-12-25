import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';

/// Transaction type for confirmation dialog
enum ConfirmTransactionType {
  expense,
  debt,
  transferWithinStore,
  transferWithinCompany,
  transferBetweenCompanies,
}

/// Data class for transaction confirmation
class TransactionConfirmData {
  final ConfirmTransactionType type;
  final double amount;

  // Common
  final String fromCashLocationName;

  // Expense specific
  final String? expenseAccountName;
  final String? expenseAccountCode;

  // Debt specific
  final String? debtTypeName; // e.g., "Lend Money", "Collect Debt"
  final String? counterpartyName;

  // Transfer specific
  final String? fromStoreName;
  final String? toStoreName;
  final String? toCompanyName;
  final String? toCashLocationName;

  const TransactionConfirmData({
    required this.type,
    required this.amount,
    required this.fromCashLocationName,
    this.expenseAccountName,
    this.expenseAccountCode,
    this.debtTypeName,
    this.counterpartyName,
    this.fromStoreName,
    this.toStoreName,
    this.toCompanyName,
    this.toCashLocationName,
  });
}

/// Result from confirmation dialog
class TransactionConfirmResult {
  final bool confirmed;
  final String? memo;
  final List<XFile> attachments;

  const TransactionConfirmResult({
    required this.confirmed,
    this.memo,
    this.attachments = const [],
  });
}

/// Transaction Confirmation Dialog
/// Shows transaction story and allows memo/photo attachment
class TransactionConfirmDialog extends StatefulWidget {
  final TransactionConfirmData data;

  const TransactionConfirmDialog({
    super.key,
    required this.data,
  });

  /// Show the dialog and return result
  static Future<TransactionConfirmResult?> show(
    BuildContext context,
    TransactionConfirmData data,
  ) {
    return showModalBottomSheet<TransactionConfirmResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionConfirmDialog(data: data),
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

  @override
  void dispose() {
    _memoController.dispose();
    _memoFocusNode.dispose();
    super.dispose();
  }

  String get _formattedAmount {
    final formatter = NumberFormat('#,###');
    return '₩${formatter.format(widget.data.amount.toInt())}';
  }

  /// Check if this is a complex transfer (needs vertical layout)
  bool get _isComplexTransfer {
    return widget.data.type == ConfirmTransactionType.transferWithinCompany ||
        widget.data.type == ConfirmTransactionType.transferBetweenCompanies;
  }

  /// Get detailed cash flow info for complex transfers
  /// Returns structured data for FROM and TO sides
  ({
    // FROM side
    String? fromCompany,
    String? fromStore,
    String fromLocation,
    // TO side
    String? toCompany,
    String? toStore,
    String? toLocation,
    // Meta
    String reason,
    bool isCashOut,
  }) get _detailedCashFlowInfo {
    final data = widget.data;

    switch (data.type) {
      case ConfirmTransactionType.expense:
        return (
          fromCompany: null,
          fromStore: null,
          fromLocation: data.fromCashLocationName,
          toCompany: null,
          toStore: null,
          toLocation: null,
          reason: data.expenseAccountName ?? 'Expense',
          isCashOut: true,
        );

      case ConfirmTransactionType.debt:
        final debtType = data.debtTypeName ?? '';
        final isCashOut = debtType.contains('Lend') || debtType.contains('Repay');

        if (isCashOut) {
          return (
            fromCompany: null,
            fromStore: null,
            fromLocation: data.fromCashLocationName,
            toCompany: null,
            toStore: null,
            toLocation: data.counterpartyName,
            reason: debtType,
            isCashOut: true,
          );
        } else {
          return (
            fromCompany: null,
            fromStore: null,
            fromLocation: data.counterpartyName ?? '—',
            toCompany: null,
            toStore: null,
            toLocation: data.fromCashLocationName,
            reason: debtType,
            isCashOut: false,
          );
        }

      case ConfirmTransactionType.transferWithinStore:
        return (
          fromCompany: null,
          fromStore: null,
          fromLocation: data.fromCashLocationName,
          toCompany: null,
          toStore: null,
          toLocation: data.toCashLocationName,
          reason: 'Transfer',
          isCashOut: true,
        );

      case ConfirmTransactionType.transferWithinCompany:
        return (
          fromCompany: null,
          fromStore: data.fromStoreName,
          fromLocation: data.fromCashLocationName,
          toCompany: null,
          toStore: data.toStoreName,
          toLocation: data.toCashLocationName,
          reason: 'Inter-store Transfer',
          isCashOut: true,
        );

      case ConfirmTransactionType.transferBetweenCompanies:
        return (
          fromCompany: null, // Current company (implied)
          fromStore: data.fromStoreName,
          fromLocation: data.fromCashLocationName,
          toCompany: data.toCompanyName,
          toStore: data.toStoreName,
          toLocation: data.toCashLocationName,
          reason: 'Inter-company Transfer',
          isCashOut: true,
        );
    }
  }

  /// Simple cash flow info for basic transactions
  ({String? decreaseFrom, String? increaseTo, String reason, bool isCashOut}) get _cashFlowInfo {
    final detailed = _detailedCashFlowInfo;
    return (
      decreaseFrom: detailed.fromLocation,
      increaseTo: detailed.toLocation,
      reason: detailed.reason,
      isCashOut: detailed.isCashOut,
    );
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
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
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
                    _buildStoryCard(),

                    const SizedBox(height: TossSpacing.space4),

                    // Memo & Photo Section
                    _buildMemoSection(),

                    const SizedBox(height: TossSpacing.space3),

                    // Attachments
                    if (_attachments.isNotEmpty) ...[
                      _buildAttachmentsSection(),
                      const SizedBox(height: TossSpacing.space3),
                    ],

                    // Photo buttons
                    _buildPhotoButtons(),

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

  Widget _buildStoryCard() {
    final cashFlow = _cashFlowInfo;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          // Amount - Big and Bold at top
          // Amount and type - compact
          Column(
            children: [
              Text(
                _formattedAmount,
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cashFlow.reason,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Cash Flow Visual Diagram
          _buildCashFlowDiagram(cashFlow),
        ],
      ),
    );
  }

  /// Build visual cash flow diagram
  /// Uses vertical layout for complex transfers, horizontal for simple ones
  Widget _buildCashFlowDiagram(
    ({String? decreaseFrom, String? increaseTo, String reason, bool isCashOut}) cashFlow,
  ) {
    // Use vertical layout for complex transfers (within company / between companies)
    if (_isComplexTransfer) {
      return _buildVerticalCashFlowDiagram();
    }

    // Simple horizontal layout for basic transfers
    return _buildHorizontalCashFlowDiagram(cashFlow);
  }

  /// Horizontal layout for simple transactions (expense, debt, within-store transfer)
  Widget _buildHorizontalCashFlowDiagram(
    ({String? decreaseFrom, String? increaseTo, String reason, bool isCashOut}) cashFlow,
  ) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          // Flow row: FROM → TO
          Row(
            children: [
              // FROM box (cash decreases here)
              Expanded(
                child: _buildLocationBox(
                  label: 'From',
                  name: cashFlow.decreaseFrom ?? '—',
                  isCashOut: true,
                  icon: Icons.remove_circle_outline,
                ),
              ),

              // Arrow in the middle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space1),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: TossColors.gray200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: TossColors.gray600,
                    size: 20,
                  ),
                ),
              ),

              // TO box (cash increases here)
              Expanded(
                child: cashFlow.increaseTo != null
                    ? _buildLocationBox(
                        label: 'To',
                        name: cashFlow.increaseTo!,
                        isCashOut: false,
                        icon: Icons.add_circle_outline,
                      )
                    : _buildExpenseEndBox(cashFlow.reason),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space2),

          // Simple explanation text
          Text(
            _getSimpleExplanation(cashFlow),
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Vertical layout for complex transfers (company-to-company, store-to-store)
  Widget _buildVerticalCashFlowDiagram() {
    final detailed = _detailedCashFlowInfo;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          // FROM section (cash goes OUT)
          _buildDetailedLocationCard(
            isCashOut: true,
            company: detailed.fromCompany,
            store: detailed.fromStore,
            location: detailed.fromLocation,
          ),

          // Arrow with amount in the middle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Row(
              children: [
                Expanded(child: Container(height: 1, color: TossColors.gray300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.gray200,
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_downward_rounded,
                          color: TossColors.gray600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formattedAmount,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Container(height: 1, color: TossColors.gray300)),
              ],
            ),
          ),

          // TO section (cash comes IN)
          _buildDetailedLocationCard(
            isCashOut: false,
            company: detailed.toCompany,
            store: detailed.toStore,
            location: detailed.toLocation,
          ),
        ],
      ),
    );
  }

  /// Build detailed location card for complex transfers
  /// Shows: Company (if different) → Store → Cash Location
  Widget _buildDetailedLocationCard({
    required bool isCashOut,
    String? company,
    String? store,
    String? location,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple header
          Text(
            isCashOut ? 'FROM' : 'TO',
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: TossSpacing.space1),

          // Location details
          if (company != null) ...[
            _buildLocationRow(
              icon: Icons.business,
              label: '회사',
              value: company,
            ),
          ],
          if (store != null) ...[
            _buildLocationRow(
              icon: Icons.store,
              label: '가게',
              value: store,
            ),
          ],
          if (location != null)
            _buildLocationRow(
              icon: Icons.account_balance_wallet,
              label: '위치',
              value: location,
              isBold: true,
            ),
        ],
      ),
    );
  }

  /// Build a single row showing location info
  Widget _buildLocationRow({
    required IconData icon,
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: TossColors.gray500),
        const SizedBox(width: TossSpacing.space1),
        Text(
          '$label:',
          style: TossTextStyles.small.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(width: TossSpacing.space1),
        Expanded(
          child: Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Build a location box showing cash increase/decrease
  Widget _buildLocationBox({
    required String label,
    required String name,
    required bool isCashOut,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          // Simple label
          Text(
            isCashOut ? 'FROM' : 'TO',
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          // Location name
          Text(
            name,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Build expense end box (no destination, money is spent)
  Widget _buildExpenseEndBox(String reason) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray300, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 24,
            color: TossColors.gray500,
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Spent',
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            reason,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Get simple explanation text that a 15-year-old can understand
  String _getSimpleExplanation(
    ({String? decreaseFrom, String? increaseTo, String reason, bool isCashOut}) cashFlow,
  ) {
    final data = widget.data;

    switch (data.type) {
      case ConfirmTransactionType.expense:
        return '${data.fromCashLocationName}에서 $_formattedAmount 나감';

      case ConfirmTransactionType.debt:
        if (cashFlow.isCashOut) {
          return '${data.fromCashLocationName} → ${cashFlow.increaseTo}';
        } else {
          return '${cashFlow.decreaseFrom} → ${data.fromCashLocationName}';
        }

      case ConfirmTransactionType.transferWithinStore:
        return '${data.fromCashLocationName} → ${data.toCashLocationName} (같은 가게)';

      case ConfirmTransactionType.transferWithinCompany:
        return '${data.fromStoreName} → ${data.toStoreName} (같은 회사)';

      case ConfirmTransactionType.transferBetweenCompanies:
        return '${data.fromStoreName} → ${data.toCompanyName} (다른 회사)';
    }
  }

  Widget _buildMemoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Memo (Optional)',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: TextField(
            controller: _memoController,
            focusNode: _memoFocusNode,
            maxLines: 2,
            minLines: 1,
            style: TossTextStyles.body.copyWith(color: TossColors.gray900),
            decoration: InputDecoration(
              hintText: 'Add a note for this transaction...',
              hintStyle: TossTextStyles.body.copyWith(color: TossColors.gray400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(TossSpacing.space3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attachments',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_attachments.length}/3',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _attachments.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: TossSpacing.space2),
            itemBuilder: (context, index) =>
                _buildThumbnail(_attachments[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(XFile file, int index) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.md - 1),
            child: Image.file(
              File(file.path),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: TossColors.gray100,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: TossColors.gray400,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () => _removeAttachment(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: TossColors.gray600,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: TossColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoButtons() {
    final canAddMore = _attachments.length < 3;

    return Row(
      children: [
        Expanded(
          child: _buildPhotoButton(
            icon: Icons.photo_library_outlined,
            label: 'Gallery',
            onTap: canAddMore && !_isPickingImage ? _pickImage : null,
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: _buildPhotoButton(
            icon: Icons.camera_alt_outlined,
            label: 'Camera',
            onTap: canAddMore && !_isPickingImage ? _takePhoto : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isEnabled ? TossColors.gray50 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isEnabled ? TossColors.gray200 : TossColors.gray200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isEnabled ? TossColors.gray600 : TossColors.gray400,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: isEnabled ? TossColors.gray700 : TossColors.gray400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
