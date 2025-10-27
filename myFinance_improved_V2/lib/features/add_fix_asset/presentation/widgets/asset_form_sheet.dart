import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_date_picker.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_enhanced_text_field.dart';
import '../../domain/entities/fixed_asset.dart';
import '../../domain/value_objects/asset_financial_info.dart';

enum AssetFormMode { create, edit }

class AssetFormSheet extends StatefulWidget {
  final AssetFormMode mode;
  final FixedAsset? existingAsset;
  final String companyId;
  final String? storeId;
  final String currencySymbol;
  final void Function(FixedAsset) onSave;

  const AssetFormSheet({
    super.key,
    required this.mode,
    this.existingAsset,
    required this.companyId,
    this.storeId,
    required this.currencySymbol,
    required this.onSave,
  });

  @override
  State<AssetFormSheet> createState() => _AssetFormSheetState();
}

class _AssetFormSheetState extends State<AssetFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _costController;
  late final TextEditingController _salvageController;
  late final TextEditingController _usefulLifeController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.mode == AssetFormMode.edit && widget.existingAsset != null) {
      final asset = widget.existingAsset!;
      _nameController = TextEditingController(text: asset.assetName);
      _costController = TextEditingController(
        text: asset.financialInfo.acquisitionCost.toStringAsFixed(0),
      );
      _salvageController = TextEditingController(
        text: asset.financialInfo.salvageValue.toStringAsFixed(0),
      );
      _usefulLifeController = TextEditingController(
        text: asset.financialInfo.usefulLifeYears.toString(),
      );
      _selectedDate = asset.acquisitionDate;
    } else {
      _nameController = TextEditingController();
      _costController = TextEditingController();
      _salvageController = TextEditingController();
      _usefulLifeController = TextEditingController();
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _salvageController.dispose();
    _usefulLifeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.mode == AssetFormMode.edit;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.9; // 90% of screen height

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  TossSpacing.space5,
                  TossSpacing.space5,
                  TossSpacing.space5,
                  TossSpacing.space3,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: TossColors.gray200,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                      ),
                    ),

                    // Title section
                    Row(
                      children: [
                        Container(
                          width: isEdit ? 44 : 48,
                          height: isEdit ? 44 : 48,
                          decoration: BoxDecoration(
                            gradient: isEdit
                                ? null
                                : LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      TossColors.primary.withValues(alpha: 0.8),
                                      TossColors.primary,
                                    ],
                                  ),
                            color: isEdit ? TossColors.primary.withValues(alpha: 0.1) : null,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          child: Icon(
                            isEdit ? Icons.edit_outlined : Icons.add_business,
                            size: isEdit ? 24 : 26,
                            color: isEdit ? TossColors.primary : TossColors.white,
                          ),
                        ),
                        SizedBox(width: isEdit ? TossSpacing.space3 : TossSpacing.space4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit ? 'Edit Asset' : 'Add New Asset',
                                style: TossTextStyles.h3.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: isEdit ? 2 : 4),
                              Text(
                                isEdit ? 'Update asset information' : 'Track your business assets',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 24,
                            color: TossColors.gray600,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Asset Name Field
                    _buildTextField(
                      label: 'Asset Name',
                      icon: Icons.inventory_2_outlined,
                      controller: _nameController,
                      hint: 'e.g., MacBook Pro, Office Desk',
                      required: true,
                      enabled: true,
                    ),

                    const SizedBox(height: 24),

                    // Acquisition Date Field
                    _buildDateField(),

                    const SizedBox(height: 24),

                    // Financial Information Section
                    _buildFinancialSection(isEdit),

                    const SizedBox(height: 20),

                    // Depreciation Preview
                    _buildDepreciationPreview(),
                  ],
                ),
              ),
            ),

            // Fixed bottom buttons
            Container(
              padding: EdgeInsets.fromLTRB(
                TossSpacing.space5,
                TossSpacing.space3,
                TossSpacing.space5,
                TossSpacing.space5 + MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: TossColors.background,
                border: Border(
                  top: BorderSide(
                    color: TossColors.gray100,
                    width: 1,
                  ),
                ),
              ),
              child: _buildActionButtons(isEdit),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    bool required = false,
    bool enabled = true,
    String? prefix,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: TossColors.gray600),
            const SizedBox(width: 6),
            Text(
              label,
              style: TossTextStyles.bodySmall.copyWith(
                color: enabled ? TossColors.gray700 : TossColors.gray400,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        AbsorbPointer(
          absorbing: !enabled,
          child: Opacity(
            opacity: enabled ? 1.0 : 0.6,
            child: TossEnhancedTextField(
              controller: controller,
              hintText: prefix != null ? '$prefix$hint' : hint,
              keyboardType: suffix == 'years' || prefix != null
                  ? TextInputType.number
                  : TextInputType.text,
              onChanged: (_) => setState(() {}),
              enabled: enabled,
              showKeyboardToolbar: true,
            ),
          ),
        ),
        if (suffix != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              suffix,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDateField() {
    final isEdit = widget.mode == AssetFormMode.edit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.event_outlined, size: 18, color: TossColors.gray600),
            const SizedBox(width: 6),
            Text(
              'Purchase Date',
              style: TossTextStyles.bodySmall.copyWith(
                color: isEdit ? TossColors.gray400 : TossColors.gray700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (!isEdit)
              Text(
                ' *',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        AbsorbPointer(
          absorbing: isEdit,
          child: Opacity(
            opacity: isEdit ? 0.6 : 1.0,
            child: TossDatePicker(
              date: _selectedDate,
              placeholder: 'Select purchase date',
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialSection(bool isEdit) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: TossColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  size: 16,
                  color: TossColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Financial Information',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray800,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Purchase Cost
          _buildTextField(
            label: 'Purchase Cost',
            icon: Icons.attach_money,
            controller: _costController,
            hint: '0',
            enabled: !isEdit, // Disabled in edit mode
            prefix: '${widget.currencySymbol} ',
          ),

          const SizedBox(height: TossSpacing.space4),

          // Salvage Value and Useful Life Row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Salvage Value',
                  icon: Icons.savings_outlined,
                  controller: _salvageController,
                  hint: '0',
                  prefix: '${widget.currencySymbol} ',
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildTextField(
                  label: 'Useful Life',
                  icon: Icons.schedule,
                  controller: _usefulLifeController,
                  hint: '0',
                  suffix: 'years',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepreciationPreview() {
    final annualDepreciation = _calculateDepreciation();
    final currentValue = _calculateCurrentValue();

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.primary.withValues(alpha: 0.05),
            TossColors.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  Icons.trending_down,
                  size: 18,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Depreciation Preview',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              children: [
                _buildPreviewRow(
                  'Annual Depreciation',
                  '${widget.currencySymbol}$annualDepreciation',
                  Icons.calendar_today_outlined,
                ),
                const SizedBox(height: 10),
                Container(height: 1, color: TossColors.gray100),
                const SizedBox(height: 10),
                _buildPreviewRow(
                  'Current Book Value',
                  '${widget.currencySymbol}$currentValue',
                  Icons.account_balance_wallet_outlined,
                  valueColor: TossColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: TossColors.gray600),
            const SizedBox(width: 6),
            Text(
              label,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray700,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: valueColor ?? TossColors.gray900,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isEdit) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              side: const BorderSide(color: TossColors.gray300, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
            ),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  TossColors.primary.withValues(alpha: 0.9),
                  TossColors.primary,
                ],
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: TossColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.transparent,
                shadowColor: TossColors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isEdit ? Icons.check_circle_outline : Icons.add_circle_outline,
                    color: TossColors.white,
                    size: 20,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    isEdit ? 'Save Changes' : 'Add Asset',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _calculateDepreciation() {
    try {
      final cost = double.tryParse(_costController.text) ?? 0;
      final salvage = double.tryParse(_salvageController.text) ?? 0;
      final years = int.tryParse(_usefulLifeController.text) ?? 0;

      if (years <= 0) return '0';
      return ((cost - salvage) / years).toStringAsFixed(0);
    } catch (e) {
      return '0';
    }
  }

  String _calculateCurrentValue() {
    try {
      final cost = double.tryParse(_costController.text) ?? 0;
      final salvage = double.tryParse(_salvageController.text) ?? 0;
      final years = int.tryParse(_usefulLifeController.text) ?? 0;

      if (years <= 0) return cost.toStringAsFixed(0);

      final annualDepreciation = (cost - salvage) / years;
      final yearsOwned = DateTime.now().difference(_selectedDate).inDays / 365;
      final totalDepreciation = annualDepreciation * yearsOwned;
      final currentValue = cost - totalDepreciation;

      return (currentValue > salvage ? currentValue : salvage).toStringAsFixed(0);
    } catch (e) {
      return '0';
    }
  }

  void _handleSave() {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter asset name');
      return;
    }

    final cost = double.tryParse(_costController.text);
    if (cost == null || cost <= 0) {
      _showError('Please enter valid acquisition cost');
      return;
    }

    final salvage = double.tryParse(_salvageController.text) ?? 0;
    final years = int.tryParse(_usefulLifeController.text);
    if (years == null || years <= 0) {
      _showError('Please enter valid useful life');
      return;
    }

    if (salvage >= cost) {
      _showError('Salvage value must be less than acquisition cost');
      return;
    }

    // Create entity
    final financialInfo = AssetFinancialInfo(
      acquisitionCost: cost,
      salvageValue: salvage,
      usefulLifeYears: years,
    );

    final asset = FixedAsset(
      assetId: widget.existingAsset?.assetId,
      assetName: _nameController.text.trim(),
      acquisitionDate: _selectedDate,
      financialInfo: financialInfo,
      companyId: widget.companyId,
      storeId: widget.storeId,
      createdAt: widget.existingAsset?.createdAt ?? DateTime.now(),
    );

    widget.onSave(asset);
  }

  void _showError(String message) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.error(
        title: 'Validation Error',
        message: message,
        primaryButtonText: 'OK',
      ),
    );
  }
}
