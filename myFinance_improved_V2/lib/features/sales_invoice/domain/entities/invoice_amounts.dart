import 'package:equatable/equatable.dart';

/// Invoice amounts entity containing financial breakdown
class InvoiceAmounts extends Equatable {
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;

  const InvoiceAmounts({
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
  });

  @override
  List<Object> get props => [subtotal, taxAmount, discountAmount, totalAmount];
}
