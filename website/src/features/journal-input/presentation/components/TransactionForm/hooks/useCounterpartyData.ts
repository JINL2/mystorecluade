/**
 * useCounterpartyData Hook
 * Manages counterparty-related data loading and state
 */

import { useEffect } from 'react';
import type { Counterparty } from '../../../../domain/repositories/IJournalInputRepository';

export interface UseCounterpartyDataProps {
  selectedCounterparty: string;
  counterparties: Counterparty[];
  setCounterpartyStores: (stores: Array<{ storeId: string; storeName: string }>) => void;
  setSelectedCounterpartyStore: (storeId: string) => void;
  setCounterpartyCashLocations: (locations: any[]) => void;
  setSelectedCounterpartyCashLocation: (locationId: string) => void;
  setLoadingCounterpartyStores: (loading: boolean) => void;
  setLoadingCounterpartyCashLocations: (loading: boolean) => void;
  selectedCounterpartyStore?: string;
  onGetCounterpartyStores?: (linkedCompanyId: string) => Promise<Array<{ storeId: string; storeName: string }>>;
  onGetCounterpartyCashLocations?: (linkedCompanyId: string, storeId?: string | null) => Promise<any[]>;
}

export const useCounterpartyData = ({
  selectedCounterparty,
  counterparties,
  setCounterpartyStores,
  setSelectedCounterpartyStore,
  setCounterpartyCashLocations,
  setSelectedCounterpartyCashLocation,
  setLoadingCounterpartyStores,
  setLoadingCounterpartyCashLocations,
  selectedCounterpartyStore,
  onGetCounterpartyStores,
  onGetCounterpartyCashLocations,
}: UseCounterpartyDataProps) => {
  // Get selected counterparty data
  const selectedCounterpartyData = counterparties.find(cp => cp.counterpartyId === selectedCounterparty) || null;

  // Load counterparty stores when internal counterparty is selected
  useEffect(() => {
    const loadCounterpartyStores = async () => {
      if (!selectedCounterpartyData?.isInternal || !selectedCounterpartyData?.linkedCompanyId || !onGetCounterpartyStores) {
        setCounterpartyStores([]);
        setSelectedCounterpartyStore('');
        setCounterpartyCashLocations([]);
        setSelectedCounterpartyCashLocation('');
        return;
      }

      setLoadingCounterpartyStores(true);
      try {
        const stores = await onGetCounterpartyStores(selectedCounterpartyData.linkedCompanyId);
        setCounterpartyStores(stores);
      } catch (error) {
        console.error('Error loading counterparty stores:', error);
        setCounterpartyStores([]);
      } finally {
        setLoadingCounterpartyStores(false);
      }
    };

    loadCounterpartyStores();
  }, [
    selectedCounterparty,
    selectedCounterpartyData?.isInternal,
    selectedCounterpartyData?.linkedCompanyId,
    onGetCounterpartyStores,
    setCounterpartyStores,
    setSelectedCounterpartyStore,
    setCounterpartyCashLocations,
    setSelectedCounterpartyCashLocation,
    setLoadingCounterpartyStores,
  ]);

  // Load counterparty cash locations when linkedCompanyId or store changes
  useEffect(() => {
    const loadCounterpartyCashLocations = async () => {
      if (!selectedCounterpartyData?.isInternal || !selectedCounterpartyData?.linkedCompanyId || !onGetCounterpartyCashLocations) {
        setCounterpartyCashLocations([]);
        setSelectedCounterpartyCashLocation('');
        return;
      }

      setLoadingCounterpartyCashLocations(true);
      try {
        const locations = await onGetCounterpartyCashLocations(
          selectedCounterpartyData.linkedCompanyId,
          selectedCounterpartyStore || null
        );
        setCounterpartyCashLocations(locations);
      } catch (error) {
        console.error('Error loading counterparty cash locations:', error);
        setCounterpartyCashLocations([]);
      } finally {
        setLoadingCounterpartyCashLocations(false);
      }
    };

    loadCounterpartyCashLocations();
  }, [
    selectedCounterparty,
    selectedCounterpartyData?.linkedCompanyId,
    selectedCounterpartyStore,
    onGetCounterpartyCashLocations,
    setCounterpartyCashLocations,
    setSelectedCounterpartyCashLocation,
    setLoadingCounterpartyCashLocations,
  ]);

  return {
    selectedCounterpartyData,
  };
};
