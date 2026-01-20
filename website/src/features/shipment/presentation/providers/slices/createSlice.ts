/**
 * Create Slice
 * Zustand slice for shipment creation state management
 */

import type { StateCreator } from 'zustand';
import type { ShipmentStore } from '../states/shipment_state';
import { initialCreateState } from '../states/shipment_state';
import { ShipmentModel } from '../../../data/models/ShipmentModel';
import type { IShipmentRepository } from '../../../domain/repositories/IShipmentRepository';
import type { ShipmentItem } from '../../../domain/types';

// ===== Slice Creator =====

export const createCreateSlice = (
  repository: IShipmentRepository
): StateCreator<ShipmentStore, [], [], Pick<ShipmentStore, 'create'>> => (set, get) => ({
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

    addProductFromSearch: (product) => {
      const state = get();
      // v6: unique key is product_id + variant_id
      const existingItem = state.create.shipmentItems.find(
        (item) =>
          item.productId === product.product_id &&
          item.variantId === (product.variant_id || undefined)
      );

      if (existingItem) {
        set((s) => ({
          create: {
            ...s.create,
            shipmentItems: s.create.shipmentItems.map((item) =>
              item.productId === product.product_id &&
              item.variantId === (product.variant_id || undefined)
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
          // v6: response uses data.items instead of data.products
          set((state) => ({
            create: {
              ...state.create,
              searchResults: result.data?.items || [],
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
            // v6: unique key is product_id + variant_id
            const existingIndex = newShipmentItems.findIndex(
              (item) =>
                item.productId === product.product_id &&
                item.variantId === (product.variant_id || undefined)
            );

            if (existingIndex >= 0) {
              newShipmentItems[existingIndex].quantity += row.quantity;
              newShipmentItems[existingIndex].unitPrice = row.cost;
            } else {
              // v6: use display_name/display_sku for display
              newShipmentItems.push({
                orderItemId: `import-${product.product_id}-${product.variant_id || 'base'}-${Date.now()}`,
                orderId: '',
                orderNumber: '-',
                productId: product.product_id,
                variantId: product.variant_id || undefined,
                productName: product.display_name || product.product_name,
                sku: product.display_sku || product.product_sku,
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
      set(() => ({
        create: { ...initialCreateState },
      }));
    },
  },
});
