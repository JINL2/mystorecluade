/**
 * Discrepancy Overview Entity
 * Domain entity for RPC response mapping
 */

// Cumulative totals
export interface DiscrepancyCumulative {
  increaseValue: number;
  decreaseValue: number;
  netValue: number;
  netPct: number;
}

// Store discrepancy data (success case)
export interface DiscrepancyStore {
  storeName: string;
  netValue: number;
  increaseValue: number;
  decreaseValue: number;
  increaseCount: number;
  decreaseCount: number;
}

// Store data for insufficient case
export interface InsufficientStore {
  storeName: string;
  totalEvents: number;
  netValue: number;
}

// Success response
export interface DiscrepancyOverviewSuccess {
  status: 'success';
  period: string;
  cumulative: DiscrepancyCumulative;
  stores: DiscrepancyStore[];
}

// Insufficient data response
export interface DiscrepancyOverviewInsufficient {
  status: 'insufficient_data';
  message: string;
  minRequired: string;
  stores: InsufficientStore[] | null;
}

// Union type for all responses
export type DiscrepancyOverview = DiscrepancyOverviewSuccess | DiscrepancyOverviewInsufficient;

/**
 * Maps RPC response to domain entity
 */
export function mapDiscrepancyOverviewFromRpc(data: Record<string, unknown>): DiscrepancyOverview {
  const status = data.status as string;

  if (status === 'insufficient_data') {
    const storesData = data.stores as Array<Record<string, unknown>> | null;

    return {
      status: 'insufficient_data',
      message: String(data.message ?? ''),
      minRequired: String(data.min_required ?? ''),
      stores: storesData
        ? storesData.map((store) => ({
            storeName: String(store.store_name ?? ''),
            totalEvents: Number(store.total_events ?? 0),
            netValue: Number(store.net_value ?? 0),
          }))
        : null,
    };
  }

  // Success case
  const cumulativeData = data.cumulative as Record<string, unknown> | undefined;
  const storesData = data.stores as Array<Record<string, unknown>> | undefined;

  return {
    status: 'success',
    period: String(data.period ?? ''),
    cumulative: {
      increaseValue: Number(cumulativeData?.increase_value ?? 0),
      decreaseValue: Number(cumulativeData?.decrease_value ?? 0),
      netValue: Number(cumulativeData?.net_value ?? 0),
      netPct: Number(cumulativeData?.net_pct ?? 0),
    },
    stores: (storesData ?? []).map((store) => ({
      storeName: String(store.store_name ?? ''),
      netValue: Number(store.net_value ?? 0),
      increaseValue: Number(store.increase_value ?? 0),
      decreaseValue: Number(store.decrease_value ?? 0),
      increaseCount: Number(store.increase_count ?? 0),
      decreaseCount: Number(store.decrease_count ?? 0),
    })),
  };
}
