/**
 * InvoiceRepositoryImpl
 * Implementation of IInvoiceRepository interface
 */

import {
  IInvoiceRepository,
  InvoiceResult,
  InvoiceDetailResult,
  RefundResult,
  BulkRefundResult,
} from '../../domain/repositories/IInvoiceRepository';
import { InvoiceDataSource } from '../datasources/InvoiceDataSource';
import { InvoiceModel } from '../models/InvoiceModel';

export class InvoiceRepositoryImpl implements IInvoiceRepository {
  private dataSource: InvoiceDataSource;

  constructor() {
    this.dataSource = new InvoiceDataSource();
  }

  async getInvoices(
    companyId: string,
    storeId: string | null,
    page: number,
    limit: number,
    search: string | null,
    startDate: string,
    endDate: string
  ): Promise<InvoiceResult> {
    try {
      const response = await this.dataSource.getInvoices(
        companyId,
        storeId,
        page,
        limit,
        search,
        startDate,
        endDate
      );

      if (!response.success || !response.data) {
        return {
          success: false,
          error: response.error || 'Failed to fetch invoices',
        };
      }

      const currencySymbol = response.data.currency?.symbol;
      const invoices = InvoiceModel.fromJsonArray(response.data.invoices, currencySymbol);

      return {
        success: true,
        data: invoices,
        pagination: response.data.pagination,
      };
    } catch (error) {
      console.error('❌ Repository error fetching invoices:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch invoices',
      };
    }
  }

  async getInvoiceDetail(invoiceId: string): Promise<InvoiceDetailResult> {
    try {
      const response = await this.dataSource.getInvoiceDetail(invoiceId);

      if (!response.success || !response.data) {
        return {
          success: false,
          error: response.error || 'Failed to fetch invoice detail',
        };
      }

      return {
        success: true,
        data: response.data,
        message: response.message,
      };
    } catch (error) {
      console.error('❌ Repository error fetching invoice detail:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch invoice detail',
      };
    }
  }

  async refundInvoice(invoiceId: string, refundReason?: string, createdBy?: string): Promise<RefundResult> {
    try {
      const response = await this.dataSource.refundInvoice(invoiceId, refundReason, createdBy);

      if (!response.success) {
        return {
          success: false,
          error: response.error || 'Failed to refund invoice',
        };
      }

      return {
        success: true,
        message: response.message || 'Invoice refunded successfully',
      };
    } catch (error) {
      console.error('❌ Repository error refunding invoice:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to refund invoice',
      };
    }
  }

  async refundInvoices(invoiceIds: string[], notes: string, createdBy: string): Promise<BulkRefundResult> {
    try {
      const response = await this.dataSource.refundInvoices(invoiceIds, notes, createdBy);

      return {
        success: true,
        data: response,
      };
    } catch (error) {
      console.error('❌ Repository error refunding invoices:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to refund invoices',
      };
    }
  }
}
