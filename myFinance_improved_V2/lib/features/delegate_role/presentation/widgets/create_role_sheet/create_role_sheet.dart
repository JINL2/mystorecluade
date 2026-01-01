import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/features/delegate_role/di/delegate_role_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import 'role_basic_info_step.dart';
import 'role_permissions_step.dart';
import 'role_tags_step.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Create Role Bottom Sheet
///
/// Multi-step role creation flow:
/// 1. Basic info (name, description)
/// 2. Permissions selection
/// 3. Tags (optional)
class CreateRoleSheet extends ConsumerStatefulWidget {
  const CreateRoleSheet({super.key});

  @override
  ConsumerState<CreateRoleSheet> createState() => _CreateRoleSheetState();
}

class _CreateRoleSheetState extends ConsumerState<CreateRoleSheet> {
  final TextEditingController _roleNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _roleNameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  bool _isCreating = false;
  bool _isEditingText = false;
  int _currentStep = 0;

  final Set<String> _selectedPermissions = {};
  final Set<String> _expandedCategories = {};
  final List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _roleNameFocus.addListener(_onTextEditingStateChanged);
    _descriptionFocus.addListener(_onTextEditingStateChanged);
    _roleNameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _roleNameFocus.removeListener(_onTextEditingStateChanged);
    _descriptionFocus.removeListener(_onTextEditingStateChanged);
    _roleNameController.dispose();
    _descriptionController.dispose();
    _roleNameFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _onTextEditingStateChanged() {
    final isEditing = _roleNameFocus.hasFocus || _descriptionFocus.hasFocus;
    if (_isEditingText != isEditing) {
      setState(() => _isEditingText = isEditing);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          _buildSheetContent(),
          _buildKeyboardToolbars(),
        ],
      ),
    );
  }

  Widget _buildSheetContent() {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          _buildStepIndicator(),
          const SizedBox(height: TossSpacing.space3),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: _buildCurrentStep(),
            ),
          ),
          if (!(_currentStep == 0 && _isEditingText && _roleNameController.text.trim().isEmpty)) _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: TossSpacing.space3),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: TossColors.gray300,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Stack(
        children: [
          // Back button (left)
          if (_currentStep > 0)
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: TossColors.gray600),
                onPressed: () => setState(() => _currentStep--),
              ),
            ),
          // Title (centered on screen)
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_getStepTitle(), style: TossTextStyles.h3, textAlign: TextAlign.center),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  _getStepDescription(),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Close button (right)
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: TossColors.gray600),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepDot(0),
          _buildStepLine(0),
          _buildStepDot(1),
          _buildStepLine(1),
          _buildStepDot(2),
        ],
      ),
    );
  }

  Widget _buildStepDot(int step) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive || isCompleted ? TossColors.primary : TossColors.gray200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, size: 16, color: TossColors.white)
            : Text(
                '${step + 1}',
                style: TossTextStyles.body.copyWith(
                  color: isActive ? TossColors.white : TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final isCompleted = _currentStep > step;

    return Container(
      width: 30,
      height: 2,
      color: isCompleted ? TossColors.primary : TossColors.gray200,
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return RoleBasicInfoStep(
          roleNameController: _roleNameController,
          descriptionController: _descriptionController,
          roleNameFocus: _roleNameFocus,
          descriptionFocus: _descriptionFocus,
        );
      case 1:
        return RolePermissionsStep(
          selectedPermissions: _selectedPermissions,
          expandedCategories: _expandedCategories,
          onTogglePermission: (id) => setState(() {
            if (_selectedPermissions.contains(id)) {
              _selectedPermissions.remove(id);
            } else {
              _selectedPermissions.add(id);
            }
          }),
          onToggleCategoryPermissions: (ids, select) => setState(() {
            if (select) {
              _selectedPermissions.addAll(ids);
            } else {
              _selectedPermissions.removeAll(ids);
            }
          }),
          onToggleExpandCategory: () => setState(() {}),
        );
      case 2:
        return RoleTagsStep(
          selectedTags: _selectedTags,
          onAddTag: (tag) => setState(() => _selectedTags.add(tag)),
          onRemoveTag: (tag) => setState(() => _selectedTags.remove(tag)),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(top: BorderSide(color: TossColors.gray200)),
      ),
      child: SafeArea(
        top: false,
        child: TossPrimaryButton(
          onPressed: _handleStepAction,
          isLoading: _isCreating,
          isEnabled: !_isCreating && _canProceed(),
          text: _getActionButtonText(),
          fullWidth: true,
        ),
      ),
    );
  }

  Widget _buildKeyboardToolbars() {
    return Column(
      children: [
        KeyboardToolbar1(
          focusNode: _roleNameFocus,
          showToolbar: true,
          showNavigation: false,
          onDone: () => FocusScope.of(context).unfocus(),
        ),
        KeyboardToolbar1(
          focusNode: _descriptionFocus,
          showToolbar: true,
          showNavigation: false,
          onDone: () => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Create New Role';
      case 1:
        return 'Configure Permissions';
      case 2:
        return 'Add Tags (Optional)';
      default:
        return '';
    }
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case 0:
        return 'Define the role name and description';
      case 1:
        return 'Select what this role can access and do';
      case 2:
        return 'Add tags to help categorize and organize';
      default:
        return '';
    }
  }

  String _getActionButtonText() {
    return _currentStep < 2 ? 'Next' : 'Create Role';
  }

  bool _canProceed() {
    if (_currentStep == 0) {
      return _roleNameController.text.trim().isNotEmpty;
    }
    return true;
  }

  void _handleStepAction() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _createRole();
    }
  }

  Future<void> _createRole() async {
    final roleName = _roleNameController.text.trim();
    if (roleName.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => TossDialog.error(
          title: 'Role Name Required',
          message: 'Please enter a role name',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }

      final createRoleUseCase = ref.read(createRoleUseCaseProvider);
      final roleId = await createRoleUseCase.execute(
        companyId: companyId,
        roleNameStr: roleName,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        roleType: 'custom',
        tagsStr: _selectedTags.isNotEmpty ? _selectedTags : null,
      );

      if (_selectedPermissions.isNotEmpty) {
        final updatePermissionsUseCase = ref.read(updateRolePermissionsUseCaseProvider);
        await updatePermissionsUseCase.execute(
          roleId: roleId,
          permissions: _selectedPermissions,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => TossDialog.success(
            title: 'Role Created!',
            message: 'Role "$roleName" has been created successfully',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => TossDialog.error(
            title: 'Failed to Create Role',
            message: 'Could not create role: $e',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }
}
