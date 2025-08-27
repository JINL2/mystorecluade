import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Test script for debt control RPC function
/// Run this test to verify the RPC function is working correctly
void main() {
  late SupabaseClient supabaseClient;

  setUpAll(() async {
    // Initialize Supabase (replace with your actual URL and anon key)
    await Supabase.initialize(
      url: 'https://atkekzwgukdvucqntryo.supabase.co',
      anonKey: 'YOUR_ANON_KEY', // TODO: Add your anon key
    );
    supabaseClient = Supabase.instance.client;
  });

  group('Debt Control RPC Tests', () {
    test('Test RPC function - Company perspective', () async {
      try {
        // Test with your actual company ID
        final response = await supabaseClient.rpc(
          'get_debt_control_data',
          params: {
            'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602', // Replace with your company ID
            'p_store_id': null,
          },
        );

        expect(response, isNotNull);
        expect(response, isA<Map<String, dynamic>>());
        
        final data = response as Map<String, dynamic>;
        
        // Verify structure
        expect(data.containsKey('metadata'), isTrue);
        expect(data.containsKey('summary'), isTrue);
        expect(data.containsKey('store_aggregates'), isTrue);
        expect(data.containsKey('records'), isTrue);
        
        // Verify metadata
        final metadata = data['metadata'] as Map<String, dynamic>;
        expect(metadata['perspective'], equals('company'));
        expect(metadata['company_id'], isNotNull);
        
        // Verify summary
        final summary = data['summary'] as Map<String, dynamic>;
        expect(summary['total_receivable'], isA<num>());
        expect(summary['total_payable'], isA<num>());
        expect(summary['net_position'], isA<num>());
        
        // Verify records
        final records = data['records'] as List;
        if (records.isNotEmpty) {
          final firstRecord = records.first as Map<String, dynamic>;
          expect(firstRecord['counterparty_id'], isNotNull);
          expect(firstRecord['counterparty_name'], isNotNull);
          expect(firstRecord['is_internal'], isA<bool>());
        }
        
        print('✅ Company perspective test passed');
        print('Summary: ${summary}');
        print('Record count: ${records.length}');
      } catch (e) {
        print('❌ Error: $e');
        fail('RPC function failed: $e');
      }
    });

    test('Test RPC function - Store perspective', () async {
      try {
        // Test with your actual store ID
        final response = await supabaseClient.rpc(
          'get_debt_control_data',
          params: {
            'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602', // Replace with your company ID
            'p_store_id': 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff', // Replace with your store ID
          },
        );

        expect(response, isNotNull);
        
        final data = response as Map<String, dynamic>;
        final metadata = data['metadata'] as Map<String, dynamic>;
        
        expect(metadata['perspective'], equals('store'));
        expect(metadata['store_id'], isNotNull);
        
        // Store perspective should have empty store_aggregates
        final storeAggregates = data['store_aggregates'] as List;
        expect(storeAggregates, isEmpty);
        
        print('✅ Store perspective test passed');
      } catch (e) {
        print('❌ Error: $e');
        fail('RPC function failed: $e');
      }
    });

    test('Test local filtering logic', () async {
      try {
        final response = await supabaseClient.rpc(
          'get_debt_control_data',
          params: {
            'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602',
            'p_store_id': null,
          },
        );

        final data = response as Map<String, dynamic>;
        final records = data['records'] as List;
        
        // Test local filtering
        final internalRecords = records.where((r) => r['is_internal'] == true).toList();
        final externalRecords = records.where((r) => r['is_internal'] == false).toList();
        
        print('Total records: ${records.length}');
        print('Internal records: ${internalRecords.length}');
        print('External records: ${externalRecords.length}');
        
        // Verify filtering works
        expect(internalRecords.length + externalRecords.length, equals(records.length));
        
        print('✅ Local filtering test passed');
      } catch (e) {
        print('❌ Error: $e');
        fail('Local filtering test failed: $e');
      }
    });

    test('Test performance - Cache behavior', () async {
      final stopwatch = Stopwatch()..start();
      
      // First call - should hit database
      await supabaseClient.rpc(
        'get_debt_control_data',
        params: {
          'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602',
          'p_store_id': null,
        },
      );
      
      final firstCallTime = stopwatch.elapsedMilliseconds;
      stopwatch.reset();
      
      // Second call - should be cached in repository (test in actual app)
      await supabaseClient.rpc(
        'get_debt_control_data',
        params: {
          'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602',
          'p_store_id': null,
        },
      );
      
      final secondCallTime = stopwatch.elapsedMilliseconds;
      
      print('First call: ${firstCallTime}ms');
      print('Second call: ${secondCallTime}ms');
      print('Note: Cache test works better in actual app, not in unit test');
      
      expect(firstCallTime, greaterThan(0));
      expect(secondCallTime, greaterThan(0));
      
      print('✅ Performance test completed');
    });
  });
}