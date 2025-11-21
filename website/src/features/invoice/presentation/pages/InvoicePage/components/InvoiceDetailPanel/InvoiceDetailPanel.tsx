/**
 * InvoiceDetailPanel Component
 * Expandable row content for invoice details
 */

import React from 'react';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { TossButton } from '@/shared/components/toss/TossButton';
import type { InvoiceDetailPanelProps } from './InvoiceDetailPanel.types';
import styles from './InvoiceDetailPanel.module.css';

export const InvoiceDetailPanel: React.FC<InvoiceDetailPanelProps> = ({
  invoice,
  invoiceDetail,
  detailLoading,
  refunding,
  onRefund,
}) => {
  if (detailLoading) {
    return (
      <div className={styles.detailLoading}>
        <LoadingAnimation size="medium" />
      </div>
    );
  }

  if (!invoiceDetail) {
    return (
      <div className={styles.detailError}>
        <p>Failed to load invoice details</p>
      </div>
    );
  }

  return (
    <>
      {/* Items Table - Full Width */}
      <div className={styles.detailSection} style={{ marginBottom: '16px', paddingLeft: '24px' }}>
        <h4 className={styles.detailSectionTitle}>Items ({invoiceDetail.items.length})</h4>
        <div className={styles.detailItems}>
          <table className={styles.itemsTable}>
            <thead>
              <tr>
                <th>Product</th>
                <th>SKU</th>
                <th>Qty</th>
                <th>Unit Price</th>
                <th>Unit Cost</th>
                <th>Discount</th>
                <th>Total</th>
              </tr>
            </thead>
            <tbody>
              {invoiceDetail.items.map((item) => (
                <tr key={item.item_id}>
                  <td>{item.product_name}</td>
                  <td>{item.sku}</td>
                  <td>{item.quantity_sold}</td>
                  <td>{invoice.formatCurrency(item.unit_price)}</td>
                  <td>{invoice.formatCurrency(item.unit_cost)}</td>
                  <td>{invoice.formatCurrency(item.discount_amount)}</td>
                  <td><strong>{invoice.formatCurrency(item.total_amount)}</strong></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Bottom Grid: Store Info + Amount Summary */}
      <div className={styles.detailBottomGrid}>
        {/* Store Information */}
        <div className={styles.detailSection}>
          <h4 className={styles.detailSectionTitle}>Store & Date</h4>
          <div className={styles.detailInfo}>
            <div className={styles.detailItem}>
              <span className={styles.detailLabel}>Store:</span>
              <span className={styles.detailValue}>{invoiceDetail.invoice.store_name}</span>
            </div>
            <div className={styles.detailItem}>
              <span className={styles.detailLabel}>Sale Date:</span>
              <span className={styles.detailValue}>{new Date(invoiceDetail.invoice.sale_date).toLocaleString('en-US')}</span>
            </div>
          </div>
        </div>

        {/* Amount Summary */}
        <div className={styles.detailSection}>
          <h4 className={styles.detailSectionTitle}>Amount Summary</h4>
          <div className={styles.detailInfo}>
            <div className={styles.detailItem}>
              <span className={styles.detailLabel}>Subtotal:</span>
              <span className={styles.detailValue}>{invoice.formatCurrency(invoiceDetail.amounts.subtotal)}</span>
            </div>
            <div className={styles.detailItem}>
              <span className={styles.detailLabel}>Tax:</span>
              <span className={styles.detailValue}>{invoice.formatCurrency(invoiceDetail.amounts.tax_amount)}</span>
            </div>
            <div className={styles.detailItem}>
              <span className={styles.detailLabel}>Discount:</span>
              <span className={styles.detailValue}>{invoice.formatCurrency(invoiceDetail.amounts.discount_amount)}</span>
            </div>
            <div className={styles.detailItem} style={{ borderTop: '2px solid #E9ECEF', paddingTop: '12px', marginTop: '8px' }}>
              <span className={styles.detailLabel} style={{ fontWeight: 600, fontSize: '15px' }}>Total:</span>
              <span className={styles.detailValue} style={{ fontWeight: 700, fontSize: '17px', color: '#0064FF' }}>
                {invoice.formatCurrency(invoiceDetail.amounts.total_amount)}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Refund Button - Only show for completed invoices */}
      {invoiceDetail.invoice.status === 'completed' && (
        <div className={styles.detailActions}>
          <TossButton
            variant="error"
            size="md"
            onClick={() => onRefund(invoice.invoiceId)}
            disabled={refunding}
          >
            {refunding ? 'Refunding...' : 'Refund Invoice'}
          </TossButton>
        </div>
      )}
    </>
  );
};
