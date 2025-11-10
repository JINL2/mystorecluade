/**
 * InvoiceRepositoryImpl
 * Implementation of IInvoiceRepository interface
 */

import {
  IInvoiceRepository,
  InvoiceResult,
  InvoiceDetailResult,
  RefundResult,
} from '../../domain/repositories/IInvoiceRepository';
import { Invoice } from '../../domain/entities/Invoice';
import { InvoiceDataSource } from '../datasources/InvoiceDataSource';

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

      const currency = response.data.currency;

      const invoices = response.data.invoices.map((item: any) => {
        const customerName = item.customer?.name || 'Walk-in';
        const customerPhone = item.customer?.phone || null;
        const itemCount = item.items_summary?.item_count || 0;
        const totalQuantity = item.items_summary?.total_quantity || 0;
        const totalAmount = item.amounts?.total_amount || 0;
        const currencySymbol = currency?.symbol || item.amounts?.currency_symbol || item.store?.currency_symbol || '';
        const paymentMethod = item.payment?.method || 'cash';
        const paymentStatus = item.payment?.status || 'pending';
        const invoiceDate = item.invoice_date || item.sale_date;

        return new Invoice(
          item.invoice_id,
          item.invoice_number,
          invoiceDate,
          customerName,
          customerPhone,
          itemCount,
          totalQuantity,
          totalAmount,
          item.status,
          currencySymbol,
          paymentMethod,
          paymentStatus
        );
      });

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
}
