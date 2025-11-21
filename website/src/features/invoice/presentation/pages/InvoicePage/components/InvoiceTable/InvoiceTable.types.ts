/**
 * InvoiceTable Component Types
 */

import type { Invoice } from '../../../../domain/entities/Invoice';
import type { InvoiceDetail } from '../../../providers/states/types';

export interface InvoiceTableProps {
  invoices: Invoice[];
  selectedInvoices: Set<string>;
  expandedInvoiceId: string | null;
  invoiceDetail: InvoiceDetail | null;
  detailLoading: boolean;
  refunding: boolean;
  localSearchQuery: string;
  onToggleSelection: (invoiceId: string) => void;
  onSelectAll: () => void;
  onRowClick: (invoiceId: string) => void;
  onRefund: (invoiceId: string) => void;
}
