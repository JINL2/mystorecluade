/**
 * InvoicePagination Component Types
 */

import type { PaginationInfo } from '../../../../domain/repositories/IInvoiceRepository';

export interface InvoicePaginationProps {
  pagination: PaginationInfo;
  currentPage: number;
  itemsPerPage: number;
  onPageChange: (page: number) => void;
}
