import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { TossButton } from '@/shared/components/toss/TossButton';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useAppState } from '@/app/providers/app_state_provider';
import { useCurrency } from '../../hooks/useCurrency';
import { EditCurrencyModal } from '../../components/EditCurrencyModal/EditCurrencyModal';
import { AddCurrencyModal } from '../../components/AddCurrencyModal/AddCurrencyModal';
import { Currency } from '../../../domain/entities/Currency';
import styles from './CurrencyPage.module.css';

export const CurrencyPage: React.FC = () => {
  const { currentCompany, currentUser } = useAppState();
  const { currencies, loading, getAllCurrencyTypes, updateExchangeRate, addCurrency } = useCurrency(
    currentCompany?.company_id || '',
    currentUser?.user_id || ''
  );
  const [editingCurrency, setEditingCurrency] = useState<Currency | null>(null);
  const [showAddModal, setShowAddModal] = useState(false);

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

  const handleSaveExchangeRate = async (currencyId: string, newRate: number) => {
    await updateExchangeRate(currencyId, newRate);
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
                        <TossButton variant="outline" size="sm">Remove</TossButton>
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
        onAddCurrency={addCurrency}
      />

      <EditCurrencyModal
        currency={editingCurrency}
        baseCurrencyCode={primaryCurrency?.code || ''}
        onClose={() => setEditingCurrency(null)}
        onSave={handleSaveExchangeRate}
      />
    </>
  );
};
