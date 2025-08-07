import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/themes/toss_colors.dart';
import '../../core/themes/toss_text_styles.dart';
import '../../core/themes/toss_spacing.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;
  final String route;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: TossTextStyles.h2.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: TossColors.gray900, size: 22),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: TossColors.gray400,
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              '$title Page',
              style: TossTextStyles.h2.copyWith(
                color: TossColors.gray700,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'This page is under construction',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
            SizedBox(height: TossSpacing.space1),
            Text(
              'Route: $route',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}