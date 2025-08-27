import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/models/debt_control_v2_models.dart';
import 'package:myfinance_improved/repositories/debt_control_v2_repository.dart';

/// Test for Debt Control V2 Implementation
/// This test validates the new v2 RPC function that returns both perspectives
void main() {
  late SupabaseClient supabaseClient;
  late DebtControlV2Repository repository;

  setUpAll(() async {
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://atkekzwgukdvucqntryo.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDU0NjM5NjIsImV4cCI6MjAyMTAzOTk2Mn0.L8VorQKfQn0H5P1cVbsCOxJndlBOBR1cOtoL_vw6LeQ', // Replace with your actual anon key
    );
    supabaseClient = Supabase.instance.client;
    repository = DebtControlV2Repository(supabaseClient);
  });

  group('Debt Control V2 Tests', () {
    test('Test V2 function returns both perspectives', () async {
      try {
        // Single call gets BOTH perspectives
        final response = await repository.getDebtControlData(
          companyId: '7a2545e0-e112-4b0c-9c59-221a530c4602',
          storeId: 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
          filter: 'all',
          showAll: false,
        );

        // Verify structure
        expect(response, isNotNull);
        expect(response.company, isNotNull);
        expect(response.store, isNotNull);
        expect(response.metadata, isNotNull);
        
        // Verify metadata
        expect(response.metadata.version, equals('2.0'));
        expect(response.metadata.hasBothPerspectives, isTrue);
        
        // Verify Company Data
        if (response.company != null) {
          final companyData = response.company!;
          expect(companyData.metadata.perspective, equals('company'));
          expect(companyData.summary, isNotNull);
          expect(companyData.storeAggregates, isNotNull);
          expect(companyData.records, isNotNull);
          
          print('✅ Company Net Position: ${companyData.summary.netPosition}');
          print('   Expected: ₫67,770,748');
          
          // Check store aggregates
          for (var store in companyData.storeAggregates) {
            print('   ${store.storeName}: ${store.netPositionCompact}');
          }
        }
        
        // Verify Store Data
        if (response.store != null) {
          final storeData = response.store!;
          expect(storeData.metadata.perspective, equals('store'));
          expect(storeData.summary, isNotNull);
          expect(storeData.storeAggregates, isEmpty); // Should be empty for store view
          expect(storeData.records, isNotNull);
          
          print('✅ Store Net Position: ${storeData.summary.netPosition}');
          print('   Expected: ₫34,044,202');
        }
        
        print('✅ V2 Test Passed - Both perspectives received in single call');
        
      } catch (e) {
        print('❌ Error: $e');
        fail('V2 RPC function failed: $e');
      }
    });

    test('Test perspective switching without refetch', () async {
      // First call - gets both perspectives
      final response = await repository.getDebtControlData(
        companyId: '7a2545e0-e112-4b0c-9c59-221a530c4602',
        storeId: 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
        filter: 'all',
        showAll: false,
      );
      
      // Simulate UI switching between tabs
      // Company view
      var currentData = response.getPerspective(true); // isCompanyView = true
      expect(currentData, equals(response.company));
      print('✅ Switched to Company view - no API call needed');
      
      // Store view
      currentData = response.getPerspective(false); // isCompanyView = false
      expect(currentData, equals(response.store));
      print('✅ Switched to Store view - no API call needed');
      
      print('✅ Tab switching test passed - instant switching');
    });

    test('Test filters work correctly', () async {
      // Test with internal filter
      final internalResponse = await repository.getDebtControlData(
        companyId: '7a2545e0-e112-4b0c-9c59-221a530c4602',
        storeId: 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
        filter: 'internal',
        showAll: false,
      );
      
      if (internalResponse.company != null) {
        // All records should be internal
        final allInternal = internalResponse.company!.records
            .every((record) => record.isInternal);
        expect(allInternal, isTrue);
        print('✅ Internal filter working correctly');
      }
      
      // Test with external filter
      final externalResponse = await repository.getDebtControlData(
        companyId: '7a2545e0-e112-4b0c-9c59-221a530c4602',
        storeId: 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
        filter: 'external',
        showAll: false,
      );
      
      if (externalResponse.company != null) {
        // All records should be external
        final allExternal = externalResponse.company!.records
            .every((record) => !record.isInternal);
        expect(allExternal, isTrue);
        print('✅ External filter working correctly');
      }
    });

    test('Test show all counterparties feature', () async {
      // Test without showing all
      final activeOnly = await repository.getDebtControlData(
        companyId: '7a2545e0-e112-4b0c-9c59-221a530c4602',
        storeId: null,
        filter: 'all',
        showAll: false,
      );
      
      // Test with showing all
      final showAll = await repository.getDebtControlData(
        companyId: '7a2545e0-e112-4b0c-9c59-221a530c4602',
        storeId: null,
        filter: 'all',
        showAll: true,
      );
      
      if (activeOnly.company != null && showAll.company != null) {
        final activeCount = activeOnly.company!.records.length;
        final allCount = showAll.company!.records.length;
        
        print('Active counterparties: $activeCount');
        print('All counterparties: $allCount');
        
        // When showing all, we should have same or more records
        expect(allCount, greaterThanOrEqualTo(activeCount));
        
        // Check for zero-balance records when showing all
        final zeroBalanceRecords = showAll.company!.records
            .where((r) => r.netAmount == 0 && r.transactionCount == 0)
            .toList();
        
        print('Zero-balance counterparties: ${zeroBalanceRecords.length}');
        print('✅ Show all counterparties feature working');
      }
    });

    test('Direct RPC call test (raw)', () async {
      // Test direct RPC call as shown in documentation
      final response = await supabaseClient.rpc(
        'get_debt_control_data_v2',
        params: {
          'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602',
          'p_store_id': 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
          'p_filter': 'all',
          'p_show_all': false,
        },
      );
      
      expect(response, isNotNull);
      expect(response, isA<Map<String, dynamic>>());
      
      final data = response as Map<String, dynamic>;
      
      // Access company data
      final companyData = data['company'];
      print('Company Net Position: ${companyData['summary']['net_position']}');
      // Should print: 67770748.00
      
      // Access store data  
      final storeData = data['store'];
      print('Store Net Position: ${storeData['summary']['net_position']}');
      // Should print: 34044202.00
      
      // Store aggregates (company view only)
      final storeAggregates = companyData['store_aggregates'];
      for (var store in storeAggregates) {
        print('${store['store_name']}: ${store['net_position']}');
      }
      // Should print:
      // test1: 34044202.00
      // test3: 32726546.00
      
      print('✅ Direct RPC call test passed');
    });
  });
}