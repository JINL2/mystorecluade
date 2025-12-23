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

  @override
  List<Object?> get props => [itemCount, totalQuantity, firstProductName];
}
