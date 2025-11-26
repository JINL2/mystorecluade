/**
 * ExcelTabContent Component Types
 */

export interface Store {
  store_id: string;
  store_name: string;
}

export interface ExcelTabContentProps {
  accounts: any[];
  cashLocations: any[];
  counterparties: any[];
  companyId: string;
  selectedStoreId: string | null;
  userId: string;
  stores: Store[];
  onStoreSelect: (storeId: string | null) => void;
  onCheckAccountMapping?: (companyId: string, counterpartyId: string, accountId: string) => Promise<boolean>;
  onGetCounterpartyStores?: (linkedCompanyId: string) => Promise<Array<{ storeId: string; storeName: string }>>;
  onGetCounterpartyCashLocations?: (linkedCompanyId: string, storeId?: string | null) => Promise<any[]>;
  onSubmitSuccess?: () => void;
  onSubmitError?: (error: string) => void;
}
