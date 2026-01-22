/**
 * GetBalanceSummaryUseCase
 * Business logic for fetching balance summary
 */

import type { ICashEndingRepository } from '../repositories/ICashEndingRepository';
import type { BalanceSummaryEntity } from '../entities/BalanceSummary';

export interface GetBalanceSummaryParams {
  locationId: string;
}

export class GetBalanceSummaryUseCase {
  constructor(private readonly repository: ICashEndingRepository) {}

  async execute(params: GetBalanceSummaryParams): Promise<BalanceSummaryEntity | null> {
    const { locationId } = params;

    if (!locationId) {
      return null;
    }

    return this.repository.getBalanceSummary(locationId);
  }
}
