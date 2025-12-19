/**
 * CountingSessionsTable Component
 * Displays list of counting sessions (same design as ShipmentsTable)
 */

import React from 'react';
import type { CountingSession } from '../../../hooks/useCountingSessionList';
import styles from '../ProductReceivePage.module.css';

interface CountingSessionsTableProps {
  sessions: CountingSession[];
  sessionsLoading: boolean;
  searchQuery: string;
  onSessionClick: (sessionId: string) => void;
}

// Format date for display (yyyy/MM/dd)
const formatDateDisplay = (dateStr: string): string => {
  if (!dateStr) return '-';
  const date = new Date(dateStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}/${month}/${day}`;
};

// Get status badge class name based on session state
const getStatusClassName = (session: CountingSession): string => {
  if (session.isFinal) {
    return 'complete';
  }
  if (session.isActive) {
    return 'process';
  }
  return 'cancelled';
};

// Get status text
const getStatusText = (session: CountingSession): string => {
  if (session.isFinal) {
    return 'Complete';
  }
  if (session.isActive) {
    return 'In Progress';
  }
  return 'Closed';
};

export const CountingSessionsTable: React.FC<CountingSessionsTableProps> = ({
  sessions,
  sessionsLoading,
  searchQuery,
  onSessionClick,
}) => {
  return (
    <div className={styles.tableContainer}>
      <table className={styles.receivesTable}>
        <thead>
          <tr>
            <th>Session Name</th>
            <th>Store</th>
            <th>Members</th>
            <th>Created By</th>
            <th>Created At</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {sessionsLoading ? (
            <tr>
              <td colSpan={6}>
                <div className={styles.loadingState}>
                  <div className={styles.spinner} />
                  <p>Loading counting sessions...</p>
                </div>
              </td>
            </tr>
          ) : sessions.length > 0 ? (
            sessions.map((session) => (
              <tr
                key={session.sessionId}
                className={styles.shipmentRow}
                onClick={() => onSessionClick(session.sessionId)}
              >
                <td>
                  <span className={styles.receiveNumber}>{session.sessionName}</span>
                </td>
                <td>
                  <span className={styles.supplierName}>{session.storeName}</span>
                </td>
                <td>
                  <span className={styles.itemCount}>{session.memberCount}</span>
                </td>
                <td>
                  <span className={styles.supplierName}>{session.createdByName}</span>
                </td>
                <td>{formatDateDisplay(session.createdAt?.split(' ')[0] || '')}</td>
                <td>
                  <span className={`${styles.statusBadge} ${styles[getStatusClassName(session)]}`}>
                    {getStatusText(session)}
                  </span>
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={6}>
                <div className={styles.emptyState}>
                  <svg className={styles.emptyIcon} width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
                    <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                    <rect x="9" y="3" width="6" height="4" rx="1" />
                    <path d="M9 12h6" />
                    <path d="M9 16h6" />
                  </svg>
                  <p className={styles.emptyTitle}>No counting sessions found</p>
                  <p className={styles.emptyDescription}>
                    {searchQuery ? 'Try adjusting your search or filters' : 'No counting sessions yet'}
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

export default CountingSessionsTable;
