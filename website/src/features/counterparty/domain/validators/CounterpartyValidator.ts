/**
 * CounterpartyValidator
 * Domain validation rules for Counterparty entities
 */

import { CounterpartyTypeValue } from '../entities/Counterparty';

export interface ValidationError {
  field: string;
  message: string;
}

/**
 * Counterparty validation rules
 * Static methods only - no state
 */
export class CounterpartyValidator {
  private static readonly VALID_TYPES: CounterpartyTypeValue[] = [
    'My Company',
    'Team Member',
    'Suppliers',
    'Employees',
    'Customers',
    'Others',
  ];

  private static readonly MAX_NAME_LENGTH = 255;
  private static readonly MAX_EMAIL_LENGTH = 255;
  private static readonly MAX_PHONE_LENGTH = 50;
  private static readonly MAX_NOTES_LENGTH = 1000;

  /**
   * Validate counterparty name
   */
  static validateName(name: string): ValidationError | null {
    if (!name || !name.trim()) {
      return { field: 'name', message: 'Name is required' };
    }

    if (name.trim().length < 2) {
      return { field: 'name', message: 'Name must be at least 2 characters' };
    }

    if (name.length > this.MAX_NAME_LENGTH) {
      return { field: 'name', message: `Name must be less than ${this.MAX_NAME_LENGTH} characters` };
    }

    return null;
  }

  /**
   * Validate counterparty type
   */
  static validateType(type: string): ValidationError | null {
    if (!type || !type.trim()) {
      return { field: 'type', message: 'Type is required' };
    }

    if (!this.VALID_TYPES.includes(type as CounterpartyTypeValue)) {
      return { field: 'type', message: 'Invalid counterparty type' };
    }

    return null;
  }

  /**
   * Validate email (optional field)
   */
  static validateEmail(email: string | null): ValidationError | null {
    if (!email || !email.trim()) {
      return null; // Email is optional
    }

    if (email.length > this.MAX_EMAIL_LENGTH) {
      return { field: 'email', message: `Email must be less than ${this.MAX_EMAIL_LENGTH} characters` };
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return { field: 'email', message: 'Invalid email format' };
    }

    return null;
  }

  /**
   * Validate phone (optional field)
   */
  static validatePhone(phone: string | null): ValidationError | null {
    if (!phone || !phone.trim()) {
      return null; // Phone is optional
    }

    if (phone.length > this.MAX_PHONE_LENGTH) {
      return { field: 'phone', message: `Phone must be less than ${this.MAX_PHONE_LENGTH} characters` };
    }

    // Allow digits, spaces, hyphens, parentheses, and plus sign
    const phoneRegex = /^[\d\s\-()+ ]+$/;
    if (!phoneRegex.test(phone)) {
      return { field: 'phone', message: 'Invalid phone format' };
    }

    return null;
  }

  /**
   * Validate notes (optional field)
   */
  static validateNotes(notes: string | null): ValidationError | null {
    if (!notes || !notes.trim()) {
      return null; // Notes are optional
    }

    if (notes.length > this.MAX_NOTES_LENGTH) {
      return { field: 'notes', message: `Notes must be less than ${this.MAX_NOTES_LENGTH} characters` };
    }

    return null;
  }

  /**
   * Validate linked company ID for internal organizations
   */
  static validateLinkedCompany(
    isInternal: boolean,
    linkedCompanyId: string | null
  ): ValidationError | null {
    if (isInternal && !linkedCompanyId) {
      return {
        field: 'linkedCompanyId',
        message: 'Linked company is required for internal organizations',
      };
    }

    if (!isInternal && linkedCompanyId) {
      return {
        field: 'linkedCompanyId',
        message: 'Linked company should only be set for internal organizations',
      };
    }

    return null;
  }

  /**
   * Validate all fields for counterparty creation
   * Returns array of validation errors (empty if valid)
   */
  static validateCreate(data: {
    name: string;
    type: CounterpartyTypeValue | '';
    isInternal: boolean;
    linkedCompanyId: string | null;
    email?: string | null;
    phone?: string | null;
    notes?: string | null;
  }): ValidationError[] {
    const errors: ValidationError[] = [];

    // Required fields
    const nameError = this.validateName(data.name);
    if (nameError) errors.push(nameError);

    const typeError = this.validateType(data.type);
    if (typeError) errors.push(typeError);

    const linkedCompanyError = this.validateLinkedCompany(data.isInternal, data.linkedCompanyId);
    if (linkedCompanyError) errors.push(linkedCompanyError);

    // Optional fields
    const emailError = this.validateEmail(data.email || null);
    if (emailError) errors.push(emailError);

    const phoneError = this.validatePhone(data.phone || null);
    if (phoneError) errors.push(phoneError);

    const notesError = this.validateNotes(data.notes || null);
    if (notesError) errors.push(notesError);

    return errors;
  }

  /**
   * Check if form data is valid
   * Quick validation method that returns boolean
   */
  static isValidCreate(data: {
    name: string;
    type: CounterpartyTypeValue | '';
    isInternal: boolean;
    linkedCompanyId: string | null;
  }): boolean {
    const errors = this.validateCreate(data);
    return errors.length === 0;
  }
}
