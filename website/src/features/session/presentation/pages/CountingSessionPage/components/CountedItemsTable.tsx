/**
 * CountedItemsTable Component
 * Table displaying counted items with expandable user breakdown
 */

import React, { useState } from 'react';
import type { CountingSessionItem } from '../../../hooks/useCountingSessionDetail';
import styles from '../CountingSessionPage.module.css';

interface CountedItemsTableProps {
  items: CountingSessionItem[];
}

export const CountedItemsTable: React.FC<CountedItemsTableProps> = ({ items }) => {
  const [expandedItems, setExpandedItems] = useState<Set<string>>(new Set());

  const toggleItemExpand = (productId: string) => {
    setExpandedItems((prev) => {
      const next = new Set(prev);
      if (next.has(productId)) {
        next.delete(productId);
      } else {
        next.add(productId);
      }
      return next;
    });
  };

  if (items.length === 0) {
    return (
      <div className={styles.emptyItems}>
        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="1.5">
          <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
          <rect x="9" y="3" width="6" height="4" rx="1" />
          <path d="M9 12h6" />
          <path d="M9 16h6" />
        </svg>
        <p>No items counted yet</p>
        <span>Items will appear here once counting begins</span>
      </div>
    );
  }

  return (
    <div className={styles.tableContainer}>
      <table className={styles.itemsTable}>
        <thead>
          <tr>
            <th className={styles.thExpand}></th>
            <th className={styles.thProduct}>Product</th>
            <th className={styles.thNumber}>Counted</th>
            <th className={styles.thNumber}>Rejected</th>
            <th className={styles.thNumber}>Counters</th>
          </tr>
        </thead>
        <tbody>
          {items.map((item) => (
            <React.Fragment key={item.productId}>
              <tr
                className={`${styles.itemRow} ${expandedItems.has(item.productId) ? styles.expanded : ''}`}
                onClick={() => toggleItemExpand(item.productId)}
              >
                <td className={styles.tdExpand}>
                  <svg
                    width="16"
                    height="16"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                    className={`${styles.expandIcon} ${expandedItems.has(item.productId) ? styles.rotated : ''}`}
                  >
                    <path d="M9 18l6-6-6-6" />
                  </svg>
                </td>
                <td className={styles.tdProduct}>{item.productName}</td>
                <td className={styles.tdNumberBlue}>{item.totalQuantity}</td>
                <td className={styles.tdNumberRed}>{item.totalRejected}</td>
                <td className={styles.tdNumber}>{item.scannedBy.length}</td>
              </tr>

              {/* Expanded user breakdown */}
              {expandedItems.has(item.productId) && (
                <tr className={styles.expandedRow}>
                  <td colSpan={5}>
                    <div className={styles.userBreakdown}>
                      <div className={styles.userBreakdownHeader}>
                        <span>Counted By</span>
                      </div>
                      <div className={styles.userList}>
                        {item.scannedBy.map((user) => (
                          <div key={user.userId} className={styles.userItem}>
                            <div className={styles.userAvatar}>
                              {user.userName.charAt(0).toUpperCase()}
                            </div>
                            <div className={styles.userInfo}>
                              <span className={styles.userName}>{user.userName}</span>
                              <div className={styles.userStats}>
                                <span className={styles.userCountedLabel}>Counted:</span>
                                <span className={styles.userCounted}>{user.quantity}</span>
                                <span className={styles.userRejectedLabel}>Rejected:</span>
                                <span className={styles.userRejected}>{user.quantityRejected}</span>
                              </div>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  </td>
                </tr>
              )}
            </React.Fragment>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default CountedItemsTable;
