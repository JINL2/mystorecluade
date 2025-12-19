/**
 * CreateReceivingSessionModal Component
 * Modal for creating a new receiving session with store selection and optional shipment
 */

import React from 'react';
import styles from './SessionModals.module.css';

interface Store {
  store_id: string;
  store_name: string;
}

interface Shipment {
  shipment_id: string;
  shipment_number: string;
  supplier_name: string;
  status: string;
}

interface CreateReceivingSessionModalProps {
  isOpen: boolean;
  stores: Store[];
  shipments: Shipment[];
  selectedStoreId: string | null;
  selectedShipmentId: string | null;
  sessionName: string;
  isCreating: boolean;
  error: string | null;
  onSelectStore: (storeId: string) => void;
  onSelectShipment: (shipmentId: string | null) => void;
  onSessionNameChange: (name: string) => void;
  onClose: () => void;
  onCreate: () => void;
}

export const CreateReceivingSessionModal: React.FC<CreateReceivingSessionModalProps> = ({
  isOpen,
  stores,
  shipments,
  selectedStoreId,
  selectedShipmentId,
  sessionName,
  isCreating,
  error,
  onSelectStore,
  onSelectShipment,
  onSessionNameChange,
  onClose,
  onCreate,
}) => {
  if (!isOpen) return null;

  // Filter shipments that are not completed (only shipped, partial, in_progress)
  const availableShipments = shipments.filter(
    (s) => s.status !== 'completed' && s.status !== 'cancelled'
  );

  return (
    <div className={styles.modalOverlay} onClick={onClose}>
      <div className={styles.createSessionModal} onClick={(e) => e.stopPropagation()}>
        {/* Modal Header */}
        <div className={styles.createSessionHeader}>
          <div className={styles.createSessionIcon}>
            <svg width="32" height="32" viewBox="0 0 24 24" fill="#0064FF">
              <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
              <polyline points="3.27 6.96 12 12.01 20.73 6.96" fill="none" stroke="white" strokeWidth="1.5" />
              <line x1="12" y1="22.08" x2="12" y2="12" stroke="white" strokeWidth="1.5" />
            </svg>
          </div>
          <h2 className={styles.createSessionTitle}>Create Receiving Session</h2>
          <p className={styles.createSessionSubtitle}>
            Select a store and optionally link to a shipment
          </p>
        </div>

        {/* Modal Body */}
        <div className={styles.createSessionBody}>
          {/* Store Selection */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>
              Store Location <span className={styles.required}>*</span>
            </label>
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

          {/* Shipment Selection (Optional) */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>
              Link to Shipment <span className={styles.optional}>(Optional)</span>
            </label>
            <div className={styles.shipmentSelectWrapper}>
              <select
                className={styles.shipmentSelect}
                value={selectedShipmentId || ''}
                onChange={(e) => onSelectShipment(e.target.value || null)}
              >
                <option value="">No shipment (standalone receiving)</option>
                {availableShipments.map((shipment) => (
                  <option key={shipment.shipment_id} value={shipment.shipment_id}>
                    {shipment.shipment_number} - {shipment.supplier_name}
                  </option>
                ))}
              </select>
              <svg
                className={styles.selectIcon}
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
            <p className={styles.formHint}>
              Select a shipment to track receiving against shipped items, or leave empty for manual receiving.
            </p>
          </div>

          {/* Session Name Input */}
          <div className={styles.formGroup}>
            <label className={styles.formLabel}>
              Session Name <span className={styles.optional}>(Optional)</span>
            </label>
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
