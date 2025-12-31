/// PO PDF Generator
///
/// Handles all Purchase Order (PO) specific PDF generation logic.
/// Uses shared utilities from PdfCommon for consistent styling.
library;

import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../purchase_order/domain/entities/purchase_order.dart';
import 'pdf_common.dart';
import 'pdf_config.dart';

/// PO PDF Generator
class PoPdfGenerator {
  /// Generate PDF for Purchase Order
  static Future<Uint8List> generate(
    PurchaseOrder po, {
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
    final itemImages = await _preloadItemImages(po.items);

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
        header: (context) => _buildHeader(
          po,
          context,
          logo,
          sellerName,
          config,
        ),
        footer: (context) => PdfCommon.buildProfessionalFooter(context, sellerName, config),
        build: (context) => [
          // Document Title
          PdfCommon.buildDocumentTitle('PURCHASE ORDER', config),
          pw.SizedBox(height: 25),

          // Reference Info Bar
          _buildReferenceBar(po, dateFormat, config),
          pw.SizedBox(height: 25),

          // Parties Section (Seller & Buyer)
          _buildPartiesSection(po, sellerInfo, buyerInfo, sellerName, buyerName, config),
          pw.SizedBox(height: 25),

          // Items Table
          _buildItemsTable(po, numberFormat, config, itemImages),
          pw.SizedBox(height: 20),

          // Totals aligned to right
          _buildTotals(po, numberFormat, config),
          pw.SizedBox(height: 25),

          // Shipping Terms
          _buildShippingTerms(po, dateFormat, config),

          // Banking Information
          if (po.bankingInfo != null && po.bankingInfo!.isNotEmpty) ...[
            pw.SizedBox(height: 25),
            PdfCommon.buildBankingInfoSection(
              po.bankingInfo,
              po.currencyCode,
              po.totalAmount,
              config.primaryColor,
            ),
          ],

          // If no notes page, add signature here
          if (!hasNotesPage) ...[
            pw.SizedBox(height: 40),
            PdfCommon.buildSignatureSection(sellerName, config),
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
              _buildNotesPageHeader(po, sellerName, config),

              // Payment Terms
              if (po.paymentTermsCode != null) ...[
                _buildPaymentTermsSection(po, config),
                pw.SizedBox(height: 20),
              ],

              // Notes
              if (po.notes != null && po.notes!.isNotEmpty) ...[
                _buildNotesSection(po, config),
                pw.SizedBox(height: 20),
              ],

              pw.Spacer(),

              // Signature Section at bottom
              PdfCommon.buildSignatureSection(sellerName, config),

              pw.SizedBox(height: 20),

              // Footer
              _buildNotesPageFooter(),
            ],
          ),
        ),
      );
    }

    return pdf.save();
  }

  // ============ Image Loading ============

  /// Preload all item images for PO
  static Future<Map<String, pw.MemoryImage>> _preloadItemImages(List<POItem> items) async {
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

  // ============ Header & Footer ============

  static pw.Widget _buildHeader(
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
                  color: _getStatusColor(po.status),
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

  static pw.Widget _buildNotesPageHeader(
    PurchaseOrder po,
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
    );
  }

  static pw.Widget _buildNotesPageFooter() {
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

  // ============ Reference Bar ============

  static pw.Widget _buildReferenceBar(
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
          PdfCommon.buildRefItem('PO Number', po.poNumber, config),
          PdfCommon.buildRefDivider(),
          PdfCommon.buildRefItem(
            'Order Date',
            po.orderDateUtc != null ? dateFormat.format(po.orderDateUtc!) : '-',
            config,
          ),
          PdfCommon.buildRefDivider(),
          PdfCommon.buildRefItem(
            'Ship By',
            po.requiredShipmentDateUtc != null ? dateFormat.format(po.requiredShipmentDateUtc!) : '-',
            config,
          ),
          PdfCommon.buildRefDivider(),
          PdfCommon.buildRefItem('Currency', po.currencyCode, config),
          if (po.incotermsCode != null) ...[
            PdfCommon.buildRefDivider(),
            PdfCommon.buildRefItem(
              'Incoterms',
              '${po.incotermsCode}${po.incotermsPlace != null ? ' ${po.incotermsPlace}' : ''}',
              config,
            ),
          ],
        ],
      ),
    );
  }

  // ============ Parties Section ============

  static pw.Widget _buildPartiesSection(
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
          child: PdfCommon.buildPartyBox(
            'FROM (BUYER)',
            sellerName,
            PdfCommon.buildAddressLines(sellerInfo),
            config,
            isLeft: true,
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: PdfCommon.buildPartyBox(
            'TO (SUPPLIER)',
            buyerName,
            PdfCommon.buildAddressLines(buyerInfo),
            config,
            isLeft: false,
          ),
        ),
      ],
    );
  }

  // ============ Items Table ============

  static pw.Widget _buildItemsTable(
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
                      PdfCommon.buildTableHeaderCell('#'),
                      PdfCommon.buildTableHeaderCell('IMAGE'),
                      PdfCommon.buildTableHeaderCell('DESCRIPTION', align: pw.TextAlign.left),
                      PdfCommon.buildTableHeaderCell('QTY'),
                      PdfCommon.buildTableHeaderCell('SHIPPED'),
                      PdfCommon.buildTableHeaderCell('UNIT'),
                      PdfCommon.buildTableHeaderCell('PRICE'),
                      PdfCommon.buildTableHeaderCell('AMOUNT'),
                    ]
                  : [
                      PdfCommon.buildTableHeaderCell('#'),
                      PdfCommon.buildTableHeaderCell('DESCRIPTION', align: pw.TextAlign.left),
                      PdfCommon.buildTableHeaderCell('QTY'),
                      PdfCommon.buildTableHeaderCell('SHIPPED'),
                      PdfCommon.buildTableHeaderCell('UNIT'),
                      PdfCommon.buildTableHeaderCell('PRICE'),
                      PdfCommon.buildTableHeaderCell('AMOUNT'),
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
                        PdfCommon.buildTableDataCell('${index + 1}', align: pw.TextAlign.center),
                        PdfCommon.buildItemImageCell(itemImage),
                        _buildItemDescriptionCell(item),
                        PdfCommon.buildTableDataCell(
                          numberFormat.format(item.quantity),
                          align: pw.TextAlign.center,
                        ),
                        PdfCommon.buildTableDataCell(
                          numberFormat.format(item.shippedQuantity),
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
                        PdfCommon.buildTableDataCell(
                          numberFormat.format(item.shippedQuantity),
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

  static pw.Widget _buildItemDescriptionCell(POItem item) {
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

  // ============ Totals Section ============

  static pw.Widget _buildTotals(
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
                PdfCommon.buildTotalRow(
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

  // ============ Shipping & Terms ============

  static pw.Widget _buildShippingTerms(
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
                      PdfCommon.buildInfoLine(
                        'Incoterms',
                        '${po.incotermsCode}${po.incotermsPlace != null ? ' ${po.incotermsPlace}' : ''}',
                      ),
                    if (po.paymentTermsCode != null)
                      PdfCommon.buildInfoLine(
                        'Payment Terms',
                        po.paymentTermsCode!.replaceAll('_', ' ').toUpperCase(),
                      ),
                    if (po.piNumber != null) PdfCommon.buildInfoLine('Reference PI', po.piNumber!),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (po.requiredShipmentDateUtc != null)
                      PdfCommon.buildInfoLine(
                        'Required Ship Date',
                        dateFormat.format(po.requiredShipmentDateUtc!),
                      ),
                    PdfCommon.buildInfoLine(
                      'Partial Shipment',
                      po.partialShipmentAllowed ? 'Allowed' : 'Not Allowed',
                    ),
                    PdfCommon.buildInfoLine(
                      'Transshipment',
                      po.transshipmentAllowed ? 'Allowed' : 'Not Allowed',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPaymentTermsSection(PurchaseOrder po, TradePdfConfig config) {
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

  static pw.Widget _buildNotesSection(PurchaseOrder po, TradePdfConfig config) {
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

  // ============ Status Color ============

  static PdfColor _getStatusColor(POStatus status) {
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
}
