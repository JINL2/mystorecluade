import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/lc_type.dart';
import 'lc_providers.dart';

/// LC Types from trade_lc_types table
final lcTypesProvider = FutureProvider.autoDispose<List<LCType>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);

  final response = await supabase
      .from('trade_lc_types')
      .select('*')
      .eq('is_active', true)
      .order('display_order', ascending: true);

  final data = response as List;
  return data.map((e) => LCType.fromJson(e as Map<String, dynamic>)).toList();
});

/// LC Payment Terms (requires_lc = true)
final lcPaymentTermsProvider =
    FutureProvider.autoDispose<List<LCPaymentTerm>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);

  final response = await supabase
      .from('trade_payment_terms')
      .select('*')
      .eq('requires_lc', true)
      .eq('is_active', true)
      .order('display_order', ascending: true);

  final data = response as List;
  return data
      .map((e) => LCPaymentTerm.fromJson(e as Map<String, dynamic>))
      .toList();
});

// Note: Bank selection uses cash_locations via allCashLocationsProvider
// from cash_location feature (locationType: 'bank')

/// Simple Currency Type model
class CurrencyType {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String? symbol;

  const CurrencyType({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    this.symbol,
  });

  factory CurrencyType.fromJson(Map<String, dynamic> json) {
    return CurrencyType(
      currencyId: json['currency_id'] as String,
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String?,
    );
  }
}

/// Simple Incoterm model
class IncotermType {
  final String incotermId;
  final String code;
  final String name;
  final String? description;
  final String? version;

  const IncotermType({
    required this.incotermId,
    required this.code,
    required this.name,
    this.description,
    this.version,
  });

  factory IncotermType.fromJson(Map<String, dynamic> json) {
    return IncotermType(
      incotermId: json['incoterm_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      version: json['version'] as String?,
    );
  }
}

/// Simple Shipping Method model
class ShippingMethod {
  final String shippingMethodId;
  final String code;
  final String name;
  final String? description;

  const ShippingMethod({
    required this.shippingMethodId,
    required this.code,
    required this.name,
    this.description,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) {
    return ShippingMethod(
      shippingMethodId: json['shipping_method_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }
}
