import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';

/// Brand model
class Brand {
  final String id;
  final String name;

  const Brand({required this.id, required this.name});
}

/// Provider to fetch all brands from inventory_brands table
final brandsProvider = FutureProvider<List<Brand>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) return [];

  final client = Supabase.instance.client;
  final response = await client
      .from('inventory_brands')
      .select('brand_id, brand_name')
      .eq('company_id', companyId)
      .eq('is_active', true)
      .order('brand_name');

  final brands = (response as List)
      .map((json) => Brand(
            id: json['brand_id']?.toString() ?? '',
            name: json['brand_name']?.toString() ?? '',
          ))
      .where((b) => b.name.isNotEmpty)
      .toList();

  return brands;
});
