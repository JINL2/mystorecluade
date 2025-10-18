/// Quick Template Bottom Sheet - Fast template creation for simple transactions
///
/// Purpose: Provides a streamlined interface for creating simple transaction templates:
/// - Quick amount input with number formatting
/// - Essential field detection and selection
/// - Minimal UI for common use cases
/// - Fast template creation workflow
///
/// Usage: QuickTemplateBottomSheet.show(context, template)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/keyboard/toss_textfield_keyboard_modal.dart';
// Updated imports to use new presentation layer components
import '../widgets/forms/quick_amount_input.dart';
import '../widgets/forms/essential_selectors.dart';
import '../widgets/forms/quick_status_indicator.dart';
import '../widgets/forms/collapsible_description.dart';
// Updated imports to use new application layer
import '../../domain/usecases/create_template_usecase.dart';
import '../../domain/value_objects/template_analysis_result.dart';

class QuickTemplateBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> template;
  
  const QuickTemplateBottomSheet({
    super.key,
    required this.template,
  });
  
  static Future<void> show(BuildContext context, Map<String, dynamic> template) {
    final GlobalKey<_QuickTemplateBottomSheetState> formKey = GlobalKey();
    
    return TossTextFieldKeyboardModal.show(
      context: context,
      title: 'Quick Template',
      content: QuickTemplateBottomSheet(key: formKey, template: template),
      actionButtons: [
        Expanded(
          child: TossSecondaryButton(
            text: 'Cancel',
            fullWidth: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: TossPrimaryButton(
            text: 'Create',
            fullWidth: true,
            onPressed: () async {
              final state = formKey.currentState;
              if (state != null && state._isFormValid) {
                await state._handleSubmit();
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  ConsumerState<QuickTemplateBottomSheet> createState() => _QuickTemplateBottomSheetState();
}

class _QuickTemplateBottomSheetState extends ConsumerState<QuickTemplateBottomSheet> {
  // Controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // State variables
  String? _selectedMyCashLocationId;
  String? _selectedCounterpartyId;
  String? _selectedCounterpartyCashLocationId;
  
  // Template analysis
  late TemplateAnalysisResult _analysis;
  
  @override
  void initState() {
    super.initState();
    // Analyze the template to determine what fields are needed
    _analysis = TemplateAnalysisResult.analyze(widget.template);
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  bool get _isFormValid {
    // Check if required fields are filled
    if (_amountController.text.isEmpty) return false;
    
    // Check if essential selections are complete based on analysis
    return _analysis.missingItems.every((item) {
      switch (item) {
        case 'cash_location':
          return _selectedMyCashLocationId != null;
        case 'counterparty':
          return _selectedCounterpartyId != null;
        case 'counterparty_cash_location':
          return _selectedCounterpartyCashLocationId != null;
        default:
          return true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicator showing template complexity
          QuickStatusIndicator(
            analysis: _analysis,
            showEstimatedTime: true,
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Amount input - the primary field for quick templates
          QuickAmountInput(
            controller: _amountController,
            onChanged: () => setState(() {}),
            label: 'Transaction Amount',
            hint: '0',
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Essential selectors - only show what's actually needed
          if (_analysis.missingItems.isNotEmpty) ...[
            EssentialSelectors(
              analysis: _analysis,
              selectedMyCashLocationId: _selectedMyCashLocationId,
              selectedCounterpartyId: _selectedCounterpartyId,
              selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
              onMyCashLocationChanged: (value) {
                setState(() {
                  _selectedMyCashLocationId = value;
                });
              },
              onCounterpartyChanged: (value) {
                setState(() {
                  _selectedCounterpartyId = value;
                });
              },
              onCounterpartyCashLocationChanged: (value) {
                setState(() {
                  _selectedCounterpartyCashLocationId = value;
                });
              },
            ),
            SizedBox(height: TossSpacing.space4),
          ],
          
          // Optional description
          CollapsibleDescription(
            controller: _descriptionController,
            title: 'Add Description (Optional)',
            hintText: 'Transaction description...',
            initiallyExpanded: false,
          ),
          
          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }
  
  Future<void> _handleSubmit() async {
    try {
      // Create transaction using the template with quick inputs
      // This would integrate with the existing business logic
      
      // For now, just close the modal
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create transaction: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
}