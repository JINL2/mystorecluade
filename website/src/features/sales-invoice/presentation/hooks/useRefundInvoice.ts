/**
 * useRefundInvoice Hook
 * Custom hook for handling invoice refund operations with journal entry creation
 */

import { Invoice } from '../../domain/entities/Invoice';
import { InvoiceDataSource } from '../../data/datasources/InvoiceDataSource';

interface RefundInvoiceParams {
  invoiceIds: string[];
  notes: string;
  companyId: string;
  userId: string;
  invoices: Invoice[];
}

interface RefundResult {
  success: boolean;
  totalSucceeded: number;
  totalFailed: number;
  totalAmountRefunded: number;
  journalSuccessCount: number;
  journalFailCount: number;
  error?: string;
}

export const useRefundInvoice = (refundInvoices: (invoiceIds: string[], notes: string, createdBy: string) => Promise<any>) => {

  /**
   * Refund invoices and create journal entries
   */
  const refundInvoicesWithJournal = async (
    params: RefundInvoiceParams
  ): Promise<RefundResult> => {
    const { invoiceIds, notes, companyId, userId, invoices } = params;

    // Call refund RPC
    const result = await refundInvoices(invoiceIds, notes, userId);

    if (!result.success || !result.data) {
      return {
        success: false,
        totalSucceeded: 0,
        totalFailed: invoiceIds.length,
        totalAmountRefunded: 0,
        journalSuccessCount: 0,
        journalFailCount: 0,
        error: result.error || 'Failed to refund invoices',
      };
    }

    const { total_succeeded, total_failed, total_amount_refunded, results } = result.data;

    console.log('🔵 Starting journal entry creation for results:', results);

    // Create journal entries for each successfully refunded invoice
    const dataSource = new InvoiceDataSource();
    let journalSuccessCount = 0;
    let journalFailCount = 0;

    for (const refundResult of results) {
      console.log('🔵 Processing refund result:', refundResult);

      if (refundResult.success) {
        // Get the invoice to access its storeId and amount
        const invoice = invoices.find((inv) => inv.invoiceId === refundResult.invoice_id);
        console.log('🔵 Found invoice for journal entry:', invoice);

        if (invoice) {
          // Use invoice totalAmount since refundResult doesn't have amount_refunded
          const refundAmount = refundResult.amount_refunded || invoice.totalAmount;

          console.log('🔵 Calling insertRefundJournalEntry with params:', {
            companyId: companyId,
            storeId: invoice.storeId,
            createdBy: userId,
            invoiceNumber: refundResult.invoice_number,
            refundAmount: refundAmount,
            totalCost: invoice.totalCost,
            cashLocationId: invoice.cashLocationId,
          });

          const journalResult = await dataSource.insertRefundJournalEntry({
            companyId: companyId,
            storeId: invoice.storeId,
            createdBy: userId,
            invoiceNumber: refundResult.invoice_number,
            refundAmount: refundAmount,
            totalCost: invoice.totalCost,
            cashLocationId: invoice.cashLocationId,
          });

          if (journalResult.success) {
            journalSuccessCount++;
            console.log(`✅ Journal entry created for invoice ${refundResult.invoice_number}`);
          } else {
            journalFailCount++;
            console.error(
              `❌ Failed to create journal entry for invoice ${refundResult.invoice_number}:`,
              journalResult.error
            );
          }
        } else {
          console.error('❌ Invoice not found for refund result:', refundResult);
        }
      } else {
        console.log('🔴 Skipping refund result (not successful):', refundResult);
      }
    }

    console.log(
      '🔵 Journal entry creation complete. Success:',
      journalSuccessCount,
      'Failed:',
      journalFailCount
    );

    // Note: Caller is responsible for refreshing the invoice list

    return {
      success: total_failed === 0 && journalFailCount === 0,
      totalSucceeded: total_succeeded,
      totalFailed: total_failed,
      totalAmountRefunded: total_amount_refunded,
      journalSuccessCount,
      journalFailCount,
    };
  };

  return {
    refundInvoicesWithJournal,
  };
};
