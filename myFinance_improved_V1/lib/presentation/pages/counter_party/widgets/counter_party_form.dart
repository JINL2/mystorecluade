import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import '../models/counter_party_models.dart';
import '../providers/counter_party_providers.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/toss/toss_dropdown.dart';

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
      duration: const Duration(milliseconds: 300),
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
            Navigator.of(context).pop(true); // Return true to indicate success
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TossColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: TossColors.error,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Delete',
                style: TossTextStyles.body.copyWith(
                  color: Colors.white,
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalSteps, (index) {
          return Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: index == _currentStep ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index <= _currentStep ? TossColors.primary : TossColors.gray300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              if (index < _totalSteps - 1)
                Container(
                  width: 16,
                  height: 1,
                  color: index < _currentStep ? TossColors.primary : TossColors.gray200,
                  margin: EdgeInsets.symmetric(horizontal: 6),
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
        _buildModernTextField(
          controller: _nameController,
          label: 'Name',
          placeholder: 'Enter full name',
          icon: Icons.person_outline,
          required: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Name is required';
            return null;
          },
        ),
        
        SizedBox(height: 24),

        // Type selector
        Text(
          'Select Type',
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _buildTypeOption(CounterPartyType.myCompany, Icons.business, const Color(0xFF007AFF)),
            _buildTypeOption(CounterPartyType.teamMember, Icons.group, const Color(0xFF34C759)),
            _buildTypeOption(CounterPartyType.supplier, Icons.local_shipping, const Color(0xFF5856D6)),
            _buildTypeOption(CounterPartyType.employee, Icons.badge, const Color(0xFFFF9500)),
            _buildTypeOption(CounterPartyType.customer, Icons.people, const Color(0xFFFF3B30)),
            _buildTypeOption(CounterPartyType.other, Icons.category, const Color(0xFF8E8E93)),
          ],
        ),

        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStep2ContactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernTextField(
          controller: _emailController,
          label: 'Email',
          placeholder: 'email@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: 20),

        _buildModernTextField(
          controller: _phoneController,
          label: 'Phone',
          placeholder: '+1 234 567 8900',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),

        SizedBox(height: 20),

        _buildModernTextField(
          controller: _addressController,
          label: 'Address',
          placeholder: 'Enter address',
          icon: Icons.location_on_outlined,
        ),

        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStep3AdditionalSettings() {
    // Always watch the provider, even if not internal
    final unlinkedCompaniesAsync = ref.watch(unlinkedCompaniesProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernTextField(
          controller: _notesController,
          label: 'Notes',
          placeholder: 'Additional notes or comments',
          icon: Icons.note_outlined,
          maxLines: 3,
        ),

        SizedBox(height: 24),

        // Internal toggle
        GestureDetector(
          onTap: () => setState(() {
            _isInternal = !_isInternal;
            if (!_isInternal) _linkedCompanyId = null;
          }),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isInternal ? TossColors.primary.withOpacity(0.05) : TossColors.gray50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isInternal ? TossColors.primary.withOpacity(0.3) : TossColors.gray200,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isInternal ? TossColors.primary.withOpacity(0.1) : TossColors.gray100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.link, 
                        size: 20, 
                        color: _isInternal ? TossColors.primary : TossColors.gray600,
                      ),
                    ),
                    SizedBox(width: 12),
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
                          SizedBox(height: 2),
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
                      activeColor: TossColors.primary,
                    ),
                  ],
                ),
                if (_isInternal) ...[
                  SizedBox(height: 16),
                  _buildCompanyDropdown(unlinkedCompaniesAsync),
                ],
              ],
            ),
          ),
        ),

        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStepNavigation() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
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
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: TossColors.gray50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, size: 18, color: TossColors.gray600),
                      SizedBox(width: 6),
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
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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

            SizedBox(width: 12),

            // Next/Create button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isLoading || !_isCurrentStepValid ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCurrentStepValid ? TossColors.primary : TossColors.gray300,
                  foregroundColor: _isCurrentStepValid ? Colors.white : TossColors.gray500,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  disabledBackgroundColor: TossColors.gray300,
                  disabledForegroundColor: TossColors.gray500,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                              color: _isCurrentStepValid ? Colors.white : TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            _currentStep < _totalSteps - 1 
                                ? Icons.arrow_forward 
                                : Icons.check,
                            size: 18,
                            color: _isCurrentStepValid ? Colors.white : TossColors.gray500,
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
    ref.watch(unlinkedCompaniesProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
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
                margin: EdgeInsets.only(top: 12, bottom: 16),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                        SizedBox(height: 2),
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
                            icon: Icon(Icons.delete_outline, color: TossColors.error),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                            tooltip: 'Delete Counter Party',
                          ),
                          SizedBox(width: 8),
                        ],
                        // Close button
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: TossColors.gray600),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(minWidth: 40, minHeight: 40),
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
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Form content first
                            _buildCurrentStep(),
                            
                            // Step progress indicator at bottom
                            SizedBox(height: 12),
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

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (required) ...[
              SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(color: TossColors.error),
              ),
            ],
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: TossTextStyles.body.copyWith(color: TossColors.gray900),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TossTextStyles.body.copyWith(color: TossColors.gray400),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 12, right: 8),
              child: Icon(icon, size: 20, color: TossColors.gray500),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: TossColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: TossColors.gray200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: TossColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: TossColors.error, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeOption(CounterPartyType type, IconData icon, Color color) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : TossColors.gray50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : TossColors.gray200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon, 
                size: 24, 
                color: isSelected ? color : TossColors.gray500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              type.displayName,
              style: TossTextStyles.caption.copyWith(
                fontSize: 11,
                color: isSelected ? color : TossColors.gray600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyDropdown(AsyncValue<List<Map<String, dynamic>>> companiesAsync) {
    return companiesAsync.when(
      data: (companies) {
        if (companies.isEmpty) {
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TossColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: TossColors.warning),
                SizedBox(width: 8),
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
          onChanged: (value) => setState(() => _linkedCompanyId = value),
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
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TossColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, size: 16, color: TossColors.error),
            SizedBox(width: 8),
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