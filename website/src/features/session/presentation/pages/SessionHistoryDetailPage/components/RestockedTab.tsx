/**
 * RestockedTab Component
 * Shows restocked products during receiving session
 */

import React from 'react';
import type { StockSnapshot } from '../../../../domain/entities';
import styles from '../SessionHistoryDetailPage.module.css';

interface RestockedTabProps {
  restockedProducts: StockSnapshot[];
}

export const RestockedTab: React.FC<RestockedTabProps> = ({ restockedProducts }) => {
  return (
    <div className={styles.stockChangesSection}>
      <div className={styles.sectionHeader}>
        <div className={styles.sectionIconBlue}>
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
          </svg>
        </div>
        <div>
          <h3 className={styles.sectionTitle}>Restocked Products</h3>
          <p className={styles.sectionSubtitle}>
            Existing products that received additional stock
          </p>
        </div>
      </div>
      <div className={styles.tableContainer}>
        <table className={styles.dataTable}>
          <thead>
            <tr>
              <th>Product</th>
              <th>SKU</th>
              <th>Previous Qty</th>
              <th>Received</th>
              <th>New Qty</th>
            </tr>
          </thead>
          <tbody>
            {restockedProducts.map((stock, index) => (
              <tr key={`${stock.productId}-${index}`}>
                <td className={styles.productName}>{stock.displayName}</td>
                <td>{stock.sku || '-'}</td>
                <td className={styles.quantityCell}>{stock.quantityBefore.toLocaleString()}</td>
                <td className={`${styles.quantityCell} ${styles.positive}`}>+{stock.quantityReceived.toLocaleString()}</td>
                <td className={styles.quantityCell}>{stock.quantityAfter.toLocaleString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default RestockedTab;
