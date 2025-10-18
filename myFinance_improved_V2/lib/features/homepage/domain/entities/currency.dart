import 'package:equatable/equatable.dart';

/// Currency entity representing a currency type
/// Represents a currency from the currency_types table
class Currency extends Equatable {
  const Currency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
  });

  /// Unique identifier (currency_id from database)
  final String id;

  /// ISO currency code (e.g., "USD", "EUR", "KRW")
  final String code;

  /// Full currency name (e.g., "US Dollar", "Euro", "South Korean Won")
  final String name;

  /// Currency symbol (e.g., "$", "€", "₩")
  final String symbol;

  @override
  List<Object?> get props => [id, code, name, symbol];

  @override
  String toString() => 'Currency(id: $id, code: $code, name: $name, symbol: $symbol)';
}
