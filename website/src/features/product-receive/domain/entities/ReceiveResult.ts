/**
 * ReceiveResult Entity
 * Represents the result of a product receive operation
 */

export interface ReceiveResult {
  success: boolean;
  receiptNumber?: string;
  message?: string;
  receivedCount?: number;
  warnings?: string[];
  error?: string;
}

export class ReceiveResultEntity implements ReceiveResult {
  success: boolean;
  receiptNumber?: string;
  message?: string;
  receivedCount?: number;
  warnings?: string[];
  error?: string;

  constructor(data: ReceiveResult) {
    this.success = data.success;
    this.receiptNumber = data.receiptNumber;
    this.message = data.message;
    this.receivedCount = data.receivedCount;
    this.warnings = data.warnings;
    this.error = data.error;
  }

  get hasWarnings(): boolean {
    return !!this.warnings && this.warnings.length > 0;
  }

  get displayMessage(): string {
    if (this.success) {
      return this.message || 'Products received successfully';
    }
    return this.error || 'Failed to receive products';
  }
}
