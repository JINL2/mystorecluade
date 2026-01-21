/**
 * NewProductsTab Component
 * Shows new products added during receiving session
 */

import React from 'react';
import type { StockSnapshot } from '../../../../domain/entities';
import styles from '../SessionHistoryDetailPage.module.css';

interface NewProductsTabProps {
  newProducts: StockSnapshot[];
}

export const NewProductsTab: React.FC<NewProductsTabProps> = ({ newProducts }) => {
  return (
    <div className={styles.newProductsSection}>
      <div className={styles.sectionHeader}>
        <div className={styles.sectionIcon}>
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M12 5v14M5 12h14" />
          </svg>
        </div>
        <div>
          <h3 className={styles.sectionTitle}>New Products Added</h3>
          <p className={styles.sectionSubtitle}>
            These products were added to inventory for the first time
          </p>
        </div>
      </div>
      <div className={styles.tableContainer}>
        <table className={styles.dataTable}>
          <thead>
            <tr>
              <th>Product</th>
              <th>SKU</th>
              <th>Quantity Received</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {newProducts.map((product, index) => (
              <tr key={`${product.productId}-${index}`} className={styles.newProductRow}>
                <td className={styles.productName}>
                  <span className={styles.newBadge}>NEW</span>
                  {product.displayName}
                </td>
                <td>{product.sku || '-'}</td>
                <td className={`${styles.quantityCell} ${styles.positive}`}>
                  +{product.quantityReceived.toLocaleString()}
                </td>
                <td>
                  <span className={styles.stockStatus}>
                    Initial Stock: {product.quantityAfter.toLocaleString()}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default NewProductsTab;
