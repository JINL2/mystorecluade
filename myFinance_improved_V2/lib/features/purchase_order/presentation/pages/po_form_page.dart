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
import '../../../register_denomination/domain/entities/currency.dart';
import '../../../trade_shared/domain/entities/trade_item.dart';
import '../../../trade_shared/presentation/pages/trade_item_picker_page.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/repositories/po_repository.dart';
import '../providers/po_providers.dart';
import '../widgets/po_form/po_form_widgets.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
                  POBuyerSection(
                    buyerId: _buyerId,
                    errorText: _buyerError,
                    onBuyerChanged: (buyer) {
                      setState(() {
                        _buyerId = buyer?.id;
                        _selectedBuyer = buyer;
                        _buyerError = null;
                      });
                    },
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  _buildTextField(
                    controller: _buyerPoNumberController,
                    label: 'Buyer\'s PO Number (Optional)',
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Currency Section
                  _buildSectionTitle('Currency'),
                  const SizedBox(height: TossSpacing.space2),
                  POCurrencySection(
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
                  POShippingTermsSection(
                    incotermsCode: _incotermsCode,
                    incotermsPlaceController: _incotermsPlaceController,
                    paymentTermsCode: _paymentTermsCode,
                    onIncotermsChanged: (v) => setState(() => _incotermsCode = v),
                    onPaymentTermsChanged: (v) => setState(() => _paymentTermsCode = v),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  POShipmentOptionsSection(
                    partialShipmentAllowed: _partialShipmentAllowed,
                    transshipmentAllowed: _transshipmentAllowed,
                    onPartialShipmentChanged: (v) => setState(() => _partialShipmentAllowed = v),
                    onTransshipmentChanged: (v) => setState(() => _transshipmentAllowed = v),
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Bank Account Selection
                  _buildSectionTitle('Banking Information'),
                  const SizedBox(height: TossSpacing.space2),
                  POBankAccountSection(
                    selectedBankAccountIds: _selectedBankAccountIds,
                    onBankAccountsChanged: (ids) {
                      setState(() => _selectedBankAccountIds = ids);
                    },
                  ),
                  const SizedBox(height: TossSpacing.space5),

                  // Items Section
                  POItemsSection(
                    items: _items,
                    currencyCode: _currencyCode,
                    errorText: _itemsError,
                    onAddItem: _addItem,
                    onEditItem: _editItem,
                    onDeleteItem: _deleteItem,
                  ),
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
    required void Function(DateTime?) onChanged,
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
