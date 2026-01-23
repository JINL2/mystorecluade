/**
 * InvoiceValidator
 * Validation rules for invoice operations
 */

import { Invoice } from '../entities/Invoice';

export interface ValidationError {
  field: string;
  message: string;
}

export class InvoiceValidator {
  /**
   * Validate if invoice can be refunded
   */
  static validateRefund(invoice: Invoice): ValidationError | null {
    if (invoice.status !== 'paid' && invoice.status !== 'issued') {
      return {
        field: 'status',
        message: `Only paid or issued invoices can be refunded. Current status: ${invoice.status}`,
      };
    }

    if (invoice.totalAmount <= 0) {
      return {
        field: 'totalAmount',
        message: 'Cannot refund invoice with zero or negative amount',
      };
    }

    return null;
  }

  /**
   * Validate invoice date
   */
  static validateInvoiceDate(date: string): ValidationError | null {
    if (!date || date.trim() === '') {
      return {
        field: 'invoiceDate',
        message: 'Invoice date is required',
      };
    }

    try {
      const invoiceDate = new Date(date);
      const now = new Date();

      if (isNaN(invoiceDate.getTime())) {
        return {
          field: 'invoiceDate',
          message: 'Invalid date format',
        };
      }

      if (invoiceDate > now) {
        return {
          field: 'invoiceDate',
          message: 'Invoice date cannot be in the future',
        };
      }

      // Check if date is not older than 10 years
      const tenYearsAgo = new Date();
      tenYearsAgo.setFullYear(tenYearsAgo.getFullYear() - 10);

      if (invoiceDate < tenYearsAgo) {
        return {
          field: 'invoiceDate',
          message: 'Invoice date cannot be older than 10 years',
        };
      }
    } catch (error) {
      return {
        field: 'invoiceDate',
        message: 'Invalid date format',
      };
    }

    return null;
  }

  /**
   * Validate invoice number format
   */
  static validateInvoiceNumber(invoiceNumber: string): ValidationError | null {
    if (!invoiceNumber || invoiceNumber.trim() === '') {
      return {
        field: 'invoiceNumber',
        message: 'Invoice number is required',
      };
    }

    if (invoiceNumber.length < 3) {
      return {
        field: 'invoiceNumber',
        message: 'Invoice number must be at least 3 characters',
      };
    }

    if (invoiceNumber.length > 50) {
      return {
        field: 'invoiceNumber',
        message: 'Invoice number must not exceed 50 characters',
      };
    }

    return null;
  }

  /**
   * Validate customer name
   */
  static validateCustomerName(customerName: string): ValidationError | null {
    if (!customerName || customerName.trim() === '') {
      return {
        field: 'customerName',
        message: 'Customer name is required',
      };
    }

    if (customerName.length > 100) {
      return {
        field: 'customerName',
        message: 'Customer name must not exceed 100 characters',
      };
    }

    return null;
  }

  /**
   * Validate total amount
   */
  static validateTotalAmount(amount: number): ValidationError | null {
    if (amount < 0) {
      return {
        field: 'totalAmount',
        message: 'Total amount cannot be negative',
      };
    }

    if (amount === 0) {
      return {
        field: 'totalAmount',
        message: 'Total amount must be greater than zero',
      };
    }

    // Check for reasonable maximum (e.g., 1 billion)
    if (amount > 1000000000) {
      return {
        field: 'totalAmount',
        message: 'Total amount exceeds maximum allowed value',
      };
    }

    return null;
  }

  /**
   * Validate payment method
   */
  static validatePaymentMethod(method: string): ValidationError | null {
    const validMethods = ['cash', 'card', 'bank', 'transfer', 'bank_transfer'];

    if (!method || method.trim() === '') {
      return {
        field: 'paymentMethod',
        message: 'Payment method is required',
      };
    }

    if (!validMethods.includes(method.toLowerCase())) {
      return {
        field: 'paymentMethod',
        message: `Invalid payment method. Must be one of: ${validMethods.join(', ')}`,
      };
    }

    return null;
  }

  /**
   * Validate complete invoice data
   */
  static validateInvoice(invoice: Invoice): ValidationError[] {
    const errors: ValidationError[] = [];

    const dateError = this.validateInvoiceDate(invoice.invoiceDate);
    if (dateError) errors.push(dateError);

    const numberError = this.validateInvoiceNumber(invoice.invoiceNumber);
    if (numberError) errors.push(numberError);

    const customerError = this.validateCustomerName(invoice.customerName);
    if (customerError) errors.push(customerError);

    const amountError = this.validateTotalAmount(invoice.totalAmount);
    if (amountError) errors.push(amountError);

    const paymentError = this.validatePaymentMethod(invoice.paymentMethod);
    if (paymentError) errors.push(paymentError);

    return errors;
  }
}
