// This file redirects to the shipment list page for backwards compatibility
// The ShipmentPage class is kept for route compatibility

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shipment_list_page.dart';

class ShipmentPage extends ConsumerWidget {
  final dynamic feature;

  const ShipmentPage({super.key, this.feature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Redirect to the shipment list page
    return const ShipmentListPage();
  }
}
