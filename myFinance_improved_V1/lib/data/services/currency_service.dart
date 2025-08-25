import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Currency service provider
final currencyServiceProvider = Provider<CurrencyService>((ref) {
  return CurrencyService();
});

// Currency types provider
final currencyTypesProvider = FutureProvider<List<CurrencyType>>((ref) async {
  final service = ref.read(currencyServiceProvider);
  return service.getCurrencyTypes();
});

class CurrencyService {
  final _supabase = Supabase.instance.client;

  /// Get all available currency types
  Future<List<CurrencyType>> getCurrencyTypes() async {
    try {
      final response = await _supabase
          .from('currency_types')
          .select('*')
          .order('currency_name');
      
      return (response as List)
          .map((json) => CurrencyType.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching currency types: $e');
      return [];
    }
  }
}

// Currency Type Model
class CurrencyType {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;

  CurrencyType({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
  });

  factory CurrencyType.fromJson(Map<String, dynamic> json) {
    return CurrencyType(
      currencyId: json['currency_id'] as String? ?? '',
      currencyCode: json['currency_code'] as String? ?? '',
      currencyName: json['currency_name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_id': currencyId,
      'currency_code': currencyCode,
      'currency_name': currencyName,
      'symbol': symbol,
    };
  }
}