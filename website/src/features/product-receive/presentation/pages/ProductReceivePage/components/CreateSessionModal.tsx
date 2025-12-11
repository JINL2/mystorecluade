/**
 * CreateSessionModal Component
 * Modal for creating a new receiving session with store selection
 */

import React from 'react';
import styles from './SessionModals.module.css';

interface Store {
  store_id: string;
  store_name: string;
}

interface CreateSessionModalProps {
  isOpen: boolean;
  stores: Store[];
  selectedStoreId: string | null;
  sessionName: string;
  isCreating: boolean;
  error: string | null;
  onSelectStore: (storeId: string) => void;
  onSessionNameChange: (name: string) => void;
  onClose: () => void;
  onCreate: () => void;
}

export const CreateSessionModal: React.FC<CreateSessionModalProps> = ({
  isOpen,
  stores,
  selectedStoreId,
  sessionName,
  isCreating,
  error,
  onSelectStore,
  onSessionNameChange,
  onClose,
  onCreate,
}) => {
  if (!isOpen) return null;

  return (
    <div className={styles.modalOverlay} onClick={onClose}>
      <div className={styles.createSessionModal} onClick={(e) => e.stopPropagation()}>
        {/* Modal Header */}
        <div className={styles.createSessionHeader}>
          <div className={styles.createSessionIcon}>
            <svg width="32" height="32" viewBox="0 0 24 24" fill="#0064FF">
              <circle cx="12" cy="12" r="10" />
              <line x1="12" y1="8" x2="12" y2="16" stroke="white" strokeWidth="2" />
              <line x1="8" y1="12" x2="16" y2="12" stroke="white" strokeWidth="2" />
            </svg>
          </div>
          <h2 className={styles.createSessionTitle}>Create New Session</h2>
          <p className={styles.createSessionSubtitle}>
            Select a store to start receiving items
          </p>
        </div>

        {/* Modal Body */}
        <div className={styles.createSessionBody}>
          {/* Store Selection */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>Store Location</label>
            <div className={styles.storeList}>
              {stores.length === 0 ? (
                <div className={styles.noStores}>No stores available</div>
              ) : (
                stores.map((store) => (
                  <button
                    key={store.store_id}
                    type="button"
                    className={`${styles.storeOption} ${selectedStoreId === store.store_id ? styles.selected : ''}`}
                    onClick={() => onSelectStore(store.store_id)}
                  >
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M10,20V14H14V20H19V12H22L12,3L2,12H5V20H10Z" />
                    </svg>
                    <span>{store.store_name}</span>
                    {selectedStoreId === store.store_id && (
                      <svg className={styles.checkIcon} width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z" />
                      </svg>
                    )}
                  </button>
                ))
              )}
            </div>
          </div>

          {/* Session Name Input */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>Session Name (Optional)</label>
            <input
              type="text"
              className={styles.sessionNameInput}
              placeholder="Enter session name..."
              value={sessionName}
              onChange={(e) => onSessionNameChange(e.target.value)}
              maxLength={100}
            />
          </div>

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
            disabled={isCreating}
          >
            Cancel
          </button>
          <button
            type="button"
            className={styles.createSessionButton}
            onClick={onCreate}
            disabled={!selectedStoreId || isCreating}
          >
            {isCreating ? (
              <>
                <div className={styles.buttonSpinner} />
                Creating...
              </>
            ) : (
              <>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                  <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                  <line x1="12" y1="22.08" x2="12" y2="12" />
                </svg>
                Create Session
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};
