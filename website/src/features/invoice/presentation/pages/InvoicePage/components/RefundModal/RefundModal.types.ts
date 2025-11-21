/**
 * RefundModal Component Types
 */

export interface RefundInvoiceInfo {
  invoiceNumber: string;
  amount: number;
  currencySymbol: string;
}

export interface RefundModalProps {
  isOpen: boolean;
  selectedInvoices: RefundInvoiceInfo[];
  onClose: () => void;
  onConfirm: (notes: string) => void;
  isRefunding?: boolean;
}
