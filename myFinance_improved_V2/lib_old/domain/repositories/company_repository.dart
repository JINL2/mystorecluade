import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/company.dart';
import '../entities/store.dart';

abstract class CompanyRepository {
  Future<List<Company>> getUserCompanies(String userId);
}

// Supabase implementation  
class SupabaseCompanyRepository implements CompanyRepository {
  @override
  Future<List<Company>> getUserCompanies(String userId) async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_user_companies_and_stores');
      
      if (response == null) {
        return [];
      }
      
      // Parse companies from the response
      final data = response as Map<String, dynamic>;
      final companies = data['companies'] as List<dynamic>? ?? [];
      
      return companies.map((company) => Company(
        id: company['id'] as String,
        companyName: company['company_name'] as String,
        companyCode: company['company_code'] as String? ?? '',
        role: UserRole(
          roleName: company['role_name'] as String,
          permissions: (company['permissions'] as List<dynamic>?)?.cast<String>() ?? [],
        ),
        stores: (company['stores'] as List<dynamic>?)?.map((store) => Store(
          id: store['id'] as String,
          storeName: store['store_name'] as String,
          storeCode: store['store_code'] as String? ?? '',
          companyId: company['id'] as String,
        )).toList() ?? [],
      )).toList();
    } catch (e) {
      throw Exception('Failed to get user companies: $e');
    }
  }
}