/**
 * DiscrepancyPage Types
 * Types for inventory discrepancy analysis page
 */

export type DiscrepancyStatus = 'abnormal' | 'warning' | 'normal';

export interface StoreDiscrepancy {
  storeId: string;
  storeName: string;
  totalEvents: number;
  increaseCount: number;
  decreaseCount: number;
  increaseValue: number;
  decreaseValue: number;
  netValue: number;
  status: DiscrepancyStatus;
}

export interface DiscrepancyOverview {
  status: 'ok' | 'insufficient_data';
  message?: string;
  totalIncreaseValue: number;
  totalDecreaseValue: number;
  netValue: number;
  totalStores: number;
  totalEvents: number;
  stores: StoreDiscrepancy[];
}

export interface DiscrepancyPageProps {
  className?: string;
}
