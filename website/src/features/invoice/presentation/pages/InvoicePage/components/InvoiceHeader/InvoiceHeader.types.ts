/**
 * InvoiceHeader Component Types
 */

export interface InvoiceHeaderProps {
  localSearchQuery: string;
  onSearchChange: (query: string) => void;
  selectedInvoicesCount: number;
  hasSelectedCancelledInvoice: boolean;
  onRefund: () => void;
  onNewInvoice: () => void;
}
