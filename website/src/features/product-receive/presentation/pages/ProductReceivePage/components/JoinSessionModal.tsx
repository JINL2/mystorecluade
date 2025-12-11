/**
 * JoinSessionModal Component
 * Modal for joining an existing receiving session
 */

import React from 'react';
import type { Session } from '../ProductReceivePage.types';
import styles from './SessionModals.module.css';

interface JoinSessionModalProps {
  isOpen: boolean;
  sessions: Session[];
  selectedSessionId: string | null;
  isLoading: boolean;
  isJoining: boolean;
  error: string | null;
  onSelectSession: (sessionId: string) => void;
  onClose: () => void;
  onJoin: () => void;
}

export const JoinSessionModal: React.FC<JoinSessionModalProps> = ({
  isOpen,
  sessions,
  selectedSessionId,
  isLoading,
  isJoining,
  error,
  onSelectSession,
  onClose,
  onJoin,
}) => {
  if (!isOpen) return null;

  return (
    <div className={styles.modalOverlay} onClick={onClose}>
      <div className={styles.createSessionModal} onClick={(e) => e.stopPropagation()}>
        {/* Modal Header */}
        <div className={styles.joinSessionHeader}>
          <div className={styles.createSessionIcon}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
              <circle cx="9" cy="7" r="4" />
              <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
              <path d="M16 3.13a4 4 0 0 1 0 7.75" />
            </svg>
          </div>
          <h2 className={styles.createSessionTitle}>Join Existing Session</h2>
          <p className={styles.createSessionSubtitle}>
            Select an active session to join
          </p>
        </div>

        {/* Modal Body */}
        <div className={styles.createSessionBody}>
          {isLoading ? (
            <div className={styles.sessionsLoading}>
              <div className={styles.spinnerSmall} />
              <span>Loading sessions...</span>
            </div>
          ) : sessions.length === 0 ? (
            <div className={styles.noSessions}>
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <circle cx="12" cy="12" r="10" />
                <path d="M8 12h8" />
              </svg>
              <p>No active sessions found</p>
              <span>Create a new session to start receiving</span>
            </div>
          ) : (
            <div className={styles.formGroup}>
              <label className={styles.formLabel}>Active Sessions ({sessions.length})</label>
              <div className={styles.sessionList}>
                {sessions.map((session) => (
                  <button
                    key={session.session_id}
                    type="button"
                    className={`${styles.sessionOption} ${selectedSessionId === session.session_id ? styles.selected : ''}`}
                    onClick={() => onSelectSession(session.session_id)}
                  >
                    <div className={styles.sessionInfo}>
                      <div className={styles.sessionHeader}>
                        <span className={styles.sessionStore}>
                          {session.session_name || session.store_name}
                        </span>
                        <span className={styles.sessionMembers}>
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z" />
                          </svg>
                          {session.member_count}
                        </span>
                      </div>
                      <div className={styles.sessionMetaVertical}>
                        <span className={styles.sessionMetaItem}>
                          {session.store_name}
                        </span>
                        <span className={styles.sessionMetaItem}>
                          Created by {session.created_by_name} · {session.created_at?.slice(0, 16)}
                        </span>
                      </div>
                    </div>
                    {selectedSessionId === session.session_id && (
                      <svg className={styles.checkIcon} width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                      </svg>
                    )}
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Error Message */}
          {error && (
            <div className={styles.errorMessage}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12,2C17.53,2 22,6.47 22,12C22,17.53 17.53,22 12,22C6.47,22 2,17.53 2,12C2,6.47 6.47,2 12,2M15.59,7L12,10.59L8.41,7L7,8.41L10.59,12L7,15.59L8.41,17L12,13.41L15.59,17L17,15.59L13.41,12L17,8.41L15.59,7Z" />
              </svg>
              <span>{error}</span>
            </div>
          )}
        </div>

        {/* Modal Footer */}
        <div className={styles.createSessionFooter}>
          <button
            type="button"
            className={styles.cancelSessionButton}
            onClick={onClose}
            disabled={isJoining}
          >
            Cancel
          </button>
          <button
            type="button"
            className={styles.joinSessionButton}
            onClick={onJoin}
            disabled={!selectedSessionId || sessions.length === 0 || isJoining}
          >
            {isJoining ? (
              <>
                <div className={styles.buttonSpinner} />
                Joining...
              </>
            ) : (
              <>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4" />
                  <polyline points="10 17 15 12 10 7" />
                  <line x1="15" y1="12" x2="3" y2="12" />
                </svg>
                Join Session
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};
