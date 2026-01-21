/**
 * MergeDetailsTab Component
 * Shows detailed breakdown of merged sessions
 */

import React from 'react';
import type { SessionMergeInfo } from '../../../../domain/entities';
import styles from '../SessionHistoryDetailPage.module.css';

interface MergeDetailsTabProps {
  mergeInfo: SessionMergeInfo;
  expandedMergedSession: string | null;
  onToggleMergedSession: (sessionId: string) => void;
}

// Format date for display (yyyy/MM/dd HH:mm)
const formatDateTime = (dateStr: string | null): string => {
  if (!dateStr) return '-';
  const parts = dateStr.split(' ');
  if (parts.length >= 2) {
    const datePart = parts[0].replace(/-/g, '/');
    const timePart = parts[1].substring(0, 5);
    return `${datePart} ${timePart}`;
  }
  return dateStr.replace(/-/g, '/');
};

// Get user display name from first and last name
const getUserDisplayName = (firstName: string, lastName: string): string => {
  return `${firstName} ${lastName}`.trim() || 'Unknown';
};

export const MergeDetailsTab: React.FC<MergeDetailsTabProps> = ({
  mergeInfo,
  expandedMergedSession,
  onToggleMergedSession,
}) => {
  return (
    <div className={styles.mergeDetailsSection}>
      {/* Original Session */}
      <div className={styles.mergeSessionCard}>
        <div className={styles.mergeSessionHeader}>
          <div className={styles.mergeSessionBadge}>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="10" />
              <path d="M12 8v8M8 12h8" />
            </svg>
            Original Session
          </div>
          <div className={styles.mergeSessionStats}>
            <span>{mergeInfo.originalSession.itemsCount} items</span>
            <span className={styles.divider}>•</span>
            <span>{mergeInfo.originalSession.totalQuantity.toLocaleString()} qty</span>
          </div>
        </div>
        <div className={styles.mergeSessionContent}>
          <table className={styles.dataTable}>
            <thead>
              <tr>
                <th>Product</th>
                <th>SKU</th>
                <th>Quantity</th>
                <th>Rejected</th>
                <th>Scanned By</th>
              </tr>
            </thead>
            <tbody>
              {mergeInfo.originalSession.items.map((item, idx) => (
                <tr key={`original-${item.productId}-${idx}`}>
                  <td className={styles.productName}>{item.displayName}</td>
                  <td>{item.sku || '-'}</td>
                  <td className={styles.quantityCell}>{item.quantity}</td>
                  <td className={item.quantityRejected > 0 ? styles.negative : ''}>
                    {item.quantityRejected > 0 ? item.quantityRejected : '-'}
                  </td>
                  <td>
                    {getUserDisplayName(item.scannedBy.firstName, item.scannedBy.lastName)}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Merged Sessions */}
      {mergeInfo.mergedSessions.map((mergedSession, sessionIdx) => (
        <div key={mergedSession.sourceSessionId} className={styles.mergeSessionCard}>
          <div
            className={styles.mergeSessionHeader}
            onClick={() => onToggleMergedSession(mergedSession.sourceSessionId)}
            style={{ cursor: 'pointer' }}
          >
            <div className={styles.mergeSessionInfo}>
              <div className={styles.mergeSessionBadge}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M16 3h5v5M8 3H3v5M3 16v5h5M21 16v5h-5" />
                </svg>
                Merged Session #{sessionIdx + 1}
              </div>
              <div className={styles.mergeSessionName}>{mergedSession.sourceSessionName}</div>
            </div>
            <div className={styles.mergeSessionMeta}>
              <div className={styles.mergeSessionStats}>
                <span>{mergedSession.itemsCount} items</span>
                <span className={styles.divider}>•</span>
                <span>{mergedSession.totalQuantity.toLocaleString()} qty</span>
              </div>
              <div className={styles.mergeSessionCreator}>
                <span className={styles.creatorLabel}>Created by:</span>
                <span className={styles.creatorName}>
                  {getUserDisplayName(mergedSession.sourceCreatedBy.firstName, mergedSession.sourceCreatedBy.lastName)}
                </span>
              </div>
              <div className={styles.mergeSessionDate}>
                {formatDateTime(mergedSession.sourceCreatedAt)}
              </div>
              <svg
                className={`${styles.expandIcon} ${expandedMergedSession === mergedSession.sourceSessionId ? styles.expanded : ''}`}
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
              >
                <path d="M6 9l6 6 6-6" />
              </svg>
            </div>
          </div>

          {expandedMergedSession === mergedSession.sourceSessionId && (
            <div className={styles.mergeSessionContent}>
              <table className={styles.dataTable}>
                <thead>
                  <tr>
                    <th>Product</th>
                    <th>SKU</th>
                    <th>Quantity</th>
                    <th>Rejected</th>
                    <th>Scanned By</th>
                  </tr>
                </thead>
                <tbody>
                  {mergedSession.items.map((item, idx) => (
                    <tr key={`merged-${mergedSession.sourceSessionId}-${item.productId}-${idx}`}>
                      <td className={styles.productName}>{item.displayName}</td>
                      <td>{item.sku || '-'}</td>
                      <td className={styles.quantityCell}>{item.quantity}</td>
                      <td className={item.quantityRejected > 0 ? styles.negative : ''}>
                        {item.quantityRejected > 0 ? item.quantityRejected : '-'}
                      </td>
                      <td>
                        {getUserDisplayName(item.scannedBy.firstName, item.scannedBy.lastName)}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      ))}
    </div>
  );
};

export default MergeDetailsTab;
