/**
 * Shipment Provider
 * Zustand store for shipment feature state management
 * Uses Repository pattern for data access and slice pattern for code organization
 */

import { create } from 'zustand';
import { devtools } from 'zustand/middleware';
import { getShipmentRepository } from '../../data/repositories/ShipmentRepositoryImpl';
import type { ShipmentStore } from './states/shipment_state';
import { createListSlice } from './slices/listSlice';
import { createDetailSlice } from './slices/detailSlice';
import { createCreateSlice } from './slices/createSlice';

// ===== Store Creation =====

const repository = getShipmentRepository();

export const useShipmentStore = create<ShipmentStore>()(
  devtools(
    (...args) => ({
      ...createListSlice(repository)(...args),
      ...createDetailSlice(repository)(...args),
      ...createCreateSlice(repository)(...args),
    }),
    { name: 'shipment-store' }
  )
);

// ===== Selector Hooks =====

export const useShipmentListState = () => useShipmentStore((state) => state.list);
export const useShipmentDetailState = () => useShipmentStore((state) => state.detail);
export const useShipmentCreateState = () => useShipmentStore((state) => state.create);

// ===== Export Store Type =====
export type { ShipmentStore };
