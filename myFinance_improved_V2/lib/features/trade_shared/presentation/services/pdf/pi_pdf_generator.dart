/// Proforma Invoice PDF Generator
///
/// Generates professional PDF documents for Proforma Invoices.
library;

import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../proforma_invoice/domain/entities/proforma_invoice.dart';
import 'pdf_common.dart';
import 'pdf_config.dart';

/// Proforma Invoice PDF Generator
class PiPdfGenerator {
  /// Preload all item images for PI
  static Future<Map<String, pw.MemoryImage>> _preloadItemImages(List<PIItem> items) async {
    final Map<String, pw.MemoryImage> images = {};

    for (final item in items) {
      if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
        final image = await PdfCommon.loadImageFromUrl(item.imageUrl);
        if (image != null) {
          images[item.itemId] = image;
        }
      }
    }

    return images;
  }

  /// Generate PDF for Proforma Invoice
  static Future<Uint8List> generate(
    ProformaInvoice pi, {
    TradePdfConfig config = const TradePdfConfig(),
  }) async {
    // Load fonts first
    await PdfCommon.loadFonts();

    final pdf = pw.Document();
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final numberFormat = NumberFormat('#,##0.00');

    // Create theme with loaded fonts
    final theme = PdfCommon.createTheme();

    // Load logo if provided
    final logo = await PdfCommon.loadLogo(config.logoUrl);

    // Preload item images
    final itemImages = await _preloadItemImages(pi.items);

    // Get seller and buyer info
    final sellerInfo = pi.sellerInfo ?? {};
    final buyerInfo = pi.counterpartyInfo ?? {};
    final sellerName = sellerInfo['name'] as String? ?? 'Company Name';
    final buyerName = pi.counterpartyName ?? buyerInfo['name'] as String? ?? 'Buyer Name';

    // Check if we have terms/notes content for last page
    final hasTermsPage = (pi.termsAndConditions != null && pi.termsAndConditions!.isNotEmpty) ||
        (pi.notes != null && pi.notes!.isNotEmpty) ||
        pi.paymentTermsCode != null ||
        pi.paymentTermsDetail != null;

    // Main content pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        header: (context) => _buildHeader(pi, context, logo, sellerName, config),
        footer: (context) => PdfCommon.buildProfessionalFooter(context, sellerName, config),
        build: (context) => [
          // Document Title with subtle design
          PdfCommon.buildDocumentTitle('PROFORMA INVOICE', config),
          pw.SizedBox(height: 25),

          // Reference Info Bar
          _buildReferenceBar(pi, dateFormat, config),
          pw.SizedBox(height: 25),

          // Parties Section (Seller & Buyer)
          _buildPartiesSection(pi, sellerInfo, buyerInfo, sellerName, buyerName, config),
          pw.SizedBox(height: 25),

          // Items Table
          _buildItemsTable(pi, numberFormat, config, itemImages),
          pw.SizedBox(height: 20),

          // Totals aligned to right
          _buildTotals(pi, numberFormat, config),
          pw.SizedBox(height: 25),

          // Shipping & Delivery (keep on main pages)
          if (_hasShippingInfo(pi) || pi.incotermsCode != null) _buildShippingAndTerms(pi, dateFormat, config),

          // Banking Information
          if (pi.bankingInfo != null && pi.bankingInfo!.isNotEmpty) ...[
            pw.SizedBox(height: 25),
            PdfCommon.buildBankingInfoSection(
              pi.bankingInfo,
              pi.currencyCode,
              pi.totalAmount,
              config.primaryColor,
            ),
          ],

          // If no terms page, add signature here
          if (!hasTermsPage) ...[
            pw.SizedBox(height: 40),
            PdfCommon.buildSignatureSection(sellerName, config),
          ],
        ],
      ),
    );

    // Terms & Signature page (separate last page)
    if (hasTermsPage) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: theme,
          margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Page header
              _buildTermsPageHeader(pi, sellerName, config),

              // Payment Terms
              if (pi.paymentTermsCode != null || pi.paymentTermsDetail != null) ...[
                _buildPaymentTermsSection(pi, config),
                pw.SizedBox(height: 20),
              ],

              // Terms & Conditions
              if (pi.termsAndConditions != null && pi.termsAndConditions!.isNotEmpty) ...[
                _buildTermsConditionsSection(pi, config),
                pw.SizedBox(height: 20),
              ],

              // Notes
              if (pi.notes != null && pi.notes!.isNotEmpty) ...[
                _buildNotesSection(pi, config),
                pw.SizedBox(height: 20),
              ],

              pw.Spacer(),

              // Signature Section at bottom
              PdfCommon.buildSignatureSection(sellerName, config),

              pw.SizedBox(height: 20),

              // Footer
              _buildTermsPageFooter(),
            ],
          ),
        ),
      );
    }

    return pdf.save();
  }

  // ============ PI Specific Widgets ============

  static pw.Widget _buildHeader(
    ProformaInvoice pi,
    pw.Context context,
    pw.MemoryImage? logo,
    String sellerName,
    TradePdfConfig config,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 15),
      margin: const pw.EdgeInsets.only(bottom: 10),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: config.primaryColor, width: 2),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Logo or Company Name
          if (logo != null)
            pw.Container(
              height: 50,
              width: 120,
              child: pw.Image(logo, fit: pw.BoxFit.contain),
            )
          else
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  sellerName,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: config.primaryColor,
                  ),
                ),
                if (config.companyTagline != null)
                  pw.Text(
                    config.companyTagline!,
                    style: pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey600,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
              ],
            ),
          pw.Spacer(),
          // Document Number and Status
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: _getStatusColor(pi.status),
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Text(
                  pi.status.label.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                pi.piNumber,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: config.primaryColor,
                ),
              ),
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildReferenceBar(
    ProformaInvoice pi,
    DateFormat dateFormat,
    TradePdfConfig config,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          PdfCommon.buildRefItem('PI Number', pi.piNumber, config),
          PdfCommon.buildRefDivider(),
          PdfCommon.buildRefItem('Issue Date', pi.createdAtUtc != null ? dateFormat.format(pi.createdAtUtc!) : '-', config),
          PdfCommon.buildRefDivider(),
          PdfCommon.buildRefItem('Valid Until', pi.validityDate != null ? dateFormat.format(pi.validityDate!) : '-', config),
          PdfCommon.buildRefDivider(),
          PdfCommon.buildRefItem('Currency', pi.currencyCode, config),
          if (pi.incotermsCode != null) ...[
            PdfCommon.buildRefDivider(),
            PdfCommon.buildRefItem('Incoterms', '${pi.incotermsCode}${pi.incotermsPlace != null ? ' ${pi.incotermsPlace}' : ''}', config),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildPartiesSection(
    ProformaInvoice pi,
    Map<String, dynamic> sellerInfo,
    Map<String, dynamic> buyerInfo,
    String sellerName,
    String buyerName,
    TradePdfConfig config,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: PdfCommon.buildPartyBox(
            'FROM (SELLER)',
            sellerName,
            PdfCommon.buildAddressLines(sellerInfo),
            config,
            isLeft: true,
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: PdfCommon.buildPartyBox(
            'TO (BUYER)',
            buyerName,
            PdfCommon.buildAddressLines(buyerInfo),
            config,
            isLeft: false,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildItemsTable(
    ProformaInvoice pi,
    NumberFormat numberFormat,
    TradePdfConfig config,
    Map<String, pw.MemoryImage> itemImages,
  ) {
    // Check if any items have images
    final hasImages = itemImages.isNotEmpty;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: pw.BoxDecoration(
            color: config.primaryColor,
            borderRadius: const pw.BorderRadius.only(
              topLeft: pw.Radius.circular(4),
              topRight: pw.Radius.circular(4),
            ),
          ),
          child: pw.Row(
            children: [
              pw.Text(
                'ORDER DETAILS',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.Spacer(),
              pw.Text(
                '${pi.items.length} item(s)',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ),
        pw.Table(
          border: const pw.TableBorder(
            left: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            right: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            horizontalInside: pw.BorderSide(color: PdfColors.grey200, width: 0.5),
          ),
          columnWidths: hasImages
              ? {
                  0: const pw.FlexColumnWidth(0.4), // No
                  1: const pw.FlexColumnWidth(0.8), // Image
                  2: const pw.FlexColumnWidth(2.2), // Description
                  3: const pw.FlexColumnWidth(0.7), // Qty
                  4: const pw.FlexColumnWidth(0.5), // Unit
                  5: const pw.FlexColumnWidth(0.9), // Unit Price
                  6: const pw.FlexColumnWidth(0.9), // Amount
                }
              : {
                  0: const pw.FlexColumnWidth(0.4), // No
                  1: const pw.FlexColumnWidth(2.8), // Description
                  2: const pw.FlexColumnWidth(0.8), // Qty
                  3: const pw.FlexColumnWidth(0.6), // Unit
                  4: const pw.FlexColumnWidth(1.0), // Unit Price
                  5: const pw.FlexColumnWidth(1.0), // Amount
                },
          children: [
            // Header Row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: hasImages
                  ? [
                      PdfCommon.buildTableHeaderCell('#'),
                      PdfCommon.buildTableHeaderCell('IMAGE'),
                      PdfCommon.buildTableHeaderCell('DESCRIPTION', align: pw.TextAlign.left),
                      PdfCommon.buildTableHeaderCell('QTY'),
                      PdfCommon.buildTableHeaderCell('UNIT'),
                      PdfCommon.buildTableHeaderCell('PRICE'),
                      PdfCommon.buildTableHeaderCell('AMOUNT'),
                    ]
                  : [
                      PdfCommon.buildTableHeaderCell('#'),
                      PdfCommon.buildTableHeaderCell('DESCRIPTION', align: pw.TextAlign.left),
                      PdfCommon.buildTableHeaderCell('QTY'),
                      PdfCommon.buildTableHeaderCell('UNIT'),
                      PdfCommon.buildTableHeaderCell('PRICE'),
                      PdfCommon.buildTableHeaderCell('AMOUNT'),
                    ],
            ),
            // Data Rows
            ...pi.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isEven = index % 2 == 0;
              final itemImage = itemImages[item.itemId];

              return pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: isEven ? PdfColors.white : PdfColors.grey50,
                ),
                children: hasImages
                    ? [
                        PdfCommon.buildTableDataCell('${index + 1}', align: pw.TextAlign.center),
                        PdfCommon.buildItemImageCell(itemImage),
                        _buildItemDescriptionCell(item),
                        PdfCommon.buildTableDataCell(
                          numberFormat.format(item.quantity),
                          align: pw.TextAlign.center,
                        ),
                        PdfCommon.buildTableDataCell(item.unit ?? 'PCS', align: pw.TextAlign.center),
                        PdfCommon.buildTableDataCell(
                          numberFormat.format(item.unitPrice),
                          align: pw.TextAlign.right,
                        ),
                        PdfCommon.buildTableDataCell(
                          numberFormat.format(item.totalAmount),
                          align: pw.TextAlign.right,
                          isBold: true,
                        ),
                      ]
                    : [
                        PdfCommon.buildTableDataCell('${index + 1}', align: pw.TextAlign.center),
                        _buildItemDescriptionCell(item),
                        PdfCommon.buildTableDataCell(
                          numberFormat.format(item.quantity),
                          align: pw.TextAlign.center,
                        ),
                        PdfCommon.buildTableDataCell(item.unit ?? 'PCS', align: pw.TextAlign.center),
                        PdfCommon.buildTableDataCell(
                          numberFormat.format(item.unitPrice),
                          align: pw.TextAlign.right,
                        ),
                        PdfCommon.buildTableDataCell(
                          numberFormat.format(item.totalAmount),
                          align: pw.TextAlign.right,
                          isBold: true,
                        ),
                      ],
              );
            }),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildItemDescriptionCell(PIItem item) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            item.description,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          if (item.sku != null && item.sku!.isNotEmpty)
            pw.Text(
              'SKU: ${item.sku}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          if (item.hsCode != null && item.hsCode!.isNotEmpty)
            pw.Text(
              'HS Code: ${item.hsCode}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          if (item.countryOfOrigin != null && item.countryOfOrigin!.isNotEmpty)
            pw.Text(
              'Origin: ${item.countryOfOrigin}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildTotals(
    ProformaInvoice pi,
    NumberFormat numberFormat,
    TradePdfConfig config,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 220,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            children: [
              PdfCommon.buildTotalRow('Subtotal', '${pi.currencyCode} ${numberFormat.format(pi.subtotal)}'),
              if (pi.discountAmount > 0)
                PdfCommon.buildTotalRow('Discount', '-${pi.currencyCode} ${numberFormat.format(pi.discountAmount)}', isNegative: true),
              if (pi.taxAmount > 0) PdfCommon.buildTotalRow('Tax (${pi.taxPercent}%)', '${pi.currencyCode} ${numberFormat.format(pi.taxAmount)}'),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: pw.BoxDecoration(
                  color: config.primaryColor,
                  borderRadius: const pw.BorderRadius.only(
                    bottomLeft: pw.Radius.circular(3),
                    bottomRight: pw.Radius.circular(3),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'TOTAL',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.Text(
                      '${pi.currencyCode} ${numberFormat.format(pi.totalAmount)}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildShippingAndTerms(
    ProformaInvoice pi,
    DateFormat dateFormat,
    TradePdfConfig config,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        border: pw.Border.all(color: PdfColors.grey200, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'SHIPPING & DELIVERY',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: config.primaryColor,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (pi.portOfLoading != null) PdfCommon.buildInfoLine('Port of Loading', pi.portOfLoading!),
                    if (pi.portOfDischarge != null) PdfCommon.buildInfoLine('Port of Discharge', pi.portOfDischarge!),
                    if (pi.finalDestination != null) PdfCommon.buildInfoLine('Final Destination', pi.finalDestination!),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (pi.shippingMethodCode != null) PdfCommon.buildInfoLine('Shipping Method', pi.shippingMethodCode!),
                    if (pi.estimatedShipmentDate != null) PdfCommon.buildInfoLine('Est. Shipment', dateFormat.format(pi.estimatedShipmentDate!)),
                    PdfCommon.buildInfoLine('Partial Shipment', pi.partialShipmentAllowed ? 'Allowed' : 'Not Allowed'),
                    PdfCommon.buildInfoLine('Transshipment', pi.transshipmentAllowed ? 'Allowed' : 'Not Allowed'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTermsPageHeader(
    ProformaInvoice pi,
    String sellerName,
    TradePdfConfig config,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 15),
      margin: const pw.EdgeInsets.only(bottom: 20),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: config.primaryColor, width: 2),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            sellerName,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: config.primaryColor,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                pi.piNumber,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: config.primaryColor,
                ),
              ),
              pw.Text(
                'Terms & Conditions',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPaymentTermsSection(ProformaInvoice pi, TradePdfConfig config) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(color: config.accentColor, width: 3),
        ),
        color: PdfColors.blue50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'PAYMENT TERMS',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: config.primaryColor,
            ),
          ),
          pw.SizedBox(height: 6),
          if (pi.paymentTermsCode != null)
            pw.Text(
              pi.paymentTermsCode!.replaceAll('_', ' ').toUpperCase(),
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          if (pi.paymentTermsDetail != null) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              pi.paymentTermsDetail!,
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildTermsConditionsSection(ProformaInvoice pi, TradePdfConfig config) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'TERMS & CONDITIONS',
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: config.primaryColor,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey200, width: 0.5),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            pi.termsAndConditions!,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildNotesSection(ProformaInvoice pi, TradePdfConfig config) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.amber50,
        border: pw.Border.all(color: PdfColors.amber200, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(2),
                decoration: pw.BoxDecoration(
                  color: PdfColors.amber,
                  borderRadius: pw.BorderRadius.circular(2),
                ),
                child: pw.Text(
                  'NOTE',
                  style: pw.TextStyle(
                    fontSize: 7,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            pi.notes!,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTermsPageFooter() {
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

  static bool _hasShippingInfo(ProformaInvoice pi) {
    return pi.portOfLoading != null ||
        pi.portOfDischarge != null ||
        pi.finalDestination != null ||
        pi.shippingMethodCode != null ||
        pi.estimatedShipmentDate != null;
  }

  static PdfColor _getStatusColor(PIStatus status) {
    switch (status) {
      case PIStatus.draft:
        return PdfColors.grey600;
      case PIStatus.sent:
        return const PdfColor.fromInt(0xFF2B6CB0);
      case PIStatus.negotiating:
        return PdfColors.orange700;
      case PIStatus.accepted:
        return PdfColors.green700;
      case PIStatus.rejected:
        return PdfColors.red700;
      case PIStatus.converted:
        return PdfColors.purple700;
      case PIStatus.expired:
        return PdfColors.grey500;
    }
  }
}
