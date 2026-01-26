import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/fixed_asset.dart';
import '../../domain/value_objects/asset_financial_info.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

enum AssetFormMode { create, edit }

/// 고정자산 유형 (하드코딩된 account_id)
enum FixedAssetType {
  interior('90d4fb63-50be-433b-8b8a-134948e61869', 'Interior', '1520'),
  officeEquipment('087402c7-d710-4515-aaa4-e3d4296399d4', 'Office Equipment', '1530');

  final String accountId;
  final String label;
  final String accountCode;

  const FixedAssetType(this.accountId, this.label, this.accountCode);
}

class AssetFormSheet extends StatefulWidget {
  final AssetFormMode mode;
  final FixedAsset? existingAsset;
  final String companyId;
  final String? storeId;
  final String currencySymbol;
  final Future<void> Function(FixedAsset) onSave;

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
  FixedAssetType _selectedAssetType = FixedAssetType.officeEquipment;

  // Original values for dirty state tracking (edit mode only)
  String? _originalName;
  String? _originalSalvage;
  String? _originalUsefulLife;
  FixedAssetType? _originalAssetType;

  @override
  void initState() {
    super.initState();

    if (widget.mode == AssetFormMode.edit && widget.existingAsset != null) {
      final asset = widget.existingAsset!;

      // DEBUG: Log asset data being loaded
      debugPrint('=== Edit Mode Init ===');
      debugPrint('Asset ID: ${asset.assetId}');
      debugPrint('Asset Name: ${asset.assetName}');
      debugPrint('Acquisition Cost: ${asset.financialInfo.acquisitionCost}');
      debugPrint('Salvage Value: ${asset.financialInfo.salvageValue}');
      debugPrint('Useful Life: ${asset.financialInfo.usefulLifeYears}');
      debugPrint('Account ID: ${asset.accountId}');

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

      // 기존 accountId에 맞는 타입 선택
      _selectedAssetType = FixedAssetType.values.firstWhere(
        (type) => type.accountId == asset.accountId,
        orElse: () => FixedAssetType.officeEquipment,
      );

      // Store original values for dirty state tracking
      _originalName = asset.assetName;
      _originalSalvage = asset.financialInfo.salvageValue.toStringAsFixed(0);
      _originalUsefulLife = asset.financialInfo.usefulLifeYears.toString();
      _originalAssetType = _selectedAssetType;

      // DEBUG: Log original values
      debugPrint('=== Original Values Stored ===');
      debugPrint('Original Name: $_originalName');
      debugPrint('Original Salvage: $_originalSalvage');
      debugPrint('Original Useful Life: $_originalUsefulLife');
      debugPrint('Original Asset Type: $_originalAssetType');
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

  /// Check if form has unsaved changes (edit mode only)
  bool get _hasChanges {
    if (widget.mode != AssetFormMode.edit) return true; // Always enabled for create

    final nameChanged = _nameController.text.trim() != _originalName;
    final salvageChanged = _salvageController.text != _originalSalvage;
    final usefulLifeChanged = _usefulLifeController.text != _originalUsefulLife;
    final assetTypeChanged = _selectedAssetType != _originalAssetType;

    // DEBUG: Log comparison
    debugPrint('=== _hasChanges Check ===');
    debugPrint('Name: "${_nameController.text.trim()}" vs "$_originalName" = $nameChanged');
    debugPrint('Salvage: "${_salvageController.text}" vs "$_originalSalvage" = $salvageChanged');
    debugPrint('UsefulLife: "${_usefulLifeController.text}" vs "$_originalUsefulLife" = $usefulLifeChanged');
    debugPrint('AssetType: $_selectedAssetType vs $_originalAssetType = $assetTypeChanged');

    return nameChanged || salvageChanged || usefulLifeChanged || assetTypeChanged;
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
                        width: TossSpacing.iconXL,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: TossSpacing.space5),
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
                            size: isEdit ? TossSpacing.iconLG : TossSpacing.iconLG,
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
                            size: TossSpacing.iconLG,
                            color: TossColors.gray600,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28), // Custom spacing

                    // Asset Name Field
                    _buildTextField(
                      label: 'Asset Name',
                      icon: Icons.inventory_2_outlined,
                      controller: _nameController,
                      hint: 'e.g., MacBook Pro, Office Desk',
                      required: true,
                      enabled: true,
                    ),

                    SizedBox(height: TossSpacing.space6),

                    // Asset Type Selector
                    _buildAssetTypeSelector(),

                    SizedBox(height: TossSpacing.space6),

                    // Acquisition Date Field
                    _buildDateField(),

                    SizedBox(height: TossSpacing.space6),

                    // Financial Information Section
                    _buildFinancialSection(isEdit),

                    SizedBox(height: TossSpacing.space5),

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
              decoration: const BoxDecoration(
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
            Icon(icon, size: TossSpacing.iconSM, color: TossColors.gray600),
            SizedBox(width: TossSpacing.space1 + 2),
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
        SizedBox(height: TossSpacing.space2 + 2),
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
            padding: const EdgeInsets.only(top: TossSpacing.space1, left: TossSpacing.space1),
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

  Widget _buildAssetTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.category_outlined, size: TossSpacing.iconSM, color: TossColors.gray600),
            SizedBox(width: TossSpacing.space1 + 2),
            Text(
              'Asset Type',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              ' *',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space2 + 2),
        Row(
          children: FixedAssetType.values.map((type) {
            final isSelected = _selectedAssetType == type;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: type != FixedAssetType.values.last ? TossSpacing.space2 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAssetType = type;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: TossSpacing.space3,
                      horizontal: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? TossColors.primary.withValues(alpha: 0.1)
                          : TossColors.white,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(
                        color: isSelected ? TossColors.primary : TossColors.gray200,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          type == FixedAssetType.interior
                              ? Icons.home_work_outlined
                              : Icons.computer_outlined,
                          size: TossSpacing.iconMD,
                          color: isSelected ? TossColors.primary : TossColors.gray500,
                        ),
                        const SizedBox(height: TossSpacing.space1),
                        Text(
                          type.label,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: isSelected ? TossColors.primary : TossColors.gray700,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
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
            const Icon(Icons.event_outlined, size: TossSpacing.iconSM, color: TossColors.gray600),
            SizedBox(width: TossSpacing.space1 + 2),
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
        SizedBox(height: TossSpacing.space2 + 2),
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
                padding: const EdgeInsets.all(TossSpacing.space1 + 2),
                decoration: BoxDecoration(
                  color: TossColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  size: TossSpacing.iconSM,
                  color: TossColors.success,
                ),
              ),
              SizedBox(width: TossSpacing.space2 + 2),
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
                padding: const EdgeInsets.all(TossSpacing.space1 + 2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  Icons.trending_down,
                  size: TossSpacing.iconSM,
                  color: TossColors.primary,
                ),
              ),
              SizedBox(width: TossSpacing.space2 + 2),
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
                SizedBox(height: TossSpacing.space2 + 2),
                Container(height: 1, color: TossColors.gray100),
                SizedBox(height: TossSpacing.space2 + 2),
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
            Icon(icon, size: TossSpacing.iconXS, color: TossColors.gray600),
            SizedBox(width: TossSpacing.space1 + 2),
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
    final canSave = _hasChanges;

    return Row(
      children: [
        Expanded(
          child: TossButton.outlinedGray(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          flex: 2,
          child: TossButton.primary(
            text: isEdit ? 'Save Changes' : 'Add Asset',
            onPressed: canSave ? _handleSave : null,
            leadingIcon: Icon(
              isEdit ? Icons.check_circle_outline : Icons.add_circle_outline,
              color: canSave ? TossColors.white : TossColors.gray400,
              size: TossSpacing.iconMD,
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

  Future<void> _handleSave() async {
    debugPrint('=== _handleSave Called ===');
    debugPrint('Mode: ${widget.mode}');

    // Validation
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter asset name');
      return;
    }

    final cost = double.tryParse(_costController.text);
    debugPrint('Parsed cost: $cost from "${_costController.text}"');
    if (cost == null || cost <= 0) {
      _showError('Please enter valid acquisition cost');
      return;
    }

    final salvage = double.tryParse(_salvageController.text) ?? 0;
    final years = int.tryParse(_usefulLifeController.text);
    debugPrint('Parsed salvage: $salvage, years: $years');
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
      accountId: _selectedAssetType.accountId,
      createdAt: widget.existingAsset?.createdAt ?? DateTime.now(),
    );

    debugPrint('=== Asset to save ===');
    debugPrint('Asset ID: ${asset.assetId}');
    debugPrint('Asset Name: ${asset.assetName}');
    debugPrint('Acquisition Cost: ${asset.financialInfo.acquisitionCost}');
    debugPrint('Salvage Value: ${asset.financialInfo.salvageValue}');
    debugPrint('Useful Life: ${asset.financialInfo.usefulLifeYears}');
    debugPrint('Account ID: ${asset.accountId}');
    debugPrint('Calling widget.onSave...');

    await widget.onSave(asset);

    debugPrint('widget.onSave completed');
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
