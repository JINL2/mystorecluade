/**
 * ReceivingSessionsTable Component
 * Displays list of receiving sessions (same design as CountingSessionsTable)
 */

import React from 'react';
import type { ReceivingSession } from '../../../hooks/useReceivingSessionList';
import styles from '../ProductReceivePage.module.css';

interface ReceivingSessionsTableProps {
  sessions: ReceivingSession[];
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
const getStatusClassName = (session: ReceivingSession): string => {
  if (session.isFinal) {
    return 'complete';
  }
  if (session.isActive) {
    return 'process';
  }
  return 'cancelled';
};

// Check if session is closed (not clickable)
const isSessionClosed = (session: ReceivingSession): boolean => {
  return !session.isActive && !session.isFinal;
};

// Get status text
const getStatusText = (session: ReceivingSession): string => {
  if (session.isFinal) {
    return 'Complete';
  }
  if (session.isActive) {
    return 'In Progress';
  }
  return 'Closed';
};

export const ReceivingSessionsTable: React.FC<ReceivingSessionsTableProps> = ({
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
            <th>Shipment</th>
            <th>Members</th>
            <th>Created By</th>
            <th>Created At</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {sessionsLoading ? (
            <tr>
              <td colSpan={7}>
                <div className={styles.loadingState}>
                  <div className={styles.spinner} />
                  <p>Loading receiving sessions...</p>
                </div>
              </td>
            </tr>
          ) : sessions.length > 0 ? (
            sessions.map((session) => (
              <tr
                key={session.sessionId}
                className={`${styles.shipmentRow} ${isSessionClosed(session) ? styles.disabled : ''}`}
                onClick={() => onSessionClick(session.sessionId)}
                style={{ cursor: isSessionClosed(session) ? 'default' : 'pointer' }}
              >
                <td>
                  <span className={styles.receiveNumber}>{session.sessionName}</span>
                </td>
                <td>
                  <span className={styles.supplierName}>{session.storeName}</span>
                </td>
                <td>
                  <span className={session.shipmentNumber ? styles.receiveNumber : styles.noShipment}>
                    {session.shipmentNumber || '-'}
                  </span>
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
              <td colSpan={7}>
                <div className={styles.emptyState}>
                  <svg className={styles.emptyIcon} width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                    <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                    <line x1="12" y1="22.08" x2="12" y2="12" />
                  </svg>
                  <p className={styles.emptyTitle}>No receiving sessions found</p>
                  <p className={styles.emptyDescription}>
                    {searchQuery ? 'Try adjusting your search' : 'Create a new receiving session to get started'}
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

export default ReceivingSessionsTable;
