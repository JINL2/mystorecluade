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
  userId: string;
  stores: Store[];
  onCheckAccountMapping?: (companyId: string, counterpartyId: string, accountId: string) => Promise<boolean>;
  onGetCounterpartyStores?: (linkedCompanyId: string) => Promise<Array<{ storeId: string; storeName: string }>>;
  onGetCounterpartyCashLocations?: (linkedCompanyId: string, storeId?: string | null) => Promise<any[]>;
  onLoadCashLocations?: (storeId: string | null) => Promise<any[]>;
  onSubmitSuccess?: () => void;
  onSubmitError?: (error: string) => void;
}
