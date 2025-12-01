import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_amounts.dart';
import '../../domain/entities/items_summary.dart';

/// Invoice model for data transfer
class InvoiceModel {
  final String invoiceId;
  final String invoiceNumber;
  final DateTime saleDate;
  final String status;
  final Map<String, dynamic>? customer;
  final Map<String, dynamic> store;
  final Map<String, dynamic> payment;
  final Map<String, dynamic> amounts;
  final Map<String, dynamic> itemsSummary;
  final Map<String, dynamic>? createdBy;
  final DateTime createdAt;

  InvoiceModel({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.saleDate,
    required this.status,
    this.customer,
    required this.store,
    required this.payment,
    required this.amounts,
    required this.itemsSummary,
    this.createdBy,
    required this.createdAt,
  });

  /// Create from JSON
  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      invoiceId: json['invoice_id']?.toString() ?? '',
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      saleDate: DateTimeUtils.toLocalSafe(json['sale_date']?.toString()) ?? DateTime.now(),
      status: json['status']?.toString() ?? 'draft',
      customer: json['customer'] as Map<String, dynamic>?,
      store: json['store'] as Map<String, dynamic>,
      payment: json['payment'] as Map<String, dynamic>,
      amounts: json['amounts'] as Map<String, dynamic>,
      itemsSummary: json['items_summary'] as Map<String, dynamic>,
      createdBy: json['created_by'] as Map<String, dynamic>?,
      createdAt: DateTimeUtils.toLocalSafe(json['created_at']?.toString()) ?? DateTime.now(),
    );
  }

  /// Convert to domain entity
  Invoice toEntity() {
    return Invoice(
      invoiceId: invoiceId,
      invoiceNumber: invoiceNumber,
      saleDate: saleDate,
      status: status,
      customer: customer != null ? _customerFromJson(customer!) : null,
      storeId: store['store_id']?.toString() ?? '',
      storeName: store['store_name']?.toString() ?? '',
      storeCode: store['store_code']?.toString() ?? '',
      paymentMethod: payment['method']?.toString() ?? 'cash',
      paymentStatus: payment['status']?.toString() ?? 'pending',
      amounts: _amountsFromJson(amounts),
      itemsSummary: _itemsSummaryFromJson(itemsSummary),
      createdById: createdBy?['user_id']?.toString(),
      createdByName: createdBy?['name']?.toString(),
      createdByEmail: createdBy?['email']?.toString(),
      createdAt: createdAt,
    );
  }

  /// Convert customer JSON to entity
  Customer _customerFromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Walk-in',
      phone: json['phone']?.toString(),
      type: json['type']?.toString() ?? 'individual',
    );
  }

  /// Convert amounts JSON to entity
  InvoiceAmounts _amountsFromJson(Map<String, dynamic> json) {
    return InvoiceAmounts(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert items summary JSON to entity
  ItemsSummary _itemsSummaryFromJson(Map<String, dynamic> json) {
    return ItemsSummary(
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
    );
  }
}
