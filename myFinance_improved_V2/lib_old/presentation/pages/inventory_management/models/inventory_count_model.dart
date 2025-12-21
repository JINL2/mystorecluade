// Inventory Count Models

class InventoryCount {
  final String id;
  final String voucherNumber;
  final DateTime countDate;
  final String countedBy;
  final List<CountItem> items;
  final CountStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? completedAt;
  
  InventoryCount({
    required this.id,
    required this.voucherNumber,
    required this.countDate,
    required this.countedBy,
    required this.items,
    required this.status,
    this.notes,
    required this.createdAt,
    this.completedAt,
  });
  
  int get totalItems => items.length;
  int get discrepancyCount => items.where((item) => item.discrepancy != 0).length;
  
  double get totalVarianceValue {
    return items.fold(0.0, (sum, item) => sum + (item.discrepancy * item.costPrice));
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'voucher_number': voucherNumber,
      'count_date': countDate.toIso8601String(),
      'counted_by': countedBy,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.name,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
  
  factory InventoryCount.fromJson(Map<String, dynamic> json) {
    return InventoryCount(
      id: json['id'],
      voucherNumber: json['voucher_number'],
      countDate: DateTime.parse(json['count_date']),
      countedBy: json['counted_by'],
      items: (json['items'] as List).map((item) => CountItem.fromJson(item)).toList(),
      status: CountStatus.values.firstWhere((e) => e.name == json['status']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : null,
    );
  }
}

class CountItem {
  final String productId;
  final String productName;
  final String sku;
  final int systemQuantity;
  final int countedQuantity;
  final int discrepancy;
  final String? location;
  final String? notes;
  final double costPrice;
  
  CountItem({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.systemQuantity,
    required this.countedQuantity,
    required this.discrepancy,
    this.location,
    this.notes,
    this.costPrice = 0,
  });
  
  double get varianceValue => discrepancy * costPrice;
  
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'system_quantity': systemQuantity,
      'counted_quantity': countedQuantity,
      'discrepancy': discrepancy,
      'location': location,
      'notes': notes,
      'cost_price': costPrice,
    };
  }
  
  factory CountItem.fromJson(Map<String, dynamic> json) {
    return CountItem(
      productId: json['product_id'],
      productName: json['product_name'],
      sku: json['sku'],
      systemQuantity: json['system_quantity'],
      countedQuantity: json['counted_quantity'],
      discrepancy: json['discrepancy'],
      location: json['location'],
      notes: json['notes'],
      costPrice: (json['cost_price'] ?? 0).toDouble(),
    );
  }
}

enum CountStatus {
  draft,
  inProgress,
  discrepancyFound,
  completed,
  cancelled;
  
  String get displayName {
    switch (this) {
      case CountStatus.draft:
        return 'Draft';
      case CountStatus.inProgress:
        return 'In Progress';
      case CountStatus.discrepancyFound:
        return 'Discrepancy Found';
      case CountStatus.completed:
        return 'Completed';
      case CountStatus.cancelled:
        return 'Cancelled';
    }
  }
  
  bool get isFinalized {
    return this == CountStatus.completed || this == CountStatus.cancelled;
  }
}