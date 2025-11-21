/**
 * InvoicePagination Component
 * Pagination controls for invoice list
 */

import React from 'react';
import type { InvoicePaginationProps } from './InvoicePagination.types';
import styles from './InvoicePagination.module.css';

export const InvoicePagination: React.FC<InvoicePaginationProps> = ({
  pagination,
  currentPage,
  itemsPerPage,
  onPageChange,
}) => {
  const totalCount = pagination.total_count || (pagination.total_pages * itemsPerPage);
  const startItem = ((currentPage - 1) * itemsPerPage) + 1;
  const endItem = Math.min(currentPage * itemsPerPage, totalCount);

  return (
    <div className={styles.pagination}>
      <div className={styles.paginationInfo}>
        {`Showing ${startItem}-${endItem} of ${totalCount} invoices`}
      </div>
      <div className={styles.paginationControls}>
        <button
          className={styles.paginationArrow}
          onClick={() => onPageChange(currentPage - 1)}
          disabled={!pagination.has_prev}
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M15.41,16.58L10.83,12L15.41,7.41L14,6L8,12L14,18L15.41,16.58Z"/>
          </svg>
        </button>

        {/* Page numbers */}
        {Array.from({ length: Math.min(5, pagination.total_pages) }, (_, i) => {
          // Calculate which pages to show (max 5 pages)
          let pageNum;
          if (pagination.total_pages <= 5) {
            pageNum = i + 1;
          } else if (currentPage <= 3) {
            pageNum = i + 1;
          } else if (currentPage >= pagination.total_pages - 2) {
            pageNum = pagination.total_pages - 4 + i;
          } else {
            pageNum = currentPage - 2 + i;
          }

          return (
            <button
              key={pageNum}
              className={`${styles.paginationNumber} ${currentPage === pageNum ? styles.active : ''}`}
              onClick={() => onPageChange(pageNum)}
            >
              {pageNum}
            </button>
          );
        })}

        <button
          className={styles.paginationArrow}
          onClick={() => onPageChange(currentPage + 1)}
          disabled={!pagination.has_next}
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z"/>
          </svg>
        </button>
      </div>
    </div>
  );
};
