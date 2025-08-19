import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/themes/toss_animations.dart';
import '../constants/counter_party_colors.dart';
import '../models/counter_party_models.dart';
import '../providers/counter_party_providers.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/toss/toss_dropdown.dart';
import '../../../widgets/toss/toss_text_field.dart';
import '../../../widgets/common/toss_type_selector.dart';

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
    'Additional Settings'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.slow,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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

    final selectedCompany = ref.read(selectedCompanyProvider);
    if (selectedCompany == null) {
      setState(() => _isLoading = false);
      _showError('No company selected');
      return;
    }

    final formData = CounterPartyFormData(
      counterpartyId: widget.counterParty?.counterpartyId,
      companyId: selectedCompany['company_id'],
      name: _nameController.text.trim(),
      type: _selectedType,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
      isInternal: _isInternal,
      linkedCompanyId: _linkedCompanyId,
    );


    try {
      CounterPartyResponse response;
      if (widget.counterParty == null) {
        response = await ref.read(createCounterPartyProvider(formData).future);
      } else {
        response = await ref.read(updateCounterPartyProvider(formData).future);
      }

      response.when(
        success: (data, message) {
          if (mounted) {
            Navigator.of(context).pop();
            _showSuccess(message ?? 'Saved successfully');
          }
        },
        error: (message, code) {
          setState(() => _isLoading = false);
          _showError(message);
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('An error occurred');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.lg)),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: TossColors.error,
                  size: TossSpacing.iconMD,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  'Delete Counter Party',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${widget.counterParty?.name}"?\n\nThis action cannot be undone.',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4, vertical: TossSpacing.space2),
              ),
              child: Text(
                'Cancel',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _deleteCounterParty,
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.error,
                foregroundColor: TossColors.textInverse,
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5, vertical: TossSpacing.space2 + 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                elevation: TossSpacing.space0,
              ),
              child: Text(
                'Delete',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textInverse,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCounterParty() async {
    if (widget.counterParty == null) return;
    
    // Close confirmation dialog
    Navigator.of(context).pop();
    
    setState(() => _isLoading = true);

    try {
      final result = await ref.read(
        deleteCounterPartyProvider(widget.counterParty!.counterpartyId).future
      );
      
      if (result) {
        if (mounted) {
          Navigator.of(context).pop(); // Close form
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
      } else {
        // Show validation error message
        _showValidationError();
      }
    } else {
      // Final step - validate before saving
      if (_validateCurrentStep()) {
        _saveCounterParty();
      } else {
        _showValidationError();
      }
    }
  }
  
  void _showValidationError() {
    String message = '';
    switch (_currentStep) {
      case 0:
        message = 'Please enter a name for the counter party';
        break;
      case 2:
        if (_isInternal && _linkedCompanyId == null) {
          message = 'Please select a linked company or disable internal company';
        }
        break;
    }
    
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: TossColors.textInverse, size: 20),
              SizedBox(width: TossSpacing.space2),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: TossColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
          margin: EdgeInsets.all(TossSpacing.space4),
        ),
      );
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
        // Additional Settings - validate internal company selection
        if (_isInternal && _linkedCompanyId == null) {
          return false; // Must select a linked company when internal is enabled
        }
        return true;
      default:
        return true;
    }
  }

  // Getter to check if current step is valid for button styling
  bool get _isCurrentStepValid => _validateCurrentStep();

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalSteps, (index) {
          return Row(
            children: [
              AnimatedContainer(
                duration: TossAnimations.slow,
                width: index == _currentStep ? TossSpacing.space8 : TossSpacing.space2,
                height: TossSpacing.space2,
                decoration: BoxDecoration(
                  color: index <= _currentStep ? TossColors.primary : TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossSpacing.space1),
                ),
              ),
              if (index < _totalSteps - 1)
                Container(
                  width: TossSpacing.space4,
                  height: TossSpacing.space0 + 1,
                  color: index < _currentStep ? TossColors.primary : TossColors.gray200,
                  margin: EdgeInsets.symmetric(horizontal: TossSpacing.space1 + 2),
                ),
            ],
          );
        }),
      ),
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
          label: 'Name *',
          hintText: 'Enter full name',
          validator: (value) {
            if (value == null || value.isEmpty) return 'Name is required';
            return null;
          },
        ),
        
        SizedBox(height: TossSpacing.space6),

        // Type selector using reusable component
        TossTypeSelector<CounterPartyType>(
          label: 'Select Type',
          selectedValue: _selectedType,
          onChanged: (type) => setState(() => _selectedType = type),
          options: [
            TossTypeOption(
              value: CounterPartyType.myCompany,
              label: CounterPartyType.myCompany.displayName,
              icon: CounterPartyColors.getTypeIcon(CounterPartyType.myCompany),
              color: CounterPartyColors.getTypeColor(CounterPartyType.myCompany),
            ),
            TossTypeOption(
              value: CounterPartyType.teamMember,
              label: CounterPartyType.teamMember.displayName,
              icon: CounterPartyColors.getTypeIcon(CounterPartyType.teamMember),
              color: CounterPartyColors.getTypeColor(CounterPartyType.teamMember),
            ),
            TossTypeOption(
              value: CounterPartyType.supplier,
              label: CounterPartyType.supplier.displayName,
              icon: CounterPartyColors.getTypeIcon(CounterPartyType.supplier),
              color: CounterPartyColors.getTypeColor(CounterPartyType.supplier),
            ),
            TossTypeOption(
              value: CounterPartyType.employee,
              label: CounterPartyType.employee.displayName,
              icon: CounterPartyColors.getTypeIcon(CounterPartyType.employee),
              color: CounterPartyColors.getTypeColor(CounterPartyType.employee),
            ),
            TossTypeOption(
              value: CounterPartyType.customer,
              label: CounterPartyType.customer.displayName,
              icon: CounterPartyColors.getTypeIcon(CounterPartyType.customer),
              color: CounterPartyColors.getTypeColor(CounterPartyType.customer),
            ),
            TossTypeOption(
              value: CounterPartyType.other,
              label: CounterPartyType.other.displayName,
              icon: CounterPartyColors.getTypeIcon(CounterPartyType.other),
              color: CounterPartyColors.getTypeColor(CounterPartyType.other),
            ),
          ],
        ),

        SizedBox(height: TossSpacing.space4),
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
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: TossSpacing.space5),

        TossTextField(
          controller: _phoneController,
          label: 'Phone',
          hintText: '+1 234 567 8900',
          keyboardType: TextInputType.phone,
        ),

        SizedBox(height: TossSpacing.space5),

        TossTextField(
          controller: _addressController,
          label: 'Address',
          hintText: 'Enter address',
        ),

        SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildStep3AdditionalSettings() {
    // Always watch the provider, even if not internal
    final unlinkedCompaniesAsync = ref.watch(unlinkedCompaniesProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TossTextField(
          controller: _notesController,
          label: 'Notes',
          hintText: 'Additional notes or comments',
          maxLines: 3,
        ),

        SizedBox(height: TossSpacing.space6),

        // Internal toggle
        GestureDetector(
          onTap: () => setState(() {
            _isInternal = !_isInternal;
            if (!_isInternal) _linkedCompanyId = null;
          }),
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: _isInternal 
                ? (_linkedCompanyId == null 
                  ? TossColors.warning.withOpacity(0.05) 
                  : TossColors.primary.withOpacity(0.05))
                : TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: _isInternal 
                  ? (_linkedCompanyId == null 
                    ? TossColors.warning.withOpacity(0.3) 
                    : TossColors.primary.withOpacity(0.3))
                  : TossColors.gray200,
                width: TossSpacing.space0 + 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(TossSpacing.space2),
                      decoration: BoxDecoration(
                        color: _isInternal 
                          ? (_linkedCompanyId == null 
                            ? TossColors.warning.withOpacity(0.1) 
                            : TossColors.primary.withOpacity(0.1))
                          : TossColors.gray100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.link, 
                        size: TossSpacing.iconMD, 
                        color: _isInternal 
                          ? (_linkedCompanyId == null 
                            ? TossColors.warning 
                            : TossColors.primary)
                          : TossColors.gray600,
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),
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
                          SizedBox(height: TossSpacing.space1),
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
                          if (!value) {
                            _linkedCompanyId = null;
                          }
                        });
                      },
                      activeColor: TossColors.primary,
                    ),
                  ],
                ),
                if (_isInternal) ...[
                  SizedBox(height: TossSpacing.space4),
                  _buildCompanyDropdown(unlinkedCompaniesAsync),
                  if (_linkedCompanyId == null) ...[
                    SizedBox(height: TossSpacing.space2),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: TossColors.warning,
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Expanded(
                          child: Text(
                            'You must select a linked company to continue',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.warning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),

        SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildStepNavigation() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.textInverse,
        border: Border(
          top: BorderSide(color: TossColors.gray100, width: TossSpacing.space0 + 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            if (_currentStep > 0)
              Expanded(
                child: TextButton(
                  onPressed: _isLoading ? null : _previousStep,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                    backgroundColor: TossColors.gray50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, size: TossSpacing.iconSM, color: TossColors.gray600),
                      SizedBox(width: TossSpacing.space1 + 2),
                      Text(
                        'Back',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            SizedBox(width: TossSpacing.space3),

            // Next/Create button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isLoading || !_isCurrentStepValid ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCurrentStepValid ? TossColors.primary : TossColors.gray300,
                  foregroundColor: _isCurrentStepValid ? TossColors.textInverse : TossColors.gray500,
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  elevation: TossSpacing.space0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  disabledBackgroundColor: TossColors.gray300,
                  disabledForegroundColor: TossColors.gray500,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: TossSpacing.iconMD,
                        width: TossSpacing.iconMD,
                        child: CircularProgressIndicator(
                          strokeWidth: TossSpacing.space0 + 2,
                          valueColor: AlwaysStoppedAnimation<Color>(TossColors.textInverse),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentStep < _totalSteps - 1 
                                ? 'Next' 
                                : (widget.counterParty == null ? 'Create' : 'Update'),
                            style: TossTextStyles.body.copyWith(
                              color: _isCurrentStepValid ? TossColors.textInverse : TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space1 + 2),
                          Icon(
                            _currentStep < _totalSteps - 1 
                                ? Icons.arrow_forward 
                                : Icons.check,
                            size: TossSpacing.iconSM,
                            color: _isCurrentStepValid ? TossColors.textInverse : TossColors.gray500,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unlinkedCompaniesAsync = ref.watch(unlinkedCompaniesProvider);

    return Container(
      decoration: BoxDecoration(
        color: TossColors.textInverse,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xxl),
          topRight: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toss-style handle and header
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: TossSpacing.space3, bottom: TossSpacing.space4),
                width: TossSpacing.space12,
                height: TossSpacing.space1,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
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
                        SizedBox(height: TossSpacing.space1),
                        Text(
                          _stepTitles[_currentStep],
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
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
                            icon: Icon(Icons.delete_outline, color: TossColors.error),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(minWidth: TossSpacing.space10, minHeight: TossSpacing.space10),
                            tooltip: 'Delete Counter Party',
                          ),
                          SizedBox(width: TossSpacing.space2),
                        ],
                        // Close button
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: TossColors.gray600),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(minWidth: TossSpacing.space10, minHeight: TossSpacing.space10),
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
                      padding: EdgeInsets.all(TossSpacing.space5),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Form content first
                            _buildCurrentStep(),
                            
                            // Step progress indicator at bottom
                            SizedBox(height: TossSpacing.space3),
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

          // Step navigation buttons
          _buildStepNavigation(),
        ],
      ),
    );
  }



  Widget _buildCompanyDropdown(AsyncValue<List<Map<String, dynamic>>> companiesAsync) {
    return companiesAsync.when(
      data: (companies) {
        if (companies.isEmpty) {
          return Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: TossSpacing.iconSM, color: TossColors.warning),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'No companies available',
                  style: TossTextStyles.caption.copyWith(color: TossColors.warning),
                ),
              ],
            ),
          );
        }

        // Convert companies to TossDropdownItems
        final dropdownItems = companies.map((company) {
          return TossDropdownItem<String>(
            value: company['company_id'] as String,
            label: company['company_name'] ?? 'Unknown Company',
            // No subtitle needed - cleaner interface
          );
        }).toList();

        return TossDropdown<String>(
          label: 'Linked Company',
          value: _linkedCompanyId,
          items: dropdownItems,
          hint: 'Select linked company',
          onChanged: (value) {
            setState(() {
              _linkedCompanyId = value;
            });
          },
        );
      },
      loading: () => TossDropdown<String>(
        label: 'Linked Company',
        value: null,
        items: const [],
        hint: 'Loading companies...',
        isLoading: true,
        onChanged: null,
      ),
      error: (_, __) => Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, size: TossSpacing.iconSM, color: TossColors.error),
            SizedBox(width: TossSpacing.space2),
            Text(
              'Error loading companies',
              style: TossTextStyles.caption.copyWith(color: TossColors.error),
            ),
          ],
        ),
      ),
    );
  }
}