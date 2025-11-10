/**
 * Formatters Utility
 * Pure utility functions for formatting numbers, dates, and currency
 */

/**
 * Format currency amount (number only, no symbol)
 */
export function formatCurrency(amount: number): string {
  return amount.toLocaleString('en-US', {
    minimumFractionDigits: 0,
    maximumFractionDigits: 2,
  });
}

/**
 * Format journal entry date for display
 */
export function formatJournalDate(date: string): string {
  return new Date(date).toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
}

/**
 * Format category tag for display
 */
export function formatCategoryTag(categoryTag: string | null): string {
  if (!categoryTag) return '';

  switch (categoryTag.toLowerCase()) {
    case 'fixedasset':
      return 'Fixed Asset';
    default:
      return categoryTag.charAt(0).toUpperCase() + categoryTag.slice(1);
  }
}

/**
 * Get cash location type badge color
 */
export function getCashLocationTypeColor(
  locationType: string | null
): { background: string; textColor: string } {
  if (!locationType) {
    return { background: 'rgba(0, 0, 0, 0.05)', textColor: 'var(--toss-gray-700)' };
  }

  switch (locationType.toLowerCase()) {
    case 'cash':
    case 'cash_register':
    case 'petty_cash':
    case 'safe':
      return { background: 'rgba(0, 200, 150, 0.15)', textColor: '#00C896' };
    case 'bank':
    case 'bank_account':
      return { background: 'rgba(0, 100, 255, 0.15)', textColor: '#0064FF' };
    case 'vault':
      return { background: 'rgba(155, 81, 224, 0.15)', textColor: '#9B51E0' };
    default:
      return { background: 'rgba(0, 0, 0, 0.05)', textColor: 'var(--toss-gray-700)' };
  }
}

/**
 * Maps currency codes to symbols following the backup implementation
 */
export function getCurrencySymbol(currencyCode: string): string {
  const symbols: Record<string, string> = {
    USD: '$',
    EUR: '€',
    GBP: '£',
    JPY: '¥',
    KRW: '₩',
    CNY: '¥',
    INR: '₹',
    AUD: 'A$',
    CAD: 'C$',
    CHF: 'Fr',
    HKD: 'HK$',
    SGD: 'S$',
    SEK: 'kr',
    NOK: 'kr',
    DKK: 'kr',
    NZD: 'NZ$',
    MXN: 'Mex$',
    TRY: '₺',
    RUB: '₽',
    BRL: 'R$',
    ZAR: 'R',
  };

  return symbols[currencyCode] || currencyCode + ' ';
}
