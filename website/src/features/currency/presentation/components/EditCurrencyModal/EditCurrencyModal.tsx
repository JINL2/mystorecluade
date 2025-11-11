import React, { useState, useEffect } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { Currency } from '../../../domain/entities/Currency';
import styles from './EditCurrencyModal.module.css';

interface EditCurrencyModalProps {
  currency: Currency | null;
  baseCurrencyCode: string;
  onClose: () => void;
  onSave: (currencyId: string, newRate: number) => Promise<void>;
}

export const EditCurrencyModal: React.FC<EditCurrencyModalProps> = ({
  currency,
  baseCurrencyCode,
  onClose,
  onSave
}) => {
  const [exchangeRate, setExchangeRate] = useState<string>('1.0000');
  const [liveRate, setLiveRate] = useState<number | null>(null);
  const [loadingLiveRate, setLoadingLiveRate] = useState(false);
  const [liveRateError, setLiveRateError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (currency) {
      // Set initial exchange rate value
      setExchangeRate(currency.exchangeRate?.toString() || '1.0000');

      // Fetch live exchange rate
      if (currency.code !== baseCurrencyCode) {
        fetchLiveExchangeRate(currency.code, baseCurrencyCode);
      }
    }
  }, [currency, baseCurrencyCode]);

  const fetchLiveExchangeRate = async (fromCurrency: string, toCurrency: string) => {
    setLoadingLiveRate(true);
    setLiveRateError(null);
    setLiveRate(null);

    try {
      const response = await fetch(`https://api.exchangerate-api.com/v4/latest/${fromCurrency}`);

      if (!response.ok) {
        throw new Error('Failed to fetch exchange rate');
      }

      const data = await response.json();
      const rate = data.rates[toCurrency];

      if (rate) {
        setLiveRate(rate);
      } else {
        throw new Error('Exchange rate not available');
      }
    } catch (error) {
      console.error('Error fetching live rate:', error);

      // Try reverse rate
      try {
        const reverseResponse = await fetch(`https://api.exchangerate-api.com/v4/latest/${toCurrency}`);
        const reverseData = await reverseResponse.json();

        if (reverseData.rates[fromCurrency]) {
          const reverseRate = 1 / reverseData.rates[fromCurrency];
          setLiveRate(reverseRate);
        } else {
          setLiveRateError('Exchange rate currently unavailable');
        }
      } catch (altError) {
        setLiveRateError('Unable to fetch live rate');
      }
    } finally {
      setLoadingLiveRate(false);
    }
  };

  const useLiveRate = () => {
    if (liveRate) {
      setExchangeRate(liveRate.toFixed(4));
      setLiveRate(null);
    }
  };

  const handleSave = async () => {
    if (!currency) return;

    const rate = parseFloat(exchangeRate);
    if (isNaN(rate) || rate <= 0) {
      alert('Please enter a valid exchange rate');
      return;
    }

    setSaving(true);
    try {
      await onSave(currency.currencyId, rate);
      onClose();
    } catch (error) {
      console.error('Error saving:', error);
      alert('Failed to save exchange rate');
    } finally {
      setSaving(false);
    }
  };

  const handleOverlayClick = (e: React.MouseEvent) => {
    if (e.target === e.currentTarget) {
      onClose();
    }
  };

  if (!currency) return null;

  const showUseLiveRateButton = liveRate !== null && Math.abs(parseFloat(exchangeRate) - liveRate) > 0.0001;

  return (
    <div className={`${styles.modalOverlay} ${currency ? styles.show : ''}`} onClick={handleOverlayClick}>
      <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
        <div className={styles.modalHeader}>
          <h2 className={styles.modalTitle}>Edit Currency Details</h2>
          <button className={styles.modalCloseBtn} onClick={onClose}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        <div className={styles.modalBody}>
          {/* Currency Information Display */}
          <div className={styles.modalInfoGroup}>
            <div className={styles.modalInfoItem}>
              <span className={styles.modalInfoLabel}>Currency Code</span>
              <span className={styles.modalInfoValue}>{currency.code}</span>
            </div>
            <div className={styles.modalInfoItem}>
              <span className={styles.modalInfoLabel}>Currency Name</span>
              <span className={styles.modalInfoValue}>{currency.name}</span>
            </div>
            <div className={styles.modalInfoItem}>
              <span className={styles.modalInfoLabel}>Symbol</span>
              <span className={styles.modalInfoValue}>{currency.symbol}</span>
            </div>
          </div>

          {/* Editable Fields */}
          <div className={styles.modalFormGroup}>
            <label className={styles.modalLabel}>Exchange Rate</label>
            <input
              type="number"
              className={styles.modalInput}
              step="0.0001"
              min="0"
              placeholder="1.0000"
              value={exchangeRate}
              onChange={(e) => setExchangeRate(e.target.value)}
            />
            <div className={styles.exchangeRateInfo}>
              <div className={styles.liveRateDisplay}>
                {loadingLiveRate && <span className={styles.loadingRate}>Loading live rate...</span>}
                {!loadingLiveRate && liveRateError && <span className={styles.rateError}>{liveRateError}</span>}
                {!loadingLiveRate && liveRate && !liveRateError && (
                  <span className={styles.liveRateText}>
                    <strong>Live Rate:</strong> 1 {currency.code} = <span className={styles.rateValue}>{liveRate.toFixed(4)}</span> <span className={styles.baseCurrency}>{baseCurrencyCode}</span>
                  </span>
                )}
                {!loadingLiveRate && currency.code === baseCurrencyCode && (
                  <span className={styles.liveRateText}>
                    Exchange rate to base currency: <span className={styles.rateValue}>1.0000</span>
                  </span>
                )}
              </div>
              {showUseLiveRateButton && (
                <button type="button" className={styles.useLiveRateBtn} onClick={useLiveRate}>
                  Use Live Rate
                </button>
              )}
            </div>
          </div>
        </div>

        <div className={styles.modalFooter}>
          <TossButton variant="outline" size="md" onClick={onClose} disabled={saving}>
            Cancel
          </TossButton>
          <TossButton variant="primary" size="md" onClick={handleSave} disabled={saving}>
            {saving ? 'Saving...' : 'Save Changes'}
          </TossButton>
        </div>
      </div>
    </div>
  );
};
