/**
 * ShipmentItemsCard Component
 * Card displaying shipment items with progress tracking
 */

import React from 'react';
import type { ReceivingItem } from '../ReceivingSessionPage.types';
import styles from '../ReceivingSessionPage.module.css';

interface ShipmentItemsCardProps {
  items: ReceivingItem[];
  totalShipped: number;
  totalReceived: number;
  totalAccepted: number;
  totalRejected: number;
  totalRemaining: number;
  progressPercentage: number;
}

export const ShipmentItemsCard: React.FC<ShipmentItemsCardProps> = ({
  items,
  totalShipped,
  totalReceived,
  totalAccepted,
  totalRejected,
  totalRemaining,
  progressPercentage,
}) => {
  return (
    <div className={styles.itemsCard}>
      <div className={styles.itemsHeader}>
        <h3>Items to Receive</h3>
        <span className={styles.itemCount}>{items.length} items</span>
      </div>

      {/* Progress Section */}
      <div className={styles.progressSection}>
        <div className={styles.progressRow}>
          <div className={styles.progressBarContainer}>
            <div
              className={styles.progressBarFill}
              style={{ width: `${progressPercentage}%` }}
            />
          </div>
          <span className={styles.progressPercentage}>{progressPercentage.toFixed(0)}%</span>
        </div>
        <div className={styles.progressStats}>
          <div className={styles.statItem}>
            <span className={styles.statLabel}>Shipped</span>
            <span className={styles.statValue}>{totalShipped}</span>
          </div>
          <div className={styles.statItem}>
            <span className={styles.statLabel}>Received</span>
            <span className={styles.statValueBlue}>{totalReceived}</span>
          </div>
          <div className={styles.statItem}>
            <span className={styles.statLabel}>Accepted</span>
            <span className={styles.statValueGreen}>{totalAccepted}</span>
          </div>
          <div className={styles.statItem}>
            <span className={styles.statLabel}>Rejected</span>
            <span className={styles.statValueRed}>{totalRejected}</span>
          </div>
          <div className={styles.statItem}>
            <span className={styles.statLabel}>Remaining</span>
            <span className={styles.statValueOrange}>{totalRemaining}</span>
          </div>
        </div>
      </div>

      {/* Items Table */}
      {items.length === 0 ? (
        <div className={styles.emptyItems}>
          <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
            <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
            <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
            <line x1="12" y1="22.08" x2="12" y2="12" />
          </svg>
          <p>No items to display</p>
          <span>Session data is loading or no items available</span>
        </div>
      ) : (
        <div className={styles.tableContainer}>
          <table className={styles.itemsTable}>
            <thead>
              <tr>
                <th className={styles.thProduct}>Product</th>
                <th className={styles.thSku}>SKU</th>
                <th className={styles.thNumber}>Shipped</th>
                <th className={styles.thNumber}>Received</th>
                <th className={styles.thNumber}>Accepted</th>
                <th className={styles.thNumber}>Rejected</th>
                <th className={styles.thNumber}>Remaining</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.item_id}>
                  <td className={styles.tdProduct}>{item.product_name}</td>
                  <td className={styles.tdSku}>{item.sku}</td>
                  <td className={styles.tdNumber}>{item.quantity_shipped}</td>
                  <td className={styles.tdNumberBlue}>{item.quantity_received}</td>
                  <td className={styles.tdNumberGreen}>{item.quantity_accepted}</td>
                  <td className={styles.tdNumberRed}>{item.quantity_rejected}</td>
                  <td className={styles.tdNumberOrange}>{item.quantity_remaining}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
};
