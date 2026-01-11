import '../../domain/entities/invoice_detail.dart';

/// Invoice Detail Model for get_invoice_detail RPC response
class InvoiceDetailModel {
  final String invoiceId;
  final String invoiceNumber;
  final DateTime saleDate;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final String? cashLocationId;
  final String? cashLocationName;
  final String? cashLocationType;
  final Map<String, dynamic> store;
  final Map<String, dynamic>? customer;
  final Map<String, dynamic>? createdBy;
  final DateTime createdAt;
  final Map<String, dynamic> amounts;
  final List<Map<String, dynamic>> items;
  // Journal info (AI description and attachments)
  final Map<String, dynamic>? journal;

  InvoiceDetailModel({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.saleDate,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    this.cashLocationId,
    this.cashLocationName,
    this.cashLocationType,
    required this.store,
    this.customer,
    this.createdBy,
    required this.createdAt,
    required this.amounts,
    required this.items,
    this.journal,
  });

  /// Parse datetime string that is already in local time
  static DateTime _parseLocalDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Create from JSON (RPC response)
  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    final cashLocation = json['cash_location'] as Map<String, dynamic>?;
    final itemsList = json['items'] as List<dynamic>? ?? [];

    return InvoiceDetailModel(
      invoiceId: json['invoice_id']?.toString() ?? '',
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      saleDate: _parseLocalDateTime(json['sale_date']?.toString()),
      status: json['status']?.toString() ?? 'draft',
      paymentMethod: json['payment_method']?.toString() ?? 'cash',
      paymentStatus: json['payment_status']?.toString() ?? 'pending',
      cashLocationId: cashLocation?['cash_location_id']?.toString(),
      cashLocationName: cashLocation?['location_name']?.toString(),
      cashLocationType: cashLocation?['location_type']?.toString(),
      store: json['store'] as Map<String, dynamic>? ?? {},
      customer: json['customer'] as Map<String, dynamic>?,
      createdBy: json['created_by'] as Map<String, dynamic>?,
      createdAt: _parseLocalDateTime(json['created_at']?.toString()),
      amounts: json['amounts'] as Map<String, dynamic>? ?? {},
      items: itemsList.map((e) => e as Map<String, dynamic>).toList(),
      journal: json['journal'] as Map<String, dynamic>?,
    );
  }

  /// Convert to domain entity
  InvoiceDetail toEntity() {
    return InvoiceDetail(
      invoiceId: invoiceId,
      invoiceNumber: invoiceNumber,
      saleDate: saleDate,
      status: status,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      cashLocationId: cashLocationId,
      cashLocationName: cashLocationName,
      cashLocationType: cashLocationType,
      storeId: store['store_id']?.toString() ?? '',
      storeName: store['store_name']?.toString() ?? '',
      storeCode: store['store_code']?.toString() ?? '',
      customerId: customer?['customer_id']?.toString(),
      customerName: customer?['name']?.toString(),
      customerPhone: customer?['phone']?.toString(),
      customerType: customer?['type']?.toString(),
      createdById: createdBy?['user_id']?.toString(),
      createdByName: createdBy?['name']?.toString(),
      createdByEmail: createdBy?['email']?.toString(),
      createdByProfileImage: createdBy?['profile_image']?.toString(),
      createdAt: createdAt,
      subtotal: (amounts['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (amounts['tax_amount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (amounts['discount_amount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (amounts['total_amount'] as num?)?.toDouble() ?? 0.0,
      totalCost: (amounts['total_cost'] as num?)?.toDouble() ?? 0.0,
      profit: (amounts['profit'] as num?)?.toDouble() ?? 0.0,
      items: items.map((item) => _itemToEntity(item)).toList(),
      // Journal info (AI description and attachments)
      journalId: journal?['journal_id']?.toString(),
      aiDescription: journal?['ai_description']?.toString(),
      attachments: _parseAttachments(journal?['attachments']),
    );
  }

  /// Parse attachments from journal
  List<InvoiceAttachment> _parseAttachments(dynamic attachmentsJson) {
    if (attachmentsJson == null) return [];
    if (attachmentsJson is! List) return [];

    return attachmentsJson
        .map((e) {
          if (e is! Map<String, dynamic>) return null;
          return InvoiceAttachment(
            attachmentId: e['attachment_id']?.toString() ?? '',
            fileName: e['file_name']?.toString() ?? '',
            fileType: e['file_type']?.toString() ?? _inferMimeType(e['file_name']?.toString() ?? ''),
            fileUrl: e['file_url']?.toString(),
          );
        })
        .whereType<InvoiceAttachment>()
        .toList();
  }

  /// Infer MIME type from file extension
  static String _inferMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  /// Convert item JSON to entity (v2 with variant support)
  InvoiceDetailItem _itemToEntity(Map<String, dynamic> json) {
    final productName = json['product_name']?.toString() ?? '';
    final sku = json['sku']?.toString();

    return InvoiceDetailItem(
      invoiceItemId: json['invoice_item_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: productName,
      sku: sku,
      barcode: json['barcode']?.toString(),
      productImage: json['product_image']?.toString(),
      brandName: json['brand_name']?.toString(),
      categoryName: json['category_name']?.toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      unitCost: (json['unit_cost'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0.0,
      // Variant fields (v2)
      variantId: json['variant_id']?.toString(),
      variantName: json['variant_name']?.toString(),
      variantSku: json['variant_sku']?.toString(),
      variantBarcode: json['variant_barcode']?.toString(),
      displayName: json['display_name']?.toString() ?? productName,
      displaySku: json['display_sku']?.toString() ?? sku ?? '',
      displayBarcode: json['display_barcode']?.toString(),
      hasVariants: json['has_variants'] as bool? ?? false,
    );
  }
}
