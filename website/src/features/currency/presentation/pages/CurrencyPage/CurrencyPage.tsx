import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { TossButton } from '@/shared/components/toss/TossButton';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { useAppState } from '@/app/providers/app_state_provider';
import { useCurrency } from '../../hooks/useCurrency';
import { EditCurrencyModal } from '../../components/EditCurrencyModal/EditCurrencyModal';
import { AddCurrencyModal } from '../../components/AddCurrencyModal/AddCurrencyModal';
import { Currency } from '../../../domain/entities/Currency';
import styles from './CurrencyPage.module.css';

export const CurrencyPage: React.FC = () => {
  const { currentCompany, currentUser } = useAppState();

  // Get userId - try multiple sources like backup does
  let userId = currentUser?.user_id || '';
  if (!userId) {
    try {
      const storedUser = sessionStorage.getItem('userData') || localStorage.getItem('userData') || localStorage.getItem('user');
      if (storedUser) {
        const parsedUser = JSON.parse(storedUser);
        userId = parsedUser.user_id || '';
      }
    } catch (e) {
      console.error('Failed to parse stored user data:', e);
    }
  }

  const { currencies, loading, getAllCurrencyTypes, updateExchangeRate, addCurrency, removeCurrency } = useCurrency(
    currentCompany?.company_id || '',
    userId
  );
  const [editingCurrency, setEditingCurrency] = useState<Currency | null>(null);
  const [showAddModal, setShowAddModal] = useState(false);
  const [notification, setNotification] = useState<{ variant: 'success' | 'error'; message: string } | null>(null);
  const [currencyToRemove, setCurrencyToRemove] = useState<Currency | null>(null);
  const [isRemoving, setIsRemoving] = useState(false);

  if (loading) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.pageContainer}>
          <main className={styles.pageContent}>
            <LoadingAnimation size="large" fullscreen />
          </main>
        </div>
      </>
    );
  }

  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="setting" />
        <div className={styles.pageContainer}>
          <main className={styles.pageContent}>
            <div className={styles.emptyContainer}>
              <h2 className={styles.emptyTitle}>No Company Selected</h2>
              <p className={styles.emptyText}>Please select a company to manage currencies</p>
            </div>
          </main>
        </div>
      </>
    );
  }

  const totalCurrencies = currencies.length;
  const activeCurrencies = currencies.length;
  const primaryCurrency = currencies.find(c => c.isDefault);

  const handleEditCurrency = (currency: Currency) => {
    setEditingCurrency(currency);
  };

  const handleSaveExchangeRate = async (currencyId: string, newRate: number | string) => {
    return await updateExchangeRate(currencyId, newRate);
  };

  const handleRemoveCurrency = (currency: Currency) => {
    // Prevent removing base currency
    if (currency.isDefault) {
      setNotification({
        variant: 'error',
        message: 'Cannot remove the base currency. Please change the base currency in company settings first.'
      });
      setTimeout(() => setNotification(null), 3000);
      return;
    }

    // Show confirm modal
    setCurrencyToRemove(currency);
  };

  const handleConfirmRemove = async () => {
    if (!currencyToRemove) return;

    setIsRemoving(true);
    const result = await removeCurrency(currencyToRemove.currencyId);
    setIsRemoving(false);

    if (result.success) {
      setNotification({
        variant: 'success',
        message: `${currencyToRemove.code} removed successfully!`
      });
      setTimeout(() => setNotification(null), 2000);
      setCurrencyToRemove(null);
    } else {
      setNotification({
        variant: 'error',
        message: result.error || 'Failed to remove currency'
      });
      setTimeout(() => setNotification(null), 3000);
    }
  };

  return (
    <>
      <Navbar activeItem="setting" />
      <div className={styles.pageContainer}>
        <main className={styles.pageContent}>
          <div className={styles.pageHeader}>
            <div className={styles.pageHeaderContent}>
              <h1 className={styles.pageTitle}>Currency Settings</h1>
              <p className={styles.pageSubtitle}>Manage your company's currencies and exchange rates</p>
            </div>
            <TossButton variant="primary" size="md" onClick={() => setShowAddModal(true)}>
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style={{ marginRight: '8px' }}>
                <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
              </svg>
              Add Currency
            </TossButton>
          </div>

          {currencies.length > 0 && (
            <div className={styles.statsCard}>
              <div className={styles.statsGrid}>
                <div className={styles.statItem}>
                  <p className={styles.statValue}>{totalCurrencies}</p>
                  <p className={styles.statLabel}>Total Currencies</p>
                </div>
                <div className={styles.statItem}>
                  <p className={styles.statValue}>{activeCurrencies}</p>
                  <p className={styles.statLabel}>Active Currencies</p>
                </div>
                <div className={styles.statItem}>
                  <p className={styles.statValue}>{primaryCurrency?.code || '-'}</p>
                  <p className={styles.statLabel}>Primary Currency</p>
                </div>
              </div>
            </div>
          )}

          <div className={styles.currencySection}>
            <div className={styles.sectionHeader}>
              <h2 className={styles.sectionTitle}>Configured Currencies</h2>
            </div>

            <div className={styles.currencyGrid}>
              {currencies.map(c => (
                <div key={c.currencyId} className={styles.currencyCard}>
                  <div className={styles.currencyCardHeader}>
                    <div className={styles.currencyIconWrapper}>
                      <span className={styles.currencySymbol}>{c.symbol}</span>
                    </div>
                    <div className={styles.currencyHeaderInfo}>
                      <h3 className={styles.currencyCode}>{c.code}</h3>
                      <p className={styles.currencyName}>{c.name}</p>
                    </div>
                    {c.isDefault && <span className={styles.currencyBadgePrimary}>DEFAULT</span>}
                  </div>
                  <div className={styles.currencyCardBody}>
                    <div className={styles.currencyDetails}>
                      <div className={styles.currencyDetailItem}>
                        <span className={styles.currencyDetailLabel}>Exchange Rate</span>
                        <span className={styles.currencyDetailValue}>{(c.exchangeRate || 1.0).toFixed(4)}</span>
                      </div>
                    </div>
                  </div>
                  <div className={styles.currencyCardFooter}>
                    <div className={styles.currencyActions}>
                      <TossButton variant="outline" size="sm" onClick={() => handleEditCurrency(c)}>Edit</TossButton>
                      {!c.isDefault && (
                        <TossButton variant="outline" size="sm" onClick={() => handleRemoveCurrency(c)}>Remove</TossButton>
                      )}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </main>
      </div>

      <AddCurrencyModal
        isOpen={showAddModal}
        onClose={() => setShowAddModal(false)}
        existingCurrencies={currencies}
        baseCurrencyCode={primaryCurrency?.code || ''}
        onGetAllCurrencyTypes={getAllCurrencyTypes}
        onAddCurrency={async (currencyId: string, exchangeRate: number | string) => {
          const result = await addCurrency(currencyId, exchangeRate);
          if (result.success) {
            // Find currency name for success message
            const allTypes = await getAllCurrencyTypes();
            const addedCurrency = allTypes.find(ct => ct.currencyId === currencyId);
            setNotification({
              variant: 'success',
              message: `${addedCurrency?.code || 'Currency'} added successfully!`
            });
            setTimeout(() => setNotification(null), 2000);
            // Modal will be closed by AddCurrencyModal's onClose() call
          }
          return result;
        }}
      />

      <EditCurrencyModal
        currency={editingCurrency}
        baseCurrencyCode={primaryCurrency?.code || ''}
        onClose={() => setEditingCurrency(null)}
        onSave={handleSaveExchangeRate}
      />

      {/* Global Notification Message */}
      <ErrorMessage
        variant={notification?.variant || 'error'}
        message={notification?.message || ''}
        isOpen={!!notification}
        onClose={() => setNotification(null)}
        autoCloseDuration={2000}
        zIndex={10000}
      />

      {/* Remove Currency Confirmation Modal */}
      <ConfirmModal
        isOpen={!!currencyToRemove}
        onClose={() => setCurrencyToRemove(null)}
        onConfirm={handleConfirmRemove}
        variant="error"
        title="Remove Currency"
        message={`Are you sure you want to remove ${currencyToRemove?.code}? This action cannot be undone.`}
        confirmText="Remove"
        cancelText="Cancel"
        confirmButtonVariant="error"
        isLoading={isRemoving}
        closeOnBackdropClick={true}
        closeOnEscape={!isRemoving}
      >
        {currencyToRemove && (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', marginTop: '16px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <span style={{ fontSize: '14px', fontWeight: 600, color: '#6C757D' }}>Currency Code:</span>
              <span style={{ fontSize: '14px', fontWeight: 600, color: '#212529' }}>{currencyToRemove.code}</span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <span style={{ fontSize: '14px', fontWeight: 600, color: '#6C757D' }}>Currency Name:</span>
              <span style={{ fontSize: '14px', fontWeight: 500, color: '#212529' }}>{currencyToRemove.name}</span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <span style={{ fontSize: '14px', fontWeight: 600, color: '#6C757D' }}>Exchange Rate:</span>
              <span style={{ fontFamily: 'Pretendard, -apple-system, BlinkMacSystemFont, system-ui, sans-serif', fontSize: '14px', fontWeight: 600, color: '#212529' }}>
                {(currencyToRemove.exchangeRate || 1.0).toFixed(4)}
              </span>
            </div>
          </div>
        )}
      </ConfirmModal>
    </>
  );
};
