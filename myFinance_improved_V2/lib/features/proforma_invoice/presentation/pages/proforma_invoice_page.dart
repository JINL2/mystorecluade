import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pi_list_page.dart';

/// Main entry point for Proforma Invoice feature
/// Redirects to the actual list page
class ProformaInvoicePage extends ConsumerWidget {
  final dynamic feature;

  const ProformaInvoicePage({super.key, this.feature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PIListPage();
  }
}
