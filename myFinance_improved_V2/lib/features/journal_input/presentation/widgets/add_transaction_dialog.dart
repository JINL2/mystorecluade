import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/monitoring/sentry_config.dart';
import '../providers/journal_input_providers.dart';
import 'package:myfinance_improved/shared/widgets/selectors/exchange_rate/index.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../domain/entities/transaction_line.dart';
import '../../../../core/domain/entities/selector_entities.dart';

// Extracted widgets
import 'add_transaction/add_transaction_widgets.dart';

class AddTransactionDialog extends ConsumerStatefulWidget {
  final TransactionLine? existingLine;
  final bool? initialIsDebit;
  final double? suggestedAmount;
  final Set<String>? blockedCashLocationIds;

  const AddTransactionDialog({
    super.key,
    this.existingLine,
    this.initialIsDebit,
    this.suggestedAmount,
    this.blockedCashLocationIds,
  });

  @override
  ConsumerState<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  late bool _isDebit;
  String? _selectedAccountId;
  String? _selectedAccountName;
  String? _selectedCategoryTag;
  String? _selectedCounterpartyId;
  bool _hasMultipleCurrencies = false;
  String? _selectedCounterpartyName;
  String? _selectedCounterpartyStoreId;
  String? _selectedCounterpartyStoreName;
  String? _selectedCashLocationId;
  String? _selectedCashLocationName;
  String? _selectedCashLocationType;
  String? _selectedCounterpartyCashLocationId;
  String? _linkedCompanyId;
  bool _isInternal = false;

  // Debt fields
  String? _debtCategory;
  final _interestRateController = TextEditingController();
  DateTime? _issueDate;
  DateTime? _dueDate;
  final _debtDescriptionController = TextEditingController();

  // Fixed asset fields
  final _fixedAssetNameController = TextEditingController();
  final _salvageValueController = TextEditingController();
  DateTime? _acquisitionDate;
  final _usefulLifeController = TextEditingController();

  // Common fields
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Focus nodes for keyboard navigation
  final _amountFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _interestRateFocusNode = FocusNode();

  // Account mapping
  Map<String, dynamic>? _accountMapping;
  String? _mappingError;

  @override
  void initState() {
    super.initState();
    _checkForMultipleCurrencies();
    _initializeFromExistingLine();
  }

  void _initializeFromExistingLine() {
    if (widget.existingLine != null) {
      final line = widget.existingLine!;
      _isDebit = line.isDebit;
      _selectedAccountId = line.accountId;
      _selectedAccountName = line.accountName;
      _selectedCategoryTag = line.categoryTag;
      _selectedCounterpartyId = line.counterpartyId;
      _selectedCounterpartyName = line.counterpartyName;
      _selectedCounterpartyStoreId = line.counterpartyStoreId;
      _selectedCounterpartyStoreName = line.counterpartyStoreName;
      _selectedCashLocationId = line.cashLocationId;
      _selectedCashLocationName = line.cashLocationName;
      _selectedCashLocationType = line.cashLocationType;
      _selectedCounterpartyCashLocationId = line.counterpartyCashLocationId;

      final formatter = NumberFormat('#,##0.##', 'en_US');
      _amountController.text = formatter.format(line.amount);
      _descriptionController.text = line.description ?? '';

      if (_selectedCounterpartyId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _loadCounterpartyDetails();
        });
      }

      // Debt fields
      _debtCategory = line.debtCategory;
      _interestRateController.text = (line.interestRate ?? 0).toString();
      _issueDate = line.issueDate;
      _dueDate = line.dueDate;
      _debtDescriptionController.text = line.debtDescription ?? '';

      // Fixed asset fields
      _fixedAssetNameController.text = line.fixedAssetName ?? '';
      _salvageValueController.text = (line.salvageValue ?? 0).toString();
      _acquisitionDate = line.acquisitionDate;
      _usefulLifeController.text = (line.usefulLife ?? 5).toString();

      _accountMapping = line.accountMapping;
    } else {
      _isDebit = widget.initialIsDebit ?? true;
      _issueDate = DateTime.now();
      _dueDate = null;
      _acquisitionDate = DateTime.now();
      _interestRateController.text = '0';

      if (widget.suggestedAmount != null) {
        final formatter = NumberFormat('#,##0.##', 'en_US');
        _amountController.text = formatter.format(widget.suggestedAmount);
      }
    }
  }

  Future<void> _checkForMultipleCurrencies() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      setState(() => _hasMultipleCurrencies = false);
      return;
    }

    try {
      final exchangeRatesData = await ref.read(
        calculatorExchangeRateDataProvider(CalculatorExchangeRateParams(companyId: companyId)).future,
      );

      final exchangeRates = exchangeRatesData['exchange_rates'] as List? ?? [];
      setState(() => _hasMultipleCurrencies = exchangeRates.length > 1);
    } catch (e) {
      setState(() => _hasMultipleCurrencies = false);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _interestRateController.dispose();
    _debtDescriptionController.dispose();
    _fixedAssetNameController.dispose();
    _salvageValueController.dispose();
    _usefulLifeController.dispose();
    _amountFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _interestRateFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadCounterpartyDetails() async {
    if (_selectedCounterpartyId == null) return;

    try {
      final appState = ref.read(appStateProvider);
      final counterparties = await ref.read(journalCounterpartiesProvider(appState.companyChoosen).future);
      final counterparty = counterparties.firstWhere(
        (Map<String, dynamic> c) => c['counterparty_id'] == _selectedCounterpartyId,
        orElse: () => <String, dynamic>{},
      );

      if (counterparty.isNotEmpty) {
        setState(() {
          _linkedCompanyId = counterparty['linked_company_id']?.toString();
          _isInternal = counterparty['is_internal'] == true;
        });
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AddTransaction: Failed to load counterparty details',
        extra: {'counterpartyId': _selectedCounterpartyId},
      );

      if (mounted) {
        TossToast.error(context, 'Failed to load counterparty details');
      }
    }
  }

  Future<void> _checkAccountMapping() async {
    if (_selectedAccountId == null ||
        _selectedCounterpartyId == null ||
        !_isInternal ||
        (_selectedCategoryTag != 'payable' && _selectedCategoryTag != 'receivable')) {
      setState(() {
        _accountMapping = null;
        _mappingError = null;
      });
      return;
    }

    setState(() => _mappingError = null);

    try {
      final appState = ref.read(appStateProvider);
      final mapping = await ref.read(journalActionsNotifierProvider.notifier).checkAccountMapping(
        companyId: appState.companyChoosen,
        counterpartyId: _selectedCounterpartyId!,
        accountId: _selectedAccountId!,
      );

      setState(() {
        _accountMapping = mapping;
        if (mapping == null) {
          _mappingError = 'Account mapping required for internal transactions';
          _showMappingRequiredDialog();
        }
      });
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AddTransaction: Failed to check account mapping',
        extra: {
          'accountId': _selectedAccountId,
          'counterpartyId': _selectedCounterpartyId,
        },
      );
      setState(() => _mappingError = 'Error checking account mapping');
    }
  }

  void _showMappingRequiredDialog() {
    MappingRequiredDialog.show(
      context: context,
      counterpartyId: _selectedCounterpartyId,
      counterpartyName: _selectedCounterpartyName,
      onSetupPressed: () {
        Navigator.of(context).pop();
        if (_selectedCounterpartyId != null && _selectedCounterpartyName != null) {
          context.pushNamed(
            'debtAccountSettings',
            pathParameters: {
              'counterpartyId': _selectedCounterpartyId!,
              'name': _selectedCounterpartyName!,
            },
          );
        }
      },
      onCancelPressed: () {
        setState(() {
          _selectedCounterpartyId = null;
          _selectedCounterpartyName = null;
          _selectedCounterpartyStoreId = null;
          _selectedCounterpartyStoreName = null;
          _linkedCompanyId = null;
          _isInternal = false;
        });
      },
    );
  }

  void _showNumberpadModal() {
    if (!mounted) return;

    TossCurrencyExchangeModal.show(
      context: context,
      title: 'Enter Amount',
      initialValue: _amountController.text.isEmpty
        ? null
        : _amountController.text.replaceAll(',', ''),
      allowDecimal: true,
      onConfirm: (result) {
        if (!mounted) return;
        final formatter = NumberFormat('#,##0.##', 'en_US');
        final numericValue = double.tryParse(result) ?? 0;
        _amountController.text = formatter.format(numericValue);
      },
    );
  }

  void _showExchangeRateCalculator() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black.withOpacity(0.5),
      isDismissible: true,
      enableDrag: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: ExchangeRateCalculator(
          initialAmount: _amountController.text.replaceAll(',', ''),
          onAmountSelected: (amount) {
            final formatter = NumberFormat('#,##0.##', 'en_US');
            final numericValue = double.tryParse(amount) ?? 0;
            setState(() {
              _amountController.text = formatter.format(numericValue);
            });
          },
        ),
      ),
    );
  }

  void _saveTransaction() {
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0;

    if (_selectedAccountId == null || amount <= 0) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Invalid Input',
          message: 'Please select an account and enter a valid amount',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }

    if (_isInternal &&
        (_selectedCategoryTag == 'payable' || _selectedCategoryTag == 'receivable') &&
        _accountMapping == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Mapping Required',
          message: 'Account mapping is required for this internal transaction',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }

    final transactionLine = TransactionLine(
      accountId: _selectedAccountId,
      accountName: _selectedAccountName,
      categoryTag: _selectedCategoryTag,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      amount: amount,
      isDebit: _isDebit,
      counterpartyId: _selectedCounterpartyId,
      counterpartyName: _selectedCounterpartyName,
      counterpartyStoreId: _selectedCounterpartyStoreId,
      counterpartyStoreName: _selectedCounterpartyStoreName,
      cashLocationId: _selectedCashLocationId,
      cashLocationName: _selectedCashLocationName,
      cashLocationType: _selectedCashLocationType,
      linkedCompanyId: _linkedCompanyId,
      counterpartyCashLocationId: _selectedCounterpartyCashLocationId,
      debtCategory: _debtCategory,
      interestRate: double.tryParse(_interestRateController.text),
      issueDate: _issueDate,
      dueDate: _dueDate,
      debtDescription: _debtDescriptionController.text.isNotEmpty ? _debtDescriptionController.text : null,
      fixedAssetName: _fixedAssetNameController.text.isNotEmpty ? _fixedAssetNameController.text : null,
      salvageValue: double.tryParse(_salvageValueController.text),
      acquisitionDate: _acquisitionDate,
      usefulLife: int.tryParse(_usefulLifeController.text),
      accountMapping: _accountMapping,
    );

    Navigator.of(context).pop(transactionLine);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              DialogHeader(isEditing: widget.existingLine != null),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(TossSpacing.space5).copyWith(
                    bottom: TossSpacing.space5 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Transaction Type Toggle
                      const SectionTitle(title: 'Transaction Type'),
                      const SizedBox(height: TossSpacing.space2),
                      DebitCreditToggle(
                        isDebit: _isDebit,
                        onChanged: (isDebit) => setState(() => _isDebit = isDebit),
                      ),

                      const SizedBox(height: TossSpacing.space5),

                      // Account Selection
                      _buildAccountSelector(),

                      // Cash Location Section (for cash accounts)
                      if (_selectedCategoryTag == 'cash') ...[
                        const SizedBox(height: TossSpacing.space5),
                        CashLocationSection(
                          selectedLocationId: _selectedCashLocationId,
                          blockedLocationIds: widget.blockedCashLocationIds,
                          onCashLocationSelected: (cashLocation) {
                            setState(() {
                              _selectedCashLocationId = cashLocation.id;
                              _selectedCashLocationName = cashLocation.name;
                              _selectedCashLocationType = cashLocation.type;
                            });
                          },
                          onLocationIdChanged: (locationId) {
                            if (locationId == null) {
                              setState(() {
                                _selectedCashLocationId = null;
                                _selectedCashLocationName = null;
                                _selectedCashLocationType = null;
                              });
                            }
                          },
                        ),
                      ],

                      // Payable/Receivable specific fields
                      if (_isPayableOrReceivable) ...[
                        const SizedBox(height: TossSpacing.space5),
                        _buildCounterpartySection(),

                        // Debt Information
                        const SizedBox(height: TossSpacing.space5),
                        DebtInformationSection(
                          selectedDebtCategory: _debtCategory,
                          interestRateController: _interestRateController,
                          interestRateFocusNode: _interestRateFocusNode,
                          issueDate: _issueDate,
                          dueDate: _dueDate,
                          onDebtCategoryChanged: (value) => setState(() => _debtCategory = value),
                          onIssueDateChanged: (date) => setState(() => _issueDate = date),
                          onDueDateChanged: (date) => setState(() => _dueDate = date),
                          onInterestRateSubmitted: () => _amountFocusNode.requestFocus(),
                        ),
                      ],

                      // Amount Section
                      const SizedBox(height: TossSpacing.space5),
                      AmountInputSection(
                        controller: _amountController,
                        focusNode: _amountFocusNode,
                        hasMultipleCurrencies: _hasMultipleCurrencies,
                        onAmountTap: _showNumberpadModal,
                        onCalculatorTap: _showExchangeRateCalculator,
                      ),

                      // Description Section
                      const SizedBox(height: TossSpacing.space5),
                      DescriptionInputSection(
                        controller: _descriptionController,
                        focusNode: _descriptionFocusNode,
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              DialogFooter(
                isEditing: widget.existingLine != null,
                onSave: _saveTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _isPayableOrReceivable {
    final tag = _selectedCategoryTag?.toLowerCase();
    return tag == 'payable' || tag == 'receivable';
  }

  Widget _buildAccountSelector() {
    return EnhancedAccountSelector(
      selectedAccountId: _selectedAccountId,
      contextType: 'journal_entry',
      onAccountSelected: (account) {
        setState(() {
          _selectedAccountId = account.id;
          _selectedAccountName = account.name;
          _selectedCategoryTag = account.categoryTag;
          // Reset all dependent fields when account changes
          _selectedCashLocationId = null;
          _selectedCounterpartyId = null;
          _selectedCounterpartyName = null;
          _selectedCounterpartyStoreId = null;
          _selectedCounterpartyStoreName = null;
          _linkedCompanyId = null;
          _isInternal = false;
          _accountMapping = null;
          _mappingError = null;
        });
      },
      label: 'Account',
      hint: 'Select account',
      showSearch: true,
      showTransactionCount: false,
      showQuickAccess: true,
      maxQuickItems: 5,
    );
  }

  Widget _buildCounterpartySection() {
    return CounterpartySection(
      categoryTag: _selectedCategoryTag,
      selectedCounterpartyId: _selectedCounterpartyId,
      selectedCounterpartyName: _selectedCounterpartyName,
      selectedCounterpartyStoreId: _selectedCounterpartyStoreId,
      selectedCounterpartyStoreName: _selectedCounterpartyStoreName,
      linkedCompanyId: _linkedCompanyId,
      selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
      isInternal: _isInternal,
      accountMapping: _accountMapping,
      mappingError: _mappingError,
      blockedCashLocationIds: widget.blockedCashLocationIds,
      onCounterpartySelected: (counterparty) {
        setState(() {
          _selectedCounterpartyId = counterparty.id;
          _selectedCounterpartyName = counterparty.name;
          _isInternal = counterparty.isInternal;
          _linkedCompanyId = counterparty.linkedCompanyId;
          _selectedCounterpartyStoreId = null;
          _selectedCounterpartyStoreName = null;
          _selectedCounterpartyCashLocationId = null;
        });
        _checkAccountMapping();
      },
      onCounterpartyIdChanged: (counterpartyId) {
        if (counterpartyId == null) {
          setState(() {
            _selectedCounterpartyId = null;
            _selectedCounterpartyName = null;
            _isInternal = false;
            _linkedCompanyId = null;
            _selectedCounterpartyStoreId = null;
            _selectedCounterpartyStoreName = null;
            _selectedCounterpartyCashLocationId = null;
          });
        }
      },
      onStoreSelected: (storeId, storeName) {
        setState(() {
          _selectedCounterpartyStoreId = storeId;
          _selectedCounterpartyStoreName = storeName;
          _selectedCounterpartyCashLocationId = null;
        });
      },
      onCounterpartyCashLocationSelected: (cashLocation) {
        setState(() {
          _selectedCounterpartyCashLocationId = cashLocation.id;
        });
      },
      onCounterpartyCashLocationChanged: (locationId) {
        if (locationId == null) {
          setState(() {
            _selectedCounterpartyCashLocationId = null;
          });
        }
      },
    );
  }
}
