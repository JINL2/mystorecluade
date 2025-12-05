/**
 * InvoiceTable Component Types
 */

import type { Invoice } from '../../../../../domain/entities/Invoice';

export interface InvoiceDetailData {
  invoice: {
    invoice_id: string;
    invoice_number: string;
    sale_date: string;
    status: string;
    store_id: string;
    store_name: string;
    store_code: string;
    company_id: string;
    customer_id: string | null;
    customer_name: string | null;
    created_at: string;
  };
  items: Array<{
    item_id: string;
    product_id: string;
    product_name: string;
    sku: string;
    quantity_sold: number;
    unit_price: number;
    unit_cost: number;
    discount_amount: number;
    total_amount: number;
  }>;
  amounts: {
    subtotal: number;
    tax_amount: number;
    discount_amount: number;
    total_amount: number;
  };
  payment: {
    method: string;
    status: string;
  };
}

export interface InvoiceTableProps {
  invoices: Invoice[];
  selectedInvoices: Set<string>;
  localSearchQuery: string;
  expandedInvoiceId: string | null;
  invoiceDetail: InvoiceDetailData | null;
  detailLoading: boolean;
  refundLoading: boolean;
  onToggleSelection: (invoiceId: string) => void;
  onSelectAll: () => void;
  onRowClick: (invoiceId: string) => void;
  onRefund: (invoiceId: string) => void;
}
