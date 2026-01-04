import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_spacing.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../purchase_order/presentation/providers/po_providers.dart';
import '../../domain/entities/letter_of_credit.dart';
import '../../domain/repositories/lc_repository.dart';
import '../providers/lc_providers.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import '../widgets/lc_form/lc_form_widgets.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class LCFormPage extends ConsumerStatefulWidget {
  final String? lcId; // null for create, non-null for edit
  final String? poId; // If creating from PO

  const LCFormPage({super.key, this.lcId, this.poId});

  @override
  ConsumerState<LCFormPage> createState() => _LCFormPageState();
}

class _LCFormPageState extends ConsumerState<LCFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _tolerancePlusController = TextEditingController(text: '0');
  final _toleranceMinusController = TextEditingController(text: '0');
  final _expiryPlaceController = TextEditingController();
  final _presentationDaysController = TextEditingController(text: '21');
  final _usanceDaysController = TextEditingController();
  final _incotermsPlaceController = TextEditingController();
  final _portOfLoadingController = TextEditingController();
  final _portOfDischargeController = TextEditingController();
  final _specialConditionsController = TextEditingController();
  final _notesController = TextEditingController();

  // Bank text controllers (for manual entry)
  final _issuingBankNameController = TextEditingController();
  final _issuingBankSwiftController = TextEditingController();
  final _issuingBankAddressController = TextEditingController();
  final _confirmingBankNameController = TextEditingController();
  final _confirmingBankSwiftController = TextEditingController();

  // Form values
  String? _applicantId;
  String? _currencyId;
  String _currencyCode = 'USD';
  String? _lcTypeCode = 'irrevocable';
  String? _paymentTermsCode;
  String? _incotermsCode;
  String? _shippingMethodCode;
  String? _usanceFrom;
  DateTime? _issueDateUtc;
  DateTime? _expiryDateUtc;
  DateTime? _latestShipmentDateUtc;
  bool _partialShipmentAllowed = true;
  bool _transshipmentAllowed = true;
  bool _isLoading = false;

  // Bank IDs and info (JSONB)
  String? _advisingBankId;
  Map<String, dynamic>? _advisingBankInfo;
  Map<String, dynamic>? _beneficiaryInfo;
  Map<String, dynamic>? _applicantInfo;

  // PO/PI references
  String? _piId;
  String? _poNumber;
  String? _piNumber;

  // Required documents
  List<LCRequiredDocumentParams> _requiredDocuments = [];

  // Validation errors
  String? _applicantError;
  String? _amountError;
  String? _expiryError;

  bool get _isEdit => widget.lcId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(masterDataProvider.notifier).loadAllMasterData();
    });

    if (_isEdit) {
      _loadExistingData();
    } else if (widget.poId != null) {
      _loadFromPO();
    } else {
      _expiryDateUtc = DateTime.now().add(const Duration(days: 90));
      _requiredDocuments = [
        LCRequiredDocumentParams(
            code: 'BL', name: 'Bill of Lading', copiesOriginal: 3, copiesCopy: 3),
        LCRequiredDocumentParams(
            code: 'CI', name: 'Commercial Invoice', copiesOriginal: 3, copiesCopy: 3),
        LCRequiredDocumentParams(
            code: 'PL', name: 'Packing List', copiesOriginal: 3, copiesCopy: 3),
      ];
    }
  }

  Future<void> _loadExistingData() async {
    setState(() => _isLoading = true);
    try {
      final lc = await ref.read(lcRepositoryProvider).getById(widget.lcId!);
      _populateFromLC(lc);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadFromPO() async {
    if (widget.poId == null) return;

    setState(() => _isLoading = true);
    try {
      final poRepository = ref.read(poRepositoryProvider);
      final po = await poRepository.getById(widget.poId!);

      setState(() {
        _applicantId = po.buyerId;
        _applicantInfo = po.buyerInfo;
        _currencyId = po.currencyId;
        _currencyCode = po.currencyCode;
        _amountController.text = po.totalAmount.toString();
        _expiryDateUtc = DateTime.now().add(const Duration(days: 90));
        _latestShipmentDateUtc = po.requiredShipmentDateUtc;
        _incotermsCode = po.incotermsCode;
        _incotermsPlaceController.text = po.incotermsPlace ?? '';
        _paymentTermsCode = po.paymentTermsCode;
        _partialShipmentAllowed = po.partialShipmentAllowed;
        _transshipmentAllowed = po.transshipmentAllowed;

        if (po.bankAccountIds.isNotEmpty) {
          _advisingBankId = po.bankAccountIds.first;
          if (po.bankingInfo != null && po.bankingInfo!.isNotEmpty) {
            _advisingBankInfo = po.bankingInfo!.first;
          }
        }

        _piId = po.piId;
        _poNumber = po.poNumber;
        _piNumber = po.piNumber;

        _requiredDocuments = [
          LCRequiredDocumentParams(
              code: 'BL', name: 'Bill of Lading', copiesOriginal: 3, copiesCopy: 3),
          LCRequiredDocumentParams(
              code: 'CI', name: 'Commercial Invoice', copiesOriginal: 3, copiesCopy: 3),
          LCRequiredDocumentParams(
              code: 'PL', name: 'Packing List', copiesOriginal: 3, copiesCopy: 3),
        ];
      });
    } catch (e) {
      if (mounted) {
        TossToast.error(context, 'Failed to load PO data: $e');
      }
      setState(() {
        _expiryDateUtc = DateTime.now().add(const Duration(days: 90));
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _populateFromLC(LetterOfCredit lc) {
    setState(() {
      _applicantId = lc.applicantId;
      _currencyId = lc.currencyId;
      _currencyCode = lc.currencyCode;
      _lcTypeCode = lc.lcTypeCode;
      _amountController.text = lc.amount.toString();
      _tolerancePlusController.text = lc.tolerancePlusPercent.toString();
      _toleranceMinusController.text = lc.toleranceMinusPercent.toString();
      _issueDateUtc = lc.issueDateUtc;
      _expiryDateUtc = lc.expiryDateUtc;
      _expiryPlaceController.text = lc.expiryPlace ?? '';
      _latestShipmentDateUtc = lc.latestShipmentDateUtc;
      _presentationDaysController.text = lc.presentationPeriodDays.toString();
      _paymentTermsCode = lc.paymentTermsCode;
      _usanceDaysController.text = lc.usanceDays?.toString() ?? '';
      _usanceFrom = lc.usanceFrom;
      _incotermsCode = lc.incotermsCode;
      _incotermsPlaceController.text = lc.incotermsPlace ?? '';
      _portOfLoadingController.text = lc.portOfLoading ?? '';
      _portOfDischargeController.text = lc.portOfDischarge ?? '';
      _shippingMethodCode = lc.shippingMethodCode;
      _partialShipmentAllowed = lc.partialShipmentAllowed;
      _transshipmentAllowed = lc.transshipmentAllowed;

      _advisingBankId = lc.advisingBankId;
      _advisingBankInfo = lc.advisingBankInfo;

      if (lc.issuingBankInfo != null) {
        _issuingBankNameController.text = lc.issuingBankInfo!['name'] as String? ?? '';
        _issuingBankSwiftController.text = lc.issuingBankInfo!['swift'] as String? ?? '';
        _issuingBankAddressController.text = lc.issuingBankInfo!['address'] as String? ?? '';
      }

      if (lc.confirmingBankInfo != null) {
        _confirmingBankNameController.text = lc.confirmingBankInfo!['name'] as String? ?? '';
        _confirmingBankSwiftController.text = lc.confirmingBankInfo!['swift'] as String? ?? '';
      }

      _beneficiaryInfo = lc.beneficiaryInfo;
      _piId = lc.piId;
      _poNumber = lc.poNumber;
      _piNumber = lc.piNumber;

      _specialConditionsController.text = lc.specialConditions ?? '';
      _notesController.text = lc.notes ?? '';
      _requiredDocuments = lc.requiredDocuments
          .map((d) => LCRequiredDocumentParams(
                code: d.code,
                name: d.name,
                copiesOriginal: d.copiesOriginal,
                copiesCopy: d.copiesCopy,
                notes: d.notes,
              ))
          .toList();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _tolerancePlusController.dispose();
    _toleranceMinusController.dispose();
    _expiryPlaceController.dispose();
    _presentationDaysController.dispose();
    _usanceDaysController.dispose();
    _incotermsPlaceController.dispose();
    _portOfLoadingController.dispose();
    _portOfDischargeController.dispose();
    _specialConditionsController.dispose();
    _notesController.dispose();
    _issuingBankNameController.dispose();
    _issuingBankSwiftController.dispose();
    _issuingBankAddressController.dispose();
    _confirmingBankNameController.dispose();
    _confirmingBankSwiftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return TossScaffold(
        appBar: TossAppBar(
          title: _isEdit ? 'Edit LC' : 'New LC',
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: const TossLoadingView(message: 'Loading...'),
      );
    }

    return TossScaffold(
      appBar: TossAppBar(
        title: _isEdit ? 'Edit LC' : 'New Letter of Credit',
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        primaryActionIcon: Icons.check,
        primaryActionText: 'Save',
        onPrimaryAction: _save,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(TossSpacing.space4),
          children: [
            // LC Type
            LCFormSection(
              title: 'LC Type',
              children: [
                LCTypeSection(
                  lcTypeCode: _lcTypeCode,
                  onLCTypeChanged: (v) => setState(() => _lcTypeCode = v),
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // PO/PI Reference (if from PO)
            if (widget.poId != null || _poNumber != null) ...[
              LCFormSection(
                title: 'Reference',
                children: [
                  if (_poNumber != null) LCInfoRow(label: 'PO Number', value: _poNumber!),
                  if (_piNumber != null) LCInfoRow(label: 'PI Number', value: _piNumber!),
                ],
              ),
              const SizedBox(height: TossSpacing.space4),
            ],

            // Applicant (Buyer)
            LCFormSection(
              title: 'Applicant',
              children: [
                LCApplicantSection(
                  applicantId: _applicantId,
                  errorText: _applicantError,
                  onApplicantChanged: (v) {
                    setState(() {
                      _applicantId = v;
                      _applicantError = null;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Issuing Bank Section
            LCFormSection(
              title: 'Issuing Bank (Buyer\'s Bank)',
              children: [
                LCIssuingBankSection(
                  nameController: _issuingBankNameController,
                  swiftController: _issuingBankSwiftController,
                  addressController: _issuingBankAddressController,
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Advising Bank Section
            LCFormSection(
              title: 'Advising Bank (Our Bank)',
              children: [
                LCAdvisingBankSection(
                  advisingBankId: _advisingBankId,
                  onBankChanged: (result) {
                    setState(() {
                      _advisingBankId = result.$1;
                      _advisingBankInfo = result.$2;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Confirming Bank Section
            LCFormSection(
              title: 'Confirming Bank (Optional)',
              children: [
                LCConfirmingBankSection(
                  nameController: _confirmingBankNameController,
                  swiftController: _confirmingBankSwiftController,
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Amount Section
            LCFormSection(
              title: 'Amount',
              children: [
                LCAmountSection(
                  currencyId: _currencyId,
                  currencyCode: _currencyCode,
                  amountController: _amountController,
                  tolerancePlusController: _tolerancePlusController,
                  toleranceMinusController: _toleranceMinusController,
                  amountError: _amountError,
                  onCurrencyChanged: (currency) {
                    if (currency != null) {
                      setState(() {
                        _currencyId = currency.id;
                        _currencyCode = currency.code;
                      });
                    }
                  },
                  onAmountChanged: () => setState(() => _amountError = null),
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Dates Section
            LCFormSection(
              title: 'Important Dates',
              children: [
                LCDatesSection(
                  issueDate: _issueDateUtc,
                  expiryDate: _expiryDateUtc,
                  latestShipmentDate: _latestShipmentDateUtc,
                  expiryPlaceController: _expiryPlaceController,
                  presentationDaysController: _presentationDaysController,
                  expiryError: _expiryError,
                  onIssueDateChanged: (date) => setState(() => _issueDateUtc = date),
                  onExpiryDateChanged: (date) {
                    setState(() {
                      _expiryDateUtc = date;
                      _expiryError = null;
                    });
                  },
                  onLatestShipmentDateChanged: (date) =>
                      setState(() => _latestShipmentDateUtc = date),
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Payment Terms Section
            LCFormSection(
              title: 'Payment Terms',
              children: [
                LCPaymentTermsSection(
                  paymentTermsCode: _paymentTermsCode,
                  usanceDaysController: _usanceDaysController,
                  usanceFrom: _usanceFrom,
                  onPaymentTermsChanged: (v) => setState(() => _paymentTermsCode = v),
                  onUsanceFromChanged: (v) => setState(() => _usanceFrom = v),
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Trade Terms Section
            LCFormSection(
              title: 'Trade Terms',
              children: [
                LCTradeTermsSection(
                  incotermsCode: _incotermsCode,
                  incotermsPlaceController: _incotermsPlaceController,
                  portOfLoadingController: _portOfLoadingController,
                  portOfDischargeController: _portOfDischargeController,
                  shippingMethodCode: _shippingMethodCode,
                  partialShipmentAllowed: _partialShipmentAllowed,
                  transshipmentAllowed: _transshipmentAllowed,
                  onIncotermsChanged: (v) => setState(() => _incotermsCode = v),
                  onShippingMethodChanged: (v) => setState(() => _shippingMethodCode = v),
                  onPartialShipmentChanged: (v) => setState(() => _partialShipmentAllowed = v),
                  onTransshipmentChanged: (v) => setState(() => _transshipmentAllowed = v),
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Required Documents Section
            LCFormSection(
              title: 'Required Documents',
              children: [
                LCRequiredDocumentsSection(
                  requiredDocuments: _requiredDocuments,
                  onDocumentsChanged: (docs) => setState(() => _requiredDocuments = docs),
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Special Conditions
            LCFormSection(
              title: 'Special Conditions',
              children: [
                TossTextField.filled(
                  controller: _specialConditionsController,
                  hintText: 'Enter special conditions...',
                  maxLines: 4,
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Notes
            LCFormSection(
              title: 'Notes',
              children: [
                TossTextField.filled(
                  controller: _notesController,
                  hintText: 'Internal notes...',
                  maxLines: 3,
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  /// Build issuing bank info from text controllers
  Map<String, dynamic>? _buildIssuingBankInfo() {
    final name = _issuingBankNameController.text.trim();
    if (name.isEmpty) return null;
    return {
      'name': name,
      if (_issuingBankSwiftController.text.trim().isNotEmpty)
        'swift': _issuingBankSwiftController.text.trim(),
      if (_issuingBankAddressController.text.trim().isNotEmpty)
        'address': _issuingBankAddressController.text.trim(),
    };
  }

  /// Build confirming bank info from text controllers
  Map<String, dynamic>? _buildConfirmingBankInfo() {
    final name = _confirmingBankNameController.text.trim();
    if (name.isEmpty) return null;
    return {
      'name': name,
      if (_confirmingBankSwiftController.text.trim().isNotEmpty)
        'swift': _confirmingBankSwiftController.text.trim(),
    };
  }

  bool _validate() {
    bool isValid = true;

    if (_applicantId == null) {
      _applicantError = 'Applicant is required';
      isValid = false;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _amountError = 'Valid amount is required';
      isValid = false;
    }

    if (_expiryDateUtc == null) {
      _expiryError = 'Expiry date is required';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  Future<void> _save() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    try {
      final appState = ref.read(appStateProvider);
      final issuingBankInfo = _buildIssuingBankInfo();
      final confirmingBankInfo = _buildConfirmingBankInfo();

      final params = LCCreateParams(
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
        piId: _piId,
        poId: widget.poId,
        lcTypeCode: _lcTypeCode,
        applicantId: _applicantId,
        applicantInfo: _applicantInfo,
        beneficiaryInfo: _beneficiaryInfo,
        issuingBankId: null,
        issuingBankInfo: issuingBankInfo,
        advisingBankId: _advisingBankId,
        advisingBankInfo: _advisingBankInfo,
        confirmingBankId: null,
        confirmingBankInfo: confirmingBankInfo,
        currencyId: _currencyId,
        amount: double.parse(_amountController.text),
        tolerancePlusPercent: double.tryParse(_tolerancePlusController.text) ?? 0,
        toleranceMinusPercent: double.tryParse(_toleranceMinusController.text) ?? 0,
        issueDateUtc: _issueDateUtc,
        expiryDateUtc: _expiryDateUtc!,
        expiryPlace: _expiryPlaceController.text.isNotEmpty
            ? _expiryPlaceController.text
            : null,
        latestShipmentDateUtc: _latestShipmentDateUtc,
        presentationPeriodDays: int.tryParse(_presentationDaysController.text) ?? 21,
        paymentTermsCode: _paymentTermsCode,
        usanceDays: int.tryParse(_usanceDaysController.text),
        usanceFrom: _usanceFrom,
        incotermsCode: _incotermsCode,
        incotermsPlace: _incotermsPlaceController.text.isNotEmpty
            ? _incotermsPlaceController.text
            : null,
        portOfLoading: _portOfLoadingController.text.isNotEmpty
            ? _portOfLoadingController.text
            : null,
        portOfDischarge: _portOfDischargeController.text.isNotEmpty
            ? _portOfDischargeController.text
            : null,
        shippingMethodCode: _shippingMethodCode,
        partialShipmentAllowed: _partialShipmentAllowed,
        transshipmentAllowed: _transshipmentAllowed,
        requiredDocuments: _requiredDocuments,
        specialConditions: _specialConditionsController.text.isNotEmpty
            ? _specialConditionsController.text
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      final notifier = ref.read(lcFormNotifierProvider.notifier);

      if (_isEdit) {
        final currentLC =
            await ref.read(lcRepositoryProvider).getById(widget.lcId!);
        await notifier.update(widget.lcId!, currentLC.version, {
          'lc_type_code': params.lcTypeCode,
          'applicant_id': params.applicantId,
          'issuing_bank_id': params.issuingBankId,
          'issuing_bank_info': params.issuingBankInfo,
          'advising_bank_id': params.advisingBankId,
          'advising_bank_info': params.advisingBankInfo,
          'confirming_bank_id': params.confirmingBankId,
          'confirming_bank_info': params.confirmingBankInfo,
          'currency_id': params.currencyId,
          'amount': params.amount,
          'tolerance_plus_percent': params.tolerancePlusPercent,
          'tolerance_minus_percent': params.toleranceMinusPercent,
          'issue_date_utc': params.issueDateUtc?.toIso8601String(),
          'expiry_date_utc': params.expiryDateUtc.toIso8601String(),
          'expiry_place': params.expiryPlace,
          'latest_shipment_date_utc':
              params.latestShipmentDateUtc?.toIso8601String(),
          'presentation_period_days': params.presentationPeriodDays,
          'payment_terms_code': params.paymentTermsCode,
          'usance_days': params.usanceDays,
          'usance_from': params.usanceFrom,
          'incoterms_code': params.incotermsCode,
          'incoterms_place': params.incotermsPlace,
          'port_of_loading': params.portOfLoading,
          'port_of_discharge': params.portOfDischarge,
          'shipping_method_code': params.shippingMethodCode,
          'partial_shipment_allowed': params.partialShipmentAllowed,
          'transshipment_allowed': params.transshipmentAllowed,
          'required_documents':
              params.requiredDocuments.map((d) => d.toJson()).toList(),
          'special_conditions': params.specialConditions,
          'notes': params.notes,
        });
      } else {
        await notifier.create(params);
      }

      if (mounted) {
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        TossToast.error(context, 'Failed to save: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
