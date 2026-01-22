/// Trade PDF Service
///
/// Facade for generating trade document PDFs (Proforma Invoice, Purchase Order).
/// Delegates to specialized generators for each document type.
///
/// Usage:
/// ```dart
/// // Generate PI PDF
/// final pdfBytes = await TradePdfService.generateProformaInvoicePdf(pi);
///
/// // Generate PO PDF
/// final pdfBytes = await TradePdfService.generatePurchaseOrderPdf(po);
///
/// // Share or print
/// await TradePdfService.sharePdf(pdfBytes, 'document.pdf');
/// ```
library;

import 'dart:typed_data';

import 'package:printing/printing.dart';

import '../../../proforma_invoice/domain/entities/proforma_invoice.dart';
// TODO: Re-enable when purchase_order is rebuilt with inventory_get_order_list RPC
// import '../../../purchase_order/domain/entities/purchase_order.dart';
import 'pdf/pdf_config.dart';
import 'pdf/pi_pdf_generator.dart';
import 'pdf/po_pdf_generator.dart';

// Re-export config for external use
export 'pdf/pdf_config.dart';

/// Trade PDF Service - Facade for PDF generation
///
/// This service provides a simple API for generating trade document PDFs.
/// All complex PDF generation logic is delegated to specialized generators.
class TradePdfService {
  /// Generate PDF for Proforma Invoice
  ///
  /// [pi] The proforma invoice entity to generate PDF for
  /// [config] Optional configuration for customizing PDF appearance
  ///
  /// Returns the PDF as bytes
  static Future<Uint8List> generateProformaInvoicePdf(
    ProformaInvoice pi, {
    TradePdfConfig config = const TradePdfConfig(),
  }) async {
    return PiPdfGenerator.generate(pi, config: config);
  }

  /// Generate PDF for Purchase Order
  ///
  /// TODO: Re-enable when purchase_order is rebuilt with inventory_get_order_list RPC
  /// Currently throws UnimplementedError
  static Future<Uint8List> generatePurchaseOrderPdf(
    dynamic po, {
    TradePdfConfig config = const TradePdfConfig(),
  }) async {
    return PoPdfGenerator.generate(po, config: config);
  }

  /// Share/Print PDF using the printing package
  ///
  /// Opens the system share dialog on mobile or print dialog on desktop
  static Future<void> sharePdf(Uint8List pdfBytes, String filename) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: filename);
  }

  /// Print PDF directly
  ///
  /// Opens the system print dialog
  static Future<void> printPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }

  /// Preview PDF in dialog
  ///
  /// Shows a preview of the PDF before printing
  static Future<void> previewPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
      name: 'Document Preview',
    );
  }
}
