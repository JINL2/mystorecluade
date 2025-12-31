/// PDF Common Utilities
///
/// Shared utilities, widgets, and helper methods for PDF generation.
/// Used by both PI and PO PDF generators.
library;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'pdf_config.dart';

/// Common PDF utilities and widget builders
class PdfCommon {
  // ============ Font & Image Caching ============

  static final Map<String, pw.MemoryImage> _imageCache = {};
  static pw.Font? _regularFont;
  static pw.Font? _boldFont;

  /// Get cached regular font
  static pw.Font? get regularFont => _regularFont;

  /// Get cached bold font
  static pw.Font? get boldFont => _boldFont;

  /// Load Google Fonts for PDF
  /// Uses Noto Sans SC (Simplified Chinese) which supports:
  /// - Korean (한국어)
  /// - Vietnamese (Tiếng Việt)
  /// - Chinese (中文)
  /// - Japanese (日本語)
  /// - English and other Latin languages
  static Future<void> loadFonts() async {
    if (_regularFont == null) {
      _regularFont = await PdfGoogleFonts.notoSansSCRegular();
      _boldFont = await PdfGoogleFonts.notoSansSCBold();
    }
  }

  /// Create PDF theme with loaded fonts
  /// Must call [loadFonts] before calling this method.
  static pw.ThemeData createTheme() {
    assert(_regularFont != null && _boldFont != null, 'Call loadFonts() first');
    return pw.ThemeData.withFont(
      base: _regularFont ?? pw.Font.helvetica(),
      bold: _boldFont ?? pw.Font.helveticaBold(),
    );
  }

  /// Load image from URL with caching
  static Future<pw.MemoryImage?> loadImageFromUrl(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) return null;

    // Check cache first
    if (_imageCache.containsKey(imageUrl)) {
      return _imageCache[imageUrl];
    }

    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final image = pw.MemoryImage(response.bodyBytes);
        _imageCache[imageUrl] = image;
        return image;
      }
    } catch (e) {
      // Image loading failed, continue without image
    }
    return null;
  }

  /// Load logo from URL
  static Future<pw.MemoryImage?> loadLogo(String? logoUrl) async {
    return loadImageFromUrl(logoUrl);
  }

  // ============ Common Widgets ============

  /// Build document title with styled container
  static pw.Widget buildDocumentTitle(String title, TradePdfConfig config) {
    return pw.Center(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        decoration: pw.BoxDecoration(
          color: config.primaryColor,
          borderRadius: pw.BorderRadius.circular(2),
        ),
        child: pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  /// Build professional footer
  static pw.Widget buildProfessionalFooter(
    pw.Context context,
    String companyName,
    TradePdfConfig config,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'This document was generated electronically and is valid without signature.',
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
          ),
          pw.Text(
            DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }

  /// Build reference item for reference bar
  static pw.Widget buildRefItem(String label, String value, TradePdfConfig config) {
    return pw.Column(
      children: [
        pw.Text(
          label.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 7,
            color: PdfColors.grey600,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: config.primaryColor,
          ),
        ),
      ],
    );
  }

  /// Build reference divider
  static pw.Widget buildRefDivider() {
    return pw.Container(
      height: 30,
      width: 1,
      color: PdfColors.grey300,
    );
  }

  /// Build address lines from info map
  static List<String> buildAddressLines(Map<String, dynamic> info) {
    final lines = <String>[];
    if (info['address'] != null) lines.add(info['address'].toString());

    final cityCountry = <String>[];
    if (info['city'] != null) cityCountry.add(info['city'].toString());
    if (info['country'] != null) cityCountry.add(info['country'].toString());
    if (cityCountry.isNotEmpty) lines.add(cityCountry.join(', '));

    if (info['phone'] != null) lines.add('Tel: ${info['phone']}');
    if (info['email'] != null) lines.add('Email: ${info['email']}');

    return lines;
  }

  /// Build party box for seller/buyer info
  static pw.Widget buildPartyBox(
    String title,
    String name,
    List<String> addressLines,
    TradePdfConfig config, {
    required bool isLeft,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(2),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                color: config.primaryColor,
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            name,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          ...addressLines.map(
            (line) => pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                line,
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ Table Widgets ============

  /// Build table header cell
  static pw.Widget buildTableHeaderCell(String text, {pw.TextAlign align = pw.TextAlign.center}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey700,
        ),
        textAlign: align,
      ),
    );
  }

  /// Build table data cell
  static pw.Widget buildTableDataCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
    bool isBold = false,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: isBold ? pw.FontWeight.bold : null,
        ),
        textAlign: align,
      ),
    );
  }

  /// Build item image cell
  static pw.Widget buildItemImageCell(pw.MemoryImage? image) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      alignment: pw.Alignment.center,
      child: image != null
          ? pw.Container(
              width: 40,
              height: 40,
              child: pw.Image(image, fit: pw.BoxFit.contain),
            )
          : pw.Container(
              width: 40,
              height: 40,
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              alignment: pw.Alignment.center,
              child: pw.Text(
                'No\nImage',
                style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey400),
                textAlign: pw.TextAlign.center,
              ),
            ),
    );
  }

  /// Build total row for totals section
  static pw.Widget buildTotalRow(String label, String value, {bool isNegative = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: isNegative ? PdfColors.red700 : PdfColors.grey900,
            ),
          ),
        ],
      ),
    );
  }

  /// Build info line for shipping/terms sections
  static pw.Widget buildInfoLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Build signature section
  static pw.Widget buildSignatureSection(String companyName, TradePdfConfig config) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 200,
          child: pw.Column(
            children: [
              pw.Container(
                height: 50,
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400)),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Authorized Signature',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                companyName,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: config.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============ Banking Info ============

  /// Build Banking Information section for PDF
  static pw.Widget buildBankingInfoSection(
    List<Map<String, dynamic>>? bankingInfo,
    String currencyCode,
    double totalAmount,
    PdfColor primaryColor,
  ) {
    if (bankingInfo == null || bankingInfo.isEmpty) {
      return pw.SizedBox.shrink();
    }

    // Filter banks by currency if possible, otherwise show all
    final relevantBanks = bankingInfo.where((bank) {
      final bankCurrency = bank['currency_code'] as String?;
      return bankCurrency == null || bankCurrency == currencyCode;
    }).toList();

    // If no matching currency, show all banks
    final banksToShow = relevantBanks.isEmpty ? bankingInfo : relevantBanks;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Total amount display
        pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(bottom: 15),
          child: pw.Text(
            'Total: $currencyCode ${NumberFormat('#,##0.00').format(totalAmount)}',
            style: pw.TextStyle(
              font: _boldFont,
              fontSize: 14,
              color: primaryColor,
            ),
          ),
        ),
        // Banking sections
        ...banksToShow.map((bank) => _buildSingleBankInfo(bank, primaryColor)),
      ],
    );
  }

  /// Build single bank information box
  static pw.Widget _buildSingleBankInfo(
    Map<String, dynamic> bank,
    PdfColor primaryColor,
  ) {
    final bankName = bank['bank_name'] as String? ?? '';
    final bankBranch = bank['bank_branch'] as String? ?? '';
    final bankAddress = bank['bank_address'] as String? ?? '';
    final beneficiaryName = bank['beneficiary_name'] as String? ?? '';
    final accountNumber = bank['bank_account'] as String? ?? '';
    final swiftCode = bank['swift_code'] as String? ?? '';
    final currencyCode = bank['currency_code'] as String? ?? '';
    final accountType = bank['account_type'] as String? ?? '';

    // Determine title
    String title = 'Banking Information';
    if (currencyCode.isNotEmpty) {
      title = 'Banking Information ($currencyCode Account)';
    } else if (accountType.isNotEmpty) {
      title = 'Banking Information ($accountType)';
    }

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Title
          pw.Text(
            title,
            style: pw.TextStyle(
              font: _boldFont,
              fontSize: 11,
              color: primaryColor,
            ),
          ),
          pw.SizedBox(height: 10),
          // Bank details
          if (bankName.isNotEmpty) _buildBankInfoRow('Bank Name:', '$bankName${bankBranch.isNotEmpty ? ' ($bankBranch)' : ''}'),
          if (beneficiaryName.isNotEmpty) _buildBankInfoRow('Beneficiary Full Name:', beneficiaryName),
          if (accountNumber.isNotEmpty)
            _buildBankInfoRow('Account Number:', '$accountNumber${currencyCode.isNotEmpty ? ' ($currencyCode)' : ''}'),
          if (bankAddress.isNotEmpty) _buildBankInfoRow('Bank Address:', bankAddress),
          if (swiftCode.isNotEmpty) _buildBankInfoRow('SWIFT Code:', swiftCode),
        ],
      ),
    );
  }

  /// Build a single row in bank info
  static pw.Widget _buildBankInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '• $label ',
            style: pw.TextStyle(font: _regularFont, fontSize: 9, color: PdfColors.grey700),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(font: _boldFont, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}
