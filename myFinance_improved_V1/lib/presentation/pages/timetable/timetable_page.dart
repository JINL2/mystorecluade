import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';

class TimetablePage extends ConsumerWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        backgroundColor: TossColors.background,
        elevation: 0,
        title: Text(
          'Timetable',
          style: TossTextStyles.h2,
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Text(
          'Timetable Page\n(Coming Soon)',
          style: TossTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}