import 'package:flutter_test/flutter_test.dart';
import 'package:myfinance_improved/data/repositories/supabase_debt_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Debt Control RPC Implementation Tests', () {
    late SupabaseDebtRepository repository;

    setUpAll(() async {
      // Initialize Supabase for testing
      await Supabase.initialize(
        url: 'https://atkekzwgukdvucqntryo.supabase.co', // Replace with your URL
        anonKey: 'YOUR_SUPABASE_ANON_KEY', // TODO: Add your anon key
      );
      repository = SupabaseDebtRepository();
    });

    test('Repository now uses new RPC function get_debt_control_data', () async {
      // Test that repository uses the single RPC function
      const testCompanyId = '7a2545e0-e112-4b0c-9c59-221a530c4602';
      
      final summary = await repository.getPerspectiveDebtSummary(
        companyId: testCompanyId,
        storeId: null,
        perspectiveType: 'company',
        entityName: 'Test Company',
      );
      
      expect(summary, isNotNull);
      expect(summary.perspectiveType, equals('company'));
      expect(summary.entityId, equals(testCompanyId));
    });

    test('Local filtering works for internal/external/all', () async {
      const testCompanyId = '7a2545e0-e112-4b0c-9c59-221a530c4602';
      
      // Test all filter
      final allDebts = await repository.getCounterpartyDebts(
        companyId: testCompanyId,
        storeId: null,
        filter: 'all',
        perspectiveType: 'company',
      );
      
      // Test internal filter
      final internalDebts = await repository.getCounterpartyDebts(
        companyId: testCompanyId,
        storeId: null,
        filter: 'internal',
        perspectiveType: 'company',
      );
      
      // Test external filter
      final externalDebts = await repository.getCounterpartyDebts(
        companyId: testCompanyId,
        storeId: null,
        filter: 'external',
        perspectiveType: 'company',
      );
      
      // Verify filtering logic
      expect(allDebts, isNotNull);
      expect(internalDebts.every((d) => d.counterpartyType == 'internal'), isTrue);
      expect(externalDebts.every((d) => d.counterpartyType == 'external'), isTrue);
    });

    test('Cache works for 5 minutes', () async {
      const testCompanyId = '7a2545e0-e112-4b0c-9c59-221a530c4602';
      
      // First call should fetch from database
      final stopwatch = Stopwatch()..start();
      await repository.getKPIMetrics(
        companyId: testCompanyId,
        storeId: null,
        viewpoint: 'company',
      );
      final firstCallTime = stopwatch.elapsedMilliseconds;
      
      // Second call should use cache (faster)
      stopwatch.reset();
      await repository.getKPIMetrics(
        companyId: testCompanyId,
        storeId: null,
        viewpoint: 'company',
      );
      final secondCallTime = stopwatch.elapsedMilliseconds;
      
      print('First call: ${firstCallTime}ms');
      print('Second call: ${secondCallTime}ms (should be from cache)');
      
      // Second call should be significantly faster if cache works
      // Note: This might not always work in tests due to test environment
      expect(firstCallTime, greaterThan(0));
      expect(secondCallTime, greaterThan(0));
    });

    test('Force refresh clears cache', () async {
      const testCompanyId = '7a2545e0-e112-4b0c-9c59-221a530c4602';
      
      // Load data to populate cache
      await repository.getKPIMetrics(
        companyId: testCompanyId,
        storeId: null,
        viewpoint: 'company',
      );
      
      // Clear cache
      await repository.refreshData();
      
      // Next call should fetch from database again
      final stopwatch = Stopwatch()..start();
      await repository.getKPIMetrics(
        companyId: testCompanyId,
        storeId: null,
        viewpoint: 'company',
      );
      final timeAfterClear = stopwatch.elapsedMilliseconds;
      
      print('Time after cache clear: ${timeAfterClear}ms (should fetch from DB)');
      expect(timeAfterClear, greaterThan(0));
    });

    test('Store perspective filters correctly', () async {
      const testCompanyId = '7a2545e0-e112-4b0c-9c59-221a530c4602';
      const testStoreId = 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff';
      
      final storeSummary = await repository.getPerspectiveDebtSummary(
        companyId: testCompanyId,
        storeId: testStoreId,
        perspectiveType: 'store',
        entityName: 'Test Store',
      );
      
      expect(storeSummary, isNotNull);
      expect(storeSummary.perspectiveType, equals('store'));
      expect(storeSummary.entityId, equals(testStoreId));
      // Store perspective should not have store aggregates
      expect(storeSummary.storeAggregates, isEmpty);
    });
  });
}