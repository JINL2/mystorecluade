/**
 * InvoiceTable Component
 * Table for invoice display with expandable detail panel
 */

import React from 'react';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import type { InvoiceTableProps } from './InvoiceTable.types';
import styles from './InvoiceTable.module.css';

export const InvoiceTable: React.FC<InvoiceTableProps> = ({
  invoices,
  selectedInvoices,
  localSearchQuery,
  expandedInvoiceId,
  invoiceDetail,
  detailLoading,
  refundLoading,
  onToggleSelection,
  onSelectAll,
  onRowClick,
  onRefund,
}) => {
  // Get the expanded invoice for formatting
  const expandedInvoice = invoices.find(inv => inv.invoiceId === expandedInvoiceId);

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
              />
            </th>
            <th>Invoice #</th>
            <th>Date</th>
            <th>Customer</th>
            <th>Items</th>
            <th style={{ textAlign: 'center' }}>Payment</th>
            <th>Total</th>
            <th style={{ textAlign: 'center' }}>Status</th>
          </tr>
        </thead>
        <tbody>
          {invoices.length === 0 ? (
            <tr>
              <td colSpan={8} className={styles.emptyStateCell}>
                <div className={styles.emptyState}>
                  <div className={styles.emptyIcon}>
                    <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#ADB5BD" strokeWidth="1.5">
                      <path d="M9 17H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                      <path d="M19 17h-4" />
                      <path d="M19 13h-4" />
                      <path d="M19 9h-4" />
                      <path d="M19 5h-4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2z" />
                      <path d="M3 9h4" />
                      <path d="M3 13h4" />
                    </svg>
                  </div>
                  <h3 className={styles.emptyTitle}>No Invoices</h3>
                  <p className={styles.emptyText}>
                    {localSearchQuery ? `No invoices found matching "${localSearchQuery}"` : 'No invoice records found for the selected period'}
                  </p>
                </div>
              </td>
            </tr>
          ) : (
            invoices.map((invoice) => (
              <React.Fragment key={invoice.invoiceId}>
                {/* Invoice Row */}
                <tr
                  className={`${styles.invoiceRow} ${styles.clickableRow} ${expandedInvoiceId === invoice.invoiceId ? styles.expandedRow : ''}`}
                  onClick={() => onRowClick(invoice.invoiceId)}
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
                {expandedInvoiceId === invoice.invoiceId && (
                  <tr className={styles.detailRow}>
                    <td colSpan={8}>
                      <div className={styles.detailContent}>
                        {detailLoading ? (
                          <div className={styles.detailLoading}>
                            <LoadingAnimation size="medium" />
                          </div>
                        ) : (
                          <div className={styles.expandedPanel}>
                            <div className={styles.expandedPanelGrid}>
                              {/* Product List Section */}
                              <div className={styles.productListSection}>
                                <h4 className={styles.sectionTitle}>
                                  Products ({invoiceDetail?.items.length || 0})
                                </h4>
                                <table className={styles.productTable}>
                                  <thead>
                                    <tr>
                                      <th>Product</th>
                                      <th>SKU</th>
                                      <th>Qty</th>
                                      <th>Unit Price</th>
                                      <th>Discount</th>
                                      <th>Total</th>
                                    </tr>
                                  </thead>
                                  <tbody>
                                    {invoiceDetail?.items.map((item) => (
                                      <tr key={item.item_id}>
                                        <td>
                                          <div className={styles.productName}>{item.product_name}</div>
                                        </td>
                                        <td>
                                          <div className={styles.productSku}>{item.sku}</div>
                                        </td>
                                        <td>{item.quantity_sold}</td>
                                        <td>{expandedInvoice?.formatCurrency(item.unit_price)}</td>
                                        <td>{expandedInvoice?.formatCurrency(item.discount_amount)}</td>
                                        <td><strong>{expandedInvoice?.formatCurrency(item.total_amount)}</strong></td>
                                      </tr>
                                    ))}
                                  </tbody>
                                </table>
                              </div>

                              {/* Info Section */}
                              <div className={styles.infoSection}>
                                {/* Store & Cash Location Info */}
                                <div className={styles.infoCard}>
                                  <h5 className={styles.infoCardTitle}>Sale Location</h5>
                                  <div className={styles.infoItem}>
                                    <span className={styles.infoLabel}>Store</span>
                                    <span className={styles.infoValue}>{invoice.storeName || '-'}</span>
                                  </div>
                                  <div className={styles.infoItem}>
                                    <span className={styles.infoLabel}>Cash Location</span>
                                    <span className={styles.infoValue}>
                                      {invoice.cashLocationName || '-'}
                                      {invoice.cashLocationType && (
                                        <span className={`${styles.cashLocationType} ${styles[invoice.cashLocationType]}`}>
                                          {invoice.cashLocationType}
                                        </span>
                                      )}
                                    </span>
                                  </div>
                                  <div className={styles.infoItem}>
                                    <span className={styles.infoLabel}>Payment Method</span>
                                    <span className={styles.infoValue}>{invoice.paymentMethodDisplay}</span>
                                  </div>
                                  {invoice.formattedTime && (
                                    <div className={styles.infoItem}>
                                      <span className={styles.infoLabel}>Created At</span>
                                      <span className={styles.infoValue}>{invoice.formattedTime}</span>
                                    </div>
                                  )}
                                </div>

                                {/* Amount Summary */}
                                <div className={styles.infoCard}>
                                  <h5 className={styles.infoCardTitle}>Amount Summary</h5>
                                  <div className={styles.infoItem}>
                                    <span className={styles.infoLabel}>Subtotal</span>
                                    <span className={styles.infoValue}>{invoice.formatCurrency(invoice.subtotal)}</span>
                                  </div>
                                  {invoice.taxAmount > 0 && (
                                    <div className={styles.infoItem}>
                                      <span className={styles.infoLabel}>Tax</span>
                                      <span className={styles.infoValue}>{invoice.formatCurrency(invoice.taxAmount)}</span>
                                    </div>
                                  )}
                                  {invoice.discountAmount > 0 && (
                                    <div className={styles.infoItem}>
                                      <span className={styles.infoLabel}>Discount</span>
                                      <span className={styles.infoValue}>-{invoice.formatCurrency(invoice.discountAmount)}</span>
                                    </div>
                                  )}
                                  <div className={`${styles.infoItem} ${styles.totalRow}`}>
                                    <span className={styles.infoLabel}>Total</span>
                                    <span className={styles.infoValueHighlight}>{invoice.formatCurrency(invoice.totalAmount)}</span>
                                  </div>
                                  <div className={styles.infoItem}>
                                    <span className={styles.infoLabel}>Total Cost</span>
                                    <span className={styles.infoValue}>{invoice.formatCurrency(invoice.totalCost)}</span>
                                  </div>
                                  <div className={styles.infoItem}>
                                    <span className={styles.infoLabel}>Profit</span>
                                    <span className={`${styles.infoValue} ${invoice.profit >= 0 ? styles.profitPositive : styles.profitNegative}`}>
                                      {invoice.formatCurrency(invoice.profit)}
                                    </span>
                                  </div>
                                </div>

                                {/* Refund Button */}
                                <button
                                  className={`${styles.refundButton} ${invoice.status === 'cancelled' ? styles.refundButtonDisabled : ''}`}
                                  disabled={invoice.status === 'cancelled' || refundLoading}
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    onRefund(invoice.invoiceId);
                                  }}
                                >
                                  {refundLoading ? 'Processing...' : 'Refund'}
                                </button>
                              </div>
                            </div>
                          </div>
                        )}
                      </div>
                    </td>
                  </tr>
                )}
              </React.Fragment>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
};
