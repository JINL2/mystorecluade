/**
 * useCashEndingSorting Hook
 * Custom hook for sorting cash endings by location type and name
 */

import { useMemo } from 'react';
import type { CashEnding } from '../../domain/entities/CashEnding';

type LocationType = 'cash' | 'bank' | 'vault';

const getLocationType = (locationName: string): LocationType => {
  const name = locationName.toLowerCase();
  if (name.includes('bank')) return 'bank';
  if (name.includes('vault')) return 'vault';
  return 'cash';
};

export const useCashEndingSorting = (cashEndings: CashEnding[]): CashEnding[] => {
  return useMemo(() => {
    const typeOrder: Record<LocationType, number> = {
      cash: 1,
      bank: 2,
      vault: 3,
    };

    return [...cashEndings].sort((a, b) => {
      const aType = getLocationType(a.locationName);
      const bType = getLocationType(b.locationName);

      const aTypePriority = typeOrder[aType] || 999;
      const bTypePriority = typeOrder[bType] || 999;

      if (aTypePriority !== bTypePriority) {
        return aTypePriority - bTypePriority;
      }

      return a.locationName.localeCompare(b.locationName);
    });
  }, [cashEndings]);
};
