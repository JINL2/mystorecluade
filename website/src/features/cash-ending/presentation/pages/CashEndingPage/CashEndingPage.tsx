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
  const locationOptions: TossSelectorOption[] = cashLocations.map(location => ({
    value: location.cash_location_id,
    label: location.location_name,
    badge: location.location_type,
    badgeColor: location.location_type === 'cash' ? '#10B981' :
                location.location_type === 'bank' ? '#3B82F6' : '#8B5CF6',
  }));

  // Handle location selection
  const handleLocationSelect = (value: string) => {
    setSelectedLocationId(value);
  };

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
                  showBadges={true}
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

            {/* TODO: Content will go here */}
          </div>
        </div>
      </div>
    </>
  );
};

export default CashEndingPage;
