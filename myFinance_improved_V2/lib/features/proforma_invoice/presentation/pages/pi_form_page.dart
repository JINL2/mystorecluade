import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../app/providers/app_state_provider.dart';
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
  final _counterpartyNameController = TextEditingController();
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
  String _currencyCode = 'USD';
  String? _incotermsCode;
  String? _paymentTermsCode;
  String? _shippingMethodCode;
  DateTime? _validityDate;
  DateTime? _estimatedShipmentDate;
  int? _leadTimeDays;
  bool _partialShipmentAllowed = true;
  bool _transshipmentAllowed = true;

  // Items
  List<PIItemFormData> _items = [];

  bool get isEditMode => widget.piId != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
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
    _counterpartyNameController.text = pi.counterpartyName ?? '';
    _counterpartyInfoController.text = _formatCounterpartyInfo(pi.counterpartyInfo);
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
    _counterpartyNameController.dispose();
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
                  _buildTextField(
                    controller: _counterpartyNameController,
                    label: 'Counterparty Name *',
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
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
                    onChanged: (d) => setState(() => _validityDate = d),
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
                  const SizedBox(height: TossSpacing.space3),
                  _buildTextField(
                    controller: _termsController,
                    label: 'Terms & Conditions',
                    maxLines: 4,
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
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: BorderSide(color: TossColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: BorderSide(color: TossColors.gray300),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    final currencies = ['USD', 'EUR', 'KRW', 'JPY', 'CNY', 'GBP'];

    return DropdownButtonFormField<String>(
      value: _currencyCode,
      decoration: InputDecoration(
        labelText: 'Currency',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
      ),
      items: currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: (v) => setState(() => _currencyCode = v ?? 'USD'),
    );
  }

  Widget _buildIncotermsRow() {
    final incoterms = ['FOB', 'CIF', 'CFR', 'EXW', 'DDP', 'DAP'];

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _incotermsCode,
            decoration: InputDecoration(
              labelText: 'Incoterms',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
            ),
            items: incoterms.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
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
    final paymentTerms = ['LC_AT_SIGHT', 'LC_USANCE', 'TT_ADVANCE', 'TT_AFTER', 'DA', 'DP'];

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _paymentTermsCode,
            decoration: InputDecoration(
              labelText: 'Payment Terms',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
            ),
            items: paymentTerms.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
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

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return InkWell(
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
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
          suffixIcon: const Icon(Icons.calendar_today, size: 20),
        ),
        child: Text(
          value != null ? DateFormat('yyyy-MM-dd').format(value) : '',
          style: TossTextStyles.bodyMedium,
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

  Widget _buildItemsSection() {
    final total = _items.fold<double>(
      0,
      (sum, item) => sum + (item.quantity * item.unitPrice * (1 - item.discountPercent / 100)),
    );

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
                    color: TossColors.gray500,
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
            TextButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Item'),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),

        if (_items.isEmpty)
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200, style: BorderStyle.solid),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.inventory_2_outlined, size: 40, color: TossColors.gray400),
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'No items added',
                    style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
                  ),
                ],
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
    final result = await showModalBottomSheet<PIItemFormData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ItemFormSheet(currencyCode: _currencyCode),
    );

    if (result != null) {
      setState(() => _items.add(result));
    }
  }

  void _editItem(int index) async {
    final result = await showModalBottomSheet<PIItemFormData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ItemFormSheet(
        currencyCode: _currencyCode,
        item: _items[index],
      ),
    );

    if (result != null) {
      setState(() => _items[index] = result);
    }
  }

  void _deleteItem(int index) {
    setState(() => _items.removeAt(index));
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
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

    final params = PICreateParams(
      companyId: companyId,
      storeId: null,
      counterpartyId: _counterpartyId,
      counterpartyInfo: _counterpartyInfoController.text.isNotEmpty
          ? {'address': _counterpartyInfoController.text}
          : null,
      currencyId: _currencyCode, // Using code as ID for simplicity
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
                padding: const EdgeInsets.all(4),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 18, color: TossColors.error),
                onPressed: onDelete,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
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

// Item Form Sheet
class _ItemFormSheet extends StatefulWidget {
  final String currencyCode;
  final PIItemFormData? item;

  const _ItemFormSheet({required this.currencyCode, this.item});

  @override
  State<_ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends State<_ItemFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _skuController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController(text: 'PCS');
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _descController.text = widget.item!.description;
      _skuController.text = widget.item!.sku ?? '';
      _quantityController.text = widget.item!.quantity.toString();
      _unitController.text = widget.item!.unit;
      _priceController.text = widget.item!.unitPrice.toString();
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _skuController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.item != null ? 'Edit Item' : 'Add Item',
                    style: TossTextStyles.h4,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space4),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: TossSpacing.space3),
              TextFormField(
                controller: _skuController,
                decoration: const InputDecoration(
                  labelText: 'SKU',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              // Quantity + Unit in separate fields instead of Row with Expanded
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity *',
                  border: const OutlineInputBorder(),
                  suffixText: _unitController.text,
                ),
                validator: (v) {
                  if (v?.isEmpty == true) return 'Required';
                  if (double.tryParse(v!) == null) return 'Invalid';
                  return null;
                },
              ),
              const SizedBox(height: TossSpacing.space3),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  border: OutlineInputBorder(),
                  hintText: 'e.g. PCS, KG, BOX',
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Unit Price (${widget.currencyCode}) *',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v?.isEmpty == true) return 'Required';
                  if (double.tryParse(v!) == null) return 'Invalid';
                  return null;
                },
              ),
              const SizedBox(height: TossSpacing.space5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  child: Text(widget.item != null ? 'Update' : 'Add'),
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final item = PIItemFormData(
      productId: widget.item?.productId,
      description: _descController.text,
      sku: _skuController.text.isNotEmpty ? _skuController.text : null,
      quantity: double.parse(_quantityController.text),
      unit: _unitController.text.isNotEmpty ? _unitController.text : 'PCS',
      unitPrice: double.parse(_priceController.text),
    );

    Navigator.pop(context, item);
  }
}
