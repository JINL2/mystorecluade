import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../domain/entities/counter_party.dart';
import '../../domain/value_objects/counter_party_type.dart';
import '../providers/counter_party_params.dart';
import '../providers/counter_party_providers.dart';
import 'form/company_dropdown.dart';
import 'form/step_indicator.dart';
import 'form/step_navigation.dart';
import 'form/type_selector.dart';

class CounterPartyForm extends ConsumerStatefulWidget {
  final CounterParty? counterParty;

  const CounterPartyForm({
    super.key,
    this.counterParty,
  });

  @override
  ConsumerState<CounterPartyForm> createState() => _CounterPartyFormState();
}

class _CounterPartyFormState extends ConsumerState<CounterPartyForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  
  CounterPartyType _selectedType = CounterPartyType.other;
  bool _isInternal = false;
  String? _linkedCompanyId;
  bool _isLoading = false;
  
  // Step management
  int _currentStep = 0;
  final int _totalSteps = 3;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final List<String> _stepTitles = [
    'Basic Information',
    'Contact Details',
    'Additional Settings',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.slow,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: TossAnimations.standard),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: TossAnimations.standard),
    );
    _animationController.forward();
    
    // Add listener to name controller for real-time validation
    _nameController.addListener(_updateButtonState);
    
    if (widget.counterParty != null) {
      _populateForm(widget.counterParty!);
    }
  }

  void _updateButtonState() {
    // Trigger rebuild to update button state
    setState(() {});
  }

  void _populateForm(CounterParty counterParty) {
    _nameController.text = counterParty.name;
    _emailController.text = counterParty.email ?? '';
    _phoneController.text = counterParty.phone ?? '';
    _addressController.text = counterParty.address ?? '';
    _notesController.text = counterParty.notes ?? '';
    _selectedType = counterParty.type;
    _isInternal = counterParty.isInternal;
    _linkedCompanyId = counterParty.linkedCompanyId;
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateButtonState);
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveCounterParty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final companyId = ref.read(selectedCompanyIdProvider);
    if (companyId == null) {
      setState(() => _isLoading = false);
      _showError('No company selected');
      return;
    }

    try {
      if (widget.counterParty == null) {
        // Create new counter party
        final params = CreateCounterPartyParams(
          companyId: companyId,
          name: _nameController.text.trim(),
          type: _selectedType,
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          isInternal: _isInternal,
          linkedCompanyId: _linkedCompanyId,
        );

        await ref.read(createCounterPartyProvider(params).future);

        // Refresh counter party list immediately
        ref.invalidate(optimizedCounterPartyDataProvider(companyId));

        if (mounted) {
          Navigator.of(context).pop(true);
          _showSuccess('Counter party created successfully');
        }
      } else {
        // Update existing counter party
        final params = UpdateCounterPartyParams(
          counterpartyId: widget.counterParty!.counterpartyId,
          companyId: companyId,
          name: _nameController.text.trim(),
          type: _selectedType,
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          isInternal: _isInternal,
          linkedCompanyId: _linkedCompanyId,
        );

        await ref.read(updateCounterPartyProvider(params).future);

        // Refresh counter party list immediately
        final currentCompanyId = ref.read(selectedCompanyIdProvider);
        if (currentCompanyId != null) {
          ref.invalidate(optimizedCounterPartyDataProvider(currentCompanyId));
        }

        if (mounted) {
          Navigator.of(context).pop(true);
          _showSuccess('Counter party updated successfully');
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.error(
        title: 'Error',
        message: message,
        primaryButtonText: 'OK',
        onPrimaryPressed: () => context.pop(),
      ),
    );
  }

  void _showSuccess(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossDialog.success(
        title: 'Success',
        message: message,
        primaryButtonText: 'Done',
        onPrimaryPressed: () => context.pop(),
      ),
    );
  }

  void _showDeleteConfirmation() {
    TossConfirmCancelDialog.showDelete(
      context: context,
      title: 'Delete Counter Party',
      message: 'Are you sure you want to delete "${widget.counterParty?.name}"?\n\nThis action cannot be undone.',
      onConfirm: _deleteCounterParty,
    );
  }

  Future<void> _deleteCounterParty() async {
    if (widget.counterParty == null) return;
    
    // Close confirmation dialog
    context.pop();
    
    setState(() => _isLoading = true);

    try {
      final result = await ref.read(
        deleteCounterPartyProvider(widget.counterParty!.counterpartyId).future,
      );
      
      if (result) {
        if (mounted) {
          Navigator.of(context).pop(true); // Return true to indicate successful deletion
          _showSuccess('Counter party deleted successfully');
        }
      } else {
        setState(() => _isLoading = false);
        _showError('Failed to delete counter party');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('An error occurred while deleting');
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      // Validate current step before proceeding
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _animateStepTransition();
      }
    } else {
      _saveCounterParty();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _animateStepTransition();
    }
  }

  void _animateStepTransition() {
    _animationController.reset();
    _animationController.forward();
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        // Basic Information
        return _nameController.text.trim().isNotEmpty;
      case 1:
        // Contact Details - optional validation
        return true;
      case 2:
        // Additional Settings
        return true;
      default:
        return true;
    }
  }

  // Getter to check if current step is valid for button styling
  bool get _isCurrentStepValid => _validateCurrentStep();

  Widget _buildStepIndicator() {
    return StepIndicator(
      currentStep: _currentStep,
      totalSteps: _totalSteps,
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1BasicInfo();
      case 1:
        return _buildStep2ContactDetails();
      case 2:
        return _buildStep3AdditionalSettings();
      default:
        return Container();
    }
  }

  Widget _buildStep1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name field
        TossTextField(
          controller: _nameController,
          label: 'Name',
          hintText: 'Enter full name',
          prefixIcon: const Icon(
            Icons.person_outline,
            size: 20,
            color: TossColors.gray500,
          ),
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Name is required';
            return null;
          },
        ),

        const SizedBox(height: 24),

        // Type selector
        TypeSelector(
          selectedType: _selectedType,
          onTypeChanged: (type) => setState(() => _selectedType = type),
        ),

        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildStep2ContactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TossTextField(
          controller: _emailController,
          label: 'Email',
          hintText: 'email@example.com',
          prefixIcon: const Icon(
            Icons.email_outlined,
            size: 20,
            color: TossColors.gray500,
          ),
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 20),

        TossTextField(
          controller: _phoneController,
          label: 'Phone',
          hintText: '+1 234 567 8900',
          prefixIcon: const Icon(
            Icons.phone_outlined,
            size: 20,
            color: TossColors.gray500,
          ),
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 20),

        TossTextField(
          controller: _addressController,
          label: 'Address',
          hintText: 'Enter address',
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            size: 20,
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildStep3AdditionalSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TossTextField(
          controller: _notesController,
          label: 'Notes',
          hintText: 'Additional notes or comments',
          prefixIcon: const Icon(
            Icons.note_outlined,
            size: 20,
            color: TossColors.gray500,
          ),
          maxLines: 3,
        ),

        const SizedBox(height: 24),

        // Internal toggle
        GestureDetector(
          onTap: () => setState(() {
            _isInternal = !_isInternal;
            if (!_isInternal) _linkedCompanyId = null;
          }),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: _isInternal ? TossColors.primary.withValues(alpha: 0.05) : TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: _isInternal ? TossColors.primary.withValues(alpha: 0.3) : TossColors.gray200,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space2),
                      decoration: BoxDecoration(
                        color: _isInternal ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.link,
                        size: 20,
                        color: _isInternal ? TossColors.primary : TossColors.gray600,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Internal Company',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Link to another company in your group',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _isInternal,
                      onChanged: (value) {
                        setState(() {
                          _isInternal = value;
                          if (!value) _linkedCompanyId = null;
                        });
                      },
                      activeTrackColor: TossColors.primary,
                    ),
                  ],
                ),
                if (_isInternal) ...[
                  const SizedBox(height: TossSpacing.space4),
                  CompanyDropdown(
                    linkedCompanyId: _linkedCompanyId,
                    onChanged: (value) => setState(() => _linkedCompanyId = value),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildStepNavigation() {
    return StepNavigation(
      currentStep: _currentStep,
      totalSteps: _totalSteps,
      isLoading: _isLoading,
      isCurrentStepValid: _isCurrentStepValid,
      isEditMode: widget.counterParty != null,
      onPrevious: _previousStep,
      onNext: _nextStep,
      onCancel: () => context.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(unlinkedCompaniesProvider);

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside of input fields
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toss-style handle and header
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.counterParty == null ? 'New Counter Party' : 'Edit Counter Party',
                          style: TossTextStyles.h3.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _stepTitles[_currentStep],
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Delete button (only for edit mode)
                        if (widget.counterParty != null) ...[
                          IconButton(
                            onPressed: _showDeleteConfirmation,
                            icon: const Icon(Icons.delete_outline, color: TossColors.error),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            tooltip: 'Delete Counter Party',
                          ),
                          const SizedBox(width: TossSpacing.space2),
                        ],
                        // Close button
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.close, color: TossColors.gray600),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Step content with animation
          Flexible(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(TossSpacing.space5).copyWith(
                        bottom: TossSpacing.space5 + MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Form content first
                            _buildCurrentStep(),
                            
                            // Step progress indicator at bottom
                            const SizedBox(height: TossSpacing.space3),
                            _buildStepIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Step navigation buttons - hide when keyboard appears
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            _buildStepNavigation(),
        ],
      ),
    ),
    );
  }
}