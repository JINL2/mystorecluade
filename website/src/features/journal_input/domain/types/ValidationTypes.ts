/**
 * ValidationTypes
 * Common validation-related types for the journal-input domain
 */

/**
 * Represents a validation error for a specific field
 */
export interface ValidationError {
  field: string;
  message: string;
}

/**
 * Result of a validation operation
 */
export interface ValidationResult {
  isValid: boolean;
  errors: ValidationError[];
}
