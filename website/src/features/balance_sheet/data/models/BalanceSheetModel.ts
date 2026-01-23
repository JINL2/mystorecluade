/**
 * BalanceSheetModel
 * DTO and Mapper for Balance Sheet data
 * Converts server response (snake_case) to Domain Entity (camelCase)
 * Compatible with get_balance_sheet_v3 RPC
 */

import {
  BalanceSheetData,
  BalanceSheetSection,
  BalanceSheetAccount,
} from '../../domain/entities/BalanceSheetData';
import { BalanceSheetV3Row } from '../datasources/BalanceSheetDataSource';

/**
 * Section names from get_balance_sheet_v3
 */
const SECTION_NAMES = {
  CURRENT_ASSETS: 'Current Assets',
  NON_CURRENT_ASSETS: 'Non-Current Assets',
  CURRENT_LIABILITIES: 'Current Liabilities',
  NON_CURRENT_LIABILITIES: 'Non-Current Liabilities',
  EQUITY: 'Equity',
} as const;

export class BalanceSheetModel {
  /**
   * Convert V3 row to domain account
   */
  private static mapRowToAccount(row: BalanceSheetV3Row): BalanceSheetAccount {
    const balance = parseFloat(row.balance) || 0;
    return {
      accountId: row.account_code, // Use account_code as ID
      accountName: row.account_name,
      balance,
      formattedBalance: balance.toLocaleString('en-US', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      }),
    };
  }

  /**
   * Group rows by section and create BalanceSheetSection
   */
  private static createSection(
    title: string,
    rows: BalanceSheetV3Row[]
  ): BalanceSheetSection {
    const accounts = rows.map((row) => this.mapRowToAccount(row));
    const total = accounts.reduce((sum, acc) => sum + acc.balance, 0);

    return {
      title,
      total,
      accounts,
    };
  }

  /**
   * Convert V3 rows array to BalanceSheetData entity
   */
  static fromV3Response(
    rows: BalanceSheetV3Row[],
    currencySymbol: string = '₫',
    asOfDate?: string
  ): BalanceSheetData {
    // Group rows by section
    const grouped: Record<string, BalanceSheetV3Row[]> = {
      [SECTION_NAMES.CURRENT_ASSETS]: [],
      [SECTION_NAMES.NON_CURRENT_ASSETS]: [],
      [SECTION_NAMES.CURRENT_LIABILITIES]: [],
      [SECTION_NAMES.NON_CURRENT_LIABILITIES]: [],
      [SECTION_NAMES.EQUITY]: [],
    };

    rows.forEach((row) => {
      if (row.section && grouped[row.section]) {
        grouped[row.section].push(row);
      }
    });

    // Create sections
    const currentAssets = this.createSection(
      SECTION_NAMES.CURRENT_ASSETS,
      grouped[SECTION_NAMES.CURRENT_ASSETS]
    );
    const nonCurrentAssets = this.createSection(
      SECTION_NAMES.NON_CURRENT_ASSETS,
      grouped[SECTION_NAMES.NON_CURRENT_ASSETS]
    );
    const currentLiabilities = this.createSection(
      SECTION_NAMES.CURRENT_LIABILITIES,
      grouped[SECTION_NAMES.CURRENT_LIABILITIES]
    );
    const nonCurrentLiabilities = this.createSection(
      SECTION_NAMES.NON_CURRENT_LIABILITIES,
      grouped[SECTION_NAMES.NON_CURRENT_LIABILITIES]
    );
    const equity = this.createSection(
      SECTION_NAMES.EQUITY,
      grouped[SECTION_NAMES.EQUITY]
    );

    // Empty comprehensive income (v3 doesn't include it)
    const comprehensiveIncome: BalanceSheetSection = {
      title: 'Other Comprehensive Income',
      total: 0,
      accounts: [],
    };

    // Calculate totals
    const totalCurrentAssets = currentAssets.total;
    const totalNonCurrentAssets = nonCurrentAssets.total;
    const totalAssets = totalCurrentAssets + totalNonCurrentAssets;

    const totalCurrentLiabilities = currentLiabilities.total;
    const totalNonCurrentLiabilities = nonCurrentLiabilities.total;
    const totalLiabilities = totalCurrentLiabilities + totalNonCurrentLiabilities;

    const totalEquity = equity.total;
    const totalLiabilitiesAndEquity = totalLiabilities + totalEquity;

    return new BalanceSheetData(
      totalAssets,
      totalLiabilities,
      totalEquity,
      totalLiabilitiesAndEquity,
      totalCurrentAssets,
      totalNonCurrentAssets,
      totalCurrentLiabilities,
      totalNonCurrentLiabilities,
      currentAssets,
      nonCurrentAssets,
      currentLiabilities,
      nonCurrentLiabilities,
      equity,
      comprehensiveIncome,
      currencySymbol,
      asOfDate || new Date().toISOString().split('T')[0]
    );
  }

  /**
   * Validate V3 response (array of rows)
   */
  static isValidV3Response(response: unknown): response is BalanceSheetV3Row[] {
    return Array.isArray(response);
  }
}
