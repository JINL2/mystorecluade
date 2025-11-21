/**
 * Invoice State Interface
 * Defines the shape of the invoice Zustand store
 */

import type { Invoice } from '../../../domain/entities/Invoice';
import type { PaginationInfo } from '../../../domain/repositories/IInvoiceRepository';
import type {
  DateFilterType,
  DateRange,
  InvoiceDetail,
  RefundResult,
  BulkRefundResult
} from './types';

/**
 * Invoice state interface for Zustand store
 */
export interface InvoiceState {
  // ========== Data State ==========
  invoices: Invoice[];
  selectedInvoice: Invoice | null;
  invoiceDetail: InvoiceDetail | null;

  // ========== UI State ==========
  loading: boolean;
  detailLoading: boolean;
  refunding: boolean;
  error: string | null;

  // ========== Filter State ==========
  selectedStoreId: string | null;
  currentPage: number;
  itemsPerPage: number;
  searchQuery: string;
  dateRange: DateRange;
  activeFilter: DateFilterType;

  // ========== Pagination State ==========
  pagination: PaginationInfo | null;

  // ========== Setter Actions ==========
  setInvoices: (invoices: Invoice[]) => void;
  setSelectedInvoice: (invoice: Invoice | null) => void;
  setInvoiceDetail: (detail: InvoiceDetail | null) => void;
  setSelectedStoreId: (storeId: string | null) => void;
  setActiveFilter: (filter: DateFilterType) => void;
  setLoading: (loading: boolean) => void;
  setDetailLoading: (loading: boolean) => void;
  setRefunding: (refunding: boolean) => void;
  setError: (error: string | null) => void;
  setPagination: (pagination: PaginationInfo | null) => void;

  // ========== Filter Actions ==========
  changeDateRange: (start: string, end: string) => void;
  changeSearch: (query: string) => void;
  changePage: (page: number) => void;

  // ========== Async Actions ==========
  loadInvoices: (companyId: string) => Promise<void>;
  fetchInvoiceDetail: (invoiceId: string) => Promise<void>;
  refundInvoice: (invoiceId: string, refundReason?: string, createdBy?: string) => Promise<RefundResult>;
  refundInvoices: (invoiceIds: string[], notes: string, createdBy: string) => Promise<BulkRefundResult>;
  refresh: (companyId: string) => Promise<void>;

  // ========== Reset Actions ==========
  clearDetail: () => void;
  reset: () => void;
}
