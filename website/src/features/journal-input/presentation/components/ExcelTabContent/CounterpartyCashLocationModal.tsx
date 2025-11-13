/**
 * CounterpartyCashLocationModal Component
 * Modal for selecting counterparty cash location when internal counterparty is selected
 */

import React, { useState, useEffect } from 'react';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector/TossSelector.types';
import styles from './CounterpartyCashLocationModal.module.css';

export interface CounterpartyCashLocationModalProps {
  isOpen: boolean;
  counterpartyName: string;
  linkedCompanyId: string;
  onGetCounterpartyStores?: (linkedCompanyId: string) => Promise<Array<{ storeId: string; storeName: string }>>;
  onGetCounterpartyCashLocations?: (linkedCompanyId: string, storeId?: string | null) => Promise<any[]>;
  onConfirm: (storeId: string, cashLocationId: string) => void;
  onCancel: () => void;
}

export const CounterpartyCashLocationModal: React.FC<CounterpartyCashLocationModalProps> = ({
  isOpen,
  counterpartyName,
  linkedCompanyId,
  onGetCounterpartyStores,
  onGetCounterpartyCashLocations,
  onConfirm,
  onCancel,
}) => {
  const [stores, setStores] = useState<Array<{ storeId: string; storeName: string }>>([]);
  const [cashLocations, setCashLocations] = useState<any[]>([]);
  const [selectedStoreId, setSelectedStoreId] = useState('');
  const [selectedCashLocationId, setSelectedCashLocationId] = useState('');
  const [loadingStores, setLoadingStores] = useState(false);
  const [loadingCashLocations, setLoadingCashLocations] = useState(false);

  // Load stores when modal opens
  useEffect(() => {
    const loadStores = async () => {
      if (!isOpen || !linkedCompanyId || !onGetCounterpartyStores) return;

      setLoadingStores(true);
      try {
        const storesData = await onGetCounterpartyStores(linkedCompanyId);
        setStores(storesData);
      } catch (error) {
        console.error('Error loading counterparty stores:', error);
        setStores([]);
      } finally {
        setLoadingStores(false);
      }
    };

    loadStores();
  }, [isOpen, linkedCompanyId, onGetCounterpartyStores]);

  // Load cash locations when store is selected
  useEffect(() => {
    const loadCashLocations = async () => {
      if (!isOpen || !linkedCompanyId || !onGetCounterpartyCashLocations) {
        setCashLocations([]);
        setSelectedCashLocationId('');
        return;
      }

      setLoadingCashLocations(true);
      try {
        const locationsData = await onGetCounterpartyCashLocations(linkedCompanyId, selectedStoreId || null);
        setCashLocations(locationsData);
      } catch (error) {
        console.error('Error loading counterparty cash locations:', error);
        setCashLocations([]);
      } finally {
        setLoadingCashLocations(false);
      }
    };

    loadCashLocations();
  }, [isOpen, linkedCompanyId, selectedStoreId, onGetCounterpartyCashLocations]);

  // Reset state when modal closes
  useEffect(() => {
    if (!isOpen) {
      setStores([]);
      setCashLocations([]);
      setSelectedStoreId('');
      setSelectedCashLocationId('');
    }
  }, [isOpen]);

  const storeOptions: TossSelectorOption[] = stores.map((store) => ({
    value: store.storeId,
    label: store.storeName,
  }));

  const cashLocationOptions: TossSelectorOption[] = cashLocations.map((location) => ({
    value: location.locationId,
    label: location.locationName,
    description: location.locationType || undefined,
  }));

  const handleConfirm = () => {
    if (selectedStoreId && selectedCashLocationId) {
      onConfirm(selectedStoreId, selectedCashLocationId);
    }
  };

  const handleCancel = () => {
    onCancel();
  };

  const isValid = selectedStoreId && selectedCashLocationId;

  if (!isOpen) return null;

  return (
    <>
      {/* Backdrop */}
      <div className={styles.backdrop} onClick={handleCancel} />

      {/* Modal */}
      <div className={styles.modal}>
        <div className={styles.modalHeader}>
          <h3 className={styles.modalTitle}>Select Counterparty Cash Location</h3>
          <button className={styles.closeButton} onClick={handleCancel} type="button">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
            </svg>
          </button>
        </div>

        <div className={styles.modalBody}>
          <p className={styles.modalDescription}>
            Select the store and cash location for <strong>{counterpartyName}</strong>
          </p>

          <TossSelector
            label="Counterparty Store"
            placeholder={loadingStores ? "Loading stores..." : "Select store"}
            value={selectedStoreId}
            options={storeOptions}
            onChange={(value) => {
              setSelectedStoreId(value);
              setSelectedCashLocationId('');
            }}
            required={true}
            searchable={true}
            fullWidth={true}
            emptyMessage={loadingStores ? "Loading..." : "No stores available"}
            disabled={loadingStores}
          />

          <div className={styles.selectorSpacing}>
            <TossSelector
              label="Counterparty Cash Location"
              placeholder={loadingCashLocations ? "Loading locations..." : "Select cash location"}
              value={selectedCashLocationId}
              options={cashLocationOptions}
              onChange={(value) => setSelectedCashLocationId(value)}
              required={true}
              searchable={true}
              fullWidth={true}
              emptyMessage={loadingCashLocations ? "Loading..." : "No cash locations available"}
              disabled={loadingCashLocations || !selectedStoreId}
            />
          </div>
        </div>

        <div className={styles.modalFooter}>
          <button className={styles.cancelButton} onClick={handleCancel} type="button">
            Cancel
          </button>
          <button
            className={styles.confirmButton}
            onClick={handleConfirm}
            disabled={!isValid}
            type="button"
          >
            Confirm
          </button>
        </div>
      </div>
    </>
  );
};

export default CounterpartyCashLocationModal;
