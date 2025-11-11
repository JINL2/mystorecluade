import React, { useState, useEffect } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector/TossSelector.types';
import { CurrencyType } from '../../../domain/repositories/ICurrencyRepository';
import { Currency } from '../../../domain/entities/Currency';
import styles from './AddCurrencyModal.module.css';

interface AddCurrencyModalProps {
  isOpen: boolean;
  onClose: () => void;
  existingCurrencies: Currency[];
  baseCurrencyCode: string;
  onGetAllCurrencyTypes: () => Promise<CurrencyType[]>;
  onAddCurrency: (currencyId: string, exchangeRate: number) => Promise<{ success: boolean; error?: string }>;
}

export const AddCurrencyModal: React.FC<AddCurrencyModalProps> = ({
  isOpen,
  onClose,
  existingCurrencies,
  baseCurrencyCode,
  onGetAllCurrencyTypes,
  onAddCurrency
}) => {
  const [allCurrencyTypes, setAllCurrencyTypes] = useState<CurrencyType[]>([]);
  const [selectedCurrencyId, setSelectedCurrencyId] = useState('');
  const [exchangeRate, setExchangeRate] = useState('');
  const [liveRate, setLiveRate] = useState<number | null>(null);
  const [fetchingLiveRate, setFetchingLiveRate] = useState(false);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (isOpen) {
      loadAllCurrencies();
      setSelectedCurrencyId('');
      setExchangeRate('');
      setLiveRate(null);
    }
  }, [isOpen]);

  const loadAllCurrencies = async () => {
    const types = await onGetAllCurrencyTypes();
    setAllCurrencyTypes(types);
  };

  const availableCurrencies = allCurrencyTypes.filter(ct => {
    const isExisting = existingCurrencies.some(ec => ec.currencyId === ct.currency_id);
    return !isExisting;
  });

  const currencyOptions: TossSelectorOption[] = availableCurrencies.map(ct => ({
    value: ct.currency_id,
    label: `${ct.code}`,
    description: ct.name,
    badge: ct.symbol
  }));

  const selectedCurrency = allCurrencyTypes.find(ct => ct.currency_id === selectedCurrencyId);

  const handleCurrencyChange = (value: string) => {
    setSelectedCurrencyId(value);
    setLiveRate(null);
  };

  const fetchLiveExchangeRate = async () => {
    if (!selectedCurrency || !baseCurrencyCode) return;

    setFetchingLiveRate(true);
    try {
      const response = await fetch(`https://api.exchangerate-api.com/v4/latest/${selectedCurrency.code}`);
      const data = await response.json();
      const rate = data.rates[baseCurrencyCode];
      if (rate) {
        setLiveRate(rate);
        setExchangeRate(rate.toFixed(4));
      } else {
        const reverseResponse = await fetch(`https://api.exchangerate-api.com/v4/latest/${baseCurrencyCode}`);
        const reverseData = await reverseResponse.json();
        if (reverseData.rates[selectedCurrency.code]) {
          const reverseRate = 1 / reverseData.rates[selectedCurrency.code];
          setLiveRate(reverseRate);
          setExchangeRate(reverseRate.toFixed(4));
        }
      }
    } catch (error) {
      console.error('Failed to fetch live exchange rate:', error);
    } finally {
      setFetchingLiveRate(false);
    }
  };

  const handleUseLiveRate = () => {
    if (liveRate) {
      setExchangeRate(liveRate.toFixed(4));
    }
  };

  const handleSave = async () => {
    if (!selectedCurrencyId || !exchangeRate) return;

    const rate = parseFloat(exchangeRate);
    if (isNaN(rate) || rate <= 0) {
      alert('Please enter a valid exchange rate');
      return;
    }

    setSaving(true);
    const result = await onAddCurrency(selectedCurrencyId, rate);
    setSaving(false);

    if (result.success) {
      onClose();
    } else {
      alert(result.error || 'Failed to add currency');
    }
  };

  const handleOverlayClick = (e: React.MouseEvent) => {
    if (e.target === e.currentTarget) {
      onClose();
    }
  };

  if (!isOpen) return null;

  return (
    <div className={`${styles.modalOverlay} ${isOpen ? styles.show : ''}`} onClick={handleOverlayClick}>
      <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
        <div className={styles.modalHeader}>
          <h2 className={styles.modalTitle}>Add New Currency</h2>
          <button className={styles.modalCloseBtn} onClick={onClose}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        <div className={styles.modalBody}>
          <TossSelector
            label="Select Currency"
            placeholder="Select currency"
            value={selectedCurrencyId}
            options={currencyOptions}
            onChange={handleCurrencyChange}
            searchable
            showDescriptions
            showBadges
            fullWidth
            emptyMessage="No currencies available"
            maxHeight="300px"
          />

          {selectedCurrency && (
            <>
              <div className={styles.currencyInfo}>
                <div className={styles.currencyInfoItem}>
                  <span className={styles.currencyInfoLabel}>Code:</span>
                  <span className={styles.currencyInfoValue}>{selectedCurrency.code}</span>
                </div>
                <div className={styles.currencyInfoItem}>
                  <span className={styles.currencyInfoLabel}>Name:</span>
                  <span className={styles.currencyInfoValue}>{selectedCurrency.name}</span>
                </div>
                <div className={styles.currencyInfoItem}>
                  <span className={styles.currencyInfoLabel}>Symbol:</span>
                  <span className={styles.currencyInfoValue}>{selectedCurrency.symbol}</span>
                </div>
              </div>

              <div className={styles.formGroup}>
                <label className={styles.formLabel}>
                  Exchange Rate (1 {selectedCurrency.code} = ? {baseCurrencyCode})
                </label>
                <div className={styles.exchangeRateWrapper}>
                  <input
                    type="number"
                    step="0.0001"
                    className={styles.formInput}
                    value={exchangeRate}
                    onChange={(e) => setExchangeRate(e.target.value)}
                    placeholder="Enter exchange rate"
                  />
                  <TossButton
                    variant="outline"
                    size="sm"
                    onClick={fetchLiveExchangeRate}
                    disabled={fetchingLiveRate}
                  >
                    {fetchingLiveRate ? 'Fetching...' : 'Get Live Rate'}
                  </TossButton>
                </div>
              </div>

              {liveRate && (
                <div className={styles.liveRateInfo}>
                  <span className={styles.liveRateLabel}>Live Rate:</span>
                  <span className={styles.liveRateValue}>{liveRate.toFixed(4)}</span>
                  <TossButton variant="text" size="sm" onClick={handleUseLiveRate}>
                    Use This Rate
                  </TossButton>
                </div>
              )}
            </>
          )}
        </div>

        <div className={styles.modalFooter}>
          <TossButton variant="outline" size="md" onClick={onClose}>
            Cancel
          </TossButton>
          <TossButton
            variant="primary"
            size="md"
            onClick={handleSave}
            disabled={!selectedCurrencyId || !exchangeRate || saving}
          >
            {saving ? 'Adding...' : 'Add Currency'}
          </TossButton>
        </div>
      </div>
    </div>
  );
};
