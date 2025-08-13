import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_shadows.dart';

class TossAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TossAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TossTextStyles.h3.copyWith(
          color: TossColors.gray900,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? TossColors.background,
      elevation: elevation,
      leading: leading,
      actions: actions,
      iconTheme: const IconThemeData(
        color: TossColors.gray900,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            boxShadow: elevation > 0 ? TossShadows.shadow1 : null,
          ),
        ),
      ),
    );
  }
}