/**
 * SessionReceivedItemsCard Component
 * Card displaying items that have been received/saved in the session
 * Shows all products received, including those not in the shipment
 */

import React from 'react';
import type { SessionItem } from '../../../../domain/entities';
import styles from '../ReceivingSessionPage.module.css';

interface SessionReceivedItemsCardProps {
  sessionItems: SessionItem[];
  totalProducts: number;
  totalQuantity: number;
  totalRejected: number;
}

export const SessionReceivedItemsCard: React.FC<SessionReceivedItemsCardProps> = ({
  sessionItems,
  totalProducts,
  totalQuantity,
  totalRejected,
}) => {
  // Calculate net accepted
  const netAccepted = totalQuantity - totalRejected;

  return (
    <div className={styles.itemsCard}>
      <div className={styles.itemsHeader}>
        <h3>Session Received Items</h3>
        <span className={styles.itemCount}>{totalProducts} products</span>
      </div>

      {/* Summary Section */}
      <div className={styles.sessionReceivedSummary}>
        <div className={styles.statItem}>
          <span className={styles.statLabel}>Total Received</span>
          <span className={styles.statValueBlue}>{totalQuantity}</span>
        </div>
        <div className={styles.statItem}>
          <span className={styles.statLabel}>Rejected</span>
          <span className={styles.statValueRed}>{totalRejected}</span>
        </div>
        <div className={styles.statItem}>
          <span className={styles.statLabel}>Net Accepted</span>
          <span className={styles.statValueGreen}>{netAccepted}</span>
        </div>
      </div>

      {/* Items Table */}
      {sessionItems.length === 0 ? (
        <div className={styles.emptyItems}>
          <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
            <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
            <rect x="9" y="3" width="6" height="4" rx="1" />
            <path d="M12 11v6M9 14h6" />
          </svg>
          <p>No items received yet</p>
          <span>Scan or search products to add them to this session</span>
        </div>
      ) : (
        <div className={styles.tableContainer}>
          <table className={styles.itemsTable}>
            <thead>
              <tr>
                <th className={styles.thProduct}>Product</th>
                <th className={styles.thSku}>SKU</th>
                <th className={styles.thNumber}>Received</th>
                <th className={styles.thNumber}>Rejected</th>
                <th className={styles.thNumber}>Accepted</th>
                <th className={styles.thContributors}>Contributors</th>
              </tr>
            </thead>
            <tbody>
              {sessionItems.map((item) => (
                <tr key={`${item.productId}-${item.variantId || 'base'}`}>
                  <td className={styles.tdProduct}>{item.displayName}</td>
                  <td className={styles.tdSku}>{item.displaySku}</td>
                  <td className={styles.tdNumberBlue}>{item.totalQuantity}</td>
                  <td className={styles.tdNumberRed}>{item.totalRejected}</td>
                  <td className={styles.tdNumberGreen}>{item.totalQuantity - item.totalRejected}</td>
                  <td className={styles.tdContributors}>
                    {item.scannedBy && item.scannedBy.length > 0 ? (
                      <div className={styles.contributorsList}>
                        {item.scannedBy.map((user) => (
                          <span key={user.userId} className={styles.contributorBadge}>
                            {user.userName}: {user.quantity}
                            {user.quantityRejected > 0 && (
                              <span className={styles.contributorRejected}>
                                (-{user.quantityRejected})
                              </span>
                            )}
                          </span>
                        ))}
                      </div>
                    ) : (
                      <span className={styles.noContributors}>-</span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
};
