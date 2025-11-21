/**
 * InvoiceTable Component
 * Table with expandable rows for invoice display
 */

import React from 'react';
import { InvoiceDetailPanel } from '../InvoiceDetailPanel';
import type { InvoiceTableProps } from './InvoiceTable.types';
import styles from './InvoiceTable.module.css';

export const InvoiceTable: React.FC<InvoiceTableProps> = ({
  invoices,
  selectedInvoices,
  expandedInvoiceId,
  invoiceDetail,
  detailLoading,
  refunding,
  localSearchQuery,
  onToggleSelection,
  onSelectAll,
  onRowClick,
  onRefund,
}) => {
  return (
    <div className={styles.invoiceTableContainer}>
      <table className={styles.invoiceTable}>
        <thead>
          <tr>
            <th className={styles.checkboxCell}>
              <input
                type="checkbox"
                checked={invoices.length > 0 && selectedInvoices.size === invoices.length}
                onChange={onSelectAll}
                className={styles.checkbox}
                disabled={invoices.length === 0}
              />
            </th>
            <th>INVOICE #</th>
            <th>DATE</th>
            <th>CUSTOMER</th>
            <th>ITEMS</th>
            <th className={styles.paymentCell}>PAYMENT</th>
            <th>TOTAL</th>
            <th className={styles.statusCell}>STATUS</th>
          </tr>
        </thead>
        <tbody>
          {invoices.length === 0 ? (
            <tr>
              <td colSpan={8} className={styles.emptyStateCell}>
                <div className={styles.emptyState}>
                  <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg">
                    {/* Background Circle */}
                    <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>

                    {/* Document Stack */}
                    <rect x="35" y="40" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>
                    <rect x="40" y="35" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>

                    {/* Document Lines */}
                    <line x1="48" y1="45" x2="75" y2="45" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
                    <line x1="48" y1="52" x2="70" y2="52" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
                    <line x1="48" y1="59" x2="72" y2="59" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>

                    {/* Invoice Symbol (Receipt Icon) */}
                    <circle cx="60" cy="75" r="12" fill="#0064FF"/>
                    <path d="M56 75 L58 77 L64 71" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                  <h3 className={styles.emptyTitle}>No Invoices</h3>
                  <p className={styles.emptyText}>
                    {localSearchQuery ? `No invoices found matching "${localSearchQuery}"` : 'No invoice records found for the selected period'}
                  </p>
                </div>
              </td>
            </tr>
          ) : (
            invoices.map((invoice) => {
              const isExpanded = expandedInvoiceId === invoice.invoiceId;

              return (
                <React.Fragment key={invoice.invoiceId}>
                  <tr
                    className={`${styles.invoiceRow} ${isExpanded ? styles.expandedRow : ''}`}
                    onClick={() => onRowClick(invoice.invoiceId)}
                    style={{ cursor: 'pointer' }}
                  >
                    <td className={styles.checkboxCell} onClick={(e) => e.stopPropagation()}>
                      <input
                        type="checkbox"
                        checked={selectedInvoices.has(invoice.invoiceId)}
                        onChange={() => onToggleSelection(invoice.invoiceId)}
                        className={styles.checkbox}
                      />
                    </td>
                    <td className={styles.invoiceNumber}>{invoice.invoiceNumber}</td>
                    <td className={styles.invoiceDate}>{invoice.formattedDate}</td>
                    <td className={styles.customerCell}>
                      {invoice.customerName}
                    </td>
                    <td className={styles.itemsCell}>
                      <div className={styles.itemCount}>{invoice.itemCount} items</div>
                      <div className={styles.itemQty}>Qty: {invoice.totalQuantity}</div>
                    </td>
                    <td className={styles.paymentCell}>
                      <span className={`${styles.paymentBadge} ${styles[invoice.paymentBadgeClass]}`}>
                        {invoice.paymentMethodDisplay}
                      </span>
                    </td>
                    <td className={styles.totalCell}>
                      {invoice.formatCurrency(invoice.totalAmount)}
                    </td>
                    <td className={styles.statusCell}>
                      <span className={`${styles.statusBadge} ${styles[invoice.status]}`}>
                        {invoice.statusDisplay.toUpperCase()}
                      </span>
                    </td>
                  </tr>

                  {/* Expanded Detail Row */}
                  {isExpanded && (
                    <tr className={styles.detailRow}>
                      <td colSpan={8}>
                        <div className={styles.detailContent}>
                          <InvoiceDetailPanel
                            invoice={invoice}
                            invoiceDetail={invoiceDetail}
                            detailLoading={detailLoading}
                            refunding={refunding}
                            onRefund={onRefund}
                          />
                        </div>
                      </td>
                    </tr>
                  )}
                </React.Fragment>
              );
            })
          )}
        </tbody>
      </table>
    </div>
  );
};
