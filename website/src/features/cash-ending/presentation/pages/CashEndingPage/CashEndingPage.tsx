/**
 * CashEndingPage Component
 * Cash ending management with step-based left sidebar
 */

import React, { useState, useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import type { CashEndingPageProps } from './CashEndingPage.types';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector';
import styles from './CashEndingPage.module.css';

// Cash location interface from RPC response
interface CashLocation {
  cash_location_id: string;
  location_name: string;
  location_type: 'cash' | 'bank' | 'vault';
  store_id: string | null;
  store_name: string | null;
  company_id: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

// Denomination interface
interface Denomination {
  denomination_id: string;
  value: number;
  type: 'bill' | 'coin';
}

// Currency with exchange rate interface from RPC response
interface CurrencyWithExchangeRate {
  currency_id: string;
  company_currency_id: string;
  currency_code: string;
  currency_name: string;
  symbol: string;
  flag_emoji: string;
  is_base_currency: boolean;
  exchange_rate_to_base: number;
  denominations: Denomination[];
  created_at: string;
}

// Balance summary interface from RPC response
interface BalanceSummary {
  success: boolean;
  location_id: string;
  location_name: string;
  location_type: string;
  total_journal: number;
  total_real: number;
  difference: number;
  is_balanced: boolean;
  has_shortage: boolean;
  has_surplus: boolean;
  currency_symbol: string;
  currency_code: string;
  last_updated: string;
  error?: string;
}

export const CashEndingPage: React.FC<CashEndingPageProps> = () => {
  const { currentCompany, currentStore, setCurrentStore } = useAppState();
  const companyId = currentCompany?.company_id || '';
  const stores = currentCompany?.stores || [];

  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(
    currentStore?.store_id || null
  );

  // Step 2: Cash location state
  const [cashLocations, setCashLocations] = useState<CashLocation[]>([]);
  const [selectedLocationId, setSelectedLocationId] = useState<string>('');
  const [isLoadingLocations, setIsLoadingLocations] = useState(false);

  // Step 3: Currency and denomination state
  const [currencies, setCurrencies] = useState<CurrencyWithExchangeRate[]>([]);
  const [selectedCurrencyId, setSelectedCurrencyId] = useState<string>('');
  const [isLoadingCurrencies, setIsLoadingCurrencies] = useState(false);

  // Denomination quantities state: { [denomination_id]: quantity }
  const [denomQuantities, setDenomQuantities] = useState<Record<string, number>>({});

  // Balance summary state
  const [balanceSummary, setBalanceSummary] = useState<BalanceSummary | null>(null);
  const [isLoadingBalance, setIsLoadingBalance] = useState(false);
  const [isCompareExpanded, setIsCompareExpanded] = useState(true);

  // Handle store selection
  const handleStoreSelect = (storeId: string | null) => {
    setSelectedStoreId(storeId);
    // Reset location when store changes
    setSelectedLocationId('');
    setCashLocations([]);

    if (storeId) {
      const selectedStore = stores.find(s => s.store_id === storeId);
      if (selectedStore) {
        setCurrentStore(selectedStore);
      }
    } else {
      setCurrentStore(null);
    }
  };

  // Fetch cash locations when store is selected
  useEffect(() => {
    const fetchCashLocations = async () => {
      if (!selectedStoreId || !companyId) {
        setCashLocations([]);
        return;
      }

      setIsLoadingLocations(true);
      try {
        const data = await supabaseService.rpc<CashLocation[]>('get_cash_locations_v2', {
          p_company_id: companyId,
          p_store_id: selectedStoreId,
        });
        setCashLocations(data || []);
      } catch (error) {
        console.error('Failed to fetch cash locations:', error);
        setCashLocations([]);
      } finally {
        setIsLoadingLocations(false);
      }
    };

    fetchCashLocations();
  }, [selectedStoreId, companyId]);

  // Convert cash locations to TossSelector options
  // Using description instead of badge for location type display
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

  const locationOptions: TossSelectorOption[] = cashLocations.map(location => {
    const colors = getLocationTypeColors(location.location_type);
    return {
      value: location.cash_location_id,
      label: location.location_name,
      description: location.location_type,
      descriptionBgColor: colors.bg,
      descriptionColor: colors.text,
    };
  });

  // Handle location selection
  const handleLocationSelect = (value: string) => {
    setSelectedLocationId(value);
    // Reset currency and quantities when location changes
    setSelectedCurrencyId('');
    setDenomQuantities({});
    setBalanceSummary(null);
  };

  // Fetch balance summary when location is selected
  useEffect(() => {
    const fetchBalanceSummary = async () => {
      if (!selectedLocationId) {
        setBalanceSummary(null);
        return;
      }

      setIsLoadingBalance(true);
      try {
        const data = await supabaseService.rpc<BalanceSummary>(
          'get_cash_location_balance_summary_v2_utc',
          { p_location_id: selectedLocationId }
        );
        if (data && data.success) {
          setBalanceSummary(data);
        } else {
          setBalanceSummary(null);
        }
      } catch (error) {
        console.error('Failed to fetch balance summary:', error);
        setBalanceSummary(null);
      } finally {
        setIsLoadingBalance(false);
      }
    };

    fetchBalanceSummary();
  }, [selectedLocationId]);

  // Handle quantity change for denomination
  const handleQuantityChange = (denominationId: string, value: number) => {
    setDenomQuantities(prev => ({
      ...prev,
      [denominationId]: Math.max(0, value),
    }));
  };

  // Calculate subtotal for a currency
  const calculateCurrencySubtotal = (currency: CurrencyWithExchangeRate) => {
    return currency.denominations.reduce((total, denom) => {
      const qty = denomQuantities[denom.denomination_id] || 0;
      return total + (denom.value * qty);
    }, 0);
  };

  // Calculate total across all currencies (converted to base currency)
  const calculateGrandTotal = () => {
    return currencies.reduce((total, currency) => {
      const currencySubtotal = calculateCurrencySubtotal(currency);
      // Convert to base currency using exchange rate
      return total + (currencySubtotal * currency.exchange_rate_to_base);
    }, 0);
  };

  // Fetch currencies when location is selected
  useEffect(() => {
    const fetchCurrencies = async () => {
      if (!selectedLocationId || !companyId) {
        setCurrencies([]);
        return;
      }

      setIsLoadingCurrencies(true);
      try {
        const today = new Date().toISOString().split('T')[0];
        const data = await supabaseService.rpc<CurrencyWithExchangeRate[]>(
          'get_company_currencies_with_exchange_rates',
          {
            p_company_id: companyId,
            p_rate_date: today,
          }
        );

        setCurrencies(data || []);

        // Auto-select first currency (base currency is usually first)
        if (data && data.length > 0) {
          setSelectedCurrencyId(data[0].currency_id);
        }
      } catch (error) {
        console.error('Failed to fetch currencies:', error);
        setCurrencies([]);
      } finally {
        setIsLoadingCurrencies(false);
      }
    };

    fetchCurrencies();
  }, [selectedLocationId, companyId]);

  // Handle currency selection
  const handleCurrencySelect = (currencyId: string) => {
    setSelectedCurrencyId(currencyId);
  };

  // Get selected currency data
  const selectedCurrency = currencies.find(c => c.currency_id === selectedCurrencyId);

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
                {/* Currency Tabs */}
                <div className={styles.currencyTabs}>
                  {currencies.map(currency => (
                    <button
                      key={currency.currency_id}
                      className={`${styles.currencyTab} ${selectedCurrencyId === currency.currency_id ? styles.currencyTabActive : ''}`}
                      onClick={() => handleCurrencySelect(currency.currency_id)}
                    >
                      <span className={styles.currencyFlag}>{currency.flag_emoji}</span>
                      <span className={styles.currencyCode}>{currency.currency_code}</span>
                      {currency.is_base_currency && (
                        <span className={styles.baseBadge}>Base</span>
                      )}
                    </button>
                  ))}
                </div>

                {/* Denomination Grid */}
                {selectedCurrency && (
                  <div className={styles.denominationSection}>
                    <div className={styles.sectionHeader}>
                      <h2 className={styles.sectionTitle}>
                        {selectedCurrency.currency_name} ({selectedCurrency.symbol})
                      </h2>
                      {!selectedCurrency.is_base_currency && (
                        <span className={styles.exchangeRate}>
                          1 {selectedCurrency.currency_code} = {selectedCurrency.exchange_rate_to_base.toFixed(4)} base
                        </span>
                      )}
                    </div>

                    {selectedCurrency.denominations.length === 0 ? (
                      <div className={styles.noDenominations}>
                        <p>No denominations configured for this currency</p>
                      </div>
                    ) : (
                      <>
                        {/* Denomination Table */}
                        <table className={styles.denomTable}>
                          <thead>
                            <tr>
                              <th className={styles.denomTableHeader}>Denomination</th>
                              <th className={styles.denomTableHeader}>Qty</th>
                              <th className={styles.denomTableHeaderRight}>Amount ({selectedCurrency.currency_code})</th>
                            </tr>
                          </thead>
                          <tbody>
                            {selectedCurrency.denominations.map(denom => {
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
                                      onChange={(e) => handleQuantityChange(denom.denomination_id, parseInt(e.target.value) || 0)}
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
                                Subtotal {selectedCurrency.currency_code}
                              </td>
                              <td className={styles.denomTotalAmount}>
                                {selectedCurrency.symbol}{calculateCurrencySubtotal(selectedCurrency).toLocaleString()}
                              </td>
                            </tr>
                          </tfoot>
                        </table>
                      </>
                    )}

                    {/* Total Section */}
                    <div className={styles.totalSection}>
                      <div className={styles.totalRow}>
                        <span className={styles.totalLabel}>Total</span>
                        <span className={styles.totalValue}>
                          {balanceSummary?.currency_symbol || '₫'}{calculateGrandTotal().toLocaleString()}
                        </span>
                      </div>

                      {/* Compare with Journal - Collapsible */}
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
                            const countedTotal = calculateGrandTotal();
                            const journalTotal = balanceSummary.total_journal;
                            const difference = countedTotal - journalTotal;
                            return (
                              <div className={styles.compareContent}>
                                <div className={styles.compareRow}>
                                  <span className={styles.compareLabel}>Journal</span>
                                  <span className={styles.compareValue}>
                                    {balanceSummary.currency_symbol}{journalTotal.toLocaleString()}
                                  </span>
                                </div>
                                <div className={styles.compareRow}>
                                  <span className={styles.compareLabel}>Difference</span>
                                  <span className={`${styles.compareValue} ${
                                    difference > 0
                                      ? styles.compareSurplus
                                      : difference < 0
                                        ? styles.compareShortage
                                        : ''
                                  }`}>
                                    {difference > 0 ? '+' : difference < 0 ? '-' : ''}
                                    {balanceSummary.currency_symbol}{Math.abs(difference).toLocaleString()}
                                  </span>
                                </div>
                              </div>
                            );
                          })()}
                        </div>
                      )}

                      {isLoadingBalance && (
                        <div className={styles.compareLoading}>
                          Loading journal data...
                        </div>
                      )}
                    </div>
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </>
  );
};

export default CashEndingPage;
