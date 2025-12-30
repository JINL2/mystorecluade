// This file redirects to the new LC list page for backwards compatibility
// The LetterOfCreditPage class is kept for route compatibility

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lc_list_page.dart';

class LetterOfCreditPage extends ConsumerWidget {
  final dynamic feature;

  const LetterOfCreditPage({super.key, this.feature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Redirect to the new LC list page
    return const LCListPage();
  }
}
