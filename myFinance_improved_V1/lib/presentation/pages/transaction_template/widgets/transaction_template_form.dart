import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_text_field.dart';
import '../models/transaction_template_model.dart';
import '../providers/transaction_template_providers.dart';
import '../../../providers/app_state_provider.dart';

class TransactionTemplateForm extends ConsumerStatefulWidget {
  final TransactionTemplate? template;
  
  const TransactionTemplateForm({
    super.key,
    this.template,
  });

  @override
  ConsumerState<TransactionTemplateForm> createState() => _TransactionTemplateFormState();
}

class _TransactionTemplateFormState extends ConsumerState<TransactionTemplateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  
  String _selectedType = 'expense';
  String? _selectedCategory;
  String? _selectedCounterParty;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _nameController.text = widget.template!.name;
      _descriptionController.text = widget.template!.description;
      _amountController.text = widget.template!.amount;
      _selectedType = widget.template!.transactionType;
      _selectedCounterParty = widget.template!.counterpartyId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveTemplate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Create data structure based on transaction type
      final transactionData = {
        'description': _descriptionController.text.trim(),
        'amount': double.tryParse(_amountController.text) ?? 0,
        'debit': _selectedType == 'expense' ? _amountController.text : '0',
        'credit': _selectedType == 'income' ? _amountController.text : '0',
      };

      final template = TransactionTemplate(
        templateId: widget.template?.templateId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        companyId: widget.template?.companyId ?? ref.read(appStateProvider).companyChoosen,
        name: _nameController.text.trim(),
        data: [transactionData],
        counterpartyId: _selectedCounterParty,
        isActive: true,
        visibilityLevel: 'company',
      );

      if (widget.template == null) {
        // Create new template - for now just invalidate to refresh
        ref.invalidate(transactionTemplatesProvider);
      } else {
        // Update existing template - for now just invalidate to refresh
        ref.invalidate(transactionTemplatesProvider);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.template == null ? 'Template created successfully' : 'Template updated successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save template: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 48,
            height: 4,
            margin: EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Text(
              widget.template == null ? 'Create Template' : 'Edit Template',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          
          // Form
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Template Name
                    TossTextField(
                      controller: _nameController,
                      label: 'Template Name',
                      hintText: 'Enter template name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a template name';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: TossSpacing.space4),
                    
                    // Type Selection
                    Text(
                      'Transaction Type',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    Row(
                      children: [
                        _buildTypeChip('income', 'Income', Icons.arrow_downward),
                        SizedBox(width: TossSpacing.space2),
                        _buildTypeChip('expense', 'Expense', Icons.arrow_upward),
                        SizedBox(width: TossSpacing.space2),
                        _buildTypeChip('transfer', 'Transfer', Icons.swap_horiz),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space4),
                    
                    // Description
                    TossTextField(
                      controller: _descriptionController,
                      label: 'Description (Optional)',
                      hintText: 'Enter description',
                      maxLines: 3,
                    ),
                    
                    SizedBox(height: TossSpacing.space4),
                    
                    // Default Amount
                    TossTextField(
                      controller: _amountController,
                      label: 'Default Amount (Optional)',
                      hintText: '0.00',
                      keyboardType: TextInputType.number,
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    // Save Button
                    TossPrimaryButton(
                      text: widget.template == null ? 'Create Template' : 'Save Changes',
                      onPressed: _isLoading ? null : _saveTemplate,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String value, String label, IconData icon) {
    final isSelected = _selectedType == value;
    
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedType = value),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: isSelected ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: isSelected ? TossColors.primary : TossColors.gray200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? TossColors.primary : TossColors.gray600,
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: isSelected ? TossColors.primary : TossColors.gray600,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}