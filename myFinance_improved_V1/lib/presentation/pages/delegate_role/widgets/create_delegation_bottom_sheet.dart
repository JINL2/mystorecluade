import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../models/delegate_role_models.dart';
import '../providers/delegate_role_providers.dart';

class CreateDelegationBottomSheet extends ConsumerStatefulWidget {
  final String? preselectedRoleId;
  final String? preselectedRoleName;

  const CreateDelegationBottomSheet({
    super.key,
    this.preselectedRoleId,
    this.preselectedRoleName,
  });

  static Future<void> show(
    BuildContext context, {
    String? preselectedRoleId,
    String? preselectedRoleName,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateDelegationBottomSheet(
        preselectedRoleId: preselectedRoleId,
        preselectedRoleName: preselectedRoleName,
      ),
    );
  }

  @override
  ConsumerState<CreateDelegationBottomSheet> createState() => _CreateDelegationBottomSheetState();
}

class _CreateDelegationBottomSheetState extends ConsumerState<CreateDelegationBottomSheet> {
  String? _selectedUserId;
  String? _selectedRoleId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRoleId = widget.preselectedRoleId;
  }

  @override
  Widget build(BuildContext context) {
    final companyUsersAsync = ref.watch(companyUsersProvider);
    final delegatableRolesAsync = ref.watch(delegatableRolesProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: TossSpacing.space3),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  ),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.all(TossSpacing.space5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create Role Delegation',
                      style: TossTextStyles.h2,
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Select User
                      Text(
                        'Select User',
                        style: TossTextStyles.labelLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      companyUsersAsync.when(
                        data: (users) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: TossColors.gray300),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedUserId,
                              isExpanded: true,
                              hint: Padding(
                                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                                child: Text(
                                  'Choose a user to delegate to',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray500,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                              items: users.map((user) {
                                return DropdownMenuItem<String>(
                                  value: user['id'] as String,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        user['name'],
                                        style: TossTextStyles.body,
                                      ),
                                      Text(
                                        user['email'],
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedUserId = value;
                                });
                              },
                            ),
                          ),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => Text('Failed to load users'),
                      ),
                      
                      SizedBox(height: TossSpacing.space5),
                      
                      // Select Role
                      Text(
                        'Select Role',
                        style: TossTextStyles.labelLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      delegatableRolesAsync.when(
                        data: (roles) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: TossColors.gray300),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedRoleId,
                              isExpanded: true,
                              hint: Padding(
                                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                                child: Text(
                                  widget.preselectedRoleName ?? 'Choose a role to delegate',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray500,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                              items: roles.map((role) {
                                return DropdownMenuItem(
                                  value: role.roleId,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        role.roleName,
                                        style: TossTextStyles.body,
                                      ),
                                      Text(
                                        role.description,
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRoleId = value;
                                });
                              },
                            ),
                          ),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => Text('Failed to load roles'),
                      ),
                      
                      SizedBox(height: TossSpacing.space5),
                      
                      // Date Range
                      Text(
                        'Delegation Period',
                        style: TossTextStyles.labelLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(
                              label: 'Start Date',
                              date: _startDate,
                              onTap: () => _selectDate(true),
                            ),
                          ),
                          SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: _buildDateField(
                              label: 'End Date',
                              date: _endDate,
                              onTap: () => _selectDate(false),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: TossSpacing.space2),
                      
                      // Duration info
                      Container(
                        padding: EdgeInsets.all(TossSpacing.space3),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: TossColors.gray600,
                            ),
                            SizedBox(width: TossSpacing.space2),
                            Text(
                              'Duration: ${_endDate.difference(_startDate).inDays} days',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: TossSpacing.space8),
                    ],
                  ),
                ),
              ),
              
              // Bottom action
              Container(
                padding: EdgeInsets.all(TossSpacing.space5),
                decoration: BoxDecoration(
                  color: TossColors.background,
                  border: Border(
                    top: BorderSide(color: TossColors.gray200),
                  ),
                ),
                child: TossPrimaryButton(
                  text: 'Create Delegation',
                  onPressed: _canSubmit() ? _handleSubmit : null,
                  isLoading: _isLoading,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          border: Border.all(color: TossColors.gray300),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
            SizedBox(height: TossSpacing.space1),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: TossColors.gray600,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: TossTextStyles.body,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: isStartDate ? DateTime.now() : _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  bool _canSubmit() {
    return _selectedUserId != null && 
           _selectedRoleId != null && 
           !_isLoading;
  }

  Future<void> _handleSubmit() async {
    if (!_canSubmit()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final rolesAsync = ref.read(delegatableRolesProvider);
      final selectedRole = rolesAsync.valueOrNull?.firstWhere(
        (role) => role.roleId == _selectedRoleId,
      );
      
      if (selectedRole == null) {
        throw Exception('Selected role not found');
      }
      
      final createDelegation = ref.read(createDelegationProvider);
      await createDelegation(
        CreateDelegationRequest(
          delegateId: _selectedUserId!,
          roleId: _selectedRoleId!,
          permissions: selectedRole.permissions,
          startDate: _startDate,
          endDate: _endDate,
        ),
      );
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Delegation created successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create delegation: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}