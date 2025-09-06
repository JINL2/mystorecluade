import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_secondary_button.dart';
import 'widgets/template_usage_bottom_sheet.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import '../../widgets/toss/keyboard/toss_numberpad_modal.dart';

/// Full-page version of template usage for better keyboard handling
/// Uses same pattern as sale_payment_page.dart
class TemplateUsagePage extends ConsumerStatefulWidget {
  final Map<String, dynamic> template;
  
  const TemplateUsagePage({
    super.key,
    required this.template,
  });
  
  static void show(BuildContext context, Map<String, dynamic> template) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TemplateUsagePage(template: template),
        fullscreenDialog: true,
      ),
    );
  }
  
  @override
  ConsumerState<TemplateUsagePage> createState() => _TemplateUsagePageState();
}

class _TemplateUsagePageState extends ConsumerState<TemplateUsagePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _numberFormat = NumberFormat('#,###');
  
  bool _isSubmitting = false;
  String _previousValue = '';
  
  // Selected values
  String? _selectedMyCashLocationId;
  String? _selectedCounterpartyCashLocationId;
  
  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatNumber);
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
  
  bool get _isFormValid {
    if (_amountController.text.isEmpty) return false;
    final cleanAmount = _amountController.text.replaceAll(',', '');
    final amount = int.tryParse(cleanAmount);
    return amount != null && amount > 0;
  }
  
  @override
  Widget build(BuildContext context) {
    final String templateName = widget.template['name']?.toString() ?? 'Transaction Template';
    
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: templateName,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // Main content - scrollable
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Template Info Card
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(Icons.receipt, size: 20, color: TossColors.primary),
                    SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: Text(
                        templateName,
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Amount Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount *',
                    style: TossTextStyles.label.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  GestureDetector(
                    onTap: () async {
                      final result = await TossNumberpadModal.show(
                        context: context,
                        title: 'Enter Amount',
                        initialValue: _amountController.text.replaceAll(',', ''),
                        // No currency symbol - universal numberpad
                        allowDecimal: false,
                        onConfirm: (value) {
                          _amountController.text = _numberFormat.format(int.parse(value));
                          setState(() {});
                        },
                      );
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.center,
                        style: TossTextStyles.h2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TossColors.gray900,
                        ),
                        decoration: InputDecoration(
                          hintText: '₩0',
                          hintStyle: TossTextStyles.h2.copyWith(
                            color: TossColors.gray300,
                            fontWeight: FontWeight.bold,
                          ),
                          filled: true,
                          fillColor: TossColors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            borderSide: BorderSide(color: TossColors.primary, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space4,
                            vertical: TossSpacing.space4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Description Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description (optional)',
                    style: TossTextStyles.label.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Add a note...',
                      filled: true,
                      fillColor: TossColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: BorderSide(color: TossColors.primary, width: 1.5),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Add more fields here as needed (cash location, counterparty, etc.)
              
              // Bottom padding for fixed button
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      
      // Fixed bottom buttons - EXACTLY like sale_payment_page!
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          border: Border(
            top: BorderSide(
              color: TossColors.gray200,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
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
                child: TossPrimaryButton(
                  text: _isSubmitting ? 'Creating...' : 'Create Transaction',
                  onPressed: (_isSubmitting || !_isFormValid) ? null : _handleSubmit,
                  isLoading: _isSubmitting,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    
    try {
      // Your existing transaction creation logic here
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction created successfully'),
            backgroundColor: TossColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create transaction'),
          backgroundColor: TossColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}