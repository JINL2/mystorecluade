import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../widgets/attributes/add_attribute_form_dialog.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
            fontWeight: TossFontWeight.bold,
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
    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return TossAppBar(
      title: 'Attributes',
      backgroundColor: TossColors.white,
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.plus, color: TossColors.gray900),
          onPressed: _addAttribute,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5, vertical: TossSpacing.space4),
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
          padding: const EdgeInsets.only(right: TossSpacing.space5),
          color: TossColors.error,
          child: const Icon(
            LucideIcons.trash2,
            color: TossColors.white,
            size: TossSpacing.iconMD + TossSpacing.space0_5,
          ),
        ),
        confirmDismiss: (direction) async {
          _deleteAttribute(index);
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space5),
          child: Row(
            children: [
              // Attribute name
              Expanded(
                child: Text(
                  attribute.name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.medium,
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
                    fontWeight: TossFontWeight.regular,
                    color: TossColors.gray500,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space4),

              // Reorder handle
              ReorderableDragStartListener(
                index: index,
                child: const Icon(
                  Icons.menu,
                  size: TossSpacing.iconMD,
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
