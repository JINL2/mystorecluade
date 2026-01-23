/**
 * CashEndingPage Component
 * Cash ending management with step-based left sidebar
 * Refactored to use Clean Architecture with hooks
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { useAppState } from '@/app/providers/app_state_provider';
import { useCashEnding } from '@/features/cash_ending/presentation/hooks/useCashEnding';
import { useCashAdjustment } from '@/features/cash_ending/presentation/hooks/useCashAdjustment';
import type { CashEndingPageProps } from './CashEndingPage.types';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector';
import styles from './CashEndingPage.module.css';

// Location type color helper
const getLocationTypeColors = (type: string) => {
  switch (type) {
    case 'cash':
      return { bg: 'rgba(16, 185, 129, 0.15)', text: '#10B981' };
    case 'bank':
      return { bg: 'rgba(59, 130, 246, 0.15)', text: '#3B82F6' };
    case 'vault':
      return { bg: 'rgba(139, 92, 246, 0.15)', text: '#8B5CF6' };
    default:
      return { bg: 'rgba(107, 114, 128, 0.15)', text: '#6B7280' };
  }
};

export const CashEndingPage: React.FC<CashEndingPageProps> = () => {
  const { currentCompany, currentStore, setCurrentStore, currentUser } = useAppState();
  const companyId = currentCompany?.company_id || '';
  const userId = currentUser?.user_id || '';
  const stores = currentCompany?.stores || [];

  // Main cash ending hook
  const {
    selectedStoreId,
    cashLocations,
    selectedLocationId,
    isLoadingLocations,
    currencies,
    selectedCurrencyId,
    isLoadingCurrencies,
    denomQuantities,
    bankAmounts,
    vaultTransactionType,
    balanceSummary,
    isLoadingBalance,
    isCompareExpanded,
    isSubmitting,
    showSuccessModal,
    showErrorModal,
    errorMessage,
    successModalData,
    selectedLocation,
    selectedCurrency,
    canSubmit,
    handleStoreSelect,
    handleLocationSelect,
    setSelectedCurrencyId,
    setDenomQuantity,
    setBankAmount,
    setVaultTransactionType,
    setIsCompareExpanded,
    handleSubmit,
    closeSuccessModal,
    closeErrorModal,
    calculateCurrencySubtotal,
    calculateGrandTotal,
    getCurrencyEnteredAmount,
  } = useCashEnding({
    companyId,
    userId,
    stores,
    currentStoreId: currentStore?.store_id || null,
    setCurrentStore,
  });

  // Adjustment hook
  const {
    isAdjusting,
    showAdjustmentConfirmModal,
    adjustmentType,
    openAdjustmentConfirm,
    closeAdjustmentConfirm,
    executeAdjustment,
  } = useCashAdjustment({
    companyId,
    storeId: selectedStoreId,
    locationId: selectedLocationId,
    userId,
  });

  // Convert locations to selector options
  const locationOptions: TossSelectorOption[] = cashLocations.map((location) => {
    const colors = getLocationTypeColors(location.locationType);
    return {
      value: location.cashLocationId,
      label: location.locationName,
      description: location.locationType,
      descriptionBgColor: colors.bg,
      descriptionColor: colors.text,
    };
  });

  return (
    <>
      <Navbar activeItem="finance" />
      <div className={styles.pageLayout}>
        {/* Left Sidebar - Steps */}
        <aside className={styles.sidebar}>
          {/* Step 1: Store Selection */}
          <div className={styles.stepSection}>
            <div className={styles.stepHeader}>
              <span className={styles.stepNumber}>1</span>
              <span className={styles.stepTitle}>Select Store</span>
            </div>
            <div className={styles.stepContent}>
              <StoreSelector
                stores={stores}
                selectedStoreId={selectedStoreId}
                onStoreSelect={handleStoreSelect}
                companyId={companyId}
                width="100%"
                showAllStoresOption={false}
              />
            </div>
          </div>

          {/* Step 2: Cash Location Selection */}
          <div className={styles.stepSection}>
            <div className={styles.stepHeader}>
              <span className={styles.stepNumber}>2</span>
              <span className={styles.stepTitle}>Select Location</span>
            </div>
            <div className={styles.stepContent}>
              {!selectedStoreId ? (
                <p className={styles.placeholderText}>Select a store first</p>
              ) : (
                <TossSelector
                  options={locationOptions}
                  value={selectedLocationId}
                  onChange={handleLocationSelect}
                  placeholder="Select cash location"
                  loading={isLoadingLocations}
                  disabled={isLoadingLocations}
                  showDescriptions={true}
                  emptyMessage="No cash locations found"
                  fullWidth
                />
              )}
            </div>
          </div>
        </aside>

        {/* Main Content Area */}
        <div className={styles.mainContent}>
          <div className={styles.container}>
            <div className={styles.header}>
              <h1 className={styles.title}>Cash Ending</h1>
              <p className={styles.subtitle}>Manage daily cash ending processes and records</p>
            </div>

            {/* Content Area */}
            {!selectedLocationId ? (
              <div className={styles.emptyState}>
                <p>Please select a store and cash location to begin</p>
              </div>
            ) : isLoadingCurrencies ? (
              <div className={styles.loadingState}>
                <p>Loading currencies...</p>
              </div>
            ) : currencies.length === 0 ? (
              <div className={styles.emptyState}>
                <p>No currencies configured for this company</p>
              </div>
            ) : (
              <div className={styles.contentArea}>
                {/* Vault Transaction Type Buttons */}
                {selectedLocation?.isVault && (
                  <div className={styles.vaultTransactionSection}>
                    <div className={styles.vaultTransactionLabel}>Vault Transaction</div>
                    <div className={styles.vaultTransactionButtons}>
                      {(['in', 'out', 'recount'] as const).map((type) => (
                        <button
                          key={type}
                          className={`${styles.vaultTransactionButton} ${vaultTransactionType === type ? styles.vaultTransactionButtonActive : ''}`}
                          onClick={() => setVaultTransactionType(type)}
                        >
                          <span className={styles.vaultTransactionIcon}>
                            {type === 'in' && (
                              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <circle cx="12" cy="12" r="10" />
                                <path d="M12 8v8M8 12h8" />
                              </svg>
                            )}
                            {type === 'out' && (
                              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <circle cx="12" cy="12" r="10" />
                                <path d="M8 12h8" />
                              </svg>
                            )}
                            {type === 'recount' && (
                              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <path d="M21 12a9 9 0 11-9-9" />
                                <path d="M21 3v6h-6" />
                              </svg>
                            )}
                          </span>
                          {type.charAt(0).toUpperCase() + type.slice(1)}
                        </button>
                      ))}
                    </div>
                  </div>
                )}

                {/* Currency Tabs */}
                {!selectedLocation?.isBank && (
                  <div className={styles.currencyTabs}>
                    {currencies.map((currency) => {
                      const enteredAmount = getCurrencyEnteredAmount(currency);
                      const hasData = enteredAmount > 0;
                      return (
                        <button
                          key={currency.currencyId}
                          className={`${styles.currencyTab} ${selectedCurrencyId === currency.currencyId ? styles.currencyTabActive : ''} ${hasData ? styles.currencyTabHasData : ''}`}
                          onClick={() => setSelectedCurrencyId(currency.currencyId)}
                        >
                          <span className={styles.currencyFlag}>{currency.flagEmoji}</span>
                          <span className={styles.currencyCode}>{currency.currencyCode}</span>
                          {currency.isBaseCurrency && <span className={styles.baseBadge}>Base</span>}
                          {hasData && <span className={styles.currencyDataDot} />}
                        </button>
                      );
                    })}
                  </div>
                )}

                {/* Content Section */}
                {selectedCurrency && (
                  <div className={styles.denominationSection}>
                    <div className={styles.sectionHeader}>
                      <h2 className={styles.sectionTitle}>
                        {selectedCurrency.currencyName} ({selectedCurrency.symbol})
                      </h2>
                      {!selectedCurrency.isBaseCurrency && (
                        <span className={styles.exchangeRate}>
                          1 {selectedCurrency.currencyCode} = {selectedCurrency.exchangeRateToBase.toFixed(4)} base
                        </span>
                      )}
                    </div>

                    {/* Bank Type: Simple amount input */}
                    {selectedLocation?.isBank ? (
                      <div className={styles.bankAmountSection}>
                        <label className={styles.bankAmountLabel}>
                          Current bank balance ({selectedCurrency.currencyCode})
                        </label>
                        <div className={styles.bankAmountInputWrapper}>
                          <span className={styles.bankAmountSymbol}>{selectedCurrency.symbol}</span>
                          <input
                            type="number"
                            className={styles.bankAmountInput}
                            value={bankAmounts[selectedCurrency.currencyId] || ''}
                            onChange={(e) => setBankAmount(selectedCurrency.currencyId, parseFloat(e.target.value) || 0)}
                            placeholder="Enter amount"
                            min="0"
                            step="0.01"
                          />
                        </div>
                      </div>
                    ) : (
                      /* Cash/Vault Type: Denomination table */
                      <>
                        {selectedCurrency.denominations.length === 0 ? (
                          <div className={styles.noDenominations}>
                            <p>No denominations configured for this currency</p>
                          </div>
                        ) : (
                          <table className={styles.denomTable}>
                            <thead>
                              <tr>
                                <th className={styles.denomTableHeader}>Denomination</th>
                                <th className={styles.denomTableHeader}>Qty</th>
                                <th className={styles.denomTableHeaderRight}>Amount ({selectedCurrency.currencyCode})</th>
                              </tr>
                            </thead>
                            <tbody>
                              {selectedCurrency.denominations.map((denom) => {
                                const qty = denomQuantities[denom.denomination_id] || 0;
                                const amount = denom.value * qty;
                                return (
                                  <tr key={denom.denomination_id} className={styles.denomTableRow}>
                                    <td className={styles.denomTableCell}>
                                      <span className={styles.denomValueText}>
                                        {selectedCurrency.symbol}{denom.value.toLocaleString()}
                                      </span>
                                    </td>
                                    <td className={styles.denomTableCellInput}>
                                      <input
                                        type="number"
                                        className={styles.denomQtyInput}
                                        value={qty || ''}
                                        onChange={(e) => setDenomQuantity(denom.denomination_id, parseInt(e.target.value) || 0)}
                                        placeholder="0"
                                        min="0"
                                      />
                                    </td>
                                    <td className={styles.denomTableCellAmount}>
                                      {selectedCurrency.symbol}{amount.toLocaleString()}
                                    </td>
                                  </tr>
                                );
                              })}
                            </tbody>
                            <tfoot>
                              <tr className={styles.denomTableFooter}>
                                <td className={styles.denomTotalLabel} colSpan={2}>
                                  Subtotal {selectedCurrency.currencyCode}
                                </td>
                                <td className={styles.denomTotalAmount}>
                                  {selectedCurrency.symbol}{calculateCurrencySubtotal(selectedCurrency).toLocaleString()}
                                </td>
                              </tr>
                            </tfoot>
                          </table>
                        )}
                      </>
                    )}

                    {/* Total Section */}
                    <div className={styles.totalSection}>
                      <div className={styles.totalRow}>
                        <span className={styles.totalLabel}>Total</span>
                        <span className={styles.totalValue}>
                          {balanceSummary?.currencySymbol || '₫'}{calculateGrandTotal().toLocaleString()}
                        </span>
                      </div>

                      {/* Compare with Journal */}
                      {balanceSummary && (
                        <div className={styles.compareSection}>
                          <button
                            className={styles.compareToggle}
                            onClick={() => setIsCompareExpanded(!isCompareExpanded)}
                          >
                            <svg
                              className={`${styles.compareChevron} ${isCompareExpanded ? styles.compareChevronExpanded : ''}`}
                              width="20"
                              height="20"
                              viewBox="0 0 24 24"
                              fill="none"
                              stroke="currentColor"
                              strokeWidth="2"
                            >
                              <polyline points="6,9 12,15 18,9" />
                            </svg>
                            <span>Compare with Journal</span>
                          </button>

                          {isCompareExpanded && (() => {
                            // Always use user's entered amount for difference calculation
                            const enteredTotal = calculateGrandTotal();
                            const journalTotal = balanceSummary.totalJournal;
                            const difference = enteredTotal - journalTotal;
                            return (
                              <div className={styles.compareContent}>
                                <div className={styles.compareRow}>
                                  <span className={styles.compareLabel}>Journal</span>
                                  <span className={styles.compareValue}>
                                    {balanceSummary.currencySymbol}{journalTotal.toLocaleString()}
                                  </span>
                                </div>
                                <div className={styles.compareRow}>
                                  <span className={styles.compareLabel}>Difference</span>
                                  <span className={`${styles.compareValue} ${
                                    difference > 0 ? styles.compareSurplus : difference < 0 ? styles.compareShortage : ''
                                  }`}>
                                    {difference > 0 ? '+' : difference < 0 ? '-' : ''}
                                    {balanceSummary.currencySymbol}{Math.abs(difference).toLocaleString()}
                                  </span>
                                </div>
                              </div>
                            );
                          })()}
                        </div>
                      )}

                      {isLoadingBalance && (
                        <div className={styles.compareLoading}>Loading journal data...</div>
                      )}

                      {/* Submit Button */}
                      <div className={styles.submitSection}>
                        <button
                          className={styles.submitButton}
                          onClick={handleSubmit}
                          disabled={!canSubmit || isSubmitting}
                        >
                          {isSubmitting ? 'Submitting...' : 'Submit'}
                        </button>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Success Modal */}
      <ConfirmModal
        isOpen={showSuccessModal}
        onClose={closeSuccessModal}
        onConfirm={closeSuccessModal}
        variant="success"
        title="Ending Completed!"
        confirmText="Close"
        cancelText=""
        confirmButtonVariant="primary"
        showConfirmIcon={false}
        closeOnBackdropClick={true}
        showWarningSection={false}
      >
        {successModalData && (
          <div className={styles.successModalContent}>
            <div className={styles.successAmount}>
              {successModalData.balanceSummary.currencySymbol}
              {successModalData.balanceSummary.totalReal.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
            </div>
            <div className={styles.successLocationInfo}>
              {successModalData.locationType.charAt(0).toUpperCase() + successModalData.locationType.slice(1)} · {successModalData.locationName}
            </div>

            <div className={styles.successSummaryCard}>
              <div className={styles.successSummaryRow}>
                <span className={styles.successSummaryLabel}>Total Journal</span>
                <span className={styles.successSummaryValue}>
                  {successModalData.balanceSummary.currencySymbol}
                  {successModalData.balanceSummary.totalJournal.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
              <div className={styles.successSummaryRow}>
                <span className={styles.successSummaryLabel}>Total Real</span>
                <span className={styles.successSummaryValue}>
                  {successModalData.balanceSummary.currencySymbol}
                  {successModalData.balanceSummary.totalReal.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
              <div className={`${styles.successSummaryRow} ${styles.successDifferenceRow}`}>
                <span className={styles.successSummaryLabel}>Difference</span>
                <div>
                  <span className={`${styles.successDifferenceValue} ${
                    successModalData.balanceSummary.hasSurplus
                      ? styles.successSurplus
                      : successModalData.balanceSummary.hasShortage
                        ? styles.successShortage
                        : styles.successBalanced
                  }`}>
                    {successModalData.balanceSummary.difference > 0 ? '+' : ''}
                    {successModalData.balanceSummary.currencySymbol}
                    {successModalData.balanceSummary.difference.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                  </span>
                  {successModalData.balanceSummary.totalJournal !== 0 && (
                    <span className={`${styles.successDifferencePercent} ${
                      successModalData.balanceSummary.hasSurplus
                        ? styles.successSurplus
                        : successModalData.balanceSummary.hasShortage
                          ? styles.successShortage
                          : styles.successBalanced
                    }`}>
                      {successModalData.balanceSummary.differencePercent > 0 ? '+' : ''}
                      {successModalData.balanceSummary.differencePercent.toFixed(2)}%
                    </span>
                  )}
                </div>
              </div>
            </div>

            {successModalData.balanceSummary.needsAdjustment && (
              <div className={styles.adjustmentButtons}>
                <button
                  className={`${styles.adjustmentButton} ${styles.adjustmentButtonPrimary}`}
                  onClick={() => openAdjustmentConfirm('error')}
                >
                  <span className={styles.adjustmentButtonIcon}>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <circle cx="12" cy="12" r="10" />
                      <line x1="12" y1="8" x2="12" y2="12" />
                      <line x1="12" y1="16" x2="12.01" y2="16" />
                    </svg>
                  </span>
                  Error Adjustment
                </button>
                <button
                  className={`${styles.adjustmentButton} ${styles.adjustmentButtonSecondary}`}
                  onClick={() => openAdjustmentConfirm('forex')}
                >
                  <span className={styles.adjustmentButtonIcon}>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <circle cx="12" cy="12" r="10" />
                      <line x1="2" y1="12" x2="22" y2="12" />
                      <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                    </svg>
                  </span>
                  Foreign Currency Translation
                </button>
              </div>
            )}
          </div>
        )}
      </ConfirmModal>

      {/* Error Modal */}
      <ConfirmModal
        isOpen={showErrorModal}
        onClose={closeErrorModal}
        onConfirm={closeErrorModal}
        variant="error"
        title="Error"
        message={errorMessage}
        confirmText="OK"
        cancelText="Close"
        confirmButtonVariant="error"
        showConfirmIcon={false}
        closeOnBackdropClick={true}
      />

      {/* Adjustment Confirm Modal */}
      <ConfirmModal
        isOpen={showAdjustmentConfirmModal}
        onClose={closeAdjustmentConfirm}
        onConfirm={executeAdjustment}
        variant="info"
        title={adjustmentType === 'error' ? 'Confirm Auto-Balance' : 'Confirm Foreign Currency Translation'}
        confirmText="Confirm & Apply"
        cancelText="Cancel"
        confirmButtonVariant="primary"
        showConfirmIcon={true}
        closeOnBackdropClick={false}
        closeOnEscape={!isAdjusting}
        isLoading={isAdjusting}
        width="480px"
        showWarningSection={false}
      >
        {successModalData && (
          <div className={styles.adjustmentConfirmContent}>
            <p className={styles.adjustmentConfirmSubtitle}>
              Review the details below before applying {adjustmentType === 'error' ? 'Auto-Balance' : 'Foreign Currency Translation'}
            </p>

            <div className={styles.adjustmentConfirmCard}>
              <div className={styles.adjustmentConfirmRow}>
                <span className={styles.adjustmentConfirmLabel}>Location</span>
                <span className={styles.adjustmentConfirmValue}>
                  {successModalData.locationName} · {successModalData.locationType}
                </span>
              </div>
              <div className={styles.adjustmentConfirmRow}>
                <span className={styles.adjustmentConfirmLabel}>Total Real</span>
                <span className={styles.adjustmentConfirmValue}>
                  {successModalData.balanceSummary.currencySymbol}
                  {successModalData.balanceSummary.totalReal.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
              <div className={styles.adjustmentConfirmRow}>
                <span className={styles.adjustmentConfirmLabel}>Total Journal</span>
                <span className={styles.adjustmentConfirmValue}>
                  {successModalData.balanceSummary.currencySymbol}
                  {successModalData.balanceSummary.totalJournal.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
              <div className={`${styles.adjustmentConfirmRow} ${styles.adjustmentConfirmDifferenceRow}`}>
                <span className={styles.adjustmentConfirmLabel}>Difference</span>
                <div className={styles.adjustmentConfirmDifferenceValue}>
                  <span className={`${styles.adjustmentConfirmAmount} ${
                    successModalData.balanceSummary.hasSurplus
                      ? styles.adjustmentConfirmSurplus
                      : successModalData.balanceSummary.hasShortage
                        ? styles.adjustmentConfirmShortage
                        : ''
                  }`}>
                    {successModalData.balanceSummary.difference > 0 ? '+' : ''}
                    {successModalData.balanceSummary.currencySymbol}
                    {successModalData.balanceSummary.difference.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                  </span>
                  {successModalData.balanceSummary.totalJournal !== 0 && (
                    <span className={`${styles.adjustmentConfirmPercent} ${
                      successModalData.balanceSummary.hasSurplus
                        ? styles.adjustmentConfirmSurplus
                        : successModalData.balanceSummary.hasShortage
                          ? styles.adjustmentConfirmShortage
                          : ''
                    }`}>
                      {successModalData.balanceSummary.differencePercent > 0 ? '+' : ''}
                      {successModalData.balanceSummary.differencePercent.toFixed(2)}%
                    </span>
                  )}
                </div>
              </div>
            </div>

            <p className={styles.adjustmentConfirmNote}>
              This action will add a Journal entry to match the Real amount.
            </p>
          </div>
        )}
      </ConfirmModal>
    </>
  );
};

export default CashEndingPage;
