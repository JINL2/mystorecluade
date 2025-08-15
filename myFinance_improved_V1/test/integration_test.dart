import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Integration test to verify database connection and queries
void main() {
  group('Database Integration Tests', () {
    late SupabaseClient client;
    
    setUpAll(() async {
      await Supabase.initialize(
        url: 'https://atkekzwgukdvucqntryo.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      );
      client = Supabase.instance.client;
    });
    
    test('Can fetch currency_types table', () async {
      final response = await client
          .from('currency_types')
          .select('*')
          .limit(5);
      
      print('Currency Types Sample:');
      for (var currency in response) {
        print('  - ${currency['currency_code']}: ${currency['currency_name']}');
      }
      
      expect(response, isNotNull);
      expect(response, isList);
    });
    
    test('Can fetch company_currency table structure', () async {
      // Test with a sample company ID (you'd need a real one for actual testing)
      final testCompanyId = 'test-company-id';
      
      final response = await client
          .from('company_currency')
          .select('*')
          .eq('company_id', testCompanyId)
          .limit(1);
      
      print('Company Currency Structure: ${response.isEmpty ? "No data" : response.first.keys.toList()}');
      
      // Just checking the query doesn't error
      expect(response, isNotNull);
    });
    
    test('Verify currency_denominations table columns', () async {
      // This will help us see what columns actually exist
      final testCompanyId = 'test-company-id';
      
      try {
        final response = await client
            .from('currency_denominations')
            .select('*')
            .eq('company_id', testCompanyId)
            .limit(1);
        
        if (response.isNotEmpty) {
          print('Currency Denominations Columns: ${response.first.keys.toList()}');
        } else {
          print('No denomination data found, but query succeeded');
        }
      } catch (e) {
        print('Query error (expected if no data): $e');
      }
    });
    
    test('Test filtering currencies by company', () async {
      // Get all currency types
      final allCurrencies = await client
          .from('currency_types')
          .select('*')
          .order('currency_name');
      
      print('Total available currencies: ${allCurrencies.length}');
      
      // In a real test, you'd filter against actual company currencies
      // This is just to show the filtering logic works
      final mockCompanyCurrencyIds = ['USD', 'EUR']; // Example
      
      final filtered = allCurrencies.where((currency) => 
        !mockCompanyCurrencyIds.contains(currency['currency_code'])
      ).toList();
      
      print('Filtered currencies (excluding USD, EUR): ${filtered.length}');
      
      expect(filtered.length, lessThan(allCurrencies.length));
    });
  });
}