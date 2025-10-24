import 'package:equatable/equatable.dart';

/// Items summary entity for invoice
class ItemsSummary extends Equatable {
  final int itemCount;
  final int totalQuantity;

  const ItemsSummary({
    required this.itemCount,
    required this.totalQuantity,
  });

  @override
  List<Object> get props => [itemCount, totalQuantity];
}
