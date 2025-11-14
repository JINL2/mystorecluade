/**
 * BalanceSheetModel
 * DTO and Mapper for Balance Sheet data
 * Converts server response (snake_case) to Domain Entity (camelCase)
 */

import {
  BalanceSheetData,
  BalanceSheetSection,
  BalanceSheetAccount,
} from '../../domain/entities/BalanceSheetData';

/**
 * Server Response Types
 */
interface ServerAccount {
  account_id: string;
  account_name: string;
  balance: number;
  formatted_balance?: string;
}

interface ServerTotals {
  total_assets: number;
  total_liabilities: number;
  total_equity: number;
  total_liabilities_and_equity: number;
  total_current_assets: number;
  total_non_current_assets: number;
  total_current_liabilities: number;
  total_non_current_liabilities: number;
}

interface ServerBalanceSheetData {
  success: boolean;
  data: {
    totals: ServerTotals;
    current_assets: ServerAccount[];
    non_current_assets: ServerAccount[];
    current_liabilities: ServerAccount[];
    non_current_liabilities: ServerAccount[];
    equity: ServerAccount[];
    comprehensive_income: ServerAccount[];
  };
  company_info?: {
    currency_symbol: string;
  };
}

export class BalanceSheetModel {
  /**
   * Convert server account to domain account
   */
  private static mapAccount(serverAccount: ServerAccount): BalanceSheetAccount {
    return {
      accountId: serverAccount.account_id,
      accountName: serverAccount.account_name,
      balance: serverAccount.balance,
      formattedBalance:
        serverAccount.formatted_balance ||
        serverAccount.balance.toLocaleString('en-US'),
    };
  }

  /**
   * Convert server accounts array to domain section
   */
  private static mapSection(
    title: string,
    total: number,
    accounts: ServerAccount[]
  ): BalanceSheetSection {
    return {
      title,
      total,
      accounts: (accounts || []).map((acc) => this.mapAccount(acc)),
    };
  }

  /**
   * Convert full server response to BalanceSheetData entity
   */
  static fromServerResponse(
    response: ServerBalanceSheetData,
    endDate: string | null
  ): BalanceSheetData {
    const data = response.data;
    const totals = data.totals;

    console.log('📊 Model - Mapping server response to entity');
    console.log('📊 Model - Totals:', totals);
    console.log('📊 Model - Current Assets sample:', data.current_assets?.[0]);

    // Map all sections
    const currentAssets = this.mapSection(
      'Current Assets',
      totals?.total_current_assets || 0,
      data.current_assets
    );

    const nonCurrentAssets = this.mapSection(
      'Non-Current Assets',
      totals?.total_non_current_assets || 0,
      data.non_current_assets
    );

    const currentLiabilities = this.mapSection(
      'Current Liabilities',
      totals?.total_current_liabilities || 0,
      data.current_liabilities
    );

    const nonCurrentLiabilities = this.mapSection(
      'Non-Current Liabilities',
      totals?.total_non_current_liabilities || 0,
      data.non_current_liabilities
    );

    const equity = this.mapSection(
      'Equity',
      totals?.total_equity || 0,
      data.equity
    );

    const comprehensiveIncome = this.mapSection(
      'Other Comprehensive Income',
      0, // This is included in equity total
      data.comprehensive_income
    );

    // Create and return entity
    return new BalanceSheetData(
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
  }

  /**
   * Validate server response structure
   */
  static isValidResponse(response: any): response is ServerBalanceSheetData {
    return (
      response &&
      typeof response === 'object' &&
      response.success === true &&
      response.data &&
      typeof response.data === 'object' &&
      response.data.totals &&
      typeof response.data.totals === 'object'
    );
  }
}
