// lib/presentation/pages/delegate_role/widgets/user_search_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/delegate_role_provider.dart';

class UserSearchBar extends ConsumerWidget {
  const UserSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(userSearchProvider);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
      child: TextField(
        onChanged: (value) => ref.read(userSearchProvider.notifier).updateQuery(value),
        decoration: InputDecoration(
          hintText: 'Search by name, email, or role',
          hintStyle: TossTextStyles.body.copyWith(
            color: TossColors.gray400,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: TossColors.gray400,
            size: 22,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: TossColors.gray500,
                    size: 20,
                  ),
                  onPressed: () => ref.read(userSearchProvider.notifier).clear(),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
        ),
        style: TossTextStyles.body.copyWith(
          fontSize: 15,
        ),
      ),
    );
  }
}