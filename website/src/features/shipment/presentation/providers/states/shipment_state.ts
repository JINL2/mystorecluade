/**
 * Shipment State Interface
 * State interface definition for shipment feature Zustand store
 */

import type {
  Currency,
  Counterparty,
  OrderInfo,
  OrderItem,
  ShipmentListItem,
  ShipmentDetail,
  ShipmentItem,
  InventoryProduct,
  SaveResult,
  ImportError,
  OneTimeSupplier,
  SelectionMode,
  DatePreset,
  SupplierOption,
} from '../../../domain/types';

// ===== List State =====

export interface ShipmentListState {
  // Data
  shipments: ShipmentListItem[];
  totalCount: number;
  currency: Currency;
  suppliers: Counterparty[];
  orders: OrderInfo[];

  // Loading states
  isLoading: boolean;
  isSuppliersLoading: boolean;
  isOrdersLoading: boolean;

  // Error state
  error: string | null;

  // Search
  searchQuery: string;

  // Date filters
  datePreset: DatePreset;
  fromDate: string;
  toDate: string;
  showDatePicker: boolean;
  tempFromDate: string;
  tempToDate: string;

  // Status filter
  shipmentStatusFilter: string | null;

  // Supplier filter
  supplierFilter: string | null;

  // Order filter
  orderFilter: string | null;
}

// ===== Detail State =====

export interface ShipmentDetailState {
  // Data
  shipmentDetail: ShipmentDetail | null;
  currency: Currency;

  // Loading state
  isLoading: boolean;

  // Error state
  error: string | null;
}

// ===== Create State =====

export interface ShipmentCreateState {
  // Currency
  currency: Currency;

  // Selection mode
  selectionMode: SelectionMode;

  // Suppliers
  suppliers: Counterparty[];
  isSuppliersLoading: boolean;
  selectedSupplier: string | null;

  // Supplier type (existing or one-time)
  supplierType: 'existing' | 'onetime';
  oneTimeSupplier: OneTimeSupplier;

  // Orders
  orders: OrderInfo[];
  isOrdersLoading: boolean;
  selectedOrder: string | null;

  // Order items (from selected order)
  orderItems: OrderItem[];
  isOrderItemsLoading: boolean;

  // Shipment items (items to be shipped)
  shipmentItems: ShipmentItem[];

  // Shipment details
  trackingNumber: string;
  notes: string;

  // Product search
  searchQuery: string;
  searchResults: InventoryProduct[];
  isSearching: boolean;
  showDropdown: boolean;

  // Item filter
  itemSearchQuery: string;

  // Save state
  isSaving: boolean;
  saveResult: SaveResult;

  // Import state
  isImporting: boolean;
  importError: ImportError;
}

// ===== Combined State =====

export interface ShipmentState {
  list: ShipmentListState;
  detail: ShipmentDetailState;
  create: ShipmentCreateState;
}

// ===== List Actions =====

export interface ShipmentListActions {
  // Data loading
  loadShipments: (params: {
    companyId: string;
    timezone: string;
    fromDate?: string;
    toDate?: string;
    statusFilter?: string;
    supplierFilter?: string;
    orderFilter?: string;
    search?: string;
  }) => Promise<void>;
  loadSuppliers: (companyId: string) => Promise<void>;
  loadOrders: (companyId: string, timezone: string) => Promise<void>;
  loadCurrency: (companyId: string) => Promise<void>;

  // Search
  setSearchQuery: (query: string) => void;

  // Date filters
  setDatePreset: (preset: DatePreset) => void;
  setFromDate: (date: string) => void;
  setToDate: (date: string) => void;
  setShowDatePicker: (show: boolean) => void;
  setTempFromDate: (date: string) => void;
  setTempToDate: (date: string) => void;
  applyCustomDate: () => void;
  cancelCustomDate: () => void;

  // Status filter
  setShipmentStatusFilter: (status: string | null) => void;
  toggleShipmentStatus: (status: string) => void;
  clearShipmentStatusFilter: () => void;

  // Supplier filter
  setSupplierFilter: (supplierId: string | null) => void;
  toggleSupplierFilter: (supplierId: string) => void;
  clearSupplierFilter: () => void;

  // Order filter
  setOrderFilter: (orderId: string | null) => void;
  toggleOrderFilter: (orderId: string) => void;
  clearOrderFilter: () => void;

  // Reset
  resetListState: () => void;
}

// ===== Detail Actions =====

export interface ShipmentDetailActions {
  // Data loading
  loadShipmentDetail: (params: {
    shipmentId: string;
    companyId: string;
    timezone: string;
  }) => Promise<void>;
  loadCurrency: (companyId: string) => Promise<void>;

  // Reset
  resetDetailState: () => void;
}

// ===== Create Actions =====

export interface ShipmentCreateActions {
  // Initialization
  initializeFromNavigation: (params: {
    currency?: Currency;
    suppliers?: Counterparty[];
    orders?: OrderInfo[];
  }) => void;

  // Currency
  loadCurrency: (companyId: string) => Promise<void>;

  // Selection mode
  setSelectionMode: (mode: SelectionMode) => void;

  // Suppliers
  loadSuppliers: (companyId: string) => Promise<void>;
  setSelectedSupplier: (supplierId: string | null) => void;
  handleSupplierChange: (supplierId: string | null) => void;
  handleSupplierSectionChange: (supplierId: string | null) => void;
  clearSupplierSelection: () => void;

  // Supplier type
  setSupplierType: (type: 'existing' | 'onetime') => void;
  setOneTimeSupplier: (supplier: OneTimeSupplier) => void;
  updateOneTimeSupplierField: (field: keyof OneTimeSupplier, value: string) => void;

  // Orders
  loadOrders: (companyId: string, timezone: string) => Promise<void>;
  setSelectedOrder: (orderId: string | null) => void;
  handleOrderChange: (orderId: string | null) => void;

  // Order items
  loadOrderItems: (orderId: string, timezone: string) => Promise<void>;

  // Shipment items
  addItem: (orderItem: OrderItem, order: OrderInfo) => void;
  addAllItems: (order: OrderInfo) => void;
  addProductFromSearch: (product: InventoryProduct) => void;
  removeItem: (orderItemId: string) => void;
  updateItemQuantity: (orderItemId: string, quantity: number) => void;
  updateItemCost: (index: number, cost: number) => void;
  setShipmentItems: (items: ShipmentItem[]) => void;

  // Shipment details
  setTrackingNumber: (value: string) => void;
  setNotes: (value: string) => void;

  // Product search
  setSearchQuery: (query: string) => void;
  searchProducts: (params: {
    companyId: string;
    storeId: string;
    query: string;
    timezone: string;
  }) => Promise<void>;
  searchProductBySku: (params: {
    companyId: string;
    storeId: string;
    sku: string;
    timezone: string;
  }) => Promise<InventoryProduct | null>;
  clearSearch: () => void;
  setShowDropdown: (show: boolean) => void;

  // Item filter
  setItemSearchQuery: (query: string) => void;

  // Save
  saveShipment: (params: {
    companyId: string;
    userId: string;
    timezone: string;
  }) => Promise<boolean>;
  setSaveResult: (result: SaveResult) => void;
  closeSaveResult: () => void;

  // Import
  importFromExcel: (params: {
    companyId: string;
    storeId: string;
    timezone: string;
    rows: Array<{ sku: string; cost: number; quantity: number }>;
  }) => Promise<void>;
  setImportError: (error: ImportError) => void;
  closeImportError: () => void;

  // Reset
  resetCreateState: () => void;
}

// ===== Combined Actions =====

export interface ShipmentActions {
  list: ShipmentListActions;
  detail: ShipmentDetailActions;
  create: ShipmentCreateActions;
}

// ===== Store Type =====

export type ShipmentStore = ShipmentState & ShipmentActions;

// ===== Initial States =====

export const initialListState: ShipmentListState = {
  shipments: [],
  totalCount: 0,
  currency: { symbol: '₩', code: 'KRW' },
  suppliers: [],
  orders: [],
  isLoading: false,
  isSuppliersLoading: false,
  isOrdersLoading: false,
  error: null,
  searchQuery: '',
  datePreset: 'this_month',
  fromDate: '',
  toDate: '',
  showDatePicker: false,
  tempFromDate: '',
  tempToDate: '',
  shipmentStatusFilter: null,
  supplierFilter: null,
  orderFilter: null,
};

export const initialDetailState: ShipmentDetailState = {
  shipmentDetail: null,
  currency: { symbol: '₩', code: 'KRW' },
  isLoading: false,
  error: null,
};

export const initialCreateState: ShipmentCreateState = {
  currency: { symbol: '₩', code: 'KRW' },
  selectionMode: null,
  suppliers: [],
  isSuppliersLoading: false,
  selectedSupplier: null,
  supplierType: 'existing',
  oneTimeSupplier: { name: '', phone: '', email: '', address: '' },
  orders: [],
  isOrdersLoading: false,
  selectedOrder: null,
  orderItems: [],
  isOrderItemsLoading: false,
  shipmentItems: [],
  trackingNumber: '',
  notes: '',
  searchQuery: '',
  searchResults: [],
  isSearching: false,
  showDropdown: false,
  itemSearchQuery: '',
  isSaving: false,
  saveResult: { show: false, success: false, message: '' },
  isImporting: false,
  importError: { show: false, notFoundSkus: [] },
};

// ===== Computed Values Helpers =====

export const getSupplierOptions = (suppliers: Counterparty[]): SupplierOption[] => {
  return suppliers.map((supplier) => ({
    value: supplier.counterparty_id,
    label: supplier.name,
    description: supplier.is_internal ? 'INTERNAL' : undefined,
  }));
};

export const getOrderOptions = (orders: OrderInfo[]) => {
  return orders.map((order) => ({
    value: order.order_id,
    label: `${order.order_number} - ${order.supplier_name}`,
  }));
};

export const getFilteredOrders = (orders: OrderInfo[], supplierId: string | null): OrderInfo[] => {
  if (!supplierId) return orders;
  return orders.filter((order) => order.supplier_id === supplierId);
};

export const getFilteredShipmentItems = (items: ShipmentItem[], searchQuery: string): ShipmentItem[] => {
  if (!searchQuery.trim()) return items;
  const query = searchQuery.toLowerCase().trim();
  return items.filter(
    (item) =>
      item.productName.toLowerCase().includes(query) ||
      item.sku.toLowerCase().includes(query) ||
      item.orderNumber.toLowerCase().includes(query)
  );
};

export const calculateTotalAmount = (items: ShipmentItem[]): number => {
  return items.reduce((sum, item) => sum + item.quantity * item.unitPrice, 0);
};

export const isCreateFormValid = (state: ShipmentCreateState): boolean => {
  if (state.isSaving) return false;
  if (state.shipmentItems.length === 0) return false;
  if (!state.selectionMode) return false;

  if (state.selectionMode === 'order') {
    return !!state.selectedOrder;
  }

  if (state.selectionMode === 'supplier') {
    if (state.supplierType === 'existing') {
      return !!state.selectedSupplier;
    }
    return !!state.oneTimeSupplier.name.trim();
  }

  return false;
};
