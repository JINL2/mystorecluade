/**
 * SessionSelectModal Component
 * Modal for selecting another session to compare/combine with
 */

import React from 'react';
import type { ActiveSession } from '../../../hooks/useReceivingSession';
import styles from './SessionSelectModal.module.css';

interface SessionSelectModalProps {
  isOpen: boolean;
  availableSessions: ActiveSession[];
  onClose: () => void;
  onSelect: (session: ActiveSession) => void;
}

export const SessionSelectModal: React.FC<SessionSelectModalProps> = ({
  isOpen,
  availableSessions,
  onClose,
  onSelect,
}) => {
  if (!isOpen) return null;

  return (
    <div className={styles.modalBackdrop} onClick={onClose}>
      <div className={styles.sessionSelectModal} onClick={(e) => e.stopPropagation()}>
        <div className={styles.modalHeader}>
          <h3>Select Session to Compare</h3>
          <button className={styles.modalCloseButton} onClick={onClose}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M18 6L6 18M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div className={styles.sessionSelectContent}>
          <p className={styles.sessionSelectDescription}>
            Select another active receiving session to compare items with your current session.
          </p>
          {availableSessions.length === 0 ? (
            <div className={styles.noSessionsMessage}>
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="1.5">
                <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                <rect x="9" y="3" width="6" height="4" rx="1" />
              </svg>
              <p>No other active sessions available</p>
            </div>
          ) : (
            <div className={styles.sessionSelectList}>
              {availableSessions.map((session: ActiveSession) => (
                <button
                  key={session.sessionId}
                  className={styles.sessionSelectItem}
                  onClick={() => onSelect(session)}
                >
                  <div className={styles.sessionSelectItemLeft}>
                    <span className={styles.sessionSelectItemName}>{session.sessionName}</span>
                    <span className={styles.sessionSelectItemMeta}>
                      {session.storeName} • Created by {session.createdByName}
                    </span>
                  </div>
                  <div className={styles.sessionSelectItemRight}>
                    <span className={styles.sessionSelectItemMembers}>
                      {session.memberCount} members
                    </span>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M9 18l6-6-6-6" />
                    </svg>
                  </div>
                </button>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default SessionSelectModal;
