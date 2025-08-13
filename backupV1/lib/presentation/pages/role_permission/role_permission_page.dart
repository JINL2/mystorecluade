import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';

class RolePermissionPage extends ConsumerWidget {
  const RolePermissionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        backgroundColor: TossColors.background,
        elevation: 0,
        title: Text(
          'Role & Permission',
          style: TossTextStyles.h2,
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Text(
          'Role & Permission Page\n(Coming Soon)',
          style: TossTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}