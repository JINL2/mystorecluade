import 'package:equatable/equatable.dart';

/// Customer entity for invoice
class Customer extends Equatable {
  final String customerId;
  final String name;
  final String? phone;
  final String type;

  const Customer({
    required this.customerId,
    required this.name,
    this.phone,
    required this.type,
  });

  @override
  List<Object?> get props => [customerId, name, phone, type];
}
