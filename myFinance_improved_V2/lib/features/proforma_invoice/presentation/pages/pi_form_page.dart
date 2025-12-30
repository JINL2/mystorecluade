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
import '../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../counter_party/presentation/widgets/counter_party_form.dart';
import '../../../register_denomination/domain/entities/currency.dart';
import '../../../trade_shared/domain/entities/trade_item.dart';
import '../../../trade_shared/presentation/pages/trade_item_picker_page.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import '../../domain/entities/proforma_invoice.dart';
import '../../domain/repositories/pi_repository.dart';
import '../providers/pi_providers.dart';

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

  // Items
  List<PIItemFormData> _items = [];

  // Validation errors
  String? _counterpartyError;
  String? _currencyError;
  String? _validityDateError;
  String? _itemsError;

  bool get isEditMode => widget.piId != null;

  /// Check if all required fields are filled for Save button enabling
  bool get _canSave =>
      _counterpartyId != null &&
      _counterpartyId!.isNotEmpty &&
      _currencyId != null &&
      _currencyId!.isNotEmpty &&
      _validityDate != null &&
      _items.isNotEmpty;

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
            onPressed: formState.isSaving || !_canSave ? null : _handleSave,
            child: formState.isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: _canSave ? null : TossColors.gray400,
                    ),
                  ),
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
                  _buildCounterpartyDropdown(),
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
                  _buildCurrencyDropdown(),
                  const SizedBox(height: TossSpacing.space3),
                  _buildIncotermsRow(),
                  const SizedBox(height: TossSpacing.space3),
                  _buildPaymentTermsRow(),
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
                  _buildTermsTemplateSection(),

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

  void _showCreateCounterpartySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        // 화면 상단 10% 여백을 줘서 CounterPartyForm이 90% 높이를 차지하도록
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.1,
        ),
        child: const CounterPartyForm(),
      ),
    ).then((result) {
      // Refresh counterparty list if a new one was created
      if (result == true) {
        ref.invalidate(currentCounterpartiesProvider);
      }
    });
  }

  Widget _buildCounterpartyDropdown() {
    final counterpartyAsync = ref.watch(currentCounterpartiesProvider);
    final appState = ref.watch(appStateProvider);

    debugPrint('🔵 [Counterparty] companyId: ${appState.companyChoosen}');
    debugPrint('🔵 [Counterparty] storeId: ${appState.storeChoosen}');
    debugPrint('🔵 [Counterparty] AsyncValue state: $counterpartyAsync');

    return counterpartyAsync.when(
      loading: () {
        debugPrint('🔵 [Counterparty] State: LOADING');
        return TossDropdown<String>(
          label: 'Counterparty',
          items: const [],
          isLoading: true,
          isRequired: true,
          hint: 'Loading...',
        );
      },
      error: (error, stackTrace) {
        debugPrint('🔴 [Counterparty] State: ERROR');
        debugPrint('🔴 [Counterparty] Error: $error');
        debugPrint('🔴 [Counterparty] StackTrace: $stackTrace');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCounterpartyLabelWithAddButton(),
            const SizedBox(height: TossSpacing.space2),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: Border.all(color: TossColors.error),
              ),
              child: Text(
                'Failed to load counterparties',
                style: TossTextStyles.body.copyWith(color: TossColors.error),
              ),
            ),
          ],
        );
      },
      data: (counterparties) {
        debugPrint('🟢 [Counterparty] State: DATA');
        debugPrint('🟢 [Counterparty] Count: ${counterparties.length}');
        for (final cp in counterparties.take(3)) {
          debugPrint('🟢 [Counterparty] Item: ${cp.id} - ${cp.name}');
        }

        // Show create button if no counterparties exist
        if (counterparties.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCounterpartyLabelWithAddButton(),
              const SizedBox(height: TossSpacing.space2),
              _buildEmptyCounterpartyPlaceholder(),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCounterpartyLabelWithAddButton(),
            const SizedBox(height: TossSpacing.space2),
            _buildCounterpartySelector(counterparties),
          ],
        );
      },
    );
  }

  Widget _buildCounterpartyLabelWithAddButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Counterparty',
              style: TossTextStyles.label.copyWith(
                color: _counterpartyError != null ? TossColors.error : TossColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _showCreateCounterpartySheet,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 16, color: TossColors.primary),
              const SizedBox(width: 2),
              Text(
                'Add New',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCounterpartyPlaceholder() {
    return GestureDetector(
      onTap: _showCreateCounterpartySheet,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: _counterpartyError != null ? TossColors.error : TossColors.gray200,
            width: _counterpartyError != null ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_outlined, size: 20, color: TossColors.primary),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Create your first counterparty',
              style: TossTextStyles.body.copyWith(color: TossColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterpartySelector(List<CounterpartyData> counterparties) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        color: TossColors.surface,
        border: Border.all(
          color: _counterpartyError != null ? TossColors.error : TossColors.border,
          width: _counterpartyError != null ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showCounterpartyBottomSheet(counterparties),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _counterpartyId != null
                        ? counterparties.firstWhere(
                            (c) => c.id == _counterpartyId,
                            orElse: () => counterparties.first,
                          ).name
                        : 'Select counterparty',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: _counterpartyId != null ? TossColors.textPrimary : TossColors.textTertiary,
                      fontWeight: _counterpartyId != null ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCounterpartyBottomSheet(List<CounterpartyData> counterparties) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: TossSpacing.space3, bottom: TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Text(
                'Counterparty',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
            ),
            const SizedBox(height: TossSpacing.space2),
            // Options list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
                ),
                itemCount: counterparties.length,
                itemBuilder: (context, index) {
                  final cp = counterparties[index];
                  final isSelected = cp.id == _counterpartyId;
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: 2,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        onTap: () {
                          setState(() {
                            _counterpartyId = cp.id;
                            _counterpartyError = null;
                            _selectedCounterparty = cp;
                            // Build address from additionalData
                            final additionalData = cp.additionalData;
                            final parts = <String>[];
                            if (additionalData != null) {
                              if (additionalData['address'] != null) parts.add(additionalData['address'].toString());
                              if (additionalData['city'] != null) parts.add(additionalData['city'].toString());
                              if (additionalData['country'] != null) parts.add(additionalData['country'].toString());
                            }
                            _counterpartyInfoController.text = parts.join(', ');
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space3,
                            vertical: TossSpacing.space3,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cp.name,
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (cp.type.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        cp.type,
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check,
                                  color: TossColors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    final currencyAsync = ref.watch(companyCurrenciesProvider);
    final appState = ref.watch(appStateProvider);

    debugPrint('🟡 [Currency] companyId: ${appState.companyChoosen}');
    debugPrint('🟡 [Currency] AsyncValue state: $currencyAsync');

    return currencyAsync.when(
      loading: () {
        debugPrint('🟡 [Currency] State: LOADING');
        return TossDropdown<String>(
          label: 'Currency',
          items: const [],
          isLoading: true,
          isRequired: true,
          hint: 'Loading...',
        );
      },
      error: (error, stackTrace) {
        debugPrint('🔴 [Currency] State: ERROR');
        debugPrint('🔴 [Currency] Error: $error');
        debugPrint('🔴 [Currency] StackTrace: $stackTrace');
        return TossDropdown<String>(
          label: 'Currency',
          items: const [],
          isRequired: true,
          errorText: 'Failed to load',
          hint: 'Error loading currencies',
        );
      },
      data: (currencies) {
        debugPrint('🟢 [Currency] State: DATA');
        debugPrint('🟢 [Currency] Count: ${currencies.length}');
        for (final c in currencies.take(3)) {
          debugPrint('🟢 [Currency] Item: ${c.id} - ${c.code} (${c.symbol})');
        }
        // Find the current value - must be in items list or null
        String? currentValue;
        if (_currencyId != null && currencies.any((c) => c.id == _currencyId)) {
          currentValue = _currencyId;
        }

        return TossDropdown<String>(
          label: 'Currency',
          value: currentValue,
          hint: 'Select currency',
          isRequired: true,
          errorText: _currencyError,
          items: currencies.map((c) => TossDropdownItem<String>(
            value: c.id,
            label: '${c.code} (${c.symbol})',
            subtitle: c.fullName,
          )).toList(),
          onChanged: (v) {
            if (v == null) return;
            setState(() {
              _currencyId = v;
              _currencyError = null; // Clear error on selection
              try {
                final selected = currencies.firstWhere((c) => c.id == v);
                _selectedCurrency = selected;
                _currencyCode = selected.code;
              } catch (e) {
                // Currency not found
              }
            });
          },
        );
      },
    );
  }

  Widget _buildIncotermsRow() {
    final masterDataState = ref.watch(masterDataProvider);
    final incoterms = masterDataState.incoterms;

    debugPrint('🟠 [Incoterms] isLoading: ${masterDataState.isLoading}');
    debugPrint('🟠 [Incoterms] error: ${masterDataState.error}');
    debugPrint('🟠 [Incoterms] Count: ${incoterms.length}');
    for (final i in incoterms.take(3)) {
      debugPrint('🟠 [Incoterms] Item: ${i.code} - ${i.name}');
    }

    // Fallback to hardcoded values if not loaded
    final incotermItems = incoterms.isNotEmpty
        ? incoterms.map((i) => TossDropdownItem<String>(
            value: i.code,
            label: i.code,
            subtitle: i.name,
          )).toList()
        : ['FOB', 'CIF', 'CFR', 'EXW', 'DDP', 'DAP']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TossDropdown<String>(
            label: 'Incoterms',
            value: _incotermsCode,
            hint: 'Select',
            isLoading: masterDataState.isLoading,
            items: incotermItems,
            onChanged: (v) => setState(() => _incotermsCode = v),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: _buildTextField(
            controller: _incotermsPlaceController,
            label: 'Place',
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTermsRow() {
    final masterDataState = ref.watch(masterDataProvider);
    final paymentTerms = masterDataState.paymentTerms;

    debugPrint('🟣 [PaymentTerms] isLoading: ${masterDataState.isLoading}');
    debugPrint('🟣 [PaymentTerms] error: ${masterDataState.error}');
    debugPrint('🟣 [PaymentTerms] Count: ${paymentTerms.length}');
    for (final p in paymentTerms.take(3)) {
      debugPrint('🟣 [PaymentTerms] Item: ${p.code} - ${p.name}');
    }

    // Fallback to hardcoded values if not loaded
    final paymentTermItems = paymentTerms.isNotEmpty
        ? paymentTerms.map((p) => TossDropdownItem<String>(
            value: p.code,
            label: p.code,
            subtitle: p.name,
          )).toList()
        : ['LC_AT_SIGHT', 'LC_USANCE', 'TT_ADVANCE', 'TT_AFTER', 'DA', 'DP']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TossDropdown<String>(
            label: 'Payment Terms',
            value: _paymentTermsCode,
            hint: 'Select',
            isLoading: masterDataState.isLoading,
            items: paymentTermItems,
            onChanged: (v) => setState(() => _paymentTermsCode = v),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: _buildTextField(
            controller: _paymentTermsDetailController,
            label: 'Detail',
          ),
        ),
      ],
    );
  }

  Widget _buildTermsTemplateSection() {
    final termsState = ref.watch(termsTemplateProvider);

    debugPrint('⚪ [Terms] isLoading: ${termsState.isLoading}');
    debugPrint('⚪ [Terms] error: ${termsState.error}');
    debugPrint('⚪ [Terms] Count: ${termsState.items.length}');
    for (final t in termsState.items.take(3)) {
      debugPrint('⚪ [Terms] Item: ${t.templateId} - ${t.templateName}');
    }

    final templateItems = [
      const TossDropdownItem<String?>(
        value: null,
        label: '-- No Template --',
      ),
      ...termsState.items.map((t) => TossDropdownItem<String?>(
        value: t.templateId,
        label: t.templateName,
        subtitle: t.isDefault ? 'Default' : null,
      )),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template dropdown
        TossDropdown<String?>(
          label: 'Template (optional)',
          value: _selectedTemplateId,
          hint: 'Select template',
          isLoading: termsState.isLoading,
          items: templateItems,
          onChanged: (v) {
            setState(() {
              _selectedTemplateId = v;
              if (v != null) {
                try {
                  final selected = termsState.items.firstWhere((t) => t.templateId == v);
                  _termsController.text = selected.content;
                } catch (e) {
                  // Template not found
                }
              }
            });
          },
        ),
        const SizedBox(height: TossSpacing.space3),

        // Terms content (editable)
        _buildTextField(
          controller: _termsController,
          label: 'Terms & Conditions Content',
          maxLines: 6,
        ),
        const SizedBox(height: TossSpacing.space2),

        // Save as template button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _termsController.text.isNotEmpty ? _showSaveTemplateDialog : null,
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text('Save as Template'),
          ),
        ),
      ],
    );
  }

  void _showSaveTemplateDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save as Template'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Template Name',
            hintText: 'e.g., Standard Export Terms',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a template name')),
                );
                return;
              }

              final result = await ref.read(termsTemplateProvider.notifier).saveAsTemplate(
                    nameController.text,
                    _termsController.text,
                  );

              if (mounted) {
                Navigator.pop(context);
                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Template "${result.templateName}" saved')),
                  );
                  setState(() {
                    _selectedTemplateId = result.templateId;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to save template')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
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
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: isRequired ? '$label *' : label,
              labelStyle: TextStyle(
                color: hasError ? TossColors.error : null,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                borderSide: BorderSide(
                  color: hasError ? TossColors.error : TossColors.gray300,
                  width: hasError ? 2 : 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                borderSide: BorderSide(
                  color: hasError ? TossColors.error : TossColors.gray300,
                  width: hasError ? 2 : 1,
                ),
              ),
              suffixIcon: const Icon(Icons.calendar_today, size: 20),
            ),
            child: Text(
              value != null ? DateFormat('yyyy-MM-dd').format(value) : '',
              style: TossTextStyles.bodyMedium,
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
    final total = _items.fold<double>(
      0,
      (sum, item) => sum + (item.quantity * item.unitPrice * (1 - item.discountPercent / 100)),
    );
    final hasError = _itemsError != null && _itemsError!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Use Text directly instead of TradeSectionHeader to avoid Spacer in nested Row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Items',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasError ? TossColors.error : TossColors.gray500,
                  ),
                ),
                Text(
                  ' *',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.error,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${_items.length}',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add_circle_outline, size: 24),
              tooltip: 'Add Items',
              color: TossColors.primary,
            ),
          ],
        ),
        if (hasError) ...[
          Text(
            _itemsError!,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
          const SizedBox(height: TossSpacing.space1),
        ],
        const SizedBox(height: TossSpacing.space2),

        if (_items.isEmpty)
          GestureDetector(
            onTap: _addItem,
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(color: TossColors.gray200, style: BorderStyle.solid),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.add_circle_outline, size: 40, color: TossColors.primary),
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'Tap to add items',
                      style: TossTextStyles.bodyMedium.copyWith(color: TossColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          )
        else ...[
          ..._items.asMap().entries.map((entry) => _ItemFormCard(
                item: entry.value,
                index: entry.key,
                currencyCode: _currencyCode,
                onEdit: () => _editItem(entry.key),
                onDelete: () => _deleteItem(entry.key),
              )),
          const SizedBox(height: TossSpacing.space3),
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TossTextStyles.bodyLarge),
                Text(
                  '$_currencyCode ${NumberFormat('#,##0.00').format(total)}',
                  style: TossTextStyles.h4,
                ),
              ],
            ),
          ),
        ],
      ],
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
    bool isValid = true;

    // Validate Counterparty
    if (_counterpartyId == null || _counterpartyId!.isEmpty) {
      _counterpartyError = 'Please select a counterparty';
      isValid = false;
    } else {
      _counterpartyError = null;
    }

    // Validate Currency
    if (_currencyId == null || _currencyId!.isEmpty) {
      _currencyError = 'Please select a currency';
      isValid = false;
    } else {
      _currencyError = null;
    }

    // Validate Validity Date
    if (_validityDate == null) {
      _validityDateError = 'Please select a validity date';
      isValid = false;
    } else {
      _validityDateError = null;
    }

    // Validate Items
    if (_items.isEmpty) {
      _itemsError = 'Please add at least one item';
      isValid = false;
    } else {
      _itemsError = null;
    }

    return isValid;
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate required fields
    final isValid = _validateForm();
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

    final notifier = ref.read(piFormProvider.notifier);
    final pi = isEditMode
        ? await notifier.update(widget.piId!, params)
        : await notifier.create(params);

    if (pi != null && mounted) {
      ref.read(piListProvider.notifier).refresh();
      context.go('/proforma-invoice/${pi.id}');
    }
  }
}

// Item Form Data class
class PIItemFormData {
  final String? productId;
  final String description;
  final String? sku;
  final String? hsCode;
  final String? countryOfOrigin;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double discountPercent;

  PIItemFormData({
    this.productId,
    required this.description,
    this.sku,
    this.hsCode,
    this.countryOfOrigin,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.discountPercent = 0,
  });

  double get lineTotal => quantity * unitPrice * (1 - discountPercent / 100);
}

// Item Form Card
class _ItemFormCard extends StatelessWidget {
  final PIItemFormData item;
  final int index;
  final String currencyCode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ItemFormCard({
    required this.item,
    required this.index,
    required this.currencyCode,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.description,
                  style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, size: 18, color: TossColors.gray500),
                onPressed: onEdit,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(TossSpacing.space1),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 18, color: TossColors.error),
                onPressed: onDelete,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(TossSpacing.space1),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${NumberFormat('#,##0.##').format(item.quantity)} ${item.unit} × $currencyCode ${NumberFormat('#,##0.00').format(item.unitPrice)}',
                style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
              ),
              Text(
                '$currencyCode ${NumberFormat('#,##0.00').format(item.lineTotal)}',
                style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

