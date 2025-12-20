/**
 * BalanceSheetModel
 * DTO and Mapper for Balance Sheet data
 * Converts server response (snake_case) to Domain Entity (camelCase)
 * Compatible with get_balance_sheet_v2 RPC
 */

import {
  BalanceSheetData,
  BalanceSheetSection,
  BalanceSheetAccount,
} from '../../domain/entities/BalanceSheetData';

/**
 * Server Response Types (get_balance_sheet_v2)
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
  total_comprehensive_income?: number;
  net_income?: number;
  balance_check?: boolean;
  balance_difference?: number;
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
    currency_code?: string;
    company_name?: string;
    store_name?: string;
  };
  ui_data?: {
    balance_verification?: {
      is_balanced: boolean;
      difference: number;
    };
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
  static fromServerResponse(response: ServerBalanceSheetData): BalanceSheetData {
    const data = response.data;
    const totals = data.totals;

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
      totals?.total_comprehensive_income || 0,
      data.comprehensive_income
    );

    // Create and return entity (asOfDate is now today since we removed date filters)
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
      new Date().toISOString().split('T')[0]
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
