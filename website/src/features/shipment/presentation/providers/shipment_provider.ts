/**
 * Shipment Provider
 * Zustand store for shipment feature state management
 * Uses Repository pattern for data access
 */

import { create } from 'zustand';
import { devtools } from 'zustand/middleware';
import { getShipmentRepository } from '../../data/repositories/ShipmentRepositoryImpl';
import { ShipmentModel } from '../../data/models/ShipmentModel';
import type {
  ShipmentStore,
  ShipmentListState,
  ShipmentDetailState,
  ShipmentCreateState,
  DatePreset,
} from './states/shipment_state';
import {
  initialListState,
  initialDetailState,
  initialCreateState,
} from './states/shipment_state';
import type {
  Currency,
  Counterparty,
  OrderInfo,
  OrderItem,
  ShipmentItem,
  InventoryProduct,
  SaveResult,
  ImportError,
  OneTimeSupplier,
  SelectionMode,
} from './states/types';

// ===== Date Utilities =====

const getDateRangeForPreset = (preset: DatePreset): { from: string; to: string } => {
  const today = new Date();
  const year = today.getFullYear();
  const month = today.getMonth();

  switch (preset) {
    case 'this_month': {
      const firstDay = new Date(year, month, 1);
      const lastDay = new Date(year, month + 1, 0);
      return {
        from: firstDay.toISOString().split('T')[0],
        to: lastDay.toISOString().split('T')[0],
      };
    }
    case 'last_month': {
      const firstDay = new Date(year, month - 1, 1);
      const lastDay = new Date(year, month, 0);
      return {
        from: firstDay.toISOString().split('T')[0],
        to: lastDay.toISOString().split('T')[0],
      };
    }
    case 'this_year': {
      const firstDay = new Date(year, 0, 1);
      const lastDay = new Date(year, 11, 31);
      return {
        from: firstDay.toISOString().split('T')[0],
        to: lastDay.toISOString().split('T')[0],
      };
    }
    default:
      return { from: '', to: '' };
  }
};

// ===== Store Creation =====

export const useShipmentStore = create<ShipmentStore>()(
  devtools(
    (set, get) => {
      const repository = getShipmentRepository();

      return {
        // ===== Initial State =====
        list: { ...initialListState },
        detail: { ...initialDetailState },
        create: { ...initialCreateState },

        // ===== List Actions =====
        list: {
          ...initialListState,

          loadShipments: async (params) => {
            set((state) => ({
              list: { ...state.list, isLoading: true, error: null },
            }));

            try {
              const result = await repository.getShipmentList({
                companyId: params.companyId,
                timezone: params.timezone,
                fromDate: params.fromDate,
                toDate: params.toDate,
                statusFilter: params.statusFilter,
                supplierFilter: params.supplierFilter,
                orderFilter: params.orderFilter,
              });

              if (result.success && result.data) {
                set((state) => ({
                  list: {
                    ...state.list,
                    shipments: result.data || [],
                    totalCount: result.totalCount || 0,
                    isLoading: false,
                  },
                }));
              } else {
                set((state) => ({
                  list: {
                    ...state.list,
                    shipments: [],
                    totalCount: 0,
                    isLoading: false,
                    error: result.error || 'Failed to load shipments',
                  },
                }));
              }
            } catch (err) {
              set((state) => ({
                list: {
                  ...state.list,
                  isLoading: false,
                  error: err instanceof Error ? err.message : 'Failed to load shipments',
                },
              }));
            }
          },

          loadSuppliers: async (companyId) => {
            set((state) => ({
              list: { ...state.list, isSuppliersLoading: true },
            }));

            try {
              const result = await repository.getCounterparties(companyId);
              if (result.success && result.data) {
                set((state) => ({
                  list: {
                    ...state.list,
                    suppliers: result.data || [],
                    isSuppliersLoading: false,
                  },
                }));
              } else {
                set((state) => ({
                  list: { ...state.list, isSuppliersLoading: false },
                }));
              }
            } catch {
              set((state) => ({
                list: { ...state.list, isSuppliersLoading: false },
              }));
            }
          },

          loadOrders: async (companyId, timezone) => {
            set((state) => ({
              list: { ...state.list, isOrdersLoading: true },
            }));

            try {
              const result = await repository.getOrders({ companyId, timezone });
              if (result.success && result.data) {
                set((state) => ({
                  list: {
                    ...state.list,
                    orders: result.data || [],
                    isOrdersLoading: false,
                  },
                }));
              } else {
                set((state) => ({
                  list: { ...state.list, isOrdersLoading: false },
                }));
              }
            } catch {
              set((state) => ({
                list: { ...state.list, isOrdersLoading: false },
              }));
            }
          },

          loadCurrency: async (companyId) => {
            try {
              const result = await repository.getBaseCurrency(companyId);
              if (result) {
                set((state) => ({
                  list: { ...state.list, currency: result },
                }));
              }
            } catch {
              // Keep default currency
            }
          },

          setSearchQuery: (query) => {
            set((state) => ({
              list: { ...state.list, searchQuery: query },
            }));
          },

          setDatePreset: (preset) => {
            const range = preset !== 'custom' ? getDateRangeForPreset(preset) : { from: '', to: '' };
            set((state) => ({
              list: {
                ...state.list,
                datePreset: preset,
                ...(preset !== 'custom' && {
                  fromDate: range.from,
                  toDate: range.to,
                  showDatePicker: false,
                }),
                ...(preset === 'custom' && {
                  tempFromDate: state.list.fromDate,
                  tempToDate: state.list.toDate,
                  showDatePicker: true,
                }),
              },
            }));
          },

          setFromDate: (date) => {
            set((state) => ({
              list: { ...state.list, fromDate: date },
            }));
          },

          setToDate: (date) => {
            set((state) => ({
              list: { ...state.list, toDate: date },
            }));
          },

          setShowDatePicker: (show) => {
            set((state) => ({
              list: { ...state.list, showDatePicker: show },
            }));
          },

          setTempFromDate: (date) => {
            set((state) => ({
              list: { ...state.list, tempFromDate: date },
            }));
          },

          setTempToDate: (date) => {
            set((state) => ({
              list: { ...state.list, tempToDate: date },
            }));
          },

          applyCustomDate: () => {
            set((state) => ({
              list: {
                ...state.list,
                fromDate: state.list.tempFromDate,
                toDate: state.list.tempToDate,
                showDatePicker: false,
              },
            }));
          },

          cancelCustomDate: () => {
            const state = get();
            if (state.list.datePreset === 'custom' && !state.list.fromDate && !state.list.toDate) {
              const range = getDateRangeForPreset('this_month');
              set((s) => ({
                list: {
                  ...s.list,
                  datePreset: 'this_month',
                  fromDate: range.from,
                  toDate: range.to,
                  showDatePicker: false,
                },
              }));
            } else {
              set((s) => ({
                list: { ...s.list, showDatePicker: false },
              }));
            }
          },

          setShipmentStatusFilter: (status) => {
            set((state) => ({
              list: { ...state.list, shipmentStatusFilter: status },
            }));
          },

          toggleShipmentStatus: (status) => {
            set((state) => ({
              list: {
                ...state.list,
                shipmentStatusFilter: state.list.shipmentStatusFilter === status ? null : status,
              },
            }));
          },

          clearShipmentStatusFilter: () => {
            set((state) => ({
              list: { ...state.list, shipmentStatusFilter: null },
            }));
          },

          setSupplierFilter: (supplierId) => {
            set((state) => ({
              list: { ...state.list, supplierFilter: supplierId },
            }));
          },

          toggleSupplierFilter: (supplierId) => {
            set((state) => ({
              list: {
                ...state.list,
                supplierFilter: state.list.supplierFilter === supplierId ? null : supplierId,
              },
            }));
          },

          clearSupplierFilter: () => {
            set((state) => ({
              list: { ...state.list, supplierFilter: null },
            }));
          },

          setOrderFilter: (orderId) => {
            set((state) => ({
              list: { ...state.list, orderFilter: orderId },
            }));
          },

          toggleOrderFilter: (orderId) => {
            set((state) => ({
              list: {
                ...state.list,
                orderFilter: state.list.orderFilter === orderId ? null : orderId,
              },
            }));
          },

          clearOrderFilter: () => {
            set((state) => ({
              list: { ...state.list, orderFilter: null },
            }));
          },

          resetListState: () => {
            set((state) => ({
              list: { ...initialListState },
            }));
          },
        },

        // ===== Detail Actions =====
        detail: {
          ...initialDetailState,

          loadShipmentDetail: async (params) => {
            set((state) => ({
              detail: { ...state.detail, isLoading: true, error: null },
            }));

            try {
              const result = await repository.getShipmentDetail(params);

              if (result.success && result.data) {
                set((state) => ({
                  detail: {
                    ...state.detail,
                    shipmentDetail: result.data || null,
                    isLoading: false,
                  },
                }));
              } else {
                set((state) => ({
                  detail: {
                    ...state.detail,
                    shipmentDetail: null,
                    isLoading: false,
                    error: result.error || 'Failed to load shipment detail',
                  },
                }));
              }
            } catch (err) {
              set((state) => ({
                detail: {
                  ...state.detail,
                  isLoading: false,
                  error: err instanceof Error ? err.message : 'Failed to load shipment detail',
                },
              }));
            }
          },

          loadCurrency: async (companyId) => {
            try {
              const result = await repository.getBaseCurrency(companyId);
              if (result) {
                set((state) => ({
                  detail: { ...state.detail, currency: result },
                }));
              }
            } catch {
              // Keep default currency
            }
          },

          cancelShipment: async (params) => {
            try {
              const result = await repository.cancelShipment(params);
              return result.success;
            } catch {
              return false;
            }
          },

          resetDetailState: () => {
            set((state) => ({
              detail: { ...initialDetailState },
            }));
          },
        },

        // ===== Create Actions =====
        create: {
          ...initialCreateState,

          initializeFromNavigation: (params) => {
            set((state) => ({
              create: {
                ...state.create,
                ...(params.currency && { currency: params.currency }),
                ...(params.suppliers && { suppliers: params.suppliers }),
                ...(params.orders && { orders: params.orders }),
              },
            }));
          },

          loadCurrency: async (companyId) => {
            try {
              const result = await repository.getBaseCurrency(companyId);
              if (result) {
                set((state) => ({
                  create: { ...state.create, currency: result },
                }));
              }
            } catch {
              // Keep default currency
            }
          },

          setSelectionMode: (mode) => {
            set((state) => ({
              create: { ...state.create, selectionMode: mode },
            }));
          },

          loadSuppliers: async (companyId) => {
            set((state) => ({
              create: { ...state.create, isSuppliersLoading: true },
            }));

            try {
              const result = await repository.getCounterparties(companyId);
              if (result.success && result.data) {
                set((state) => ({
                  create: {
                    ...state.create,
                    suppliers: result.data || [],
                    isSuppliersLoading: false,
                  },
                }));
              } else {
                set((state) => ({
                  create: { ...state.create, isSuppliersLoading: false },
                }));
              }
            } catch {
              set((state) => ({
                create: { ...state.create, isSuppliersLoading: false },
              }));
            }
          },

          setSelectedSupplier: (supplierId) => {
            set((state) => ({
              create: { ...state.create, selectedSupplier: supplierId },
            }));
          },

          handleSupplierChange: (supplierId) => {
            const state = get();
            set((s) => ({
              create: { ...s.create, selectedSupplier: supplierId },
            }));

            // Clear order selection if it's not in the filtered list
            if (supplierId && state.create.selectedOrder) {
              const orderStillValid = state.create.orders.some(
                (o) => o.order_id === state.create.selectedOrder && o.supplier_id === supplierId
              );
              if (!orderStillValid) {
                set((s) => ({
                  create: {
                    ...s.create,
                    selectedOrder: null,
                    orderItems: [],
                    shipmentItems: [],
                  },
                }));
              }
            }
          },

          handleSupplierSectionChange: (supplierId) => {
            set((state) => ({
              create: {
                ...state.create,
                selectedSupplier: supplierId,
                selectionMode: supplierId ? 'supplier' : null,
                selectedOrder: null,
                orderItems: [],
                shipmentItems: [],
              },
            }));
          },

          clearSupplierSelection: () => {
            set((state) => ({
              create: {
                ...state.create,
                selectedSupplier: null,
                oneTimeSupplier: { name: '', phone: '', email: '', address: '' },
                selectionMode: null,
              },
            }));
          },

          setSupplierType: (type) => {
            set((state) => ({
              create: {
                ...state.create,
                supplierType: type,
                ...(type === 'existing'
                  ? { oneTimeSupplier: { name: '', phone: '', email: '', address: '' } }
                  : { selectedSupplier: null, selectionMode: null }),
              },
            }));
          },

          setOneTimeSupplier: (supplier) => {
            set((state) => ({
              create: { ...state.create, oneTimeSupplier: supplier },
            }));
          },

          updateOneTimeSupplierField: (field, value) => {
            const state = get();
            const newSupplier = { ...state.create.oneTimeSupplier, [field]: value };

            const allFieldsEmpty =
              !newSupplier.name.trim() &&
              !newSupplier.phone.trim() &&
              !newSupplier.email.trim() &&
              !newSupplier.address.trim();

            set((s) => ({
              create: {
                ...s.create,
                oneTimeSupplier: newSupplier,
                selectionMode: allFieldsEmpty ? null : 'supplier',
                ...(allFieldsEmpty ? {} : {
                  selectedOrder: null,
                  orderItems: [],
                  shipmentItems: [],
                }),
              },
            }));
          },

          loadOrders: async (companyId, timezone) => {
            set((state) => ({
              create: { ...state.create, isOrdersLoading: true },
            }));

            try {
              const result = await repository.getOrders({ companyId, timezone });
              if (result.success && result.data) {
                set((state) => ({
                  create: {
                    ...state.create,
                    orders: result.data || [],
                    isOrdersLoading: false,
                  },
                }));
              } else {
                set((state) => ({
                  create: { ...state.create, orders: [], isOrdersLoading: false },
                }));
              }
            } catch {
              set((state) => ({
                create: { ...state.create, orders: [], isOrdersLoading: false },
              }));
            }
          },

          setSelectedOrder: (orderId) => {
            set((state) => ({
              create: { ...state.create, selectedOrder: orderId },
            }));
          },

          handleOrderChange: (orderId) => {
            const state = get();

            if (orderId) {
              const selectedOrderData = state.create.orders.find((o) => o.order_id === orderId);
              set((s) => ({
                create: {
                  ...s.create,
                  selectedOrder: orderId,
                  shipmentItems: [],
                  selectionMode: 'order',
                  ...(selectedOrderData?.supplier_id &&
                    selectedOrderData.supplier_id !== s.create.selectedSupplier && {
                      selectedSupplier: selectedOrderData.supplier_id,
                    }),
                },
              }));
            } else {
              set((s) => ({
                create: {
                  ...s.create,
                  selectedOrder: null,
                  selectionMode: null,
                },
              }));
            }
          },

          loadOrderItems: async (orderId, timezone) => {
            set((state) => ({
              create: { ...state.create, isOrderItemsLoading: true },
            }));

            try {
              const result = await repository.getOrderItems({ orderId, timezone });
              if (result.success && result.data) {
                // Filter items with remaining quantity > 0
                const availableItems = result.data.filter(
                  (item: OrderItem) => item.remaining_quantity > 0
                );
                set((state) => ({
                  create: {
                    ...state.create,
                    orderItems: availableItems,
                    isOrderItemsLoading: false,
                  },
                }));
              } else {
                set((state) => ({
                  create: { ...state.create, orderItems: [], isOrderItemsLoading: false },
                }));
              }
            } catch {
              set((state) => ({
                create: { ...state.create, orderItems: [], isOrderItemsLoading: false },
              }));
            }
          },

          addItem: (orderItem, order) => {
            const state = get();
            const exists = state.create.shipmentItems.find(
              (item) => item.orderItemId === orderItem.order_item_id
            );
            if (exists) return;

            const newItem: ShipmentItem = {
              orderItemId: orderItem.order_item_id,
              orderId: order.order_id,
              orderNumber: order.order_number,
              productId: orderItem.product_id,
              productName: orderItem.product_name,
              sku: orderItem.sku,
              quantity: orderItem.remaining_quantity,
              maxQuantity: orderItem.remaining_quantity,
              unitPrice: orderItem.unit_price,
            };

            set((s) => ({
              create: {
                ...s.create,
                shipmentItems: [...s.create.shipmentItems, newItem],
              },
            }));
          },

          addAllItems: (order) => {
            const state = get();
            const newItems: ShipmentItem[] = state.create.orderItems
              .filter(
                (oi) => !state.create.shipmentItems.find((si) => si.orderItemId === oi.order_item_id)
              )
              .map((orderItem) => ({
                orderItemId: orderItem.order_item_id,
                orderId: order.order_id,
                orderNumber: order.order_number,
                productId: orderItem.product_id,
                productName: orderItem.product_name,
                sku: orderItem.sku,
                quantity: orderItem.remaining_quantity,
                maxQuantity: orderItem.remaining_quantity,
                unitPrice: orderItem.unit_price,
              }));

            set((s) => ({
              create: {
                ...s.create,
                shipmentItems: [...s.create.shipmentItems, ...newItems],
              },
            }));
          },

          addProductFromSearch: (product) => {
            const state = get();
            const existingItem = state.create.shipmentItems.find(
              (item) => item.productId === product.product_id
            );

            if (existingItem) {
              set((s) => ({
                create: {
                  ...s.create,
                  shipmentItems: s.create.shipmentItems.map((item) =>
                    item.productId === product.product_id
                      ? { ...item, quantity: item.quantity + 1 }
                      : item
                  ),
                },
              }));
            } else {
              const newItem = ShipmentModel.fromProduct(product);
              set((s) => ({
                create: {
                  ...s.create,
                  shipmentItems: [...s.create.shipmentItems, newItem],
                },
              }));
            }
          },

          removeItem: (orderItemId) => {
            set((state) => ({
              create: {
                ...state.create,
                shipmentItems: state.create.shipmentItems.filter(
                  (item) => item.orderItemId !== orderItemId
                ),
              },
            }));
          },

          updateItemQuantity: (orderItemId, quantity) => {
            set((state) => ({
              create: {
                ...state.create,
                shipmentItems: state.create.shipmentItems.map((item) =>
                  item.orderItemId === orderItemId
                    ? { ...item, quantity: Math.max(0, quantity) }
                    : item
                ),
              },
            }));
          },

          updateItemCost: (index, cost) => {
            set((state) => ({
              create: {
                ...state.create,
                shipmentItems: state.create.shipmentItems.map((item, i) =>
                  i === index ? { ...item, unitPrice: cost } : item
                ),
              },
            }));
          },

          setShipmentItems: (items) => {
            set((state) => ({
              create: { ...state.create, shipmentItems: items },
            }));
          },

          setTrackingNumber: (value) => {
            set((state) => ({
              create: { ...state.create, trackingNumber: value },
            }));
          },

          setNotes: (value) => {
            set((state) => ({
              create: { ...state.create, notes: value },
            }));
          },

          setSearchQuery: (query) => {
            set((state) => ({
              create: { ...state.create, searchQuery: query },
            }));
          },

          searchProducts: async (params) => {
            if (!params.query.trim()) {
              set((state) => ({
                create: {
                  ...state.create,
                  searchResults: [],
                  showDropdown: false,
                },
              }));
              return;
            }

            set((state) => ({
              create: { ...state.create, isSearching: true },
            }));

            try {
              const result = await repository.searchProducts({
                companyId: params.companyId,
                storeId: params.storeId,
                query: params.query,
                timezone: params.timezone,
              });

              if (result.success && result.data) {
                set((state) => ({
                  create: {
                    ...state.create,
                    searchResults: result.data?.products || [],
                    showDropdown: true,
                    isSearching: false,
                    ...(result.data?.currency && { currency: result.data.currency }),
                  },
                }));
              } else {
                set((state) => ({
                  create: {
                    ...state.create,
                    searchResults: [],
                    showDropdown: true,
                    isSearching: false,
                  },
                }));
              }
            } catch {
              set((state) => ({
                create: {
                  ...state.create,
                  searchResults: [],
                  isSearching: false,
                },
              }));
            }
          },

          searchProductBySku: async (params) => {
            return await repository.searchProductBySku(params);
          },

          clearSearch: () => {
            set((state) => ({
              create: {
                ...state.create,
                searchQuery: '',
                searchResults: [],
                showDropdown: false,
              },
            }));
          },

          setShowDropdown: (show) => {
            set((state) => ({
              create: { ...state.create, showDropdown: show },
            }));
          },

          setItemSearchQuery: (query) => {
            set((state) => ({
              create: { ...state.create, itemSearchQuery: query },
            }));
          },

          saveShipment: async (params) => {
            const state = get();
            const { create } = state;

            set((s) => ({
              create: { ...s.create, isSaving: true },
            }));

            try {
              const items = ShipmentModel.toRpcCreateItems(
                create.shipmentItems.map((item) => ({
                  orderItemId: item.orderItemId,
                  orderId: item.orderId,
                  orderNumber: item.orderNumber,
                  productId: item.productId,
                  productName: item.productName,
                  sku: item.sku,
                  quantity: item.quantity,
                  maxQuantity: item.maxQuantity,
                  unitPrice: item.unitPrice,
                }))
              );

              const createParams: Parameters<typeof repository.createShipment>[0] = {
                companyId: params.companyId,
                userId: params.userId,
                items,
                time: new Date().toISOString(),
                timezone: params.timezone,
              };

              if (create.selectionMode === 'order' && create.selectedOrder) {
                createParams.orderIds = [create.selectedOrder];
              } else if (create.selectionMode === 'supplier') {
                if (create.supplierType === 'existing') {
                  createParams.counterpartyId = create.selectedSupplier || undefined;
                } else {
                  createParams.supplierInfo = {
                    name: create.oneTimeSupplier.name.trim(),
                    phone: create.oneTimeSupplier.phone.trim(),
                    email: create.oneTimeSupplier.email.trim(),
                    address: create.oneTimeSupplier.address.trim(),
                  };
                }
              }

              if (create.trackingNumber.trim()) {
                createParams.trackingNumber = create.trackingNumber.trim();
              }
              if (create.notes.trim()) {
                createParams.notes = create.notes.trim();
              }

              const result = await repository.createShipment(createParams);

              set((s) => ({
                create: {
                  ...s.create,
                  isSaving: false,
                  saveResult: {
                    show: true,
                    success: result.success,
                    message: result.success
                      ? `Shipment ${result.shipmentNumber} has been created successfully.`
                      : result.error || 'Failed to create shipment',
                    shipmentNumber: result.shipmentNumber,
                  },
                },
              }));

              return result.success;
            } catch (err) {
              set((s) => ({
                create: {
                  ...s.create,
                  isSaving: false,
                  saveResult: {
                    show: true,
                    success: false,
                    message: err instanceof Error ? err.message : 'Failed to create shipment',
                  },
                },
              }));
              return false;
            }
          },

          setSaveResult: (result) => {
            set((state) => ({
              create: { ...state.create, saveResult: result },
            }));
          },

          closeSaveResult: () => {
            set((state) => ({
              create: {
                ...state.create,
                saveResult: { show: false, success: false, message: '' },
              },
            }));
          },

          importFromExcel: async (params) => {
            set((state) => ({
              create: { ...state.create, isImporting: true },
            }));

            try {
              const notFoundSkus: string[] = [];
              const newShipmentItems = [...get().create.shipmentItems];

              for (const row of params.rows) {
                const product = await repository.searchProductBySku({
                  companyId: params.companyId,
                  storeId: params.storeId,
                  sku: row.sku,
                  timezone: params.timezone,
                });

                if (product) {
                  const existingIndex = newShipmentItems.findIndex(
                    (item) => item.productId === product.product_id
                  );

                  if (existingIndex >= 0) {
                    newShipmentItems[existingIndex].quantity += row.quantity;
                    newShipmentItems[existingIndex].unitPrice = row.cost;
                  } else {
                    newShipmentItems.push({
                      orderItemId: `import-${product.product_id}-${Date.now()}`,
                      orderId: '',
                      orderNumber: '-',
                      productId: product.product_id,
                      productName: product.product_name,
                      sku: product.sku,
                      quantity: row.quantity,
                      maxQuantity: product.stock.quantity_on_hand,
                      unitPrice: row.cost,
                    });
                  }
                } else {
                  notFoundSkus.push(row.sku);
                }
              }

              set((state) => ({
                create: {
                  ...state.create,
                  shipmentItems: newShipmentItems,
                  isImporting: false,
                  ...(notFoundSkus.length > 0 && {
                    importError: { show: true, notFoundSkus },
                  }),
                },
              }));
            } catch (err) {
              set((state) => ({
                create: {
                  ...state.create,
                  isImporting: false,
                  importError: {
                    show: true,
                    notFoundSkus: [
                      `Failed to import: ${err instanceof Error ? err.message : 'Unknown error'}`,
                    ],
                  },
                },
              }));
            }
          },

          setImportError: (error) => {
            set((state) => ({
              create: { ...state.create, importError: error },
            }));
          },

          closeImportError: () => {
            set((state) => ({
              create: {
                ...state.create,
                importError: { show: false, notFoundSkus: [] },
              },
            }));
          },

          resetCreateState: () => {
            set((state) => ({
              create: { ...initialCreateState },
            }));
          },
        },
      };
    },
    { name: 'shipment-store' }
  )
);

// ===== Selector Hooks =====

export const useShipmentListState = () => useShipmentStore((state) => state.list);
export const useShipmentDetailState = () => useShipmentStore((state) => state.detail);
export const useShipmentCreateState = () => useShipmentStore((state) => state.create);

// ===== Export Store Type =====
export type { ShipmentStore };
