import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/counterparty_provider.dart';
import '../../../../core/domain/entities/selector_entities.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../counter_party/presentation/widgets/counter_party_form.dart';
import '../../../register_denomination/domain/entities/currency.dart';
import '../../../register_denomination/presentation/providers/currency_providers.dart';
import '../../../trade_shared/domain/entities/trade_item.dart';
import '../../../trade_shared/presentation/pages/trade_item_picker_page.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import '../../../cash_location/presentation/providers/cash_location_providers.dart';
import '../../../cash_location/domain/value_objects/cash_location_query_params.dart';
import '../../../cash_location/domain/entities/cash_location.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/repositories/po_repository.dart';
import '../providers/po_providers.dart';

class POFormPage extends ConsumerStatefulWidget {
  final String? poId; // null for create, non-null for edit

  const POFormPage({super.key, this.poId});

  @override
  ConsumerState<POFormPage> createState() => _POFormPageState();
}

class _POFormPageState extends ConsumerState<POFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Form controllers
  final _buyerPoNumberController = TextEditingController();
  final _incotermsPlaceController = TextEditingController();
  final _notesController = TextEditingController();

  // Form values
  String? _buyerId;
  CounterpartyData? _selectedBuyer;
  String? _currencyId;
  // ignore: unused_field - kept for potential future use
  Currency? _selectedCurrency;
  String _currencyCode = 'USD';
  String? _incotermsCode;
  String? _paymentTermsCode;
  DateTime? _orderDate;
  DateTime? _requiredShipmentDate;
  bool _partialShipmentAllowed = true;
  bool _transshipmentAllowed = true;

  // Bank accounts for PDF
  List<String> _selectedBankAccountIds = [];

  // Items
  List<POItemFormData> _items = [];

  // Validation errors
  String? _buyerError;
  String? _currencyError;
  String? _itemsError;

  bool get isEditMode => widget.poId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeForm();
    });
  }

  Future<void> _initializeForm() async {
    final appState = ref.read(appStateProvider);
    debugPrint('🚀 [POFormPage] _initializeForm called');
    debugPrint('🚀 [POFormPage] companyId: ${appState.companyChoosen}');
    debugPrint('🚀 [POFormPage] storeId: ${appState.storeChoosen}');

    // Load dropdown data
    debugPrint('🚀 [POFormPage] Loading masterDataProvider...');
    ref.read(masterDataProvider.notifier).loadAllMasterData();

    if (isEditMode) {
      // Load existing PO for editing
      await ref.read(poDetailProvider.notifier).load(widget.poId!);
      if (!mounted) return;
      final po = ref.read(poDetailProvider).po;
      if (po != null) {
        _populateForm(po);
      }
    } else {
      // Generate new PO number
      ref.read(poFormProvider.notifier).generateNumber();
      // Set default order date to today
      _orderDate = DateTime.now();
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _populateForm(PurchaseOrder po) {
    _buyerId = po.buyerId;
    _buyerPoNumberController.text = po.buyerPoNumber ?? '';
    _currencyId = po.currencyId;
    _currencyCode = po.currencyCode;
    _incotermsCode = po.incotermsCode;
    _incotermsPlaceController.text = po.incotermsPlace ?? '';
    _paymentTermsCode = po.paymentTermsCode;
    _orderDate = po.orderDateUtc;
    _requiredShipmentDate = po.requiredShipmentDateUtc;
    _partialShipmentAllowed = po.partialShipmentAllowed;
    _transshipmentAllowed = po.transshipmentAllowed;
    _notesController.text = po.notes ?? '';
    _selectedBankAccountIds = List<String>.from(po.bankAccountIds);

    _items = po.items
        .map((item) => POItemFormData(
              productId: item.productId,
              description: item.description,
              sku: item.sku,
              hsCode: item.hsCode,
              quantity: item.quantity,
              unit: item.unit ?? 'PCS',
              unitPrice: item.unitPrice,
            ))
        .toList();
  }

  @override
  void dispose() {
    _buyerPoNumberController.dispose();
    _incotermsPlaceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(poFormProvider);
    ref.watch(appStateProvider);

    return TossScaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit PO' : 'New PO'),
        actions: [
          TextButton(
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
                  // PO Number (read-only)
                  _buildPONumberSection(),
                  const SizedBox(height: TossSpacing.space5),

                  // Buyer Section
                  _buildSectionTitle('Buyer Information'),
                  const SizedBox(height: TossSpacing.space2),
                  _buildBuyerDropdown(),
                  const SizedBox(height: TossSpacing.space3),
                  _buildTextField(
                    controller: _buyerPoNumberController,
                    label: 'Buyer\'s PO Number (Optional)',
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Currency Section
                  _buildSectionTitle('Currency'),
                  const SizedBox(height: TossSpacing.space2),
                  _buildCurrencyDropdown(),
                  const SizedBox(height: TossSpacing.space5),

                  // Dates Section
                  _buildSectionTitle('Dates'),
                  const SizedBox(height: TossSpacing.space2),
                  _buildDateField(
                    label: 'Order Date',
                    value: _orderDate,
                    onChanged: (d) => setState(() => _orderDate = d),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  _buildDateField(
                    label: 'Required Shipment Date',
                    value: _requiredShipmentDate,
                    onChanged: (d) => setState(() => _requiredShipmentDate = d),
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Trade Terms Section
                  _buildSectionTitle('Trade Terms'),
                  const SizedBox(height: TossSpacing.space2),
                  _buildIncotermsRow(),
                  const SizedBox(height: TossSpacing.space3),
                  _buildPaymentTermsDropdown(),
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

                  // Bank Account Selection
                  _buildSectionTitle('Banking Information'),
                  const SizedBox(height: TossSpacing.space2),
                  _buildBankAccountSelector(),
                  const SizedBox(height: TossSpacing.space5),

                  // Items Section
                  _buildItemsSection(),
                  const SizedBox(height: TossSpacing.space5),

                  // Notes Section
                  _buildSectionTitle('Notes'),
                  const SizedBox(height: TossSpacing.space2),
                  _buildTextField(
                    controller: _notesController,
                    label: 'Notes',
                    maxLines: 3,
                  ),

                  const SizedBox(height: TossSpacing.space8),
                ],
              ),
            ),
    );
  }

  Widget _buildPONumberSection() {
    final formState = ref.watch(poFormProvider);
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'PO Number',
            style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray600),
          ),
          Text(
            formState.generatedNumber ?? 'Generating...',
            style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TossTextStyles.h4.copyWith(color: TossColors.gray900),
    );
  }

  Widget _buildBuyerDropdown() {
    final counterpartyAsync = ref.watch(currentCounterpartiesProvider);

    return counterpartyAsync.when(
      loading: () => TossDropdown<String>(
        label: 'Buyer',
        items: const [],
        isLoading: true,
        isRequired: true,
        hint: 'Loading...',
      ),
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBuyerLabelWithAddButton(),
          const SizedBox(height: TossSpacing.space2),
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.error),
            ),
            child: Text(
              'Failed to load buyers',
              style: TossTextStyles.body.copyWith(color: TossColors.error),
            ),
          ),
        ],
      ),
      data: (counterparties) {
        if (counterparties.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBuyerLabelWithAddButton(),
              const SizedBox(height: TossSpacing.space2),
              _buildEmptyBuyerPlaceholder(),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBuyerLabelWithAddButton(),
            const SizedBox(height: TossSpacing.space2),
            _buildBuyerSelector(counterparties),
          ],
        );
      },
    );
  }

  Widget _buildBuyerLabelWithAddButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Buyer',
              style: TossTextStyles.label.copyWith(
                color: _buyerError != null ? TossColors.error : TossColors.textSecondary,
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
            children: [
              Icon(Icons.add_circle_outline, size: 16, color: TossColors.primary),
              const SizedBox(width: 4),
              Text(
                'Add New',
                style: TossTextStyles.caption.copyWith(color: TossColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyBuyerPlaceholder() {
    return GestureDetector(
      onTap: _showCreateCounterpartySheet,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: _buyerError != null ? TossColors.error : TossColors.gray200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: TossColors.primary, size: 20),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Add your first buyer',
              style: TossTextStyles.body.copyWith(color: TossColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyerSelector(List<CounterpartyData> counterparties) {
    String? currentValue;
    if (_buyerId != null && counterparties.any((c) => c.id == _buyerId)) {
      currentValue = _buyerId;
    }

    return TossDropdown<String>(
      label: '',
      value: currentValue,
      hint: 'Select buyer',
      isRequired: true,
      errorText: _buyerError,
      items: counterparties
          .map((c) => TossDropdownItem<String>(
                value: c.id,
                label: c.name,
                subtitle: _getCounterpartySubtitle(c),
              ))
          .toList(),
      onChanged: (v) {
        if (v == null) return;
        setState(() {
          _buyerId = v;
          _buyerError = null;
          try {
            _selectedBuyer = counterparties.firstWhere((c) => c.id == v);
          } catch (e) {
            _selectedBuyer = null;
          }
        });
      },
    );
  }

  String? _getCounterpartySubtitle(CounterpartyData c) {
    // Try to get country from additionalData
    final country = c.additionalData?['country'] as String?;
    if (country != null && country.isNotEmpty) {
      return country;
    }
    // Fallback to type if no country
    return c.type.isNotEmpty ? c.type : null;
  }

  Widget _buildCurrencyDropdown() {
    final currencyAsync = ref.watch(companyCurrenciesProvider);

    return currencyAsync.when(
      loading: () => TossDropdown<String>(
        label: 'Currency',
        items: const [],
        isLoading: true,
        isRequired: true,
        hint: 'Loading...',
      ),
      error: (error, _) => TossDropdown<String>(
        label: 'Currency',
        items: const [],
        isRequired: true,
        errorText: 'Failed to load',
        hint: 'Error loading currencies',
      ),
      data: (currencies) {
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
          items: currencies
              .map((c) => TossDropdownItem<String>(
                    value: c.id,
                    label: '${c.code} (${c.symbol})',
                    subtitle: c.fullName,
                  ))
              .toList(),
          onChanged: (v) {
            if (v == null) return;
            setState(() {
              _currencyId = v;
              _currencyError = null;
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

    final incotermItems = incoterms.isNotEmpty
        ? incoterms
            .map((i) => TossDropdownItem<String>(
                  value: i.code,
                  label: i.code,
                  subtitle: i.name,
                ))
            .toList()
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
            items: incotermItems,
            onChanged: (v) => setState(() => _incotermsCode = v),
            hint: 'Select',
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

  Widget _buildPaymentTermsDropdown() {
    final masterDataState = ref.watch(masterDataProvider);
    final paymentTerms = masterDataState.paymentTerms;

    final paymentTermItems = paymentTerms.isNotEmpty
        ? paymentTerms
            .map((p) => TossDropdownItem<String>(
                  value: p.code,
                  label: p.code,
                  subtitle: p.name,
                ))
            .toList()
        : ['T/T', 'L/C', 'D/P', 'D/A', 'CAD']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    return TossDropdown<String>(
      label: 'Payment Terms',
      value: _paymentTermsCode,
      items: paymentTermItems,
      onChanged: (v) => setState(() => _paymentTermsCode = v),
      hint: 'Select',
    );
  }

  Widget _buildBankAccountSelector() {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return const Text('No company selected');
    }

    final params = CashLocationQueryParams(
      companyId: companyId,
      locationType: 'bank',
    );

    final bankAccountsAsync = ref.watch(allCashLocationsProvider(params));

    return bankAccountsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Text(
        'Failed to load bank accounts: $error',
        style: TextStyle(color: TossColors.error),
      ),
      data: (bankAccounts) {
        if (bankAccounts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Text(
              'No bank accounts registered. Add bank accounts in Cash Location settings.',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
          );
        }

        final tossDropdownItems = bankAccounts.map((bank) {
          final primaryName = bank.locationName;
          final bankName = bank.bankName;
          final currencyCode = bank.currencyCode ?? '';

          String label = primaryName;
          if (currencyCode.isNotEmpty) {
            label = '$primaryName ($currencyCode)';
          }

          String? subtitle;
          if (bankName != null && bankName.isNotEmpty && bankName != primaryName) {
            subtitle = bankName;
          }

          return TossDropdownItem<String>(
            value: bank.locationId,
            label: label,
            subtitle: subtitle,
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TossDropdown<String>(
              label: '',
              hint: 'Select bank account',
              value: _selectedBankAccountIds.isNotEmpty ? _selectedBankAccountIds.first : null,
              items: tossDropdownItems,
              onChanged: (value) {
                setState(() {
                  _selectedBankAccountIds.clear();
                  if (value != null) {
                    _selectedBankAccountIds.add(value);
                  }
                });
              },
            ),
            // Show selected bank details
            if (_selectedBankAccountIds.isNotEmpty) ...[
              const SizedBox(height: TossSpacing.space3),
              Builder(
                builder: (context) {
                  final selectedBank = bankAccounts.firstWhere(
                    (b) => b.locationId == _selectedBankAccountIds.first,
                    orElse: () => bankAccounts.first,
                  );
                  return _buildBankDetailCard(selectedBank);
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildBankDetailCard(CashLocation bank) {
    final details = <MapEntry<String, String>>[];

    if (bank.bankName != null && bank.bankName!.isNotEmpty) {
      details.add(MapEntry('Bank Name', bank.bankName!));
    }
    if (bank.bankAccount != null && bank.bankAccount!.isNotEmpty) {
      details.add(MapEntry('Account No.', bank.bankAccount!));
    }
    if (bank.beneficiaryName != null && bank.beneficiaryName!.isNotEmpty) {
      details.add(MapEntry('Beneficiary', bank.beneficiaryName!));
    }
    if (bank.swiftCode != null && bank.swiftCode!.isNotEmpty) {
      details.add(MapEntry('SWIFT Code', bank.swiftCode!));
    }
    if (bank.bankBranch != null && bank.bankBranch!.isNotEmpty) {
      details.add(MapEntry('Branch', bank.bankBranch!));
    }
    if (bank.bankAddress != null && bank.bankAddress!.isNotEmpty) {
      details.add(MapEntry('Bank Address', bank.bankAddress!));
    }
    if (bank.currencyCode != null && bank.currencyCode!.isNotEmpty) {
      details.add(MapEntry('Currency', bank.currencyCode!));
    }
    if (bank.accountType != null && bank.accountType!.isNotEmpty) {
      details.add(MapEntry('Account Type', bank.accountType!));
    }

    if (details.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.border),
        ),
        child: Text(
          'No additional details available for this bank account.',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.asMap().entries.map((mapEntry) {
          final entry = mapEntry.value;
          final isLast = mapEntry.key == details.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : TossSpacing.space2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    entry.key,
                    style: TossTextStyles.label.copyWith(
                      color: TossColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value,
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemsSection() {
    final totalAmount = _calculateTotalAmount();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Items',
                  style: TossTextStyles.h4.copyWith(color: TossColors.gray900),
                ),
                const SizedBox(width: 2),
                Text(
                  '*',
                  style: TossTextStyles.h4.copyWith(color: TossColors.error),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Total: $_currencyCode ${NumberFormat('#,##0.00').format(totalAmount)}',
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: TossColors.primary),
                  onPressed: _addItem,
                ),
              ],
            ),
          ],
        ),
        if (_itemsError != null) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            _itemsError!,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
        const SizedBox(height: TossSpacing.space2),
        if (_items.isEmpty)
          _buildEmptyItemsPlaceholder()
        else
          ...List.generate(_items.length, (index) {
            final item = _items[index];
            return _POItemCard(
              item: item,
              index: index,
              currencyCode: _currencyCode,
              onEdit: () => _editItem(index),
              onDelete: () => _deleteItem(index),
            );
          }),
      ],
    );
  }

  Widget _buildEmptyItemsPlaceholder() {
    return GestureDetector(
      onTap: _addItem,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: _itemsError != null ? TossColors.error : TossColors.gray200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: TossColors.primary, size: 20),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Add items',
              style: TossTextStyles.body.copyWith(color: TossColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: TossColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          borderSide: BorderSide(color: TossColors.primary),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    DateTime? value,
    required Function(DateTime?) onChanged,
    bool isRequired = false,
    String? errorText,
  }) {
    return GestureDetector(
      onTap: () => _selectDate(
        initialDate: value,
        onSelected: onChanged,
      ),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: errorText != null ? TossColors.error : TossColors.gray200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                    ),
                    if (isRequired)
                      Text(
                        ' *',
                        style: TossTextStyles.caption.copyWith(color: TossColors.error),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  value != null ? DateFormat('yyyy-MM-dd').format(value) : 'Select date',
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: value != null ? TossColors.gray900 : TossColors.gray400,
                  ),
                ),
              ],
            ),
            Icon(Icons.calendar_today, size: 20, color: TossColors.gray400),
          ],
        ),
      ),
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

  // Helper methods
  double _calculateTotalAmount() {
    double total = 0;
    for (final item in _items) {
      total += item.quantity * item.unitPrice;
    }
    return total;
  }

  Future<void> _selectDate({
    DateTime? initialDate,
    required void Function(DateTime?) onSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  void _showCreateCounterpartySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const CounterPartyForm(),
        ),
      ),
    ).then((_) {
      // Refresh counterparties after bottom sheet closes
      ref.invalidate(currentCounterpartiesProvider);
    });
  }

  void _addItem() async {
    final result = await Navigator.push<List<TradeItem>>(
      context,
      MaterialPageRoute(
        builder: (context) => const TradeItemPickerPage(),
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      setState(() {
        for (final item in result) {
          _items.add(POItemFormData(
            productId: item.productId,
            description: item.description,
            sku: item.sku,
            hsCode: item.hsCode,
            quantity: item.quantity,
            unit: item.unit,
            unitPrice: item.unitPrice,
          ));
        }
        _itemsError = null;
      });
    }
  }

  void _editItem(int index) async {
    final item = _items[index];
    final initialTradeItem = TradeItem(
      productId: item.productId,
      description: item.description,
      sku: item.sku,
      hsCode: item.hsCode,
      countryOfOrigin: null,
      quantity: item.quantity,
      unit: item.unit,
      unitPrice: item.unitPrice,
      discountPercent: 0,
    );

    final result = await Navigator.push<List<TradeItem>>(
      context,
      MaterialPageRoute(
        builder: (context) => TradeItemPickerPage(
          initialItems: [initialTradeItem],
        ),
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      final editedItem = result.first;
      setState(() {
        _items[index] = POItemFormData(
          productId: editedItem.productId,
          description: editedItem.description,
          sku: editedItem.sku,
          hsCode: editedItem.hsCode,
          quantity: editedItem.quantity,
          unit: editedItem.unit,
          unitPrice: editedItem.unitPrice,
        );
      });
    }
  }

  void _deleteItem(int index) {
    setState(() => _items.removeAt(index));
  }

  bool _validateForm() {
    debugPrint('🔍 [POFormPage] _validateForm starting...');
    debugPrint('🔍 [POFormPage]   - buyerId: $_buyerId');
    debugPrint('🔍 [POFormPage]   - currencyId: $_currencyId');
    debugPrint('🔍 [POFormPage]   - items count: ${_items.length}');

    bool isValid = true;

    // Validate Buyer
    if (_buyerId == null || _buyerId!.isEmpty) {
      _buyerError = 'Please select a buyer';
      isValid = false;
      debugPrint('🔴 [POFormPage] Buyer validation FAILED');
    } else {
      _buyerError = null;
      debugPrint('✅ [POFormPage] Buyer validation OK');
    }

    // Validate Currency
    if (_currencyId == null || _currencyId!.isEmpty) {
      _currencyError = 'Please select a currency';
      isValid = false;
      debugPrint('🔴 [POFormPage] Currency validation FAILED');
    } else {
      _currencyError = null;
      debugPrint('✅ [POFormPage] Currency validation OK');
    }

    // Validate Items
    if (_items.isEmpty) {
      _itemsError = 'Please add at least one item';
      isValid = false;
      debugPrint('🔴 [POFormPage] Items validation FAILED');
    } else {
      _itemsError = null;
      debugPrint('✅ [POFormPage] Items validation OK');
    }

    debugPrint('🔍 [POFormPage] _validateForm result: $isValid');
    return isValid;
  }

  Future<void> _handleSave() async {
    debugPrint('🟢 [POFormPage] _handleSave called!');
    debugPrint('🟢 [POFormPage] Form validate result: ${_formKey.currentState!.validate()}');

    if (!_formKey.currentState!.validate()) {
      debugPrint('🔴 [POFormPage] Form validation failed - returning');
      return;
    }

    debugPrint('🟡 [POFormPage] Calling _validateForm...');
    final isValid = _validateForm();
    debugPrint('🟡 [POFormPage] _validateForm result: $isValid');
    if (!isValid) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final appState = ref.read(appStateProvider);
    debugPrint('🟢 [POFormPage] Creating POCreateParams...');

    final params = POCreateParams(
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
      counterpartyId: _buyerId,
      buyerPoNumber:
          _buyerPoNumberController.text.isNotEmpty ? _buyerPoNumberController.text : null,
      buyerInfo: _selectedBuyer != null
          ? {
              'name': _selectedBuyer!.name,
              'address': _selectedBuyer!.additionalData?['address'],
              'city': _selectedBuyer!.additionalData?['city'],
              'country': _selectedBuyer!.additionalData?['country'],
              'phone': _selectedBuyer!.phone,
              'email': _selectedBuyer!.email,
            }
          : null,
      currencyId: _currencyId,
      incotermsCode: _incotermsCode,
      incotermsPlace:
          _incotermsPlaceController.text.isNotEmpty ? _incotermsPlaceController.text : null,
      paymentTermsCode: _paymentTermsCode,
      orderDateUtc: _orderDate,
      requiredShipmentDateUtc: _requiredShipmentDate,
      partialShipmentAllowed: _partialShipmentAllowed,
      transshipmentAllowed: _transshipmentAllowed,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      bankAccountIds: _selectedBankAccountIds,
      items: _items
          .map((item) => POItemCreateParams(
                productId: item.productId,
                description: item.description,
                sku: item.sku,
                hsCode: item.hsCode,
                quantity: item.quantity,
                unit: item.unit,
                unitPrice: item.unitPrice,
              ))
          .toList(),
    );

    debugPrint('🚀 [POFormPage] Calling ${isEditMode ? 'update' : 'create'}...');
    final notifier = ref.read(poFormProvider.notifier);
    try {
      final po = isEditMode
          ? await notifier.update(widget.poId!, 1, {
              'buyer_id': _buyerId,
              'buyer_po_number':
                  _buyerPoNumberController.text.isNotEmpty ? _buyerPoNumberController.text : null,
              'currency_id': _currencyId,
              'incoterms_code': _incotermsCode,
              'incoterms_place':
                  _incotermsPlaceController.text.isNotEmpty ? _incotermsPlaceController.text : null,
              'payment_terms_code': _paymentTermsCode,
              'order_date_utc': _orderDate?.toIso8601String(),
              'required_shipment_date_utc': _requiredShipmentDate?.toIso8601String(),
              'partial_shipment_allowed': _partialShipmentAllowed,
              'transshipment_allowed': _transshipmentAllowed,
              'notes': _notesController.text.isNotEmpty ? _notesController.text : null,
              'bank_account_ids': _selectedBankAccountIds,
            })
          : await notifier.create(params);

      if (po != null && mounted) {
        debugPrint(
            '✅ [POFormPage] PO ${isEditMode ? 'updated' : 'created'} successfully! ID: ${po.id}');
        ref.read(poListProvider.notifier).refresh();
        context.go('/purchase-order/${po.id}');
      } else {
        final formState = ref.read(poFormProvider);
        final errorMessage = formState.error ?? 'Unknown error occurred';
        debugPrint('🔴 [POFormPage] PO ${isEditMode ? 'update' : 'create'} returned null');
        debugPrint('🔴 [POFormPage] Error from state: $errorMessage');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save PO: $errorMessage'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('🔴 [POFormPage] Error saving PO: $e');
      debugPrint('🔴 [POFormPage] StackTrace: $stackTrace');
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

// Item Form Data class
class POItemFormData {
  final String? productId;
  final String description;
  final String? sku;
  final String? hsCode;
  final double quantity;
  final String unit;
  final double unitPrice;

  POItemFormData({
    this.productId,
    required this.description,
    this.sku,
    this.hsCode,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
  });

  double get lineTotal => quantity * unitPrice;
}

// PO Item Card Widget
class _POItemCard extends StatelessWidget {
  final POItemFormData item;
  final int index;
  final String currencyCode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _POItemCard({
    required this.item,
    required this.index,
    required this.currencyCode,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    item.description,
                    style: TossTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: TossSpacing.space2),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 20, color: TossColors.error),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space2),
            Row(
              children: [
                if (item.sku != null && item.sku!.isNotEmpty) _buildChip('SKU: ${item.sku}'),
                if (item.hsCode != null && item.hsCode!.isNotEmpty) _buildChip('HS: ${item.hsCode}'),
              ],
            ),
            const SizedBox(height: TossSpacing.space2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${NumberFormat('#,##0.##').format(item.quantity)} ${item.unit} × $currencyCode ${NumberFormat('#,##0.00').format(item.unitPrice)}',
                  style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
                ),
                Text(
                  '$currencyCode ${NumberFormat('#,##0.00').format(item.lineTotal)}',
                  style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: TossSpacing.space2),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
      ),
    );
  }
}
