/**
 * CreateErrorAdjustmentUseCase
 * Business logic for creating error adjustment journal entries
 */

import type { IJournalRepository, JournalLine } from '../repositories/IJournalRepository';

export interface CreateErrorAdjustmentParams {
  differenceAmount: number;
  companyId: string;
  userId: string;
  locationName: string;
  cashLocationId: string;
  storeId: string;
}

export class CreateErrorAdjustmentUseCase {
  constructor(private readonly repository: IJournalRepository) {}

  async execute(params: CreateErrorAdjustmentParams): Promise<{ success: boolean; error?: string }> {
    const { differenceAmount, companyId, userId, locationName, cashLocationId, storeId } = params;

    // Validation
    if (Math.abs(differenceAmount) < 0.01) {
      return { success: false, error: 'No difference to adjust' };
    }

    // Calculate amounts
    const absAmount = Math.abs(differenceAmount);
    const isPositiveDifference = differenceAmount > 0;

    // Create journal lines
    const lines: JournalLine[] = [
      {
        account_id: this.repository.accountIds.cash,
        description: 'Make error',
        debit: isPositiveDifference ? absAmount : 0,
        credit: isPositiveDifference ? 0 : absAmount,
        cash: { cash_location_id: cashLocationId },
      },
      {
        account_id: this.repository.accountIds.errorAdjustment,
        description: 'Make error',
        debit: isPositiveDifference ? 0 : absAmount,
        credit: isPositiveDifference ? absAmount : 0,
      },
    ];

    // Get current date in UTC format
    const now = new Date();
    const entryDateUtc = now.toISOString().replace('T', ' ').substring(0, 19);

    return this.repository.insertJournalWithEverything({
      baseAmount: absAmount,
      companyId,
      createdBy: userId,
      description: `Make Error - ${locationName}`,
      entryDateUtc,
      lines,
      storeId,
    });
  }
}
