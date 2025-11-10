/**
 * CashEndingRepositoryImpl
 * Implementation of ICashEndingRepository interface
 */

import {
  ICashEndingRepository,
  CashEndingResult,
} from '../../domain/repositories/ICashEndingRepository';
import { CashEnding } from '../../domain/entities/CashEnding';
import { CashEndingDataSource } from '../datasources/CashEndingDataSource';

export class CashEndingRepositoryImpl implements ICashEndingRepository {
  private dataSource: CashEndingDataSource;

  constructor() {
    this.dataSource = new CashEndingDataSource();
  }

  async getCashEndings(
    companyId: string,
    storeId: string | null
  ): Promise<CashEndingResult> {
    try {
      // Load cash locations and balance/actual amounts
      const locations = await this.dataSource.getCashLocations(companyId);
      const balanceData = await this.dataSource.getBalanceAndActualAmounts(companyId, storeId);

      console.log('Cash locations:', locations);
      console.log('Balance data:', balanceData);

      // Handle response format - could be direct or wrapped
      let balance = [];
      let actual = [];

      if (balanceData) {
        if (balanceData.success && balanceData.data) {
          balance = balanceData.data.balance || [];
          actual = balanceData.data.actual || [];
        } else if (balanceData.balance || balanceData.actual) {
          balance = balanceData.balance || [];
          actual = balanceData.actual || [];
        }
      }

      // Combine location, balance, and actual data into CashEnding entities
      const cashEndings = locations.map((location: any) => {
        const balanceItem = balance.find((b: any) => b.cash_location_id === location.cash_location_id);
        const actualItem = actual.find((a: any) => a.cash_location_id === location.cash_location_id);

        const balanceAmount = balanceItem?.balance_amount || 0;
        const actualAmount = actualItem?.actual_amount || 0;
        const difference = actualAmount - balanceAmount;

        return new CashEnding(
          location.cash_location_id,
          location.cash_location_id,
          location.location_name,
          location.store_id,
          new Date().toISOString().split('T')[0],
          0, // opening_balance
          balanceAmount, // total_inflow (using balance as inflow)
          0, // total_outflow
          balanceAmount, // expected_balance
          actualAmount, // actual_balance
          difference, // difference
          actualItem ? 'completed' : 'pending',
          '₩'
        );
      });

      return {
        success: true,
        data: cashEndings,
      };
    } catch (error) {
      console.error('Repository error fetching cash endings:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch cash endings',
      };
    }
  }
}
