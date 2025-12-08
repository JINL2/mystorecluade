import 'package:equatable/equatable.dart';

/// Invoice amounts entity containing financial breakdown
class InvoiceAmounts extends Equatable {
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final double totalCost;
  final double profit;

  const InvoiceAmounts({
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    this.totalCost = 0.0,
    this.profit = 0.0,
  });

  @override
  List<Object> get props => [subtotal, taxAmount, discountAmount, totalAmount, totalCost, profit];
}
