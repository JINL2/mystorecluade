/**
 * CurrencyValidator
 *
 * Defines validation rules for currency operations.
 * Following ARCHITECTURE.md pattern: validators define rules (static methods),
 * hooks execute validation.
 */

export interface ValidationResult {
  isValid: boolean;
  error?: string;
}

export class CurrencyValidator {
  /**
   * Validates exchange rate value
   * @param rate - Exchange rate to validate
   * @returns ValidationResult with isValid flag and error message if invalid
   */
  static validateExchangeRate(rate: string | number): ValidationResult {
    // Convert to number if string
    const numericRate = typeof rate === 'string' ? parseFloat(rate) : rate;

    // Check if valid number
    if (isNaN(numericRate)) {
      return {
        isValid: false,
        error: 'Please enter a valid exchange rate'
      };
    }

    // Check if positive
    if (numericRate <= 0) {
      return {
        isValid: false,
        error: 'Exchange rate must be greater than 0'
      };
    }

    // Check reasonable range (0.0001 to 1000000)
    if (numericRate < 0.0001 || numericRate > 1000000) {
      return {
        isValid: false,
        error: 'Exchange rate must be between 0.0001 and 1,000,000'
      };
    }

    return {
      isValid: true
    };
  }

  /**
   * Validates currency selection
   * @param currencyId - Currency ID to validate
   * @returns ValidationResult with isValid flag and error message if invalid
   */
  static validateCurrencyId(currencyId: string): ValidationResult {
    if (!currencyId || currencyId.trim() === '') {
      return {
        isValid: false,
        error: 'Please select a currency'
      };
    }

    return {
      isValid: true
    };
  }

  /**
   * Validates complete currency addition request
   * @param currencyId - Currency ID
   * @param exchangeRate - Exchange rate value
   * @returns ValidationResult with isValid flag and error message if invalid
   */
  static validateAddCurrency(currencyId: string, exchangeRate: string | number): ValidationResult {
    // Validate currency ID first
    const currencyIdResult = CurrencyValidator.validateCurrencyId(currencyId);
    if (!currencyIdResult.isValid) {
      return currencyIdResult;
    }

    // Then validate exchange rate
    return CurrencyValidator.validateExchangeRate(exchangeRate);
  }
}
