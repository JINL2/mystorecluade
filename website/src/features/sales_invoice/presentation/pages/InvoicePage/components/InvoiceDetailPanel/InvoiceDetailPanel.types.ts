/**
 * InvoiceDetailPanel Component Types
 */

import type { Invoice } from '../../../../domain/entities/Invoice';
import type { InvoiceDetail } from '../../../providers/states/types';

export interface InvoiceDetailPanelProps {
  invoice: Invoice;
  invoiceDetail: InvoiceDetail | null;
  detailLoading: boolean;
  refunding: boolean;
  onRefund: (invoiceId: string) => void;
}
