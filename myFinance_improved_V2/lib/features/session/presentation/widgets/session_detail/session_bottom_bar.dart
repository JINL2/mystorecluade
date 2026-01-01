import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/states/session_detail_state.dart';
import 'counted_item_row.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Bottom bar widget for session detail page
/// Shows summary and save button with expandable item list
class SessionBottomBar extends StatefulWidget {
  final List<SelectedProduct> selectedProducts;
  final int totalQuantity;
  final int totalRejected;
  final VoidCallback onSave;
  final void Function(SelectedProduct item) onItemTap;

  const SessionBottomBar({
    super.key,
    required this.selectedProducts,
    required this.totalQuantity,
    required this.totalRejected,
    required this.onSave,
    required this.onItemTap,
  });

  @override
  State<SessionBottomBar> createState() => _SessionBottomBarState();
}

class _SessionBottomBarState extends State<SessionBottomBar> {
  bool _isExpanded = false;

  List<SelectedProduct> get _countedProducts =>
      widget.selectedProducts.where((item) => item.quantity > 0).toList();

  bool get _hasCountedItems => _countedProducts.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: const BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A1A1A1A),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildExpandableSection(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection() {
    return GestureDetector(
      onTap: _hasCountedItems
          ? () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            }
          : null,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          // Arrow icon
          Container(
            padding: const EdgeInsets.only(top: TossSpacing.space2),
            child: Icon(
              _isExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: _hasCountedItems ? TossColors.gray600 : TossColors.gray300,
              size: 24,
            ),
          ),
          // Expanded items list
          if (_isExpanded && _hasCountedItems) ...[
            const SizedBox(height: TossSpacing.space2),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                ),
                itemCount: _countedProducts.length,
                itemBuilder: (context, index) {
                  final item = _countedProducts[index];
                  return CountedItemRow(
                    item: item,
                    onTap: () => widget.onItemTap(item),
                  );
                },
              ),
            ),
            const Divider(height: 1, color: TossColors.gray200),
          ],
          // Summary text
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            child: Text(
              'Item Counted: ${_countedProducts.length} | Total Quantity: ${widget.totalQuantity} | Rejected: ${widget.totalRejected}',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        bottom: TossSpacing.space4,
      ),
      child: SizedBox(
        width: double.infinity,
        child: TossButton.primary(
          text: 'Save',
          onPressed: widget.onSave,
        ),
      ),
    );
  }
}
