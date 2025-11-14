/**
 * AccountMappingValidator
 * Validation rules for account mapping operations
 *
 * Following Clean Architecture:
 * - Domain layer defines validation RULES (static methods)
 * - Presentation layer EXECUTES validation (in hooks)
 */

export interface ValidationError {
  field: string;
  message: string;
}

export class AccountMappingValidator {
  /**
   * Validate account selection
   */
  static validateAccountSelection(accountId: string | null | undefined): ValidationError | null {
    if (!accountId || accountId.trim() === '') {
      return {
        field: 'account',
        message: 'Account is required',
      };
    }
    return null;
  }

  /**
   * Validate company selection
   */
  static validateCompanySelection(companyId: string | null | undefined): ValidationError | null {
    if (!companyId || companyId.trim() === '') {
      return {
        field: 'company',
        message: 'Company is required',
      };
    }
    return null;
  }

  /**
   * Validate direction
   */
  static validateDirection(direction: string | null | undefined): ValidationError | null {
    if (!direction || direction.trim() === '') {
      return {
        field: 'direction',
        message: 'Direction is required',
      };
    }

    const validDirections = ['outgoing', 'incoming', 'both'];
    if (!validDirections.includes(direction)) {
      return {
        field: 'direction',
        message: `Direction must be one of: ${validDirections.join(', ')}`,
      };
    }

    return null;
  }

  /**
   * Validate user ID (creator)
   */
  static validateUserId(userId: string | null | undefined): ValidationError | null {
    if (!userId || userId.trim() === '') {
      return {
        field: 'user',
        message: 'User ID is required',
      };
    }
    return null;
  }

  /**
   * Validate account mapping creation data (composite validation)
   */
  static validateCreateMapping(data: {
    myCompanyId: string;
    counterpartyCompanyId: string;
    myAccountId: string;
    linkedAccountId: string;
    direction: string;
    createdBy: string;
  }): ValidationError[] {
    const errors: ValidationError[] = [];

    // Validate my company
    const myCompanyError = this.validateCompanySelection(data.myCompanyId);
    if (myCompanyError) errors.push(myCompanyError);

    // Validate counterparty company
    const counterpartyError = this.validateCompanySelection(data.counterpartyCompanyId);
    if (counterpartyError) {
      errors.push({
        field: 'counterpartyCompany',
        message: 'Counterparty company is required',
      });
    }

    // Validate my account
    const myAccountError = this.validateAccountSelection(data.myAccountId);
    if (myAccountError) {
      errors.push({
        field: 'myAccount',
        message: 'My account is required',
      });
    }

    // Validate linked account
    const linkedAccountError = this.validateAccountSelection(data.linkedAccountId);
    if (linkedAccountError) {
      errors.push({
        field: 'linkedAccount',
        message: 'Linked account is required',
      });
    }

    // Validate direction
    const directionError = this.validateDirection(data.direction);
    if (directionError) errors.push(directionError);

    // Validate creator
    const userError = this.validateUserId(data.createdBy);
    if (userError) errors.push(userError);

    // Business rule: Cannot map to same company
    if (data.myCompanyId === data.counterpartyCompanyId) {
      errors.push({
        field: 'counterpartyCompany',
        message: 'Cannot create mapping to the same company',
      });
    }

    return errors;
  }

  /**
   * Validate mapping deletion
   */
  static validateDeleteMapping(mappingId: string | null | undefined): ValidationError | null {
    if (!mappingId || mappingId.trim() === '') {
      return {
        field: 'mappingId',
        message: 'Mapping ID is required',
      };
    }
    return null;
  }

  /**
   * Check if mapping can be edited (business rule)
   */
  static canEdit(isReadOnly: boolean): { allowed: boolean; reason?: string } {
    if (isReadOnly) {
      return {
        allowed: false,
        reason: 'This mapping is read-only and cannot be edited',
      };
    }
    return { allowed: true };
  }

  /**
   * Check if mapping can be deleted (business rule)
   */
  static canDelete(isReadOnly: boolean): { allowed: boolean; reason?: string } {
    if (isReadOnly) {
      return {
        allowed: false,
        reason: 'This mapping is read-only and cannot be deleted',
      };
    }
    return { allowed: true };
  }
}
