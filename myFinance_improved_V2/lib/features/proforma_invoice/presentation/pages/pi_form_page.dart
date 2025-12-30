import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/domain/entities/selector_entities.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../register_denomination/domain/entities/currency.dart';
import '../../../trade_shared/domain/entities/trade_item.dart';
import '../../../trade_shared/presentation/pages/trade_item_picker_page.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import '../../domain/entities/proforma_invoice.dart';
import '../../domain/repositories/pi_repository.dart';
import '../providers/pi_providers.dart';
import '../widgets/pi_form/pi_form_widgets.dart';

class PIFormPage extends ConsumerStatefulWidget {
  final String? piId; // null for create, non-null for edit

  const PIFormPage({super.key, this.piId});

  @override
  ConsumerState<PIFormPage> createState() => _PIFormPageState();
}

class _PIFormPageState extends ConsumerState<PIFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Form controllers
  final _counterpartyInfoController = TextEditingController();
  final _incotermsPlaceController = TextEditingController();
  final _portOfLoadingController = TextEditingController();
  final _portOfDischargeController = TextEditingController();
  final _finalDestinationController = TextEditingController();
  final _paymentTermsDetailController = TextEditingController();
  final _notesController = TextEditingController();
  final _termsController = TextEditingController();

  // Form values
  String? _counterpartyId;
  CounterpartyData? _selectedCounterparty;
  String? _currencyId;
  Currency? _selectedCurrency;
  String _currencyCode = 'USD';
  String? _incotermsCode;
  String? _paymentTermsCode;
  String? _shippingMethodCode;
  DateTime? _validityDate;
  DateTime? _estimatedShipmentDate;
  int? _leadTimeDays;
  bool _partialShipmentAllowed = true;
  bool _transshipmentAllowed = true;
  String? _selectedTemplateId;

  // Bank accounts for PDF
  List<String> _selectedBankAccountIds = [];

  // Items
  List<PIItemFormData> _items = [];

  // Validation errors
  String? _counterpartyError;
  String? _currencyError;
  String? _validityDateError;
  String? _itemsError;

  bool get isEditMode => widget.piId != null;

  /// Check if all required fields are filled for Save button enabling
  bool get _canSave {
    final canSave = _counterpartyId != null &&
        _counterpartyId!.isNotEmpty &&
        _currencyId != null &&
        _currencyId!.isNotEmpty &&
        _validityDate != null &&
        _items.isNotEmpty;

    // Debug: print which conditions are not met
    if (!canSave) {
      debugPrint('🔴 [PIFormPage] _canSave = false');
      debugPrint('🔴 [PIFormPage]   - counterpartyId: $_counterpartyId (${_counterpartyId != null && _counterpartyId!.isNotEmpty ? '✓' : '✗'})');
      debugPrint('🔴 [PIFormPage]   - currencyId: $_currencyId (${_currencyId != null && _currencyId!.isNotEmpty ? '✓' : '✗'})');
      debugPrint('🔴 [PIFormPage]   - validityDate: $_validityDate (${_validityDate != null ? '✓' : '✗'})');
      debugPrint('🔴 [PIFormPage]   - items: ${_items.length} (${_items.isNotEmpty ? '✓' : '✗'})');
    }

    return canSave;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeForm();
    });
  }

  Future<void> _initializeForm() async {
    final appState = ref.read(appStateProvider);
    debugPrint('🚀 [PIFormPage] _initializeForm called');
    debugPrint('🚀 [PIFormPage] companyId: ${appState.companyChoosen}');
    debugPrint('🚀 [PIFormPage] storeId: ${appState.storeChoosen}');

    // Load dropdown data (fire and forget - don't await)
    // Counterparty and Currency use existing global providers (auto-loaded on watch)
    debugPrint('🚀 [PIFormPage] Loading termsTemplateProvider...');
    ref.read(termsTemplateProvider.notifier).load();
    debugPrint('🚀 [PIFormPage] Loading masterDataProvider...');
    ref.read(masterDataProvider.notifier).loadAllMasterData();

    if (isEditMode) {
      // Load existing PI for editing
      await ref.read(piDetailProvider.notifier).load(widget.piId!);
      if (!mounted) return;
      final pi = ref.read(piDetailProvider).pi;
      if (pi != null) {
        _populateForm(pi);
      }
    } else {
      // Generate new PI number
      ref.read(piFormProvider.notifier).generateNumber();
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _populateForm(ProformaInvoice pi) {
    _counterpartyId = pi.counterpartyId;
    _counterpartyInfoController.text = _formatCounterpartyInfo(pi.counterpartyInfo);
    _currencyId = pi.currencyId;
    _currencyCode = pi.currencyCode;
    _incotermsCode = pi.incotermsCode;
    _incotermsPlaceController.text = pi.incotermsPlace ?? '';
    _portOfLoadingController.text = pi.portOfLoading ?? '';
    _portOfDischargeController.text = pi.portOfDischarge ?? '';
    _finalDestinationController.text = pi.finalDestination ?? '';
    _paymentTermsCode = pi.paymentTermsCode;
    _paymentTermsDetailController.text = pi.paymentTermsDetail ?? '';
    _shippingMethodCode = pi.shippingMethodCode;
    _validityDate = pi.validityDate;
    _estimatedShipmentDate = pi.estimatedShipmentDate;
    _leadTimeDays = pi.leadTimeDays;
    _partialShipmentAllowed = pi.partialShipmentAllowed;
    _transshipmentAllowed = pi.transshipmentAllowed;
    _notesController.text = pi.notes ?? '';
    _termsController.text = pi.termsAndConditions ?? '';
    _selectedBankAccountIds = List<String>.from(pi.bankAccountIds);

    _items = pi.items
        .map((item) => PIItemFormData(
              productId: item.productId,
              description: item.description,
              sku: item.sku,
              hsCode: item.hsCode,
              countryOfOrigin: item.countryOfOrigin,
              quantity: item.quantity,
              unit: item.unit ?? 'PCS',
              unitPrice: item.unitPrice,
              discountPercent: item.discountPercent,
            ))
        .toList();
  }

  String _formatCounterpartyInfo(Map<String, dynamic>? counterpartyInfo) {
    if (counterpartyInfo == null) return '';
    final parts = <String>[];
    if (counterpartyInfo['address'] != null) parts.add(counterpartyInfo['address'].toString());
    if (counterpartyInfo['city'] != null) parts.add(counterpartyInfo['city'].toString());
    if (counterpartyInfo['country'] != null) parts.add(counterpartyInfo['country'].toString());
    return parts.join(', ');
  }

  @override
  void dispose() {
    _counterpartyInfoController.dispose();
    _incotermsPlaceController.dispose();
    _portOfLoadingController.dispose();
    _portOfDischargeController.dispose();
    _finalDestinationController.dispose();
    _paymentTermsDetailController.dispose();
    _notesController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(piFormProvider);
    // Watch app state to react to company changes
    ref.watch(appStateProvider);

    return TossScaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit PI' : 'New PI'),
        actions: [
          TextButton(
            // Always allow tap, validation happens in _handleSave
            onPressed: formState.isSaving ? null : _handleSave,
            child: formState.isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(TossSpacing.space4),
                children: [
                  // PI Number (auto-generated)
                  if (!isEditMode && formState.generatedNumber != null) ...[
                    _buildInfoRow('PI Number', formState.generatedNumber!),
                    const SizedBox(height: TossSpacing.space4),
                  ],

                  // Counterparty Section
                  _buildSectionTitle('Counterparty Information'),
                  const SizedBox(height: TossSpacing.space2),
                  PICounterpartySection(
                    counterpartyId: _counterpartyId,
                    counterpartyInfoController: _counterpartyInfoController,
                    errorText: _counterpartyError,
                    onCounterpartyChanged: (cp) {
                      setState(() {
                        _counterpartyId = cp?.id;
                        _selectedCounterparty = cp;
                        _counterpartyError = null;
                      });
                    },
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  _buildTextField(
                    controller: _counterpartyInfoController,
                    label: 'Counterparty Address',
                    maxLines: 3,
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Currency & Terms
                  _buildSectionTitle('Currency & Terms'),
                  const SizedBox(height: TossSpacing.space2),
                  PICurrencySection(
                    currencyId: _currencyId,
                    errorText: _currencyError,
                    onCurrencyChanged: (currency) {
                      setState(() {
                        _currencyId = currency?.id;
                        _selectedCurrency = currency;
                        _currencyCode = currency?.code ?? 'USD';
                        _currencyError = null;
                      });
                    },
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  PIShippingTermsSection(
                    incotermsCode: _incotermsCode,
                    incotermsPlaceController: _incotermsPlaceController,
                    paymentTermsCode: _paymentTermsCode,
                    paymentTermsDetailController: _paymentTermsDetailController,
                    onIncotermsChanged: (v) => setState(() => _incotermsCode = v),
                    onPaymentTermsChanged: (v) => setState(() => _paymentTermsCode = v),
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Shipping
                  _buildSectionTitle('Shipping Details'),
                  const SizedBox(height: TossSpacing.space2),
                  _buildTextField(
                    controller: _portOfLoadingController,
                    label: 'Port of Loading',
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  _buildTextField(
                    controller: _portOfDischargeController,
                    label: 'Port of Discharge',
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  _buildTextField(
                    controller: _finalDestinationController,
                    label: 'Final Destination',
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  _buildDateField(
                    label: 'Estimated Shipment Date',
                    value: _estimatedShipmentDate,
                    onChanged: (d) => setState(() => _estimatedShipmentDate = d),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSwitchTile(
                          'Partial Shipment',
                          _partialShipmentAllowed,
                          (v) => setState(() => _partialShipmentAllowed = v),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: _buildSwitchTile(
                          'Transshipment',
                          _transshipmentAllowed,
                          (v) => setState(() => _transshipmentAllowed = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Validity
                  _buildSectionTitle('Validity'),
                  const SizedBox(height: TossSpacing.space2),
                  _buildDateField(
                    label: 'Valid Until',
                    value: _validityDate,
                    onChanged: (d) => setState(() {
                      _validityDate = d;
                      _validityDateError = null; // Clear error on selection
                    }),
                    isRequired: true,
                    errorText: _validityDateError,
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Items
                  _buildItemsSection(),
                  const SizedBox(height: TossSpacing.space5),

                  // Banking Information for PDF
                  _buildSectionTitle('Banking Information'),
                  const SizedBox(height: TossSpacing.space2),
                  PIBankAccountSection(
                    selectedBankAccountIds: _selectedBankAccountIds,
                    onSelectionChanged: (ids) {
                      setState(() {
                        _selectedBankAccountIds = ids;
                      });
                    },
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Notes
                  _buildSectionTitle('Notes'),
                  const SizedBox(height: TossSpacing.space2),
                  _buildTextField(
                    controller: _notesController,
                    label: 'Notes (visible to counterparty)',
                    maxLines: 3,
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Terms & Conditions
                  _buildSectionTitle('Terms & Conditions'),
                  const SizedBox(height: TossSpacing.space2),
                  PITermsTemplateSection(
                    selectedTemplateId: _selectedTemplateId,
                    termsController: _termsController,
                    onTemplateChanged: (v) {
                      setState(() {
                        _selectedTemplateId = v;
                      });
                    },
                  ),

                  const SizedBox(height: TossSpacing.space6),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TossTextStyles.h4.copyWith(color: TossColors.gray900),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray600)),
          Text(value, style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool showLabel = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label above the field (matching TossDropdown style)
        if (showLabel && label.isNotEmpty) ...[
          Text(
            label,
            style: TossTextStyles.label.copyWith(
              color: TossColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
        ],
        // Text field
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: TossColors.surface,
            contentPadding: const EdgeInsets.all(TossSpacing.space3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
    bool isRequired = false,
    String? errorText,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator (matching TossDropdown style)
        Row(
          children: [
            Text(
              label,
              style: TossTextStyles.label.copyWith(
                color: hasError ? TossColors.error : TossColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 2),
              Text(
                '*',
                style: TossTextStyles.label.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        // Date field
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
            );
            onChanged(date);
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: hasError ? TossColors.error : TossColors.border,
                width: hasError ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null ? DateFormat('yyyy-MM-dd').format(value) : 'Select date',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: value != null ? TossColors.textPrimary : TossColors.textTertiary,
                      fontWeight: value != null ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            errorText,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildSwitchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray300),
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              label,
              style: TossTextStyles.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            height: 24,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Switch(
                value: value,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return PIItemsSection(
      items: _items,
      currencyCode: _currencyCode,
      errorText: _itemsError,
      onAddItem: _addItem,
      onEditItem: _editItem,
      onDeleteItem: _deleteItem,
    );
  }

  void _addItem() async {
    // Convert existing items to TradeItem for picker
    final existingTradeItems = _items.map((item) => TradeItem(
      productId: item.productId,
      description: item.description,
      sku: item.sku,
      hsCode: item.hsCode,
      countryOfOrigin: item.countryOfOrigin,
      quantity: item.quantity,
      unit: item.unit,
      unitPrice: item.unitPrice,
      discountPercent: item.discountPercent,
    )).toList();

    // Show the product picker
    final selectedItems = await TradeItemPickerPage.show(
      context,
      title: 'Select Products',
      currencySymbol: _currencyCode,
      confirmButtonText: 'Add to PI',
      initialItems: existingTradeItems,
    );

    if (selectedItems != null) {
      setState(() {
        // Convert selected TradeItems back to PIItemFormData
        _items = selectedItems.map((item) => PIItemFormData(
          productId: item.productId,
          description: item.description,
          sku: item.sku,
          hsCode: item.hsCode,
          countryOfOrigin: item.countryOfOrigin,
          quantity: item.quantity,
          unit: item.unit,
          unitPrice: item.unitPrice,
          discountPercent: item.discountPercent ?? 0,
        )).toList();
        // Clear error when items are added
        if (_items.isNotEmpty) {
          _itemsError = null;
        }
      });
    }
  }

  void _editItem(int index) {
    // Re-open picker with current items to allow editing
    _addItem();
  }

  void _deleteItem(int index) {
    setState(() => _items.removeAt(index));
  }

  /// Validates required fields and returns true if all valid
  bool _validateForm() {
    debugPrint('🔍 [PIFormPage] _validateForm starting...');
    debugPrint('🔍 [PIFormPage]   - counterpartyId: $_counterpartyId');
    debugPrint('🔍 [PIFormPage]   - currencyId: $_currencyId');
    debugPrint('🔍 [PIFormPage]   - validityDate: $_validityDate');
    debugPrint('🔍 [PIFormPage]   - items count: ${_items.length}');

    bool isValid = true;

    // Validate Counterparty
    if (_counterpartyId == null || _counterpartyId!.isEmpty) {
      _counterpartyError = 'Please select a counterparty';
      isValid = false;
      debugPrint('🔴 [PIFormPage] Counterparty validation FAILED');
    } else {
      _counterpartyError = null;
      debugPrint('✅ [PIFormPage] Counterparty validation OK');
    }

    // Validate Currency
    if (_currencyId == null || _currencyId!.isEmpty) {
      _currencyError = 'Please select a currency';
      isValid = false;
      debugPrint('🔴 [PIFormPage] Currency validation FAILED');
    } else {
      _currencyError = null;
      debugPrint('✅ [PIFormPage] Currency validation OK');
    }

    // Validate Validity Date
    if (_validityDate == null) {
      _validityDateError = 'Please select a validity date';
      isValid = false;
      debugPrint('🔴 [PIFormPage] Validity Date validation FAILED');
    } else {
      _validityDateError = null;
      debugPrint('✅ [PIFormPage] Validity Date validation OK');
    }

    // Validate Items
    if (_items.isEmpty) {
      _itemsError = 'Please add at least one item';
      isValid = false;
      debugPrint('🔴 [PIFormPage] Items validation FAILED');
    } else {
      _itemsError = null;
      debugPrint('✅ [PIFormPage] Items validation OK');
    }

    debugPrint('🔍 [PIFormPage] _validateForm result: $isValid');
    return isValid;
  }

  Future<void> _handleSave() async {
    debugPrint('🟢 [PIFormPage] _handleSave called!');
    debugPrint('🟢 [PIFormPage] Form validate result: ${_formKey.currentState!.validate()}');

    if (!_formKey.currentState!.validate()) {
      debugPrint('🔴 [PIFormPage] Form validation failed - returning');
      return;
    }

    // Validate required fields
    debugPrint('🟡 [PIFormPage] Calling _validateForm...');
    final isValid = _validateForm();
    debugPrint('🟡 [PIFormPage] _validateForm result: $isValid');
    if (!isValid) {
      setState(() {}); // Refresh UI to show errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final appStateRead = ref.read(appStateProvider);
    final companyId = appStateRead.companyChoosen;
    if (companyId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company not selected')),
      );
      return;
    }

    // Build counterparty info with name and address
    Map<String, dynamic>? counterpartyInfo;
    if (_selectedCounterparty != null || _counterpartyInfoController.text.isNotEmpty) {
      counterpartyInfo = {};
      if (_selectedCounterparty != null) {
        counterpartyInfo['name'] = _selectedCounterparty!.name;
        // Include additional data from counterparty
        final additionalData = _selectedCounterparty!.additionalData;
        if (additionalData != null) {
          if (additionalData['address'] != null) counterpartyInfo['address'] = additionalData['address'];
          if (additionalData['city'] != null) counterpartyInfo['city'] = additionalData['city'];
          if (additionalData['country'] != null) counterpartyInfo['country'] = additionalData['country'];
          if (additionalData['email'] != null) counterpartyInfo['email'] = additionalData['email'];
          if (additionalData['phone'] != null) counterpartyInfo['phone'] = additionalData['phone'];
        }
      }
      // Override address if user edited it manually
      if (_counterpartyInfoController.text.isNotEmpty) {
        counterpartyInfo['address'] = _counterpartyInfoController.text;
      }
    }

    final params = PICreateParams(
      companyId: companyId,
      storeId: null,
      counterpartyId: _counterpartyId,
      counterpartyInfo: counterpartyInfo,
      currencyId: _currencyId ?? _currencyCode, // Use actual currency ID if available
      incotermsCode: _incotermsCode,
      incotermsPlace: _incotermsPlaceController.text.isNotEmpty ? _incotermsPlaceController.text : null,
      portOfLoading: _portOfLoadingController.text.isNotEmpty ? _portOfLoadingController.text : null,
      portOfDischarge: _portOfDischargeController.text.isNotEmpty ? _portOfDischargeController.text : null,
      finalDestination: _finalDestinationController.text.isNotEmpty ? _finalDestinationController.text : null,
      countryOfOrigin: null,
      paymentTermsCode: _paymentTermsCode,
      paymentTermsDetail: _paymentTermsDetailController.text.isNotEmpty ? _paymentTermsDetailController.text : null,
      partialShipmentAllowed: _partialShipmentAllowed,
      transshipmentAllowed: _transshipmentAllowed,
      shippingMethodCode: _shippingMethodCode,
      estimatedShipmentDate: _estimatedShipmentDate,
      leadTimeDays: _leadTimeDays,
      validityDate: _validityDate,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      internalNotes: null,
      termsAndConditions: _termsController.text.isNotEmpty ? _termsController.text : null,
      bankAccountIds: _selectedBankAccountIds,
      items: _items
          .map((item) => PIItemParams(
                productId: item.productId,
                description: item.description,
                sku: item.sku,
                hsCode: item.hsCode,
                countryOfOrigin: item.countryOfOrigin,
                quantity: item.quantity,
                unit: item.unit,
                unitPrice: item.unitPrice,
                discountPercent: item.discountPercent,
                packingInfo: null,
              ))
          .toList(),
    );

    debugPrint('🚀 [PIFormPage] Calling ${isEditMode ? 'update' : 'create'}...');
    final notifier = ref.read(piFormProvider.notifier);
    try {
      final pi = isEditMode
          ? await notifier.update(widget.piId!, params)
          : await notifier.create(params);

      if (pi != null && mounted) {
        debugPrint('✅ [PIFormPage] PI ${isEditMode ? 'updated' : 'created'} successfully! ID: ${pi.id}');
        ref.read(piListProvider.notifier).refresh();
        context.go('/proforma-invoice/${pi.id}');
      } else {
        // Get the actual error from piFormProvider state
        final formState = ref.read(piFormProvider);
        final errorMessage = formState.error ?? 'Unknown error occurred';
        debugPrint('🔴 [PIFormPage] PI ${isEditMode ? 'update' : 'create'} returned null');
        debugPrint('🔴 [PIFormPage] Error from state: $errorMessage');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save PI: $errorMessage'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('🔴 [PIFormPage] Error saving PI: $e');
      debugPrint('🔴 [PIFormPage] StackTrace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
