/// PDF Configuration
///
/// Configuration class for customizing trade document PDF generation.
library;

import 'package:pdf/pdf.dart';

/// PDF Configuration for customization
class TradePdfConfig {
  final String? logoUrl;
  final PdfColor primaryColor;
  final PdfColor accentColor;
  final String? companyTagline;

  const TradePdfConfig({
    this.logoUrl,
    this.primaryColor = const PdfColor.fromInt(0xFF1A365D), // Dark blue
    this.accentColor = const PdfColor.fromInt(0xFF2B6CB0), // Medium blue
    this.companyTagline,
  });
}
