/// Purchase Order PDF Generator
///
/// TODO: Re-implement when purchase_order is rebuilt with inventory_get_order_list RPC
library;

import 'dart:typed_data';

import 'pdf_config.dart';

/// Stub generator - PO PDF generation temporarily disabled
class PoPdfGenerator {
  /// Generate PDF for Purchase Order
  ///
  /// Currently throws error as PO system is being rebuilt
  static Future<Uint8List> generate(
    dynamic po, {
    TradePdfConfig config = const TradePdfConfig(),
  }) async {
    throw UnimplementedError(
      'PO PDF generation temporarily disabled. '
      'PO system is being rebuilt with inventory_get_order_list RPC.',
    );
  }
}
