/**
 * ExcelTabContent Component Types
 */

import type { TransactionTemplate } from '../../../domain/repositories/IJournalInputRepository';

export interface Store {
  store_id: string;
  store_name: string;
}

export interface ExcelTabContentProps {
  accounts: any[];
  cashLocations: any[];
  counterparties: any[];
  templates: TransactionTemplate[];
  loadingTemplates: boolean;
  companyId: string;
  userId: string;
  stores: Store[];
  onCheckAccountMapping?: (companyId: string, counterpartyId: string, accountId: string) => Promise<boolean>;
  onGetCounterpartyStores?: (linkedCompanyId: string) => Promise<Array<{ storeId: string; storeName: string }>>;
  onGetCounterpartyCashLocations?: (linkedCompanyId: string, storeId?: string | null) => Promise<any[]>;
  onLoadCashLocations?: (storeId: string | null) => Promise<any[]>;
  onLoadTemplates?: (storeId: string | null) => Promise<void>;
  onApplyTemplate?: (templateId: string) => void;
  onSubmitSuccess?: () => void;
  onSubmitError?: (error: string) => void;
  // App state store connection
  currentStoreId?: string | null;
  onCurrentStoreChange?: (storeId: string | null) => void;
}
