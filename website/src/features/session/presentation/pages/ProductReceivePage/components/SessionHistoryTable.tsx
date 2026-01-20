/**
 * SessionHistoryTable Component
 * Displays list of closed/completed sessions with detailed information
 */

import React from 'react';
import type { SessionHistoryEntry } from '../../../../domain/entities';
import styles from '../ProductReceivePage.module.css';

interface SessionHistoryTableProps {
  sessions: SessionHistoryEntry[];
  isLoading: boolean;
  isLoadingMore: boolean;
  hasMore: boolean;
  error: string | null;
  onSessionClick: (session: SessionHistoryEntry) => void;
  onLoadMore: () => void;
}

// Format date for display (yyyy/MM/dd HH:mm)
// RPC returns date string already in user's local timezone (e.g., '2026-01-19 21:34:51')
// So we just reformat the string, not parse it as Date (which would cause timezone issues)
const formatDateTimeDisplay = (dateStr: string | null): string => {
  if (!dateStr) return '-';
  // dateStr format from RPC: 'YYYY-MM-DD HH:MM:SS'
  const parts = dateStr.split(' ');
  if (parts.length >= 2) {
    const datePart = parts[0].replace(/-/g, '/');
    const timePart = parts[1].substring(0, 5); // HH:MM
    return `${datePart} ${timePart}`;
  }
  return dateStr.replace(/-/g, '/');
};

// Format date only (yyyy/MM/dd)
// RPC returns date string already in user's local timezone
const formatDateDisplay = (dateStr: string | null): string => {
  if (!dateStr) return '-';
  // dateStr format from RPC: 'YYYY-MM-DD HH:MM:SS' or 'YYYY-MM-DD'
  const datePart = dateStr.split(' ')[0];
  return datePart.replace(/-/g, '/');
};

// Get session type badge class
const getSessionTypeBadgeClass = (type: 'counting' | 'receiving'): string => {
  return type === 'counting' ? 'process' : 'complete';
};

// Get status badge class name based on session state
const getStatusClassName = (session: SessionHistoryEntry): string => {
  if (session.isFinal) {
    return 'complete';
  }
  if (session.isActive) {
    return 'process';
  }
  if (session.completedAt) {
    return 'complete';
  }
  return 'cancelled';
};

// Get status text
const getStatusText = (session: SessionHistoryEntry): string => {
  if (session.isFinal) {
    return 'Final';
  }
  if (session.isActive) {
    return 'Active';
  }
  if (session.completedAt) {
    return 'Completed';
  }
  return 'Closed';
};

export const SessionHistoryTable: React.FC<SessionHistoryTableProps> = ({
  sessions,
  isLoading,
  isLoadingMore,
  hasMore,
  error,
  onSessionClick,
  onLoadMore,
}) => {
  if (error) {
    return (
      <div className={styles.errorState}>
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#EF4444" strokeWidth="2">
          <circle cx="12" cy="12" r="10" />
          <line x1="12" y1="8" x2="12" y2="12" />
          <line x1="12" y1="16" x2="12.01" y2="16" />
        </svg>
        <p className={styles.errorTitle}>Failed to load history</p>
        <p className={styles.errorDescription}>{error}</p>
      </div>
    );
  }

  return (
    <div className={styles.tableContainer}>
      <table className={styles.receivesTable}>
        <thead>
          <tr>
            <th>Session Name</th>
            <th>Type</th>
            <th>Store</th>
            <th>Items</th>
            <th>Quantity</th>
            <th>Members</th>
            <th>Created</th>
            <th>Closed</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {isLoading ? (
            <tr>
              <td colSpan={9}>
                <div className={styles.loadingState}>
                  <div className={styles.spinner} />
                  <p>Loading session history...</p>
                </div>
              </td>
            </tr>
          ) : sessions.length > 0 ? (
            <>
              {sessions.map((session) => (
                <tr
                  key={session.sessionId}
                  className={styles.shipmentRow}
                  onClick={() => onSessionClick(session)}
                  style={{ cursor: 'pointer' }}
                >
                  <td>
                    <div className={styles.sessionNameCell}>
                      <span className={styles.receiveNumber}>{session.sessionName}</span>
                      {session.isMergedSession && (
                        <span className={styles.mergedBadge} title="This session was merged">
                          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M8 6v12M12 6v12M16 6v12" />
                          </svg>
                          Merged
                        </span>
                      )}
                      {session.sessionType === 'receiving' && session.receivingInfo && session.receivingInfo.newProductsCount > 0 && (
                        <span className={styles.newProductsBadge} title={`${session.receivingInfo.newProductsCount} new product(s) added`}>
                          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M12 5v14M5 12h14" />
                          </svg>
                          +{session.receivingInfo.newProductsCount} New
                        </span>
                      )}
                    </div>
                  </td>
                  <td>
                    <span className={`${styles.statusBadge} ${styles[getSessionTypeBadgeClass(session.sessionType)]}`}>
                      {session.sessionType === 'counting' ? 'Counting' : 'Receiving'}
                    </span>
                  </td>
                  <td>
                    <span className={styles.supplierName}>{session.storeName}</span>
                  </td>
                  <td>
                    <span className={styles.itemCount}>{session.items?.length || 0}</span>
                  </td>
                  <td>
                    <span className={styles.quantityValue}>
                      {(session.totalConfirmedQuantity ?? session.totalScannedQuantity).toLocaleString()}
                    </span>
                  </td>
                  <td>
                    <span className={styles.memberCount}>{session.memberCount}</span>
                  </td>
                  <td>{formatDateDisplay(session.createdAt)}</td>
                  <td>{formatDateTimeDisplay(session.completedAt)}</td>
                  <td>
                    <span className={`${styles.statusBadge} ${styles[getStatusClassName(session)]}`}>
                      {getStatusText(session)}
                    </span>
                  </td>
                </tr>
              ))}
              {hasMore && (
                <tr>
                  <td colSpan={9}>
                    <div className={styles.loadMoreContainer}>
                      {isLoadingMore ? (
                        <div className={styles.loadingMore}>
                          <div className={styles.spinnerSmall} />
                          <span>Loading more...</span>
                        </div>
                      ) : (
                        <button className={styles.loadMoreButton} onClick={onLoadMore}>
                          Load More
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              )}
            </>
          ) : (
            <tr>
              <td colSpan={9}>
                <div className={styles.emptyState}>
                  <svg className={styles.emptyIcon} width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
                    <path d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <p className={styles.emptyTitle}>No session history found</p>
                  <p className={styles.emptyDescription}>
                    Completed or closed sessions will appear here
                  </p>
                </div>
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default SessionHistoryTable;
