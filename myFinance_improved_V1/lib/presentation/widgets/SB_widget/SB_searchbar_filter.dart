import 'package:flutter/material.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_colors.dart';

/// SB SearchBar Filter Component
/// Modern pill-style search bar with search icon prefix and circular filter button
class SBSearchBarFilter extends StatelessWidget {
  final TextEditingController? searchController;
  final String searchHint;
  final Function(String)? onSearchChanged;
  final VoidCallback? onFilterTap;

  const SBSearchBarFilter({
    super.key,
    this.searchController,
    this.searchHint = 'Search roles...',
    this.onSearchChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(24), // Perfect pill shape
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: TossTextStyles.body.copyWith(
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: TossTextStyles.body.copyWith(
                    color: TossColors.gray400,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: 14,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: TossSpacing.space3, right: TossSpacing.space2),
                    child: Icon(
                      Icons.search_rounded,
                      color: TossColors.gray400,
                      size: 20,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 20,
                  ),
                  suffixIcon: searchController?.text.isNotEmpty == true
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: TossColors.gray400,
                            size: 20,
                          ),
                          onPressed: () {
                            searchController?.clear();
                            onSearchChanged?.call('');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          SizedBox(width: TossSpacing.space3),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: TossColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: TossColors.primary.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onFilterTap,
                borderRadius: BorderRadius.circular(24),
                child: Center(
                  child: Icon(
                    Icons.filter_list_rounded,
                    color: TossColors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}