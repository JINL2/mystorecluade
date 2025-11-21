/**
 * InvoiceHeader Component Types
 */

export interface InvoiceHeaderProps {
  localSearchQuery: string;
  onSearchChange: (query: string) => void;
  selectedInvoicesCount: number;
  onRefund: () => void;
  onNewInvoice: () => void;
}
