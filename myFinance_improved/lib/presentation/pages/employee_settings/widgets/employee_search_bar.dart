import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';

class EmployeeSearchBar extends StatefulWidget {
  final Function(String)? onSearch;
  
  const EmployeeSearchBar({
    super.key,
    this.onSearch,
  });

  @override
  State<EmployeeSearchBar> createState() => _EmployeeSearchBarState();
}

class _EmployeeSearchBarState extends State<EmployeeSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: widget.onSearch,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
        ),
        decoration: InputDecoration(
          hintText: 'Search by name, role, or email',
          hintStyle: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: TossColors.gray500,
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: TossColors.gray500,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      widget.onSearch?.call('');
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
        ),
      ),
    );
  }
}