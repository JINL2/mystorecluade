/**
 * CashEndingDifferenceItem Component Types
 */

export interface CashEndingDifferenceItemProps {
  cashEndingId: string;
  locationName: string;
  difference: number;
  formatCurrency: (amount: number) => string;
  onMakeError: () => void;
  onExchangeTranslation: () => void;
}
