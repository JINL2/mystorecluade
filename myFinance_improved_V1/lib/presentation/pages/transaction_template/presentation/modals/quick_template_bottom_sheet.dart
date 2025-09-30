import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/keyboard/toss_textfield_keyboard_modal.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../providers/app_state_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../shared/utils/quick_template_analyzer.dart';
import '../../shared/services/quick_template_validator.dart';
import '../../shared/services/quick_transaction_builder.dart';
import '../components/forms/quick_amount_input.dart';
import '../components/forms/quick_status_indicator.dart';
import '../components/forms/essential_selectors.dart';
import '../components/forms/collapsible_description.dart';
import '../components/forms/complex_template_card.dart';
import './template_usage_bottom_sheet.dart';
import 'package:myfinance_improved/core/themes/index.dart';

enum TemplateComplexity {
  simple,
  complex,
}

/// Quick Transaction Modal - Speed-optimized transaction creation for simple templates
/// 
/// Purpose: Allows users to quickly create transactions from templates that only need
/// minimal input (typically just amount). Used for frequently used, simple templates.
///
/// Keyboard Handling: Uses TossTextFieldKeyboardModal for proper keyboard management
/// 
/// Usage: QuickTemplateBottomSheet.show(context, template)
class QuickTemplateBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> template;
  
  const QuickTemplateBottomSheet({
    super.key,
    required this.template,
  });
  
  static Future<void> show(BuildContext context, Map<String, dynamic> template) {
    // For complex templates, use full page; for simple ones, keep modal
    final complexity = _analyzeTemplateComplexity(template);
    
    if (complexity == TemplateComplexity.complex) {
      // Use full template page for complex templates
      return TemplateUsageBottomSheet.show(context, template);
    }
    
    // Create a key to access the form state
    final GlobalKey<_QuickTemplateBottomSheetState> formKey = GlobalKey();
    
    // Use modal for simple quick templates
    return TossTextFieldKeyboardModal.show(
      context: context,
      title: template['name'] as String?,
      content: QuickTemplateBottomSheet(key: formKey, template: template),
      actionButtons: [
        Expanded(
          child: TossSecondaryButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        SizedBox(width: TossSpacing.space3),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              // Access form state to enable/disable button and handle submission
              final canProceed = formKey.currentState?._canProceed ?? false;
              final isSubmitting = formKey.currentState?._isSubmitting ?? false;
              
              return TossPrimaryButton(
                text: isSubmitting ? 'Creating...' : 'Create Transaction',
                onPressed: canProceed && !isSubmitting 
                    ? () => formKey.currentState?._handleQuickSubmit()
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
  
  static TemplateComplexity _analyzeTemplateComplexity(Map<String, dynamic> template) {
    final analysis = QuickTemplateAnalyzer.analyze(template);
    return analysis.completeness == TemplateCompleteness.complex 
        ? TemplateComplexity.complex 
        : TemplateComplexity.simple;
  }
  
  @override
  ConsumerState<QuickTemplateBottomSheet> createState() => _QuickTemplateBottomSheetState();
}

class _QuickTemplateBottomSheetState extends ConsumerState<QuickTemplateBottomSheet> {
  late final TemplateAnalysisResult _analysis;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  
  // Selected values for essential setup
  String? _selectedMyCashLocationId;
  String? _selectedCounterpartyId;
  String? _selectedCounterpartyCashLocationId;
  
  // State
  bool _isSubmitting = false;
  bool _showDetailedMode = false;
  
  // Quick validation using extracted validator
  bool get _canProceed {
    return QuickTemplateValidator.canProceed(
      analysis: _analysis,
      amountText: _amountController.text,
      selectedMyCashLocationId: _selectedMyCashLocationId,
      selectedCounterpartyId: _selectedCounterpartyId,
      selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
      isDetailedMode: _showDetailedMode,
    );
  }
  
  @override
  void initState() {
    super.initState();
    _analysis = QuickTemplateAnalyzer.analyze(widget.template);
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    
    _amountController.addListener(() {
      setState(() {}); // Update button state
    });
    
    // Removed auto-focus to prevent keyboard from appearing immediately
    // Users can tap the amount field when ready to enter the value
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    // This widget is now only responsible for the content
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Quick Status Indicator (extracted component)
          QuickStatusIndicator(analysis: _analysis),
          
          SizedBox(height: TossSpacing.space4),
          
          // Main Content based on completeness
          if (_showDetailedMode) ...[
            _buildDetailedModeToggle(),
            SizedBox(height: TossSpacing.space3),
            _buildDetailedInterface(),
          ] else ...[
            _buildQuickInterface(),
          ],
        ],
      ),
    );
  }
  
  
  Widget _buildQuickInterface() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Amount Input (extracted component)
        QuickAmountInput(
          controller: _amountController,
          onChanged: () => setState(() {}),
        ),
        
        if (_analysis.completeness == TemplateCompleteness.essential) ...[
          SizedBox(height: TossSpacing.space4),
          // Essential Selectors (extracted component)
          EssentialSelectors(
            analysis: _analysis,
            selectedMyCashLocationId: _selectedMyCashLocationId,
            selectedCounterpartyId: _selectedCounterpartyId,
            selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
            onMyCashLocationChanged: (value) => setState(() => _selectedMyCashLocationId = value),
            onCounterpartyChanged: (value) => setState(() => _selectedCounterpartyId = value),
            onCounterpartyCashLocationChanged: (value) => setState(() => _selectedCounterpartyCashLocationId = value),
          ),
        ],
        
        if (_analysis.completeness == TemplateCompleteness.complex) ...[
          SizedBox(height: TossSpacing.space4),
          // Complex Template Card (extracted component)
          ComplexTemplateCard(
            onOpenDetailed: () => setState(() => _showDetailedMode = true),
          ),
        ],
        
        SizedBox(height: TossSpacing.space4),
        
        // Optional description (extracted component)
        CollapsibleDescription(controller: _descriptionController),
      ],
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
  
  // Note: Action buttons are now handled in _QuickTemplateModal
  
  Future<void> _handleQuickSubmit() async {
    // Use extracted validator for comprehensive validation
    final validation = QuickTemplateValidator.validate(
      analysis: _analysis,
      amountText: _amountController.text,
      selectedMyCashLocationId: _selectedMyCashLocationId,
      selectedCounterpartyId: _selectedCounterpartyId,
      selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
      isDetailedMode: _showDetailedMode,
    );
    
    if (!validation.isValid) {
      _showError(validation.errors.first);
      return;
    }
    
    setState(() => _isSubmitting = true);
    
    try {
      // Use extracted transaction builder
      await QuickTransactionBuilder.createTransaction(
        ref: ref,
        template: widget.template,
        amount: validation.amountValue!,
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        selectedMyCashLocationId: _selectedMyCashLocationId,
        selectedCounterpartyId: _selectedCounterpartyId,
        selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.white),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Transaction created successfully! ⚡',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
  
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.error,
      ),
    );
  }
}