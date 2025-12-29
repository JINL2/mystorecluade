import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../widgets/attributes/add_attribute_form_dialog.dart';

/// Attribute item model for display
class AttributeItem {
  final String id;
  final String name;
  AttributeType type;
  final bool isBuiltIn;

  AttributeItem({
    required this.id,
    required this.name,
    required this.type,
    this.isBuiltIn = false,
  });

  AttributeItem copyWith({
    String? id,
    String? name,
    AttributeType? type,
    bool? isBuiltIn,
  }) {
    return AttributeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
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
  // Default built-in attributes
  final List<AttributeItem> _attributes = [
    AttributeItem(
      id: '1',
      name: 'Category',
      type: AttributeType.text,
      isBuiltIn: true,
    ),
    AttributeItem(
      id: '2',
      name: 'Brand',
      type: AttributeType.text,
      isBuiltIn: true,
    ),
  ];

  Future<void> _addAttribute() async {
    final result = await AddAttributeFormDialog.show(context);
    if (result != null) {
      setState(() {
        _attributes.add(
          AttributeItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: result.name,
            type: result.type,
            isBuiltIn: false,
          ),
        );
      });
    }
  }

  Future<AttributeType?> _showTypeSelector(AttributeType currentType) async {
    final items = AttributeType.values.map((type) {
      return TossSelectionItem(
        id: type.name,
        title: type.label,
      );
    }).toList();

    final result = await TossSelectionBottomSheet.show<TossSelectionItem>(
      context: context,
      title: 'Select Type',
      items: items,
      selectedId: currentType.name,
      maxHeightFraction: 0.4,
      showSubtitle: false,
      showIcon: false,
      checkIcon: LucideIcons.check,
      borderBottomWidth: 0,
      showSelectedBackground: false,
    );

    if (result != null) {
      return AttributeType.values.firstWhere((t) => t.name == result.id);
    }
    return null;
  }

  void _changeAttributeType(int index) async {
    final attribute = _attributes[index];
    final result = await _showTypeSelector(attribute.type);
    if (result != null) {
      setState(() {
        _attributes[index] = attribute.copyWith(type: result);
      });
    }
  }

  void _deleteAttribute(int index) {
    final attribute = _attributes[index];
    if (attribute.isBuiltIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot delete built-in attribute',
            style: TossTextStyles.caption.copyWith(color: TossColors.white),
          ),
          backgroundColor: TossColors.gray800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        ),
      );
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _attributes.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Attributes',
        style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.plus),
          onPressed: _addAttribute,
        ),
      ],
      elevation: 0,
      backgroundColor: TossColors.white,
      foregroundColor: TossColors.gray900,
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

              // Attribute type (tappable plain text)
              GestureDetector(
                onTap: () => _changeAttributeType(index),
                child: Text(
                  attribute.type.label,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w400,
                    color: TossColors.gray500,
                  ),
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
