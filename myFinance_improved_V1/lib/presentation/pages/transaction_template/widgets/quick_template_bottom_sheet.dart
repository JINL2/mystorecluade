import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../widgets/toss/toss_bottom_sheet.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_text_field.dart';
import '../../../widgets/specific/selectors/autonomous_cash_location_selector.dart';
import '../../../widgets/specific/selectors/autonomous_counterparty_selector.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';
import 'quick_template_analyzer.dart';
import 'template_usage_bottom_sheet.dart';

/// Quick template interface optimized for speed and user intuition
class QuickTemplateBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> template;
  
  const QuickTemplateBottomSheet({
    super.key,
    required this.template,
  });
  
  static Future<void> show(BuildContext context, Map<String, dynamic> template) {
    return TossBottomSheet.show(
      context: context,
      title: template['name'],
      content: QuickTemplateBottomSheet(template: template),
    );
  }
  
  @override
  ConsumerState<QuickTemplateBottomSheet> createState() => _QuickTemplateBottomSheetState();
}

class _QuickTemplateBottomSheetState extends ConsumerState<QuickTemplateBottomSheet> {
  late final TemplateAnalysisResult _analysis;
  final _formKey = GlobalKey<FormState>();
  final _numberFormat = NumberFormat('#,###');
  
  // Controllers
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  String _previousValue = '';
  
  // Selected values for essential setup
  String? _selectedMyCashLocationId;
  String? _selectedCounterpartyId;
  String? _selectedCounterpartyCashLocationId;
  
  // State
  bool _isSubmitting = false;
  bool _showDetailedMode = false;
  
  // Quick validation
  bool get _canProceed {
    // Amount validation
    if (_amountController.text.isEmpty) return false;
    final cleanAmount = _amountController.text.replaceAll(',', '');
    final amount = int.tryParse(cleanAmount);
    if (amount == null || amount <= 0) return false;
    
    // Completeness-based validation
    switch (_analysis.completeness) {
      case TemplateCompleteness.complete:
        return true; // No additional requirements
      case TemplateCompleteness.amountOnly:
        return true; // Only amount needed
      case TemplateCompleteness.essential:
        // Check essential requirements
        if (_analysis.missingItems.contains('cash_location') && 
            _selectedMyCashLocationId == null) return false;
        if (_analysis.missingItems.contains('counterparty_cash_location') && 
            _selectedCounterpartyCashLocationId == null) return false;
        return true;
      case TemplateCompleteness.complex:
        // For complex templates, recommend detailed mode
        return _showDetailedMode;
    }
  }
  
  @override
  void initState() {
    super.initState();
    _analysis = QuickTemplateAnalyzer.analyze(widget.template);
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    
    _amountController.addListener(() {
      _formatNumber();
      setState(() {}); // Update button state
    });
    
    // Auto-focus amount field for speed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_analysis.completeness == TemplateCompleteness.amountOnly ||
          _analysis.completeness == TemplateCompleteness.essential) {
        // Auto-focus for quick entry
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }
  
  @override
  void dispose() {
    _amountController.removeListener(_formatNumber);
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  void _formatNumber() {
    final text = _amountController.text;
    if (text == _previousValue) return;
    
    final cleanText = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) {
      _previousValue = '';
      return;
    }
    
    final number = int.tryParse(cleanText);
    if (number == null) return;
    
    final formatted = _numberFormat.format(number);
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    _previousValue = formatted;
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quick Status Indicator
            _buildQuickStatusIndicator(),
            
            SizedBox(height: TossSpacing.space4),
            
            // Main Content based on completeness
            if (_showDetailedMode) ...[
              _buildDetailedModeToggle(),
              SizedBox(height: TossSpacing.space3),
              _buildDetailedInterface(),
            ] else ...[
              _buildQuickInterface(),
            ],
            
            SizedBox(height: TossSpacing.space5),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickStatusIndicator() {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (_analysis.completeness) {
      case TemplateCompleteness.complete:
        statusColor = TossColors.success;
        statusIcon = Icons.flash_on;
        statusText = 'Ready for instant creation';
        break;
      case TemplateCompleteness.amountOnly:
        statusColor = TossColors.primary;
        statusIcon = Icons.speed;
        statusText = 'Just enter amount';
        break;
      case TemplateCompleteness.essential:
        statusColor = TossColors.warning;
        statusIcon = Icons.tune;
        statusText = '${_analysis.missingFields} quick selections needed';
        break;
      case TemplateCompleteness.complex:
        statusColor = TossColors.gray600;
        statusIcon = Icons.settings;
        statusText = 'Complex setup required';
        break;
    }
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: TossColors.white,
              size: 18,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                Text(
                  'Estimated: ${_analysis.estimatedTime}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickInterface() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Amount Input (primary focus)
        _buildAmountInput(),
        
        if (_analysis.completeness == TemplateCompleteness.essential) ...[
          SizedBox(height: TossSpacing.space4),
          _buildEssentialSelectors(),
        ],
        
        if (_analysis.completeness == TemplateCompleteness.complex) ...[
          SizedBox(height: TossSpacing.space4),
          _buildComplexTemplateCard(),
        ],
        
        SizedBox(height: TossSpacing.space4),
        
        // Optional description (collapsed by default)
        _buildCollapsibleDescription(),
      ],
    );
  }
  
  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            color: TossColors.white,
            border: Border.all(
              color: _amountController.text.isNotEmpty 
                ? TossColors.primary
                : TossColors.gray300,
              width: 2,
            ),
            boxShadow: _amountController.text.isNotEmpty ? [
              BoxShadow(
                color: TossColors.primary.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ] : null,
          ),
          child: TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
              LengthLimitingTextInputFormatter(15),
            ],
            autofocus: _analysis.isQuickEligible,
            style: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            cursorColor: TossColors.primary,
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TossTextStyles.h2.copyWith(
                color: TossColors.gray300,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: TossSpacing.space5,
                horizontal: TossSpacing.space4,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEssentialSelectors() {
    final List<Widget> selectors = [];
    
    if (_analysis.missingItems.contains('cash_location')) {
      selectors.add(_buildCashLocationSelector());
    }
    
    if (_analysis.missingItems.contains('counterparty_cash_location')) {
      selectors.add(_buildCounterpartySelector());
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quick Setup',
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space3),
        ...selectors.map((selector) => Padding(
          padding: EdgeInsets.only(bottom: TossSpacing.space3),
          child: selector,
        )),
      ],
    );
  }
  
  Widget _buildCashLocationSelector() {
    return AutonomousCashLocationSelector(
      selectedLocationId: _selectedMyCashLocationId,
      onChanged: (cashLocationId) {
        setState(() {
          _selectedMyCashLocationId = cashLocationId;
        });
      },
      label: 'Cash Location',
      hint: 'Select cash location',
      showSearch: false,
      showTransactionCount: false,
    );
  }
  
  Widget _buildCounterpartySelector() {
    // Simplified counterparty selection for essential mode
    return AutonomousCounterpartySelector(
      selectedCounterpartyId: _selectedCounterpartyId,
      onChanged: (counterpartyId) {
        setState(() {
          _selectedCounterpartyId = counterpartyId;
          // TODO: Auto-select default cash location for this counterparty
        });
      },
      label: 'Counterparty',
      hint: 'Select counterparty',
      showSearch: false,
      showTransactionCount: false,
    );
  }
  
  Widget _buildComplexTemplateCard() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: TossColors.gray600, size: 20),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Complex Template',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            'This template requires detailed setup including debt configuration, multiple selections, and validation.',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showDetailedMode = true;
              });
            },
            icon: Icon(Icons.open_in_full, size: 16),
            label: Text('Open Detailed Setup'),
            style: TextButton.styleFrom(
              foregroundColor: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCollapsibleDescription() {
    return ExpansionTile(
      title: Text(
        'Add Description (Optional)',
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray600,
        ),
      ),
      children: [
        TossTextField(
          controller: _descriptionController,
          hintText: 'Transaction description...',
          maxLines: 2,
        ),
      ],
      initiallyExpanded: false,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(bottom: TossSpacing.space2),
    );
  }
  
  Widget _buildDetailedModeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Detailed Mode',
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _showDetailedMode = false;
            });
          },
          child: Text('Back to Quick Mode'),
        ),
      ],
    );
  }
  
  Widget _buildDetailedInterface() {
    // For detailed mode, embed the original complex form
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Text(
            'Opening detailed template configuration...',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          TossSecondaryButton(
            text: 'Open Full Template Editor',
            onPressed: () {
              Navigator.of(context).pop();
              TemplateUsageBottomSheet.show(context, widget.template);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons() {
    final primaryButtonText = _analysis.completeness == TemplateCompleteness.complete
        ? 'Create Now ⚡'
        : _canProceed ? 'Create Transaction 🚀' : 'Enter Required Fields';
    
    return Row(
      children: [
        Expanded(
          child: TossSecondaryButton(
            text: 'Cancel',
            onPressed: _isSubmitting ? null : () {
              Navigator.of(context).pop();
            },
          ),
        ),
        SizedBox(width: TossSpacing.space3),
        Expanded(
          flex: 2,
          child: TossPrimaryButton(
            text: _isSubmitting ? 'Creating...' : primaryButtonText,
            onPressed: (_isSubmitting || !_canProceed) ? null : _handleQuickSubmit,
            isLoading: _isSubmitting,
          ),
        ),
      ],
    );
  }
  
  Future<void> _handleQuickSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final cleanAmount = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(cleanAmount);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }
    
    setState(() => _isSubmitting = true);
    
    try {
      // For quick templates, use simplified transaction creation
      await _createQuickTransaction(amount);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.white),
                SizedBox(width: TossSpacing.space2),
                Text('Transaction created successfully! ⚡'),
              ],
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(TossSpacing.space4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      _showError('Failed to create transaction: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
  
  Future<void> _createQuickTransaction(double amount) async {
    final supabase = Supabase.instance.client;
    final appState = ref.read(appStateProvider);
    final user = ref.read(authStateProvider);
    
    if (user == null) throw Exception('User not authenticated');
    
    // Get description (optional)
    final description = _descriptionController.text.trim().isEmpty 
        ? null 
        : _descriptionController.text.trim();
    
    // Build transaction lines from template
    final pLines = await _buildQuickTransactionLines(amount);
    
    // Extract main counterparty info
    String? mainCounterpartyId = widget.template['counterparty_id'];
    if (mainCounterpartyId == null) {
      final data = widget.template['data'] as List? ?? [];
      for (var line in data) {
        if (line['counterparty_id'] != null) {
          mainCounterpartyId = line['counterparty_id'] as String;
          break;
        }
      }
    }
    
    // Format entry date
    final entryDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());
    
    // Prepare RPC parameters
    final rpcParams = {
      'p_base_amount': amount,
      'p_company_id': appState.companyChoosen,
      'p_created_by': user.id,
      'p_description': description,
      'p_entry_date': entryDate,
      'p_lines': pLines,
      'p_counterparty_id': mainCounterpartyId,
      'p_if_cash_location_id': _selectedCounterpartyCashLocationId,
      'p_store_id': appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
    };
    
    // Call RPC to create transaction
    await supabase.rpc('insert_journal_with_everything', params: rpcParams);
  }
  
  Future<List<Map<String, dynamic>>> _buildQuickTransactionLines(double amount) async {
    final lines = <Map<String, dynamic>>[];
    final templateData = widget.template['data'] as List? ?? [];
    final tags = widget.template['tags'] as Map? ?? {};
    
    // Get cash location info if needed
    Map<String, dynamic>? myCashLocationData;
    if (_selectedMyCashLocationId != null || _analysis.missingItems.contains('cash_location')) {
      final supabase = Supabase.instance.client;
      
      final cashLocationId = _selectedMyCashLocationId ?? 
          (tags['cash_locations'] as List?)?.first;
          
      if (cashLocationId != null && cashLocationId != 'none') {
        final response = await supabase
            .from('cash_locations')
            .select('cash_location_id, location_name')
            .eq('cash_location_id', cashLocationId)
            .maybeSingle();
        myCashLocationData = response;
      }
    }
    
    // Build lines from template
    for (var templateLine in templateData) {
      final line = <String, dynamic>{
        'account_id': templateLine['account_id'],
        'description': templateLine['description'] ?? '',
      };
      
      // Set amounts
      if (templateLine['type'] == 'debit') {
        line['debit'] = amount.toString();
        line['credit'] = '0';
      } else {
        line['debit'] = '0';
        line['credit'] = amount.toString();
      }
      
      // Add counterparty info if present
      if (templateLine['counterparty_id'] != null) {
        line['counterparty_id'] = templateLine['counterparty_id'];
      }
      
      // Handle cash accounts
      if (templateLine['category_tag'] == 'cash' && myCashLocationData != null) {
        line['cash'] = {
          'cash_location_id': myCashLocationData['cash_location_id'],
          'cash_location_name': myCashLocationData['location_name'] ?? '',
        };
      }
      
      // For quick templates, skip complex debt configuration
      // Users can use detailed mode for debt tracking
      
      lines.add(line);
    }
    
    return lines;
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.error,
      ),
    );
  }
}