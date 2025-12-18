import 'package:equatable/equatable.dart';

/// Items summary entity for invoice
class ItemsSummary extends Equatable {
  final int itemCount;
  final int totalQuantity;
  final String? firstProductName;

  const ItemsSummary({
    required this.itemCount,
    required this.totalQuantity,
    this.firstProductName,
  });

  /// Get display name for invoice list
  /// - 1 product: "루이비통 벨트"
  /// - N products: "루이비통 벨트 외 N-1건"
  String get productDisplayName {
    if (firstProductName == null || firstProductName!.isEmpty) {
      return '$itemCount products';
    }
    final otherCount = itemCount - 1;
    if (otherCount > 0) {
      return '$firstProductName 외 $otherCount건';
    }
    return firstProductName!;
  }

  @override
  List<Object?> get props => [itemCount, totalQuantity, firstProductName];
}
