/// Test Page for Template → RPC Mapping
///
/// Purpose: Test and verify template data mapping to insert_journal_with_everything_utc
/// - Load templates from DB
/// - Analyze template type (Expense+Cash, Cash-Cash, External Debt, Internal, etc.)
/// - Build p_lines JSON
/// - Send to RPC and verify result
///
/// Route: /test (add to app_router.dart)
library;

import 'dart:convert';

import 'package:myfinance_improved/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart' as legacy;
import 'package:myfinance_improved/core/services/supabase_service.dart';
import 'package:myfinance_improved/app/providers/cash_location_provider.dart';
import 'package:myfinance_improved/app/providers/counterparty_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

class TestTemplateMapppingPage extends ConsumerStatefulWidget {
  const TestTemplateMapppingPage({super.key});

  @override
  ConsumerState<TestTemplateMapppingPage> createState() => _TestTemplateMapppingPageState();
}

class _TestTemplateMapppingPageState extends ConsumerState<TestTemplateMapppingPage> {
  List<Map<String, dynamic>> _templates = [];
  Map<String, dynamic>? _selectedTemplate;
  String _analysisResult = '';
  String _linesJson = '';
  String _rpcResult = '';
  bool _isLoading = false;

  // User input
  final _amountController = TextEditingController(text: '10000');
  String? _selectedCashLocationId;
  String? _selectedCounterpartyId;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    setState(() => _isLoading = true);
    try {
      final appState = ref.read(legacy.appStateProvider);
      final companyId = appState.companyChoosen;

      final supabaseService = ref.read(supabaseServiceProvider);
      final supabase = supabaseService.client;
      final response = await supabase
          .from('transaction_templates')
          .select('template_id, name, data, counterparty_id, counterparty_cash_location_id')
          .eq('company_id', companyId)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(20);

      setState(() {
        _templates = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _analysisResult = 'Error loading templates: $e';
        _isLoading = false;
      });
    }
  }

  void _selectTemplate(Map<String, dynamic> template) {
    // Extract default values from template
    String? defaultCashLocationId;
    String? defaultCounterpartyId;

    final data = template['data'];
    if (data is List) {
      for (final line in data) {
        // Get first cash_location_id found
        if (defaultCashLocationId == null && line['cash_location_id'] != null) {
          defaultCashLocationId = line['cash_location_id']?.toString();
        }
        // Get first counterparty_id found
        if (defaultCounterpartyId == null && line['counterparty_id'] != null) {
          defaultCounterpartyId = line['counterparty_id']?.toString();
        }
      }
    }

    // Fallback to template-level counterparty_id
    defaultCounterpartyId ??= template['counterparty_id']?.toString();

    // 🔍 DEBUG: Print template selection
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('📋 TEMPLATE SELECTED');
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('Name: ${template['name']}');
    debugPrint('ID: ${template['template_id']}');
    debugPrint('Default Cash Location ID: $defaultCashLocationId');
    debugPrint('Default Counterparty ID: $defaultCounterpartyId');
    debugPrint('Template-level counterparty_id: ${template['counterparty_id']}');
    debugPrint('Template data lines: ${(data as List?)?.length ?? 0}');
    final encoder = const JsonEncoder.withIndent('  ');
    debugPrint('Template data:');
    debugPrint(encoder.convert(data));
    debugPrint('═══════════════════════════════════════════════════');

    setState(() {
      _selectedTemplate = template;
      _selectedCashLocationId = defaultCashLocationId;  // Set template default
      _selectedCounterpartyId = defaultCounterpartyId;  // Set template default
      _analysisResult = '';
      _linesJson = '';
      _rpcResult = '';
    });
    _analyzeTemplate();
  }

  /// Analyze template type
  void _analyzeTemplate() {
    if (_selectedTemplate == null) return;

    final data = _selectedTemplate!['data'];
    if (data == null) {
      setState(() => _analysisResult = 'No data in template');
      return;
    }

    final List<dynamic> lines = data is List ? data : [];
    if (lines.isEmpty) {
      setState(() => _analysisResult = 'Empty data array');
      return;
    }

    // Analyze
    bool hasCash = false;
    bool hasExpense = false;
    bool hasReceivablePayable = false;
    bool hasInternal = false;
    int cashCount = 0;
    String? debitTag;
    String? creditTag;

    final StringBuffer analysis = StringBuffer();
    analysis.writeln('=== TEMPLATE ANALYSIS ===\n');
    analysis.writeln('Name: ${_selectedTemplate!['name']}');
    analysis.writeln('Lines count: ${lines.length}\n');

    for (final line in lines) {
      final type = line['type']?.toString() ?? '';
      final categoryTag = line['category_tag']?.toString() ?? '';
      final accountCode = line['account_code']?.toString() ?? '';
      final cashLocationId = line['cash_location_id']?.toString();
      final counterpartyId = line['counterparty_id']?.toString();
      final linkedCompanyId = line['linked_company_id']?.toString();

      analysis.writeln('--- ${type.toUpperCase()} ---');
      analysis.writeln('  category_tag: $categoryTag');
      analysis.writeln('  account_code: $accountCode');
      analysis.writeln('  cash_location_id: $cashLocationId');
      analysis.writeln('  counterparty_id: $counterpartyId');
      analysis.writeln('  linked_company_id: $linkedCompanyId');

      if (type == 'debit') debitTag = categoryTag;
      if (type == 'credit') creditTag = categoryTag;

      // Check flags
      if (categoryTag == 'cash' || categoryTag == 'bank') {
        hasCash = true;
        cashCount++;
      }

      if (categoryTag == 'receivable' || categoryTag == 'payable') {
        hasReceivablePayable = true;
      }

      if (linkedCompanyId != null && linkedCompanyId.isNotEmpty) {
        hasInternal = true;
      }

      // Check expense (5000-9999)
      if (accountCode.isNotEmpty) {
        final code = int.tryParse(accountCode) ?? 0;
        if (code >= 5000 && code <= 9999) {
          hasExpense = true;
        }
      }
    }

    analysis.writeln('\n=== FLAGS ===');
    analysis.writeln('hasCash: $hasCash (count: $cashCount)');
    analysis.writeln('hasExpense: $hasExpense');
    analysis.writeln('hasReceivablePayable: $hasReceivablePayable');
    analysis.writeln('hasInternal: $hasInternal');

    // Determine template type
    String templateType = 'UNKNOWN';
    bool canChangeCashLocation = false;
    bool canChangeCounterparty = false;

    if (hasInternal) {
      templateType = 'INTERNAL (locked)';
      canChangeCashLocation = false;
      canChangeCounterparty = false;
    } else if (hasCash && cashCount >= 2) {
      templateType = 'CASH-CASH (locked)';
      canChangeCashLocation = false;
      canChangeCounterparty = false;
    } else if (hasExpense && hasCash && cashCount == 1) {
      templateType = 'EXPENSE + CASH';
      canChangeCashLocation = true;
      canChangeCounterparty = false;
    } else if (hasReceivablePayable && hasCash && !hasInternal) {
      templateType = 'EXTERNAL DEBT + CASH';
      canChangeCashLocation = true;
      canChangeCounterparty = true;
    } else if (hasCash && !hasExpense && !hasReceivablePayable) {
      templateType = 'CASH ONLY';
      canChangeCashLocation = false;
    } else {
      templateType = 'OTHER';
    }

    analysis.writeln('\n=== TEMPLATE TYPE ===');
    analysis.writeln('Type: $templateType');
    analysis.writeln('Transaction: ${debitTag ?? "?"} → ${creditTag ?? "?"}');
    analysis.writeln('\n=== USER CAN CHANGE ===');
    analysis.writeln('Cash Location: $canChangeCashLocation');
    analysis.writeln('Counterparty: $canChangeCounterparty');

    setState(() {
      _analysisResult = analysis.toString();
    });
  }

  /// Build p_lines JSON for RPC
  void _buildLinesJson() {
    if (_selectedTemplate == null) return;

    final data = _selectedTemplate!['data'];
    if (data == null || data is! List) {
      setState(() => _linesJson = 'Invalid template data');
      return;
    }

    final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    final entryDate = DateTime.now().toIso8601String().split('T').first;

    // Analyze template type first
    final List<dynamic> templateLines = data;
    bool hasInternal = templateLines.any((l) =>
      l['linked_company_id'] != null && l['linked_company_id'].toString().isNotEmpty);
    bool hasExpense = templateLines.any((l) {
      final code = int.tryParse(l['account_code']?.toString() ?? '') ?? 0;
      return code >= 5000 && code <= 9999;
    });
    int cashCount = templateLines.where((l) =>
      l['category_tag'] == 'cash' || l['category_tag'] == 'bank').length;
    bool hasReceivablePayable = templateLines.any((l) =>
      l['category_tag'] == 'receivable' || l['category_tag'] == 'payable');

    bool isExpenseCash = hasExpense && cashCount == 1;
    bool isExternalDebtCash = hasReceivablePayable && !hasInternal && cashCount >= 1;

    final List<Map<String, dynamic>> rpcLines = [];

    for (final line in templateLines) {
      final type = line['type']?.toString() ?? '';
      final accountId = line['account_id']?.toString() ?? '';
      final categoryTag = line['category_tag']?.toString() ?? '';
      final description = line['description']?.toString();

      // Base line
      final Map<String, dynamic> rpcLine = {
        'account_id': accountId,
        'description': description,
        'debit': type == 'debit' ? amount.toStringAsFixed(0) : '0',
        'credit': type == 'credit' ? amount.toStringAsFixed(0) : '0',
      };

      // Handle cash
      if (categoryTag == 'cash' || categoryTag == 'bank') {
        String? cashLocationId;

        if (isExpenseCash || isExternalDebtCash) {
          // User can change → use selected or template default
          cashLocationId = _selectedCashLocationId ?? line['cash_location_id']?.toString();
        } else {
          // Locked → use template value
          cashLocationId = line['cash_location_id']?.toString();
        }

        if (cashLocationId != null && cashLocationId.isNotEmpty) {
          rpcLine['cash'] = {'cash_location_id': cashLocationId};
        }
      }

      // Handle debt (receivable/payable)
      if (categoryTag == 'receivable' || categoryTag == 'payable') {
        String? counterpartyId;

        if (isExternalDebtCash && !hasInternal) {
          // External → user can change
          counterpartyId = _selectedCounterpartyId ?? line['counterparty_id']?.toString();
        } else {
          // Internal or locked → use template value
          counterpartyId = line['counterparty_id']?.toString();
        }

        if (counterpartyId != null && counterpartyId.isNotEmpty) {
          final debtObj = <String, dynamic>{
            'counterparty_id': counterpartyId,
            'direction': categoryTag,
            'category': 'account',  // default
            'issue_date': entryDate,
          };

          // Internal fields
          final linkedStoreId = line['counterparty_store_id']?.toString();
          final linkedCompanyId = line['linked_company_id']?.toString();

          if (linkedStoreId != null && linkedStoreId.isNotEmpty) {
            debtObj['linkedCounterparty_store_id'] = linkedStoreId;
          }
          if (linkedCompanyId != null && linkedCompanyId.isNotEmpty) {
            debtObj['linkedCounterparty_companyId'] = linkedCompanyId;
          }

          rpcLine['debt'] = debtObj;
        }
      }

      rpcLines.add(rpcLine);
    }

    // Format JSON
    final encoder = const JsonEncoder.withIndent('  ');
    final jsonResult = encoder.convert(rpcLines);

    // 🔍 DEBUG: Print build result
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('🔧 BUILD p_lines JSON');
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('Template: ${_selectedTemplate!['name']}');
    debugPrint('Amount: $amount');
    debugPrint('Selected Cash Location: $_selectedCashLocationId');
    debugPrint('Selected Counterparty: $_selectedCounterpartyId');
    debugPrint('Template Type Flags:');
    debugPrint('  - hasInternal: $hasInternal');
    debugPrint('  - hasExpense: $hasExpense');
    debugPrint('  - cashCount: $cashCount');
    debugPrint('  - hasReceivablePayable: $hasReceivablePayable');
    debugPrint('  - isExpenseCash: $isExpenseCash');
    debugPrint('  - isExternalDebtCash: $isExternalDebtCash');
    debugPrint('───────────────────────────────────────────────────');
    debugPrint('p_lines JSON:');
    debugPrint(jsonResult);
    debugPrint('═══════════════════════════════════════════════════');

    setState(() {
      _linesJson = jsonResult;
    });
  }

  /// Send to RPC and test
  Future<void> _testRpc() async {
    if (_linesJson.isEmpty) {
      _buildLinesJson();
    }

    setState(() => _isLoading = true);

    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final supabase = supabaseService.client;

      final appState = ref.read(legacy.appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      final userId = supabaseService.currentUser?.id ?? '';

      final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
      final lines = jsonDecode(_linesJson) as List;

      // Get counterparty_cash_location_id from template if internal
      String? ifCashLocationId;
      final data = _selectedTemplate!['data'] as List?;
      if (data != null) {
        for (final line in data) {
          if (line['counterparty_cash_location_id'] != null) {
            ifCashLocationId = line['counterparty_cash_location_id'].toString();
            break;
          }
        }
      }
      ifCashLocationId ??= _selectedTemplate!['counterparty_cash_location_id']?.toString();

      // Get counterparty_id
      String? counterpartyId = _selectedCounterpartyId;
      if (counterpartyId == null && data != null) {
        for (final line in data) {
          if (line['counterparty_id'] != null) {
            counterpartyId = line['counterparty_id'].toString();
            break;
          }
        }
      }
      counterpartyId ??= _selectedTemplate!['counterparty_id']?.toString();

      // Build RPC params
      final entryDateUtc = DateTime.now().toUtc().toIso8601String();
      final rpcParams = {
        'p_base_amount': amount,
        'p_company_id': companyId,
        'p_created_by': userId,
        'p_description': 'Test from template: ${_selectedTemplate!['name']}',
        'p_entry_date_utc': entryDateUtc,
        'p_lines': lines,
        'p_counterparty_id': counterpartyId,
        'p_if_cash_location_id': ifCashLocationId,
        'p_store_id': storeId.isNotEmpty ? storeId : null,
      };

      // 🔍 DEBUG: Print full RPC params
      final encoder = const JsonEncoder.withIndent('  ');
      final rpcParamsJson = encoder.convert(rpcParams);
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('🚀 CALLING insert_journal_with_everything_utc');
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint(rpcParamsJson);
      debugPrint('═══════════════════════════════════════════════════');

      final result = await supabase.rpc(
        'insert_journal_with_everything_utc',
        params: rpcParams,
      );

      // 🔍 DEBUG: Print result
      debugPrint('✅ RPC RESULT: $result');

      setState(() {
        _rpcResult = '''SUCCESS!

📋 RPC PARAMS SENT:
$rpcParamsJson

📦 RESULT:
Journal ID: $result''';
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      // 🔍 DEBUG: Print error
      debugPrint('❌ RPC ERROR: $e');
      debugPrint('Stack trace: $stackTrace');

      setState(() {
        _rpcResult = 'ERROR!\n\n$e\n\nStack:\n$stackTrace';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Mapping Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTemplates,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Template selector
                  Text('1. Select Template', style: TossTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _templates.length,
                      itemBuilder: (context, index) {
                        final template = _templates[index];
                        final isSelected = _selectedTemplate?['template_id'] == template['template_id'];
                        return GestureDetector(
                          onTap: () => _selectTemplate(template),
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(TossSpacing.space3),
                            decoration: BoxDecoration(
                              color: isSelected ? TossColors.primary.withOpacity(0.1) : TossColors.gray100,
                              border: Border.all(
                                color: isSelected ? TossColors.primary : TossColors.gray300,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  template['name']?.toString() ?? 'Unnamed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? TossColors.primary : TossColors.gray900,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Text(
                                  '${(template['data'] as List?)?.length ?? 0} lines',
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Analysis result
                  Text('2. Template Analysis', style: TossTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: SelectableText(
                      _analysisResult.isEmpty ? 'Select a template to analyze' : _analysisResult,
                      style: TossTextStyles.bodySmall.copyWith(fontFamily: 'monospace'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // User inputs
                  Text('3. User Inputs', style: TossTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),

                  // Cash Location Selector - TossDropdown
                  Builder(
                    builder: (context) {
                      final cashLocationsAsync = ref.watch(companyCashLocationsProvider);
                      return TossDropdown<String>(
                        label: 'Cash Location',
                        hint: 'Select Cash Location',
                        value: _selectedCashLocationId,
                        isLoading: cashLocationsAsync.isLoading,
                        items: cashLocationsAsync.maybeWhen(
                          data: (locations) => locations
                              .map((l) => TossDropdownItem(
                                    value: l.id,
                                    label: l.name,
                                    subtitle: l.type,
                                  ))
                              .toList(),
                          orElse: () => [],
                        ),
                        onChanged: (locationId) {
                          setState(() {
                            _selectedCashLocationId = locationId;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Counterparty Selector - TossDropdown (External only)
                  Builder(
                    builder: (context) {
                      final counterpartiesAsync = ref.watch(currentCounterpartiesProvider);
                      return TossDropdown<String>(
                        label: 'Counterparty (External)',
                        hint: 'Select Counterparty',
                        value: _selectedCounterpartyId,
                        isLoading: counterpartiesAsync.isLoading,
                        items: counterpartiesAsync.maybeWhen(
                          data: (counterparties) => counterparties
                              .where((c) => !c.isInternal) // Only external
                              .map((c) => TossDropdownItem(
                                    value: c.id,
                                    label: c.name,
                                    subtitle: c.type,
                                  ))
                              .toList(),
                          orElse: () => [],
                        ),
                        onChanged: (counterpartyId) {
                          setState(() {
                            _selectedCounterpartyId = counterpartyId;
                          });
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Build lines button
                  ElevatedButton.icon(
                    onPressed: _buildLinesJson,
                    icon: const Icon(Icons.build),
                    label: const Text('Build p_lines JSON'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Lines JSON
                  Text('4. p_lines JSON', style: TossTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        _linesJson.isEmpty ? 'Click "Build p_lines JSON" to generate' : _linesJson,
                        style: TossTextStyles.labelSmall.copyWith(fontFamily: 'monospace'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Copy button
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: _linesJson.isEmpty ? null : () {
                          Clipboard.setData(ClipboardData(text: _linesJson));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied to clipboard')),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy JSON'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Test RPC button
                  ElevatedButton.icon(
                    onPressed: _linesJson.isEmpty ? null : _testRpc,
                    icon: const Icon(Icons.send),
                    label: const Text('Test RPC (Create Journal)'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: TossColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // RPC Result
                  Text('5. RPC Result', style: TossTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: _rpcResult.startsWith('SUCCESS')
                          ? Colors.green.withOpacity(0.1)
                          : _rpcResult.startsWith('ERROR')
                              ? Colors.red.withOpacity(0.1)
                              : TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      border: Border.all(
                        color: _rpcResult.startsWith('SUCCESS')
                            ? Colors.green
                            : _rpcResult.startsWith('ERROR')
                                ? Colors.red
                                : TossColors.gray300,
                      ),
                    ),
                    child: SelectableText(
                      _rpcResult.isEmpty ? 'Click "Test RPC" to send' : _rpcResult,
                      style: TossTextStyles.bodySmall.copyWith(fontFamily: 'monospace'),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
