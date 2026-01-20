import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../di/inventory_providers.dart';
import '../../domain/exceptions/inventory_exceptions.dart';
import '../models/attribute_option_item.dart';
import '../providers/inventory_providers.dart';

/// Attribute Detail Page - Edit attribute name and manage options
class AttributeDetailPage extends ConsumerStatefulWidget {
  final String attributeId;
  final String attributeName;
  final bool isBuiltIn;

  const AttributeDetailPage({
    super.key,
    required this.attributeId,
    required this.attributeName,
    required this.isBuiltIn,
  });

  @override
  ConsumerState<AttributeDetailPage> createState() => _AttributeDetailPageState();
}

class _AttributeDetailPageState extends ConsumerState<AttributeDetailPage> {
  late TextEditingController _nameController;
  List<AttributeOptionItem> _options = [];
  List<AttributeOptionItem> _originalOptions = []; // Track original options for change detection
  final List<TextEditingController> _optionControllers = []; // Controllers for each option
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.attributeName);
    _nameController.addListener(_onNameChanged);
    _loadOptions();
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    for (final controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onNameChanged() {
    if (_nameController.text != widget.attributeName) {
      setState(() => _hasChanges = true);
    }
  }

  /// Initialize text controllers for all options
  void _initOptionControllers() {
    // Dispose existing controllers
    for (final controller in _optionControllers) {
      controller.dispose();
    }
    _optionControllers.clear();

    // Create new controllers for each option
    for (final option in _options) {
      _optionControllers.add(TextEditingController(text: option.value));
    }
  }

  Future<void> _loadOptions() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // For built-in attributes, load from metadata
      if (widget.isBuiltIn) {
        final metadataState = ref.read(inventoryMetadataNotifierProvider);
        final metadata = metadataState.metadata;

        if (metadata != null) {
          if (widget.attributeId == 'builtin_category') {
            _options = metadata.categories
                .map((c) => AttributeOptionItem(
                      id: c.id,
                      value: c.name,
                      sortOrder: 0,
                    ))
                .toList();
          } else if (widget.attributeId == 'builtin_brand') {
            _options = metadata.brands
                .map((b) => AttributeOptionItem(
                      id: b.id,
                      value: b.name,
                      sortOrder: 0,
                    ))
                .toList();
          }
        }
      } else {
        // For custom attributes, load options from metadata
        final metadataState = ref.read(inventoryMetadataNotifierProvider);
        final metadata = metadataState.metadata;

        if (metadata != null) {
          final attribute = metadata.attributes.firstWhere(
            (a) => a.id == widget.attributeId,
            orElse: () => throw Exception('Attribute not found'),
          );

          _options = attribute.options
              .map((o) => AttributeOptionItem(
                    id: o.id,
                    value: o.value,
                    sortOrder: o.sortOrder,
                  ))
              .toList();

          // Store original options for change detection
          _originalOptions = attribute.options
              .map((o) => AttributeOptionItem(
                    id: o.id,
                    value: o.value,
                    sortOrder: o.sortOrder,
                  ))
              .toList();

          // Create controllers for each option
          _initOptionControllers();
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        TossToast.error(context, 'Failed to load options');
      }
    }
  }

  void _addOption() {
    setState(() {
      _options.add(AttributeOptionItem(
        id: null,
        value: '',
        sortOrder: _options.length,
        isNew: true,
      ));
      _optionControllers.add(TextEditingController());
      _hasChanges = true;
    });
  }

  void _removeOption(int index) {
    setState(() {
      _options.removeAt(index);
      _optionControllers[index].dispose();
      _optionControllers.removeAt(index);
      _hasChanges = true;
    });
  }

  void _updateOptionValue(int index, String value) {
    setState(() {
      _options[index] = _options[index].copyWith(value: value);
      _hasChanges = true;
    });
  }

  Future<void> _save() async {
    if (!_hasChanges) {
      Navigator.pop(context);
      return;
    }

    // Validate
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      TossToast.warning(context, 'Please enter attribute name');
      return;
    }

    // Check for empty options (use controller values)
    for (final controller in _optionControllers) {
      if (controller.text.trim().isEmpty) {
        TossToast.warning(context, 'Please fill in all option values');
        return;
      }
    }

    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final userId = appState.userId;

    if (companyId.isEmpty) {
      TossToast.error(context, 'Company not selected');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(inventoryRepositoryProvider);

      // Build options array for RPC
      final optionsJson = _buildOptionsJson();

      // Only pass attribute name if it changed
      final newName = name != widget.attributeName ? name : null;

      await repository.updateAttributeAndOptions(
        companyId: companyId,
        attributeId: widget.attributeId,
        createdBy: userId,
        attributeName: newName,
        options: optionsJson.isNotEmpty ? optionsJson : null,
      );

      if (mounted) {
        // Refresh metadata and inventory list
        ref.read(inventoryMetadataNotifierProvider.notifier).refresh();
        ref.read(inventoryPageNotifierProvider.notifier).refresh();

        // Show success dialog
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Saved Successfully',
            message: 'Attribute changes have been saved',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => Navigator.of(context).pop(true),
          ),
        );

        if (mounted) {
          // Pop back to inventory list page
          // Navigation stack: InventoryManagementPage -> ProductDetailPage -> EditProductPage -> AttributesEditPage -> AttributeDetailPage
          // Pop 4 screens to return to InventoryManagementPage
          Navigator.of(context).pop(); // Pop AttributeDetailPage
          Navigator.of(context).pop(); // Pop AttributesEditPage
          Navigator.of(context).pop(); // Pop EditProductPage
          Navigator.of(context).pop(); // Pop ProductDetailPage
        }
      }
    } on InventoryAttributeException catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        TossToast.error(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        TossToast.error(context, 'Failed to save changes');
      }
    }
  }

  /// Build options JSON array for RPC
  /// Compares current options with original to determine actions
  List<Map<String, dynamic>> _buildOptionsJson() {
    final result = <Map<String, dynamic>>[];

    // Create a map of original options by ID for quick lookup
    final originalMap = <String, AttributeOptionItem>{};
    for (final option in _originalOptions) {
      if (option.id != null) {
        originalMap[option.id!] = option;
      }
    }

    // Track which original options are still present
    final presentIds = <String>{};

    // Process current options
    for (int i = 0; i < _options.length; i++) {
      final option = _options[i];
      final sortOrder = i + 1;
      // Get current value from controller
      final currentValue = _optionControllers[i].text.trim();

      if (option.id == null || option.isNew) {
        // New option - add action
        result.add({
          'action': 'add',
          'option_value': currentValue,
          'sort_order': sortOrder,
        });
      } else {
        // Existing option - check if it changed
        presentIds.add(option.id!);
        final original = originalMap[option.id!];

        if (original != null) {
          final valueChanged = currentValue != original.value;
          final sortOrderChanged = sortOrder != original.sortOrder;

          if (valueChanged || sortOrderChanged) {
            // Update action
            final updateData = <String, dynamic>{
              'action': 'update',
              'option_id': option.id,
            };
            if (valueChanged) {
              updateData['option_value'] = currentValue;
            }
            if (sortOrderChanged) {
              updateData['sort_order'] = sortOrder;
            }
            result.add(updateData);
          }
        }
      }
    }

    // Find deleted options (original options not in current list)
    for (final original in _originalOptions) {
      if (original.id != null && !presentIds.contains(original.id)) {
        result.add({
          'action': 'delete',
          'option_id': original.id,
        });
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return TossAppBar(
      title: widget.isBuiltIn ? widget.attributeName : 'Edit Attribute',
      backgroundColor: TossColors.white,
      actions: [
        if (!widget.isBuiltIn)
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: Text(
              'Save',
              style: TossTextStyles.body.copyWith(
                color: _hasChanges ? TossColors.primary : TossColors.gray400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attribute name (editable only for custom attributes)
          if (!widget.isBuiltIn) ...[
            Text(
              'Attribute Name',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            TossTextField(
              controller: _nameController,
              hintText: 'Enter attribute name',
            ),
            const SizedBox(height: TossSpacing.space6),
          ],

          // Options section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Options',
                style: TossTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray600,
                ),
              ),
              Text(
                '${_options.length} items',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray400,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),

          // Options list
          ..._options.asMap().entries.map((entry) => _buildOptionRow(entry.key)),

          // Add option button (only for custom attributes)
          if (!widget.isBuiltIn) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildAddOptionButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionRow(int index) {
    final option = _options[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: Row(
        children: [
          Expanded(
            child: widget.isBuiltIn
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Text(
                      option.value,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                      ),
                    ),
                  )
                : TextField(
                    controller: _optionControllers[index],
                    onChanged: (value) => _updateOptionValue(index, value),
                    decoration: InputDecoration(
                      hintText: 'Option ${index + 1}',
                      hintStyle: TossTextStyles.body.copyWith(
                        color: TossColors.gray400,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                        vertical: TossSpacing.space3,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: const BorderSide(color: TossColors.gray200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: const BorderSide(color: TossColors.gray200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: const BorderSide(color: TossColors.primary),
                      ),
                    ),
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
          ),
          if (!widget.isBuiltIn) ...[
            const SizedBox(width: TossSpacing.space2),
            GestureDetector(
              onTap: () => _removeOption(index),
              child: Container(
                padding: const EdgeInsets.all(TossSpacing.space2),
                child: const Icon(
                  LucideIcons.x,
                  size: 18,
                  color: TossColors.gray400,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddOptionButton() {
    return InkWell(
      onTap: _addOption,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
        decoration: BoxDecoration(
          border: Border.all(
            color: TossColors.gray200,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.plus,
              size: 16,
              color: TossColors.gray500,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Add Option',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
