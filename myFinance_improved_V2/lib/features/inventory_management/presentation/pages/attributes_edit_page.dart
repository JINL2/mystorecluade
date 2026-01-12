import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../di/inventory_providers.dart';
import '../../domain/entities/inventory_metadata.dart' show Attribute;
import '../../domain/exceptions/inventory_exceptions.dart';
import '../providers/inventory_providers.dart';
import '../widgets/attributes/add_attribute_form_dialog.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Attribute item model for display
class AttributeItem {
  final String id;
  final String name;
  final bool isBuiltIn;
  final int optionCount;

  AttributeItem({
    required this.id,
    required this.name,
    this.isBuiltIn = false,
    this.optionCount = 0,
  });

  AttributeItem copyWith({
    String? id,
    String? name,
    bool? isBuiltIn,
    int? optionCount,
  }) {
    return AttributeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      optionCount: optionCount ?? this.optionCount,
    );
  }
}

/// Attributes Edit Page - Shows all attributes with their types
class AttributesEditPage extends ConsumerStatefulWidget {
  const AttributesEditPage({super.key});

  @override
  ConsumerState<AttributesEditPage> createState() => _AttributesEditPageState();
}

class _AttributesEditPageState extends ConsumerState<AttributesEditPage> {
  List<AttributeItem> _attributes = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Load attributes after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAttributes();
    });
  }

  void _loadAttributes() {
    final metadataState = ref.read(inventoryMetadataNotifierProvider);
    final metadata = metadataState.metadata;

    if (metadata != null) {
      setState(() {
        // Built-in attributes (Category, Brand)
        _attributes = [
          AttributeItem(
            id: 'builtin_category',
            name: 'Category',
            isBuiltIn: true,
            optionCount: metadata.categories.length,
          ),
          AttributeItem(
            id: 'builtin_brand',
            name: 'Brand',
            isBuiltIn: true,
            optionCount: metadata.brands.length,
          ),
          // Custom attributes from metadata
          ...metadata.attributes.map((Attribute attr) => AttributeItem(
                id: attr.id,
                name: attr.name,
                isBuiltIn: false,
                optionCount: attr.optionCount,
              )),
        ];
        _isInitialized = true;
      });
    } else {
      // If metadata not loaded yet, set default built-in attributes
      setState(() {
        _attributes = [
          AttributeItem(
            id: 'builtin_category',
            name: 'Category',
            isBuiltIn: true,
          ),
          AttributeItem(
            id: 'builtin_brand',
            name: 'Brand',
            isBuiltIn: true,
          ),
        ];
        _isInitialized = true;
      });
    }
  }

  Future<void> _addAttribute() async {
    final result = await AddAttributeFormDialog.show(context);
    if (result == null) return;

    // Get companyId
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      if (mounted) {
        TossToast.error(context, 'Company not selected');
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(inventoryRepositoryProvider);

      // Convert options to RPC format
      final optionsJson = result.options.isNotEmpty
          ? result.options.map((o) => o.toJson()).toList()
          : null;

      final response = await repository.createAttributeAndOption(
        companyId: companyId,
        attributeName: result.name,
        options: optionsJson,
      );

      if (mounted) {
        setState(() {
          _attributes.add(
            AttributeItem(
              id: response.attributeId,
              name: response.attributeName,
              optionCount: result.options.length,
              isBuiltIn: false,
            ),
          );
          _isLoading = false;
        });

        // Refresh metadata to update cache
        ref.read(inventoryMetadataNotifierProvider.notifier).refresh();

        TossToast.success(context, 'Attribute created successfully');
      }
    } on InventoryAttributeException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        if (e.isDuplicateName) {
          TossToast.error(context, 'Attribute name already exists');
        } else if (e.isDuplicateOptionValue) {
          TossToast.error(context, 'Duplicate option value');
        } else {
          TossToast.error(context, e.message);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        TossToast.error(context, 'Failed to create attribute');
      }
    }
  }

  void _deleteAttribute(int index) {
    final attribute = _attributes[index];
    if (attribute.isBuiltIn) {
      TossToast.warning(context, 'Cannot delete built-in attribute');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TossColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        title: Text(
          'Delete Attribute',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${attribute.name}"?',
          style: TossTextStyles.body.copyWith(color: TossColors.gray700),
        ),
        actions: [
          TossButton.textButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          TossButton.textButton(
            text: 'Delete',
            textColor: TossColors.error,
            onPressed: () {
              setState(() {
                _attributes.removeAt(index);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch metadata state to update when it changes
    final metadataState = ref.watch(inventoryMetadataNotifierProvider);

    // Reload attributes if metadata is updated and we haven't initialized yet
    if (!_isInitialized && metadataState.metadata != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadAttributes();
      });
    }

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          if (metadataState.isLoading && !_isInitialized)
            const Center(child: CircularProgressIndicator())
          else
            _buildBody(),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return TossAppBar(
      title: 'Attributes',
      backgroundColor: TossColors.white,
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.plus, color: TossColors.gray900),
          onPressed: _isLoading ? null : _addAttribute,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: _attributes.length,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final elevation =
                Tween<double>(begin: 0, end: 4).evaluate(animation);
            return Material(
              elevation: elevation,
              color: TossColors.white,
              child: child,
            );
          },
          child: child,
        );
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _attributes.removeAt(oldIndex);
          _attributes.insert(newIndex, item);
        });
      },
      itemBuilder: (context, index) {
        final attribute = _attributes[index];
        return _buildAttributeRow(
          key: ValueKey(attribute.id),
          attribute: attribute,
          index: index,
        );
      },
    );
  }

  Widget _buildAttributeRow({
    required Key key,
    required AttributeItem attribute,
    required int index,
  }) {
    return Container(
      key: key,
      color: TossColors.white,
      child: Dismissible(
        key: ValueKey('dismiss_${attribute.id}'),
        direction: attribute.isBuiltIn
            ? DismissDirection.none
            : DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: TossColors.error,
          child: const Icon(
            LucideIcons.trash2,
            color: TossColors.white,
            size: 22,
          ),
        ),
        confirmDismiss: (direction) async {
          _deleteAttribute(index);
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              // Attribute name
              Expanded(
                child: Text(
                  attribute.name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                  ),
                ),
              ),

              // Options count
              if (attribute.optionCount > 0)
                Text(
                  '${attribute.optionCount} options',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w400,
                    color: TossColors.gray500,
                  ),
                ),
              const SizedBox(width: 16),

              // Reorder handle
              ReorderableDragStartListener(
                index: index,
                child: const Icon(
                  Icons.menu,
                  size: 20,
                  color: TossColors.gray400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
