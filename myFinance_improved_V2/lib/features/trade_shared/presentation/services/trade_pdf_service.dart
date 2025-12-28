import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../../../proforma_invoice/domain/entities/proforma_invoice.dart';
import '../../../purchase_order/domain/entities/purchase_order.dart';

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

/// Trade PDF Service - Generates professional PDFs for trade documents
class TradePdfService {
  static final Map<String, pw.MemoryImage> _imageCache = {};
  static pw.Font? _regularFont;
  static pw.Font? _boldFont;

  /// Load Google Fonts for PDF
  static Future<void> _loadFonts() async {
    if (_regularFont == null) {
      _regularFont = await PdfGoogleFonts.notoSansRegular();
      _boldFont = await PdfGoogleFonts.notoSansBold();
    }
  }

  /// Load image from URL with caching
  static Future<pw.MemoryImage?> _loadImageFromUrl(String? imageUrl) async {
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
  static Future<pw.MemoryImage?> _loadLogo(String? logoUrl) async {
    return _loadImageFromUrl(logoUrl);
  }

  /// Preload all item images for PI
  static Future<Map<String, pw.MemoryImage>> _preloadItemImages(List<PIItem> items) async {
    final Map<String, pw.MemoryImage> images = {};

    for (final item in items) {
      if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
        final image = await _loadImageFromUrl(item.imageUrl);
        if (image != null) {
          images[item.itemId] = image;
        }
      }
    }

    return images;
  }

  /// Preload all item images for PO
  static Future<Map<String, pw.MemoryImage>> _preloadPOItemImages(List<POItem> items) async {
    final Map<String, pw.MemoryImage> images = {};

    for (final item in items) {
      if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
        final image = await _loadImageFromUrl(item.imageUrl);
        if (image != null) {
          images[item.itemId] = image;
        }
      }
    }

    return images;
  }

  /// Generate PDF for Proforma Invoice
  static Future<Uint8List> generateProformaInvoicePdf(
    ProformaInvoice pi, {
    TradePdfConfig config = const TradePdfConfig(),
  }) async {
    // Load fonts first
    await _loadFonts();

    final pdf = pw.Document();
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final numberFormat = NumberFormat('#,##0.00');

    // Create theme with loaded fonts
    final theme = pw.ThemeData.withFont(
      base: _regularFont!,
      bold: _boldFont!,
    );

    // Load logo if provided
    final logo = await _loadLogo(config.logoUrl);

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
        header: (context) => _buildProfessionalHeader(
          pi,
          context,
          logo,
          sellerName,
          config,
        ),
        footer: (context) => _buildProfessionalFooter(context, sellerName, config),
        build: (context) => [
          // Document Title with subtle design
          _buildDocumentTitle('PROFORMA INVOICE', config),
          pw.SizedBox(height: 25),

          // Reference Info Bar
          _buildReferenceBar(pi, dateFormat, config),
          pw.SizedBox(height: 25),

          // Parties Section (Seller & Buyer)
          _buildPartiesSection(pi, sellerInfo, buyerInfo, sellerName, buyerName, config),
          pw.SizedBox(height: 25),

          // Items Table
          _buildProfessionalItemsTable(pi, numberFormat, config, itemImages),
          pw.SizedBox(height: 20),

          // Totals aligned to right
          _buildProfessionalTotals(pi, numberFormat, config),
          pw.SizedBox(height: 25),

          // Shipping & Delivery (keep on main pages)
          if (_hasShippingInfo(pi) || pi.incotermsCode != null)
            _buildShippingAndTerms(pi, dateFormat, config),

          // If no terms page, add signature here
          if (!hasTermsPage) ...[
            pw.SizedBox(height: 40),
            _buildSignatureSection(sellerName, config),
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
              pw.Container(
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
              ),

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
              _buildSignatureSection(sellerName, config),

              pw.SizedBox(height: 20),

              // Footer
              pw.Container(
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
              ),
            ],
          ),
        ),
      );
    }

    return pdf.save();
  }

  /// Generate PDF for Purchase Order
  static Future<Uint8List> generatePurchaseOrderPdf(
    PurchaseOrder po, {
    TradePdfConfig config = const TradePdfConfig(),
  }) async {
    // Load fonts first
    await _loadFonts();

    final pdf = pw.Document();
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final numberFormat = NumberFormat('#,##0.00');

    // Create theme with loaded fonts
    final theme = pw.ThemeData.withFont(
      base: _regularFont!,
      bold: _boldFont!,
    );

    // Load logo if provided
    final logo = await _loadLogo(config.logoUrl);

    // Preload item images
    final itemImages = await _preloadPOItemImages(po.items);

    // Get seller (our company) and buyer info
    final sellerInfo = po.sellerInfo ?? {};
    final buyerInfo = po.buyerInfo ?? {};
    final sellerName = sellerInfo['name'] as String? ?? 'Company Name';
    final buyerName = po.buyerName ?? buyerInfo['name'] as String? ?? 'Supplier Name';

    // Check if we have notes content
    final hasNotesPage = po.notes != null && po.notes!.isNotEmpty;

    // Main content pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        header: (context) => _buildPOHeader(
          po,
          context,
          logo,
          sellerName,
          config,
        ),
        footer: (context) => _buildProfessionalFooter(context, sellerName, config),
        build: (context) => [
          // Document Title
          _buildDocumentTitle('PURCHASE ORDER', config),
          pw.SizedBox(height: 25),

          // Reference Info Bar
          _buildPOReferenceBar(po, dateFormat, config),
          pw.SizedBox(height: 25),

          // Parties Section (Seller & Buyer)
          _buildPOPartiesSection(po, sellerInfo, buyerInfo, sellerName, buyerName, config),
          pw.SizedBox(height: 25),

          // Items Table
          _buildPOItemsTable(po, numberFormat, config, itemImages),
          pw.SizedBox(height: 20),

          // Totals aligned to right
          _buildPOTotals(po, numberFormat, config),
          pw.SizedBox(height: 25),

          // Shipping Terms
          _buildPOShippingTerms(po, dateFormat, config),

          // If no notes page, add signature here
          if (!hasNotesPage) ...[
            pw.SizedBox(height: 40),
            _buildSignatureSection(sellerName, config),
          ],
        ],
      ),
    );

    // Notes & Signature page (if notes exist)
    if (hasNotesPage) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: theme,
          margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Page header
              pw.Container(
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
                          po.poNumber,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: config.primaryColor,
                          ),
                        ),
                        pw.Text(
                          'Notes & Terms',
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Payment Terms
              if (po.paymentTermsCode != null) ...[
                _buildPOPaymentTermsSection(po, config),
                pw.SizedBox(height: 20),
              ],

              // Notes
              if (po.notes != null && po.notes!.isNotEmpty) ...[
                _buildPONotesSection(po, config),
                pw.SizedBox(height: 20),
              ],

              pw.Spacer(),

              // Signature Section at bottom
              _buildSignatureSection(sellerName, config),

              pw.SizedBox(height: 20),

              // Footer
              pw.Container(
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
              ),
            ],
          ),
        ),
      );
    }

    return pdf.save();
  }

  // ============ PO Specific Widgets ============

  static pw.Widget _buildPOHeader(
    PurchaseOrder po,
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
                  color: _getPOStatusColor(po.status),
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Text(
                  po.status.label.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                po.poNumber,
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

  static pw.Widget _buildPOReferenceBar(
    PurchaseOrder po,
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
          _buildRefItem('PO Number', po.poNumber, config),
          _buildRefDivider(),
          _buildRefItem('Order Date', po.orderDateUtc != null ? dateFormat.format(po.orderDateUtc!) : '-', config),
          _buildRefDivider(),
          _buildRefItem('Ship By', po.requiredShipmentDateUtc != null ? dateFormat.format(po.requiredShipmentDateUtc!) : '-', config),
          _buildRefDivider(),
          _buildRefItem('Currency', po.currencyCode, config),
          if (po.incotermsCode != null) ...[
            _buildRefDivider(),
            _buildRefItem('Incoterms', '${po.incotermsCode}${po.incotermsPlace != null ? ' ${po.incotermsPlace}' : ''}', config),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildPOPartiesSection(
    PurchaseOrder po,
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
          child: _buildPartyBox(
            'FROM (BUYER)',
            sellerName,
            _buildAddressLines(sellerInfo),
            config,
            isLeft: true,
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: _buildPartyBox(
            'TO (SUPPLIER)',
            buyerName,
            _buildAddressLines(buyerInfo),
            config,
            isLeft: false,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPOItemsTable(
    PurchaseOrder po,
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
                '${po.items.length} item(s)',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ),
        pw.Table(
          border: pw.TableBorder(
            left: const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            right: const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            bottom: const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            horizontalInside: const pw.BorderSide(color: PdfColors.grey200, width: 0.5),
          ),
          columnWidths: hasImages
              ? {
                  0: const pw.FlexColumnWidth(0.4), // No
                  1: const pw.FlexColumnWidth(0.8), // Image
                  2: const pw.FlexColumnWidth(2.0), // Description
                  3: const pw.FlexColumnWidth(0.6), // Qty
                  4: const pw.FlexColumnWidth(0.6), // Shipped
                  5: const pw.FlexColumnWidth(0.5), // Unit
                  6: const pw.FlexColumnWidth(0.8), // Unit Price
                  7: const pw.FlexColumnWidth(0.8), // Amount
                }
              : {
                  0: const pw.FlexColumnWidth(0.4), // No
                  1: const pw.FlexColumnWidth(2.4), // Description
                  2: const pw.FlexColumnWidth(0.7), // Qty
                  3: const pw.FlexColumnWidth(0.7), // Shipped
                  4: const pw.FlexColumnWidth(0.5), // Unit
                  5: const pw.FlexColumnWidth(0.9), // Unit Price
                  6: const pw.FlexColumnWidth(0.9), // Amount
                },
          children: [
            // Header Row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: hasImages
                  ? [
                      _buildTableHeaderCell('#'),
                      _buildTableHeaderCell('IMAGE'),
                      _buildTableHeaderCell('DESCRIPTION', align: pw.TextAlign.left),
                      _buildTableHeaderCell('QTY'),
                      _buildTableHeaderCell('SHIPPED'),
                      _buildTableHeaderCell('UNIT'),
                      _buildTableHeaderCell('PRICE'),
                      _buildTableHeaderCell('AMOUNT'),
                    ]
                  : [
                      _buildTableHeaderCell('#'),
                      _buildTableHeaderCell('DESCRIPTION', align: pw.TextAlign.left),
                      _buildTableHeaderCell('QTY'),
                      _buildTableHeaderCell('SHIPPED'),
                      _buildTableHeaderCell('UNIT'),
                      _buildTableHeaderCell('PRICE'),
                      _buildTableHeaderCell('AMOUNT'),
                    ],
            ),
            // Data Rows
            ...po.items.asMap().entries.map((entry) {
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
                        _buildTableDataCell('${index + 1}', align: pw.TextAlign.center),
                        _buildItemImageCell(itemImage),
                        _buildPOItemDescriptionCell(item),
                        _buildTableDataCell(
                          numberFormat.format(item.quantity),
                          align: pw.TextAlign.center,
                        ),
                        _buildTableDataCell(
                          numberFormat.format(item.shippedQuantity),
                          align: pw.TextAlign.center,
                        ),
                        _buildTableDataCell(item.unit ?? 'PCS', align: pw.TextAlign.center),
                        _buildTableDataCell(
                          numberFormat.format(item.unitPrice),
                          align: pw.TextAlign.right,
                        ),
                        _buildTableDataCell(
                          numberFormat.format(item.totalAmount),
                          align: pw.TextAlign.right,
                          isBold: true,
                        ),
                      ]
                    : [
                        _buildTableDataCell('${index + 1}', align: pw.TextAlign.center),
                        _buildPOItemDescriptionCell(item),
                        _buildTableDataCell(
                          numberFormat.format(item.quantity),
                          align: pw.TextAlign.center,
                        ),
                        _buildTableDataCell(
                          numberFormat.format(item.shippedQuantity),
                          align: pw.TextAlign.center,
                        ),
                        _buildTableDataCell(item.unit ?? 'PCS', align: pw.TextAlign.center),
                        _buildTableDataCell(
                          numberFormat.format(item.unitPrice),
                          align: pw.TextAlign.right,
                        ),
                        _buildTableDataCell(
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

  static pw.Widget _buildPOItemDescriptionCell(POItem item) {
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
        ],
      ),
    );
  }

  static pw.Widget _buildPOTotals(
    PurchaseOrder po,
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
              // Shipped Progress
              if (po.shippedPercent > 0)
                _buildTotalRow(
                  'Shipped',
                  '${po.shippedPercent.toStringAsFixed(1)}%',
                ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: pw.BoxDecoration(
                  color: config.primaryColor,
                  borderRadius: po.shippedPercent > 0
                      ? const pw.BorderRadius.only(
                          bottomLeft: pw.Radius.circular(3),
                          bottomRight: pw.Radius.circular(3),
                        )
                      : pw.BorderRadius.circular(3),
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
                      '${po.currencyCode} ${numberFormat.format(po.totalAmount)}',
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

  static pw.Widget _buildPOShippingTerms(
    PurchaseOrder po,
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
            'SHIPPING & TERMS',
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
                    if (po.incotermsCode != null)
                      _buildInfoLine('Incoterms', '${po.incotermsCode}${po.incotermsPlace != null ? ' ${po.incotermsPlace}' : ''}'),
                    if (po.paymentTermsCode != null)
                      _buildInfoLine('Payment Terms', po.paymentTermsCode!.replaceAll('_', ' ').toUpperCase()),
                    if (po.piNumber != null)
                      _buildInfoLine('Reference PI', po.piNumber!),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (po.requiredShipmentDateUtc != null)
                      _buildInfoLine('Required Ship Date', dateFormat.format(po.requiredShipmentDateUtc!)),
                    _buildInfoLine('Partial Shipment', po.partialShipmentAllowed ? 'Allowed' : 'Not Allowed'),
                    _buildInfoLine('Transshipment', po.transshipmentAllowed ? 'Allowed' : 'Not Allowed'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPOPaymentTermsSection(PurchaseOrder po, TradePdfConfig config) {
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
          pw.Text(
            po.paymentTermsCode!.replaceAll('_', ' ').toUpperCase(),
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPONotesSection(PurchaseOrder po, TradePdfConfig config) {
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
            po.notes!,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
          ),
        ],
      ),
    );
  }

  static PdfColor _getPOStatusColor(POStatus status) {
    switch (status) {
      case POStatus.draft:
        return PdfColors.grey600;
      case POStatus.confirmed:
        return const PdfColor.fromInt(0xFF2B6CB0);
      case POStatus.inProduction:
        return PdfColors.orange700;
      case POStatus.readyToShip:
        return PdfColors.yellow800;
      case POStatus.partiallyShipped:
        return PdfColors.cyan700;
      case POStatus.shipped:
        return PdfColors.green700;
      case POStatus.completed:
        return PdfColors.green800;
      case POStatus.cancelled:
        return PdfColors.red700;
    }
  }

  // ============ Common Widgets ============

  static pw.Widget _buildProfessionalHeader(
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

  static pw.Widget _buildProfessionalFooter(
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

  static pw.Widget _buildDocumentTitle(String title, TradePdfConfig config) {
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
          _buildRefItem('PI Number', pi.piNumber, config),
          _buildRefDivider(),
          _buildRefItem('Issue Date', pi.createdAtUtc != null ? dateFormat.format(pi.createdAtUtc!) : '-', config),
          _buildRefDivider(),
          _buildRefItem('Valid Until', pi.validityDate != null ? dateFormat.format(pi.validityDate!) : '-', config),
          _buildRefDivider(),
          _buildRefItem('Currency', pi.currencyCode, config),
          if (pi.incotermsCode != null) ...[
            _buildRefDivider(),
            _buildRefItem('Incoterms', '${pi.incotermsCode}${pi.incotermsPlace != null ? ' ${pi.incotermsPlace}' : ''}', config),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildRefItem(String label, String value, TradePdfConfig config) {
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

  static pw.Widget _buildRefDivider() {
    return pw.Container(
      height: 30,
      width: 1,
      color: PdfColors.grey300,
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
          child: _buildPartyBox(
            'FROM (SELLER)',
            sellerName,
            _buildAddressLines(sellerInfo),
            config,
            isLeft: true,
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: _buildPartyBox(
            'TO (BUYER)',
            buyerName,
            _buildAddressLines(buyerInfo),
            config,
            isLeft: false,
          ),
        ),
      ],
    );
  }

  static List<String> _buildAddressLines(Map<String, dynamic> info) {
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

  static pw.Widget _buildPartyBox(
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
          ...addressLines.map((line) => pw.Padding(
            padding: const pw.EdgeInsets.only(top: 2),
            child: pw.Text(
              line,
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
          )),
        ],
      ),
    );
  }

  static pw.Widget _buildProfessionalItemsTable(
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
          border: pw.TableBorder(
            left: const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            right: const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            bottom: const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            horizontalInside: const pw.BorderSide(color: PdfColors.grey200, width: 0.5),
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
                      _buildTableHeaderCell('#'),
                      _buildTableHeaderCell('IMAGE'),
                      _buildTableHeaderCell('DESCRIPTION', align: pw.TextAlign.left),
                      _buildTableHeaderCell('QTY'),
                      _buildTableHeaderCell('UNIT'),
                      _buildTableHeaderCell('PRICE'),
                      _buildTableHeaderCell('AMOUNT'),
                    ]
                  : [
                      _buildTableHeaderCell('#'),
                      _buildTableHeaderCell('DESCRIPTION', align: pw.TextAlign.left),
                      _buildTableHeaderCell('QTY'),
                      _buildTableHeaderCell('UNIT'),
                      _buildTableHeaderCell('PRICE'),
                      _buildTableHeaderCell('AMOUNT'),
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
                        _buildTableDataCell('${index + 1}', align: pw.TextAlign.center),
                        _buildItemImageCell(itemImage),
                        _buildItemDescriptionCell(item),
                        _buildTableDataCell(
                          numberFormat.format(item.quantity),
                          align: pw.TextAlign.center,
                        ),
                        _buildTableDataCell(item.unit ?? 'PCS', align: pw.TextAlign.center),
                        _buildTableDataCell(
                          numberFormat.format(item.unitPrice),
                          align: pw.TextAlign.right,
                        ),
                        _buildTableDataCell(
                          numberFormat.format(item.totalAmount),
                          align: pw.TextAlign.right,
                          isBold: true,
                        ),
                      ]
                    : [
                        _buildTableDataCell('${index + 1}', align: pw.TextAlign.center),
                        _buildItemDescriptionCell(item),
                        _buildTableDataCell(
                          numberFormat.format(item.quantity),
                          align: pw.TextAlign.center,
                        ),
                        _buildTableDataCell(item.unit ?? 'PCS', align: pw.TextAlign.center),
                        _buildTableDataCell(
                          numberFormat.format(item.unitPrice),
                          align: pw.TextAlign.right,
                        ),
                        _buildTableDataCell(
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

  static pw.Widget _buildItemImageCell(pw.MemoryImage? image) {
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

  static pw.Widget _buildTableHeaderCell(String text, {pw.TextAlign align = pw.TextAlign.center}) {
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

  static pw.Widget _buildTableDataCell(
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

  static pw.Widget _buildProfessionalTotals(
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
              _buildTotalRow('Subtotal', '${pi.currencyCode} ${numberFormat.format(pi.subtotal)}'),
              if (pi.discountAmount > 0)
                _buildTotalRow('Discount', '-${pi.currencyCode} ${numberFormat.format(pi.discountAmount)}', isNegative: true),
              if (pi.taxAmount > 0)
                _buildTotalRow('Tax (${pi.taxPercent}%)', '${pi.currencyCode} ${numberFormat.format(pi.taxAmount)}'),
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

  static pw.Widget _buildTotalRow(String label, String value, {bool isNegative = false}) {
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
                    if (pi.portOfLoading != null)
                      _buildInfoLine('Port of Loading', pi.portOfLoading!),
                    if (pi.portOfDischarge != null)
                      _buildInfoLine('Port of Discharge', pi.portOfDischarge!),
                    if (pi.finalDestination != null)
                      _buildInfoLine('Final Destination', pi.finalDestination!),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (pi.shippingMethodCode != null)
                      _buildInfoLine('Shipping Method', pi.shippingMethodCode!),
                    if (pi.estimatedShipmentDate != null)
                      _buildInfoLine('Est. Shipment', dateFormat.format(pi.estimatedShipmentDate!)),
                    _buildInfoLine('Partial Shipment', pi.partialShipmentAllowed ? 'Allowed' : 'Not Allowed'),
                    _buildInfoLine('Transshipment', pi.transshipmentAllowed ? 'Allowed' : 'Not Allowed'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoLine(String label, String value) {
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

  static pw.Widget _buildSignatureSection(String companyName, TradePdfConfig config) {
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

  /// Share/Print PDF using the printing package
  static Future<void> sharePdf(Uint8List pdfBytes, String filename) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: filename);
  }

  /// Print PDF directly
  static Future<void> printPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }

  /// Preview PDF in dialog
  static Future<void> previewPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
      name: 'Document Preview',
    );
  }
}
