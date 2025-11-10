/**
 * BalanceSheetRepositoryImpl
 * Implementation of IBalanceSheetRepository interface
 */

import {
  IBalanceSheetRepository,
  BalanceSheetResult,
} from '../../domain/repositories/IBalanceSheetRepository';
import { BalanceSheetData, BalanceSheetSection } from '../../domain/entities/BalanceSheetData';
import { BalanceSheetDataSource } from '../datasources/BalanceSheetDataSource';

export class BalanceSheetRepositoryImpl implements IBalanceSheetRepository {
  private dataSource: BalanceSheetDataSource;

  constructor() {
    this.dataSource = new BalanceSheetDataSource();
  }

  async getBalanceSheet(
    companyId: string,
    storeId: string | null,
    startDate: string | null,
    endDate: string | null
  ): Promise<BalanceSheetResult> {
    try {
      const response = await this.dataSource.getBalanceSheet(companyId, storeId, startDate, endDate);

      if (!response || !response.success) {
        return {
          success: false,
          error: 'No balance sheet data available',
        };
      }

      const data = response.data;
      const totals = data.totals;

      console.log('📊 Repository - Full response:', response);
      console.log('📊 Repository - Data:', data);
      console.log('📊 Repository - Totals:', totals);
      console.log('📊 Repository - Current Assets sample:', data.current_assets?.[0]);

      // Map sections from backup structure - use formatted_balance from server
      const currentAssets: BalanceSheetSection = {
        title: 'Current Assets',
        total: totals?.total_current_assets || 0,
        accounts: (data.current_assets || []).map((acc: any) => ({
          accountId: acc.account_id,
          accountName: acc.account_name,
          balance: acc.balance,
          formattedBalance: acc.formatted_balance || acc.balance.toLocaleString('en-US'),
        })),
      };

      const nonCurrentAssets: BalanceSheetSection = {
        title: 'Non-Current Assets',
        total: totals?.total_non_current_assets || 0,
        accounts: (data.non_current_assets || []).map((acc: any) => ({
          accountId: acc.account_id,
          accountName: acc.account_name,
          balance: acc.balance,
          formattedBalance: acc.formatted_balance || acc.balance.toLocaleString('en-US'),
        })),
      };

      const currentLiabilities: BalanceSheetSection = {
        title: 'Current Liabilities',
        total: totals?.total_current_liabilities || 0,
        accounts: (data.current_liabilities || []).map((acc: any) => ({
          accountId: acc.account_id,
          accountName: acc.account_name,
          balance: acc.balance,
          formattedBalance: acc.formatted_balance || acc.balance.toLocaleString('en-US'),
        })),
      };

      const nonCurrentLiabilities: BalanceSheetSection = {
        title: 'Non-Current Liabilities',
        total: totals?.total_non_current_liabilities || 0,
        accounts: (data.non_current_liabilities || []).map((acc: any) => ({
          accountId: acc.account_id,
          accountName: acc.account_name,
          balance: acc.balance,
          formattedBalance: acc.formatted_balance || acc.balance.toLocaleString('en-US'),
        })),
      };

      const equity: BalanceSheetSection = {
        title: 'Equity',
        total: totals?.total_equity || 0,
        accounts: (data.equity || []).map((acc: any) => ({
          accountId: acc.account_id,
          accountName: acc.account_name,
          balance: acc.balance,
          formattedBalance: acc.formatted_balance || acc.balance.toLocaleString('en-US'),
        })),
      };

      const comprehensiveIncome: BalanceSheetSection = {
        title: 'Other Comprehensive Income',
        total: 0, // This is included in equity total
        accounts: (data.comprehensive_income || []).map((acc: any) => ({
          accountId: acc.account_id,
          accountName: acc.account_name,
          balance: acc.balance,
          formattedBalance: acc.formatted_balance || acc.balance.toLocaleString('en-US'),
        })),
      };

      const balanceSheetData = new BalanceSheetData(
        totals?.total_assets || 0,
        totals?.total_liabilities || 0,
        totals?.total_equity || 0,
        totals?.total_liabilities_and_equity || 0,
        totals?.total_current_assets || 0,
        totals?.total_non_current_assets || 0,
        totals?.total_current_liabilities || 0,
        totals?.total_non_current_liabilities || 0,
        currentAssets,
        nonCurrentAssets,
        currentLiabilities,
        nonCurrentLiabilities,
        equity,
        comprehensiveIncome,
        response.company_info?.currency_symbol || '₩',
        endDate || new Date().toISOString().split('T')[0]
      );

      return {
        success: true,
        data: balanceSheetData,
      };
    } catch (error) {
      console.error('Repository error fetching balance sheet:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch balance sheet',
      };
    }
  }
}
