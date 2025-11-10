/**
 * CashEndingPage Component
 * Cash ending management with daily reconciliation
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { useCashEnding } from '../../hooks/useCashEnding';
import { useCashEndingJournal } from '../../hooks/useCashEndingJournal';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import type { CashEndingPageProps } from './CashEndingPage.types';
import styles from './CashEndingPage.module.css';

const getLocationIcon = (locationType: string) => {
  switch (locationType) {
    case 'bank':
      return (
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
          <path d="M12 4L4 8V9H20V9L12 4Z" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"/>
          <rect x="6" y="10" width="2" height="6" stroke="currentColor" strokeWidth="2"/>
          <rect x="11" y="10" width="2" height="6" stroke="currentColor" strokeWidth="2"/>
          <rect x="16" y="10" width="2" height="6" stroke="currentColor" strokeWidth="2"/>
          <rect x="4" y="17" width="16" height="2" fill="currentColor"/>
        </svg>
      );
    case 'vault':
      return (
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
          <rect x="5" y="5" width="16" height="16" rx="2" stroke="currentColor" strokeWidth="2.5"/>
          <circle cx="12" cy="12" r="3" stroke="currentColor" strokeWidth="2"/>
          <circle cx="12" cy="12" r="1" fill="currentColor"/>
        </svg>
      );
    case 'cash':
    default:
      return (
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
          <ellipse cx="12" cy="8" rx="6" ry="2.5" stroke="currentColor" strokeWidth="2.5"/>
          <path d="M6 8V12C6 13.1 8.686 14 12 14C15.314 14 18 13.1 18 12V8" stroke="currentColor" strokeWidth="2.5"/>
          <path d="M6 12V16C6 17.1 8.686 18 12 18C15.314 18 18 17.1 18 16V12" stroke="currentColor" strokeWidth="2.5"/>
        </svg>
      );
  }
};

const getIconBackground = (locationType: string) => {
  switch (locationType) {
    case 'bank': return '#E3F2FD';
    case 'vault': return '#FFF3E0';
    case 'cash': return '#E8F5E9';
    default: return '#F5F5F5';
  }
};

const getIconTextColor = (locationType: string) => {
  switch (locationType) {
    case 'bank': return '#1976D2';
    case 'vault': return '#F57C00';
    case 'cash': return '#2E7D32';
    default: return '#616161';
  }
};

const formatCurrency = (amount: number) => {
  if (amount === null || amount === undefined || amount === 0) {
    return '0 ₫';
  }
  return amount.toLocaleString('vi-VN') + ' ₫';
};

export const CashEndingPage: React.FC<CashEndingPageProps> = () => {
  const { currentCompany, currentStore, setCurrentStore, currentUser } = useAppState();
  const companyId = currentCompany?.company_id || '';
  const storeId = currentStore?.store_id || null;
  const { cashEndings, loading, error, refresh } = useCashEnding(companyId, storeId);
  const { createJournalEntry, isLoading: isCreatingJournal } = useCashEndingJournal();

  // Modal state
  const [modalState, setModalState] = useState<{
    isOpen: boolean;
    type: 'error' | 'exchange' | null;
    locationId: string | null;
    locationName: string;
    storeId: string | null;
    difference: number;
  }>({
    isOpen: false,
    type: null,
    locationId: null,
    locationName: '',
    storeId: null,
    difference: 0
  });

  // Handle store selection
  const handleStoreSelect = (selectedStoreId: string | null) => {
    if (!selectedStoreId) {
      // "All Stores" selected
      setCurrentStore(null);
    } else {
      // Find the selected store from company's stores
      const selectedStore = currentCompany?.stores?.find(s => s.store_id === selectedStoreId);
      if (selectedStore) {
        setCurrentStore(selectedStore);
      }
    }
  };

  // Handle Make Error button click
  const handleMakeError = (cashEndingItem: any) => {
    setModalState({
      isOpen: true,
      type: 'error',
      locationId: cashEndingItem.locationId,
      locationName: cashEndingItem.locationName,
      storeId: cashEndingItem.storeId,
      difference: cashEndingItem.difference
    });
  };

  // Handle Foreign Currency Translation button click
  const handleExchangeRate = (cashEndingItem: any) => {
    setModalState({
      isOpen: true,
      type: 'exchange',
      locationId: cashEndingItem.locationId,
      locationName: cashEndingItem.locationName,
      storeId: cashEndingItem.storeId,
      difference: cashEndingItem.difference
    });
  };

  // Handle modal close
  const handleModalClose = () => {
    setModalState({
      isOpen: false,
      type: null,
      locationId: null,
      locationName: '',
      storeId: null,
      difference: 0
    });
  };

  // Handle modal confirm
  const handleModalConfirm = async () => {
    if (!modalState.type || !modalState.locationId) {
      console.error('Missing modal state data');
      return;
    }

    // Get user ID
    let userId = currentUser?.user_id;
    if (!userId) {
      const supabase = supabaseService.getClient();
      if (supabase) {
        const { data: { session } } = await supabase.auth.getSession();
        userId = session?.user?.id;
      }
    }

    if (!companyId || !userId) {
      console.error('Missing company ID or user ID');
      alert('Missing required session data. Please refresh the page.');
      return;
    }

    // Create journal entry
    const success = await createJournalEntry({
      companyId,
      userId,
      storeId: modalState.storeId,
      cashLocationId: modalState.locationId,
      difference: modalState.difference,
      type: modalState.type
    });

    if (success) {
      // Close modal
      handleModalClose();

      // Show success message
      alert(
        modalState.type === 'error'
          ? 'Error entry created successfully'
          : 'Exchange rate entry created successfully'
      );

      // Reload data
      refresh();
    } else {
      alert('Failed to create journal entry. Please try again.');
    }
  };

  // Show loading if no company selected yet
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="finance" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Cash Ending</h1>
            <p className={styles.subtitle}>Manage daily cash ending processes and records</p>
          </div>
          <LoadingAnimation fullscreen size="large" />
        </div>
      </>
    );
  }

  if (loading) {
    return (
      <>
        <Navbar activeItem="finance" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Cash Ending</h1>
            <p className={styles.subtitle}>Manage daily cash ending processes and records</p>
          </div>
          <LoadingAnimation fullscreen size="large" />
        </div>
      </>
    );
  }

  if (error) {
    return (
      <>
        <Navbar activeItem="finance" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Cash Ending</h1>
            <p className={styles.subtitle}>Manage daily cash ending processes and records</p>
          </div>
          <div className={styles.errorContainer}>
            <div className={styles.errorIcon}>⚠️</div>
            <h2 className={styles.errorTitle}>Failed to Load Cash Endings</h2>
            <p className={styles.errorMessage}>{error}</p>
          </div>
        </div>
      </>
    );
  }

  // Group by location type
  const sortedCashEndings = [...cashEndings].sort((a, b) => {
    const typeOrder: Record<string, number> = { cash: 1, bank: 2, vault: 3 };
    const aType = cashEndings.find(c => c.locationId === a.locationId) || a;
    const bType = cashEndings.find(c => c.locationId === b.locationId) || b;

    // Get location type from location name or assume 'cash' as default
    const getType = (name: string) => {
      if (name.toLowerCase().includes('bank')) return 'bank';
      if (name.toLowerCase().includes('vault')) return 'vault';
      return 'cash';
    };

    const aTypePriority = typeOrder[getType(aType.locationName)] || 999;
    const bTypePriority = typeOrder[getType(bType.locationName)] || 999;

    if (aTypePriority !== bTypePriority) {
      return aTypePriority - bTypePriority;
    }

    return a.locationName.localeCompare(b.locationName);
  });

  return (
    <>
      <Navbar activeItem="finance" />
      <div className={styles.container}>
        <div className={styles.header}>
          <h1 className={styles.title}>Cash Ending</h1>
          <p className={styles.subtitle}>Manage daily cash ending processes and records</p>
        </div>

        {/* Store Selector */}
        <div style={{ marginBottom: '24px' }}>
          <StoreSelector
            stores={currentCompany?.stores || []}
            selectedStoreId={storeId}
            onStoreSelect={handleStoreSelect}
            companyId={companyId}
            width="280px"
            showAllStoresOption={true}
            allStoresLabel="All Stores"
          />
        </div>

        {cashEndings.length === 0 ? (
          <div className={styles.emptyState}>
            <div className={styles.emptyIcon}>💰</div>
            <h3 className={styles.emptyTitle}>No Cash Endings</h3>
            <p className={styles.emptyText}>
              No cash ending records found for the selected period
            </p>
          </div>
        ) : (
          <div className={styles.cashEndingContainer}>
            <div className={styles.comparisonSplit}>
              {/* Headers */}
              <div className={styles.comparisonHeaders}>
                <div className={styles.headerBalance}>
                  <svg className={styles.headerIcon} width="20" height="20" viewBox="0 0 24 24" fill="none">
                    <rect x="3" y="10" width="4" height="11" rx="1" fill="currentColor"/>
                    <rect x="10" y="6" width="4" height="15" rx="1" fill="currentColor"/>
                    <rect x="17" y="13" width="4" height="8" rx="1" fill="currentColor"/>
                  </svg>
                  <div className={styles.headerContent}>
                    <div className={styles.headerTitle}>Balance</div>
                    <div className={styles.headerSubtitle}>Based on Balance Sheet</div>
                  </div>
                </div>
                <div className={styles.headerActual}>
                  <svg className={styles.headerIcon} width="20" height="20" viewBox="0 0 24 24" fill="none">
                    <path d="M12 2L2 7V11C2 16.5 5.8 21.5 12 23C18.2 21.5 22 16.5 22 11V7L12 2Z" stroke="currentColor" strokeWidth="2" fill="none"/>
                    <path d="M9 12L11 14L15 10" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                  <div className={styles.headerContent}>
                    <div className={styles.headerTitle}>Actual Cash</div>
                    <div className={styles.headerSubtitle}>Cash ending input for today</div>
                  </div>
                </div>
              </div>

              {/* Location Rows */}
              <div className={styles.comparisonRows}>
                {sortedCashEndings.map((cashEnding) => {
                  const locationType = cashEnding.locationName.toLowerCase().includes('bank')
                    ? 'bank'
                    : cashEnding.locationName.toLowerCase().includes('vault')
                    ? 'vault'
                    : 'cash';

                  const hasActual = cashEnding.actualBalance > 0 || cashEnding.status === 'completed';

                  return (
                    <div key={cashEnding.cashEndingId} className={styles.comparisonRow}>
                      {/* Balance Column */}
                      <div className={styles.balanceCard}>
                        <div className={styles.locationHeader}>
                          <div
                            className={styles.locationIconWrap}
                            style={{
                              background: getIconBackground(locationType),
                              color: getIconTextColor(locationType)
                            }}
                          >
                            {getLocationIcon(locationType)}
                          </div>
                          <div className={styles.locationDetails}>
                            <div className={styles.locationName}>{cashEnding.locationName}</div>
                            <div className={styles.locationType}>From Balance Sheet</div>
                          </div>
                        </div>
                        <div className={styles.balanceAmount}>{formatCurrency(cashEnding.expectedBalance)}</div>
                      </div>

                      {/* Actual Column */}
                      <div className={`${styles.actualCard} ${!hasActual ? styles.notSet : ''}`}>
                        <div className={styles.locationHeader}>
                          <div
                            className={styles.locationIconWrap}
                            style={{
                              background: getIconBackground(locationType),
                              color: getIconTextColor(locationType)
                            }}
                          >
                            {getLocationIcon(locationType)}
                          </div>
                          <div className={styles.locationDetails}>
                            <div className={styles.locationName}>{cashEnding.locationName}</div>
                            <div className={`${styles.locationType} ${!hasActual ? styles.notSetLabel : ''}`}>
                              {hasActual ? 'Not updated today' : 'NOT SET'}
                            </div>
                          </div>
                        </div>
                        <div className={`${styles.actualAmountDisplay} ${!hasActual ? styles.pending : ''}`}>
                          {formatCurrency(cashEnding.actualBalance)}
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Difference Section */}
            <div className={styles.differenceSection}>
              <div className={styles.differenceHeader}>
                <svg className={styles.sectionIcon} width="20" height="20" viewBox="0 0 24 24" fill="none">
                  <rect x="4" y="6" width="7" height="2" rx="1" fill="currentColor"/>
                  <rect x="4" y="11" width="7" height="2" rx="1" fill="currentColor"/>
                  <rect x="4" y="16" width="7" height="2" rx="1" fill="currentColor"/>
                  <rect x="13" y="6" width="7" height="2" rx="1" fill="currentColor"/>
                  <rect x="13" y="11" width="5" height="2" rx="1" fill="currentColor"/>
                  <rect x="13" y="16" width="6" height="2" rx="1" fill="currentColor"/>
                </svg>
                <div>
                  <h3 className={styles.differenceTitle}>Difference</h3>
                  <p className={styles.differenceSubtitle}>Difference Between Balance & Actual</p>
                </div>
              </div>

              <div className={styles.differenceItems}>
                {sortedCashEndings.map((cashEnding) => {
                  const difference = cashEnding.difference;
                  const differenceClass =
                    difference > 0
                      ? styles.differencePositive
                      : difference < 0
                      ? styles.differenceNegative
                      : styles.differenceZero;

                  return (
                    <div key={`diff-${cashEnding.cashEndingId}`} className={styles.differenceItem}>
                      <div className={styles.differenceLocationName}>{cashEnding.locationName}</div>
                      <div className={styles.differenceAmountActions}>
                        <div className={`${styles.differenceAmount} ${differenceClass}`}>
                          {difference > 0 ? '+' : ''}{formatCurrency(Math.abs(difference))}
                        </div>
                        <div className={styles.actionButtonsSimple}>
                          <button
                            className={`${styles.actionBtnSimple} ${styles.errorBtnSimple}`}
                            onClick={() => handleMakeError(cashEnding)}
                            disabled={difference === 0}
                          >
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                              <path d="M13,14H11V10H13M13,18H11V16H13M1,21H23L12,2L1,21Z"/>
                            </svg>
                            Make Error
                          </button>
                          <button
                            className={`${styles.actionBtnSimple} ${styles.exchangeBtnSimple}`}
                            onClick={() => handleExchangeRate(cashEnding)}
                            disabled={difference === 0}
                          >
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                              <path d="M17.9,17.39C17.64,16.59 16.89,16 16,16H15V13A1,1 0 0,0 14,12H8V10H10A1,1 0 0,0 11,9V7H13A2,2 0 0,0 15,5V4.59C17.93,5.77 20,8.64 20,12C20,14.08 19.2,15.97 17.9,17.39M11,19.93C7.05,19.44 4,16.08 4,12C4,11.38 4.08,10.78 4.21,10.21L9,15V16A2,2 0 0,0 11,18M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z"/>
                            </svg>
                            Foreign Currency Translation
                          </button>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        )}

        {/* Confirmation Modal */}
        <ConfirmModal
          isOpen={modalState.isOpen}
          onClose={handleModalClose}
          onConfirm={handleModalConfirm}
          title={modalState.type === 'error' ? 'Make Error' : 'Foreign Currency Translation'}
          message={
            modalState.type === 'error'
              ? 'Are you sure you want to record this variance as an error?'
              : 'Are you sure you want to record this variance as a foreign exchange gain/loss?'
          }
          variant="info"
          confirmButtonVariant="primary"
          isLoading={isCreatingJournal}
        >
          {/* Custom content for Location and Variance */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <span style={{ fontWeight: 600, color: '#6C757D' }}>Location:</span>
              <span style={{ fontWeight: 600, color: '#212529' }}>{modalState.locationName}</span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <span style={{ fontWeight: 600, color: '#6C757D' }}>Variance:</span>
              <span style={{ fontFamily: 'JetBrains Mono', fontWeight: 700, color: '#FF5847' }}>
                {formatCurrency(modalState.difference)}
              </span>
            </div>
          </div>
        </ConfirmModal>
      </div>
    </>
  );
};

export default CashEndingPage;
