import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/counterparty_provider.dart';
import '../../../register_denomination/presentation/providers/currency_providers.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import '../../../purchase_order/presentation/providers/po_providers.dart';
import '../../../cash_location/presentation/providers/cash_location_providers.dart';
import '../../domain/entities/letter_of_credit.dart';
import '../../domain/repositories/lc_repository.dart';
import '../providers/lc_providers.dart';
import '../providers/lc_master_data_providers.dart';
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
  // Issuing Bank: 구매자 은행 - 텍스트 입력 (ID 없음)
  // Advising Bank: 우리 은행 - cash_location 선택
  // Confirming Bank: 확인 은행 - 텍스트 입력 (선택사항)
  String? _advisingBankId; // Only advising bank uses cash_location
  Map<String, dynamic>? _issuingBankInfo;
  Map<String, dynamic>? _advisingBankInfo;
  Map<String, dynamic>? _confirmingBankInfo;
  Map<String, dynamic>? _beneficiaryInfo;
  Map<String, dynamic>? _applicantInfo; // From PO buyer_info

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
    // Load master data for dropdowns
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(masterDataProvider.notifier).loadAllMasterData();
    });

    if (_isEdit) {
      _loadExistingData();
    } else if (widget.poId != null) {
      _loadFromPO();
    } else {
      // Default expiry date 90 days from now
      _expiryDateUtc = DateTime.now().add(const Duration(days: 90));
      // Default required documents
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
        // Applicant from PO buyer
        _applicantId = po.buyerId;
        _applicantInfo = po.buyerInfo; // buyer_info → applicant_info

        // Currency and amount
        _currencyId = po.currencyId;
        _currencyCode = po.currencyCode;
        _amountController.text = po.totalAmount.toString();

        // Dates
        _expiryDateUtc = DateTime.now().add(const Duration(days: 90));
        _latestShipmentDateUtc = po.requiredShipmentDateUtc;

        // Trade terms from PO
        _incotermsCode = po.incotermsCode;
        _incotermsPlaceController.text = po.incotermsPlace ?? '';
        _paymentTermsCode = po.paymentTermsCode;
        _partialShipmentAllowed = po.partialShipmentAllowed;
        _transshipmentAllowed = po.transshipmentAllowed;

        // Advising Bank from PO (우리 은행)
        if (po.bankAccountIds.isNotEmpty) {
          _advisingBankId = po.bankAccountIds.first;
          // bankingInfo에서 해당 은행 정보 찾기
          if (po.bankingInfo != null && po.bankingInfo!.isNotEmpty) {
            _advisingBankInfo = po.bankingInfo!.first;
          }
        }

        // Note: Shipping info (port of loading/discharge, shipping method)
        // needs to be filled manually for LC - PO doesn't have these fields

        // Store PO/PI references
        _piId = po.piId;
        _poNumber = po.poNumber;
        _piNumber = po.piNumber;

        // Default required documents
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load PO data: $e')),
        );
      }
      // Set defaults even on error
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

      // Bank info
      // Advising bank uses cash_location
      _advisingBankId = lc.advisingBankId;
      _advisingBankInfo = lc.advisingBankInfo;

      // Issuing bank - populate text fields from JSONB
      _issuingBankInfo = lc.issuingBankInfo;
      if (lc.issuingBankInfo != null) {
        _issuingBankNameController.text = lc.issuingBankInfo!['name'] as String? ?? '';
        _issuingBankSwiftController.text = lc.issuingBankInfo!['swift'] as String? ?? '';
        _issuingBankAddressController.text = lc.issuingBankInfo!['address'] as String? ?? '';
      }

      // Confirming bank - populate text fields from JSONB
      _confirmingBankInfo = lc.confirmingBankInfo;
      if (lc.confirmingBankInfo != null) {
        _confirmingBankNameController.text = lc.confirmingBankInfo!['name'] as String? ?? '';
        _confirmingBankSwiftController.text = lc.confirmingBankInfo!['swift'] as String? ?? '';
      }

      _beneficiaryInfo = lc.beneficiaryInfo;

      // PO/PI references
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
    // Bank controllers
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
            _buildSection(
              'LC Type',
              [_buildLCTypeDropdown()],
            ),

            const SizedBox(height: TossSpacing.space4),

            // PO/PI Reference (if from PO)
            if (widget.poId != null || _poNumber != null) ...[
              _buildSection(
                'Reference',
                [
                  if (_poNumber != null)
                    _buildInfoRow('PO Number', _poNumber!),
                  if (_piNumber != null)
                    _buildInfoRow('PI Number', _piNumber!),
                ],
              ),
              const SizedBox(height: TossSpacing.space4),
            ],

            // Applicant (Buyer)
            _buildSection(
              'Applicant',
              [_buildApplicantDropdown()],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Issuing Bank Section (구매자 은행 - 텍스트 입력)
            _buildSection(
              'Issuing Bank (구매자 은행)',
              [
                _buildTextField('Bank Name *', _issuingBankNameController),
                const SizedBox(height: TossSpacing.space3),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField('SWIFT Code', _issuingBankSwiftController),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      flex: 2,
                      child: _buildTextField('Address', _issuingBankAddressController),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Advising Bank Section (우리 은행 - cash_location 선택)
            _buildSection(
              'Advising Bank (우리 은행)',
              [
                _buildBankDropdown('Select Bank Account *', _advisingBankId, (bank) {
                  setState(() {
                    _advisingBankId = bank?.locationId;
                    _advisingBankInfo = _cashLocationToBankInfo(bank);
                  });
                }),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Confirming Bank Section (선택사항)
            _buildSection(
              'Confirming Bank (선택사항)',
              [
                _buildTextField('Bank Name', _confirmingBankNameController),
                const SizedBox(height: TossSpacing.space3),
                _buildTextField('SWIFT Code', _confirmingBankSwiftController),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Amount Section
            _buildSection(
              'Amount',
              [
                _buildCurrencyDropdown(),
                const SizedBox(height: TossSpacing.space3),
                _buildAmountField(),
                const SizedBox(height: TossSpacing.space3),
                Row(
                  children: [
                    Expanded(child: _buildToleranceField('+', _tolerancePlusController)),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(child: _buildToleranceField('-', _toleranceMinusController)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Dates Section
            _buildSection(
              'Important Dates',
              [
                _buildDatePicker('Issue Date', _issueDateUtc, (date) {
                  setState(() => _issueDateUtc = date);
                }),
                const SizedBox(height: TossSpacing.space3),
                _buildDatePicker(
                  'Expiry Date *',
                  _expiryDateUtc,
                  (date) {
                    setState(() {
                      _expiryDateUtc = date;
                      _expiryError = null;
                    });
                  },
                  isRequired: true,
                  error: _expiryError,
                ),
                const SizedBox(height: TossSpacing.space3),
                _buildTextField('Expiry Place', _expiryPlaceController),
                const SizedBox(height: TossSpacing.space3),
                _buildDatePicker('Latest Shipment Date', _latestShipmentDateUtc, (date) {
                  setState(() => _latestShipmentDateUtc = date);
                }),
                const SizedBox(height: TossSpacing.space3),
                _buildTextField('Presentation Period (Days)', _presentationDaysController,
                    keyboardType: TextInputType.number),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Payment Terms Section
            _buildSection(
              'Payment Terms',
              [
                _buildPaymentTermsDropdown(),
                const SizedBox(height: TossSpacing.space3),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        'Usance Days',
                        _usanceDaysController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(child: _buildUsanceFromDropdown()),
                  ],
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Trade Terms Section
            _buildSection(
              'Trade Terms',
              [
                _buildIncotermsDropdown(),
                const SizedBox(height: TossSpacing.space3),
                _buildTextField('Incoterms Place', _incotermsPlaceController),
                const SizedBox(height: TossSpacing.space3),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField('Port of Loading', _portOfLoadingController),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: _buildTextField('Port of Discharge', _portOfDischargeController),
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space3),
                _buildShippingMethodDropdown(),
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
                    const SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: _buildSwitchTile(
                        'Transshipment',
                        _transshipmentAllowed,
                        (v) => setState(() => _transshipmentAllowed = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Required Documents Section
            _buildSection(
              'Required Documents',
              [
                ..._requiredDocuments.asMap().entries.map((entry) {
                  return _buildDocumentItem(entry.key, entry.value);
                }),
                const SizedBox(height: TossSpacing.space2),
                TextButton.icon(
                  onPressed: _addDocument,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Document'),
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Special Conditions
            _buildSection(
              'Special Conditions',
              [
                TextField(
                  controller: _specialConditionsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter special conditions...',
                    filled: true,
                    fillColor: TossColors.gray50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: BorderSide(color: TossColors.gray300),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Notes
            _buildSection(
              'Notes',
              [
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Internal notes...',
                    filled: true,
                    fillColor: TossColors.gray50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: BorderSide(color: TossColors.gray300),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray800,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TossTextStyles.bodyMedium.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Convert CashLocation to bank_info JSONB format for LC
  Map<String, dynamic>? _cashLocationToBankInfo(CashLocation? bank) {
    if (bank == null) return null;
    return {
      'name': bank.bankName ?? bank.locationName,
      if (bank.swiftCode != null) 'swift': bank.swiftCode,
      if (bank.bankAddress != null) 'address': bank.bankAddress,
      if (bank.bankAccount != null) 'account': bank.bankAccount,
      if (bank.beneficiaryName != null) 'beneficiary': bank.beneficiaryName,
      if (bank.bankBranch != null) 'branch': bank.bankBranch,
    };
  }

  Widget _buildBankDropdown(
    String label,
    String? selectedBankId,
    ValueChanged<CashLocation?> onChanged,
  ) {
    final appState = ref.watch(appStateProvider);
    final params = CashLocationQueryParams(
      companyId: appState.companyChoosen,
      locationType: 'bank',
    );
    final banksAsync = ref.watch(allCashLocationsProvider(params));

    return banksAsync.when(
      loading: () => TossDropdown<String>(
        label: label,
        items: const [],
        isLoading: true,
      ),
      error: (e, _) => TossDropdown<String>(
        label: label,
        items: const [],
        errorText: 'Failed to load banks',
      ),
      data: (banks) {
        if (banks.isEmpty) {
          return TossDropdown<String>(
            label: label,
            items: const [],
            hint: 'No bank accounts registered',
          );
        }

        return TossDropdown<String>(
          label: label,
          value: selectedBankId,
          hint: 'Select bank',
          items: banks
              .map((b) => TossDropdownItem<String>(
                    value: b.locationId,
                    label: b.locationName,
                    subtitle: b.swiftCode ?? b.bankName,
                  ))
              .toList(),
          onChanged: (v) {
            if (v == null) {
              onChanged(null);
            } else {
              final bank = banks.firstWhere((b) => b.locationId == v);
              onChanged(bank);
            }
          },
        );
      },
    );
  }

  Widget _buildLCTypeDropdown() {
    final lcTypesAsync = ref.watch(lcTypesProvider);

    return lcTypesAsync.when(
      loading: () => TossDropdown<String>(
        label: 'LC Type',
        items: const [],
        isLoading: true,
      ),
      error: (e, _) {
        // Fallback to hardcoded if DB fails
        final fallbackTypes = [
          TossDropdownItem(value: 'irrevocable', label: 'Irrevocable'),
          TossDropdownItem(value: 'confirmed', label: 'Confirmed'),
          TossDropdownItem(value: 'transferable', label: 'Transferable'),
          TossDropdownItem(value: 'revolving', label: 'Revolving'),
          TossDropdownItem(value: 'standby', label: 'Standby'),
        ];
        return TossDropdown<String>(
          label: 'LC Type',
          value: _lcTypeCode,
          hint: 'Select LC type',
          items: fallbackTypes,
          onChanged: (v) => setState(() => _lcTypeCode = v),
        );
      },
      data: (lcTypes) {
        return TossDropdown<String>(
          label: 'LC Type',
          value: _lcTypeCode,
          hint: 'Select LC type',
          items: lcTypes
              .map((t) => TossDropdownItem<String>(
                    value: t.code,
                    label: t.name,
                    subtitle: t.description,
                  ))
              .toList(),
          onChanged: (v) => setState(() => _lcTypeCode = v),
        );
      },
    );
  }

  Widget _buildApplicantDropdown() {
    final counterpartiesAsync = ref.watch(currentCounterpartiesProvider);

    return counterpartiesAsync.when(
      loading: () => TossDropdown<String>(
        label: 'Applicant (Buyer)',
        items: const [],
        isLoading: true,
        isRequired: true,
      ),
      error: (e, _) => TossDropdown<String>(
        label: 'Applicant (Buyer)',
        items: const [],
        errorText: 'Failed to load',
        isRequired: true,
      ),
      data: (counterparties) {
        return TossDropdown<String>(
          label: 'Applicant (Buyer)',
          value: _applicantId,
          hint: 'Select applicant',
          isRequired: true,
          errorText: _applicantError,
          items: counterparties
              .map((c) => TossDropdownItem<String>(
                    value: c.id,
                    label: c.name,
                    subtitle: c.additionalData?['country'] as String?,
                  ))
              .toList(),
          onChanged: (v) {
            setState(() {
              _applicantId = v;
              _applicantError = null;
            });
          },
        );
      },
    );
  }

  Widget _buildCurrencyDropdown() {
    final currencyAsync = ref.watch(companyCurrenciesProvider);

    return currencyAsync.when(
      loading: () => TossDropdown<String>(
        label: 'Currency',
        items: const [],
        isLoading: true,
      ),
      error: (e, _) => TossDropdown<String>(
        label: 'Currency',
        items: const [],
        errorText: 'Failed to load',
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
              final currency = currencies.firstWhere((c) => c.id == v);
              _currencyCode = currency.code;
            });
          },
        );
      },
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Amount *',
        prefixText: '$_currencyCode ',
        errorText: _amountError,
        filled: true,
        fillColor: TossColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: BorderSide(color: TossColors.gray300),
        ),
      ),
      onChanged: (_) => setState(() => _amountError = null),
    );
  }

  Widget _buildToleranceField(String prefix, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Tolerance $prefix%',
        suffixText: '%',
        filled: true,
        fillColor: TossColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: BorderSide(color: TossColors.gray300),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: TossColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: BorderSide(color: TossColors.gray300),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? value,
    ValueChanged<DateTime?> onChanged, {
    bool isRequired = false,
    String? error,
  }) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: error,
          filled: true,
          fillColor: TossColors.gray50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide(color: TossColors.gray300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value != null ? dateFormat.format(value) : 'Select date',
              style: TextStyle(
                color: value != null ? TossColors.gray800 : TossColors.gray500,
              ),
            ),
            Icon(Icons.calendar_today, size: 20, color: TossColors.gray400),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTermsDropdown() {
    final lcPaymentTermsAsync = ref.watch(lcPaymentTermsProvider);

    return lcPaymentTermsAsync.when(
      loading: () => TossDropdown<String>(
        label: 'Payment Terms (LC)',
        items: const [],
        isLoading: true,
      ),
      error: (e, _) {
        // Fallback to hardcoded LC terms
        final fallbackTerms = [
          TossDropdownItem(value: 'lc_at_sight', label: 'L/C At Sight'),
          TossDropdownItem(value: 'lc_usance_30', label: 'L/C Usance 30 Days'),
          TossDropdownItem(value: 'lc_usance_60', label: 'L/C Usance 60 Days'),
          TossDropdownItem(value: 'lc_usance_90', label: 'L/C Usance 90 Days'),
        ];
        return TossDropdown<String>(
          label: 'Payment Terms (LC)',
          value: _paymentTermsCode,
          items: fallbackTerms,
          onChanged: (v) => setState(() => _paymentTermsCode = v),
          hint: 'Select',
        );
      },
      data: (paymentTerms) {
        return TossDropdown<String>(
          label: 'Payment Terms (LC)',
          value: _paymentTermsCode,
          hint: 'Select LC payment term',
          items: paymentTerms
              .map((p) => TossDropdownItem<String>(
                    value: p.code,
                    label: p.name,
                    subtitle: p.description,
                  ))
              .toList(),
          onChanged: (v) => setState(() => _paymentTermsCode = v),
        );
      },
    );
  }

  Widget _buildUsanceFromDropdown() {
    final usanceFromOptions = [
      TossDropdownItem(value: 'bl_date', label: 'B/L Date'),
      TossDropdownItem(value: 'shipment_date', label: 'Shipment Date'),
      TossDropdownItem(value: 'sight', label: 'At Sight'),
    ];

    return TossDropdown<String>(
      label: 'Usance From',
      value: _usanceFrom,
      hint: 'Select',
      items: usanceFromOptions,
      onChanged: (v) => setState(() => _usanceFrom = v),
    );
  }

  Widget _buildIncotermsDropdown() {
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

    return TossDropdown<String>(
      label: 'Incoterms',
      value: _incotermsCode,
      items: incotermItems,
      onChanged: (v) => setState(() => _incotermsCode = v),
      hint: 'Select',
    );
  }

  Widget _buildShippingMethodDropdown() {
    final masterDataState = ref.watch(masterDataProvider);
    final shippingMethods = masterDataState.shippingMethods;

    final shippingItems = shippingMethods.isNotEmpty
        ? shippingMethods
            .map((m) => TossDropdownItem<String>(
                  value: m.code,
                  label: m.code,
                  subtitle: m.name,
                ))
            .toList()
        : ['SEA', 'AIR', 'RAIL', 'ROAD', 'MULTI']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    return TossDropdown<String>(
      label: 'Shipping Method',
      value: _shippingMethodCode,
      items: shippingItems,
      onChanged: (v) => setState(() => _shippingMethodCode = v),
      hint: 'Select',
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

  Widget _buildDocumentItem(int index, LCRequiredDocumentParams doc) {
    return Card(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: ListTile(
        title: Text(doc.name ?? doc.code),
        subtitle: Text('Original: ${doc.copiesOriginal}, Copy: ${doc.copiesCopy}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            setState(() => _requiredDocuments.removeAt(index));
          },
        ),
      ),
    );
  }

  void _addDocument() {
    showDialog(
      context: context,
      builder: (context) => _AddDocumentDialog(
        onAdd: (doc) {
          setState(() => _requiredDocuments.add(doc));
        },
      ),
    );
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

  Future<void> _save() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    try {
      final appState = ref.read(appStateProvider);

      // Build bank info from inputs
      final issuingBankInfo = _buildIssuingBankInfo();
      final confirmingBankInfo = _buildConfirmingBankInfo();

      final params = LCCreateParams(
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
        piId: _piId,
        poId: widget.poId,
        lcTypeCode: _lcTypeCode,
        applicantId: _applicantId,
        applicantInfo: _applicantInfo, // From PO buyer_info
        beneficiaryInfo: _beneficiaryInfo,
        issuingBankId: null, // Issuing bank is text entry, no ID
        issuingBankInfo: issuingBankInfo,
        advisingBankId: _advisingBankId,
        advisingBankInfo: _advisingBankInfo,
        confirmingBankId: null, // Confirming bank is text entry, no ID
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
        // For edit, we need to get current version and update
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _AddDocumentDialog extends StatefulWidget {
  final ValueChanged<LCRequiredDocumentParams> onAdd;

  const _AddDocumentDialog({required this.onAdd});

  @override
  State<_AddDocumentDialog> createState() => _AddDocumentDialogState();
}

class _AddDocumentDialogState extends State<_AddDocumentDialog> {
  String _code = '';
  String _name = '';
  int _original = 3;
  int _copy = 3;

  final _commonDocs = [
    {'code': 'BL', 'name': 'Bill of Lading'},
    {'code': 'AWB', 'name': 'Air Waybill'},
    {'code': 'CI', 'name': 'Commercial Invoice'},
    {'code': 'PL', 'name': 'Packing List'},
    {'code': 'CO', 'name': 'Certificate of Origin'},
    {'code': 'INS', 'name': 'Insurance Certificate'},
    {'code': 'CERT', 'name': 'Inspection Certificate'},
    {'code': 'PHY', 'name': 'Phytosanitary Certificate'},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Required Document'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Common documents dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Document Type'),
              items: [
                const DropdownMenuItem(value: '', child: Text('Custom...')),
                ..._commonDocs.map((d) => DropdownMenuItem(
                      value: d['code'],
                      child: Text('${d['code']} - ${d['name']}'),
                    )),
              ],
              onChanged: (v) {
                if (v != null && v.isNotEmpty) {
                  final doc = _commonDocs.firstWhere((d) => d['code'] == v);
                  setState(() {
                    _code = doc['code']!;
                    _name = doc['name']!;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Code'),
              controller: TextEditingController(text: _code),
              onChanged: (v) => _code = v,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: _name),
              onChanged: (v) => _name = v,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Original Copies'),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: '$_original'),
                    onChanged: (v) => _original = int.tryParse(v) ?? 3,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Copy Copies'),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: '$_copy'),
                    onChanged: (v) => _copy = int.tryParse(v) ?? 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_code.isNotEmpty) {
              widget.onAdd(LCRequiredDocumentParams(
                code: _code,
                name: _name.isNotEmpty ? _name : null,
                copiesOriginal: _original,
                copiesCopy: _copy,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
