/// Shared utility for filtering deleted companies and stores from data responses
///
/// This utility provides pure data transformation functions that can be used
/// across all layers (presentation, domain, data) without violating Clean Architecture.
///
/// Use case: Filter out soft-deleted companies and stores from RPC responses
class DataFilterUtils {
  /// Filter deleted companies and stores from RPC response
  ///
  /// ✅ Removes companies where is_deleted = true
  /// ✅ Removes stores where is_deleted = true within each company
  /// ✅ Updates company_count and store_count after filtering
  ///
  /// This should be called on raw JSON before parsing into models.
  ///
  /// Example:
  /// ```dart
  /// final rawData = await rpc('get_user_companies_and_stores');
  /// final filteredData = DataFilterUtils.filterDeletedCompaniesAndStores(rawData);
  /// final model = UserCompaniesModel.fromJson(filteredData);
  /// ```
  static Map<String, dynamic> filterDeletedCompaniesAndStores(
    Map<String, dynamic> data,
  ) {
    if (data['companies'] == null || data['companies'] is! List) {
      return data;
    }

    final companies = data['companies'] as List<dynamic>;

    // Filter deleted companies and their deleted stores
    final filteredCompanies = companies.where((company) {
      final isDeleted = company['is_deleted'] == true;
      return !isDeleted;
    }).map((company) {
      // Also filter deleted stores within each company
      if (company['stores'] != null && company['stores'] is List) {
        final stores = company['stores'] as List<dynamic>;
        final filteredStores = stores.where((store) {
          final isDeleted = store['is_deleted'] == true;
          return !isDeleted;
        }).toList();

        company['stores'] = filteredStores;
        company['store_count'] = filteredStores.length;
      }
      return company;
    }).toList();

    data['companies'] = filteredCompanies;
    data['company_count'] = filteredCompanies.length;

    return data;
  }
}
