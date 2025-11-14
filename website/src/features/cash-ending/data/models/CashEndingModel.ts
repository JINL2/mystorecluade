/**
 * CashEndingModel
 * DTO mapping for cash ending data
 */

import { CashEnding } from '../../domain/entities/CashEnding';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export interface CashLocationDTO {
  cash_location_id: string;
  store_id: string | null;
  location_name: string;
  location_type: string;
}

export interface BalanceDTO {
  cash_location_id: string;
  balance_amount: number;
}

export interface ActualDTO {
  cash_location_id: string;
  actual_amount: number;
}

export interface CashEndingDTO {
  cash_ending_id: string;
  location_id: string;
  location_name: string;
  store_id: string | null;
  date: string;
  opening_balance: number;
  total_inflow: number;
  total_outflow: number;
  expected_balance: number;
  actual_balance: number;
  difference: number;
  status: 'pending' | 'completed' | 'verified';
  currency_symbol: string;
}

export class CashEndingModel {
  /**
   * Map location, balance, and actual data to CashEnding entity
   */
  static fromLocation(
    location: CashLocationDTO,
    balance: BalanceDTO | undefined,
    actual: ActualDTO | undefined
  ): CashEnding {
    const balanceAmount = balance?.balance_amount || 0;
    const actualAmount = actual?.actual_amount || 0;
    const difference = actualAmount - balanceAmount;

    // Determine status based on actual data presence
    const status: 'pending' | 'completed' | 'verified' = actual
      ? 'completed'
      : 'pending';

    return new CashEnding(
      location.cash_location_id,
      location.cash_location_id,
      location.location_name,
      location.store_id,
      DateTimeUtils.toDateOnly(new Date()), // Current date in local timezone
      0, // opening_balance - currently not tracked
      balanceAmount, // total_inflow (using balance as inflow)
      0, // total_outflow - currently not tracked
      balanceAmount, // expected_balance
      actualAmount, // actual_balance
      difference, // difference
      status,
      '₩' // Default currency symbol (KRW)
    );
  }

  /**
   * Map from database RPC result to CashEnding entity
   */
  static fromRpcResult(data: any): CashEnding {
    // If date comes from DB (UTC), convert to local date-only string
    const dateValue = data.date
      ? DateTimeUtils.toDateOnly(DateTimeUtils.toLocal(data.date))
      : DateTimeUtils.toDateOnly(new Date());

    return new CashEnding(
      data.cash_ending_id || data.cash_location_id,
      data.location_id || data.cash_location_id,
      data.location_name,
      data.store_id,
      dateValue,
      data.opening_balance || 0,
      data.total_inflow || 0,
      data.total_outflow || 0,
      data.expected_balance || 0,
      data.actual_balance || 0,
      data.difference || 0,
      data.status || 'pending',
      data.currency_symbol || '₩'
    );
  }

  /**
   * Map CashEnding entity to DTO for API requests
   */
  static toDto(cashEnding: CashEnding): CashEndingDTO {
    return {
      cash_ending_id: cashEnding.cashEndingId,
      location_id: cashEnding.locationId,
      location_name: cashEnding.locationName,
      store_id: cashEnding.storeId,
      date: cashEnding.date,
      opening_balance: cashEnding.openingBalance,
      total_inflow: cashEnding.totalInflow,
      total_outflow: cashEnding.totalOutflow,
      expected_balance: cashEnding.expectedBalance,
      actual_balance: cashEnding.actualBalance,
      difference: cashEnding.difference,
      status: cashEnding.status,
      currency_symbol: cashEnding.currencySymbol,
    };
  }

  /**
   * Map array of locations with balance/actual data to CashEnding entities
   */
  static fromLocationList(
    locations: CashLocationDTO[],
    balances: BalanceDTO[],
    actuals: ActualDTO[]
  ): CashEnding[] {
    return locations.map((location) => {
      const balance = balances.find(
        (b) => b.cash_location_id === location.cash_location_id
      );
      const actual = actuals.find(
        (a) => a.cash_location_id === location.cash_location_id
      );

      return this.fromLocation(location, balance, actual);
    });
  }

  /**
   * Parse balance/actual response from RPC
   * Handles both wrapped and direct response formats
   */
  static parseBalanceActualResponse(response: any): {
    balance: BalanceDTO[];
    actual: ActualDTO[];
  } {
    let balance: BalanceDTO[] = [];
    let actual: ActualDTO[] = [];

    if (!response) {
      return { balance, actual };
    }

    // Handle wrapped response format
    if (response.success && response.data) {
      balance = response.data.balance || [];
      actual = response.data.actual || [];
    }
    // Handle direct response format
    else if (response.balance || response.actual) {
      balance = response.balance || [];
      actual = response.actual || [];
    }

    return { balance, actual };
  }

  /**
   * Create a new CashEnding entity with default values
   */
  static create(data: Partial<CashEndingDTO>): CashEnding {
    return new CashEnding(
      data.cash_ending_id || '',
      data.location_id || '',
      data.location_name || '',
      data.store_id || null,
      data.date || DateTimeUtils.toDateOnly(new Date()),
      data.opening_balance || 0,
      data.total_inflow || 0,
      data.total_outflow || 0,
      data.expected_balance || 0,
      data.actual_balance || 0,
      data.difference || 0,
      data.status || 'pending',
      data.currency_symbol || '₩'
    );
  }
}
