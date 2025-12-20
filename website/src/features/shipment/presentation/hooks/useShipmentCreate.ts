/**
 * useShipmentCreate Hook
 * Main hook for shipment creation form management
 * Composes smaller specialized hooks for better maintainability
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { getShipmentRepository } from '../../data/repositories/ShipmentRepositoryImpl';
import { supabaseService } from '@/core/services/supabase_service';
import type {
  Counterparty,
  OrderInfo,
  Currency,
  SaveResult,
  SelectionMode,
} from '../pages/ShipmentCreatePage/ShipmentCreatePage.types';

import { useShipmentCreateSupplier } from './useShipmentCreateSupplier';
import { useShipmentCreateOrder } from './useShipmentCreateOrder';
import { useShipmentCreateItems } from './useShipmentCreateItems';
import { useShipmentCreateImport } from './useShipmentCreateImport';
import { useShipmentCreateSearch } from './useShipmentCreateSearch';

// Navigation state interface
interface NavigationState {
  currency?: Currency;
  suppliers?: Counterparty[];
  orders?: OrderInfo[];
}

export const useShipmentCreate = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const repository = useMemo(() => getShipmentRepository(), []);

  // App state
  const { currentCompany, currentStore } = useAppState();
  const companyId = currentCompany?.company_id;
  const storeId = currentStore?.store_id;

  // Get navigation state
  const navigationState = location.state as NavigationState | null;
  const currencyFromState = navigationState?.currency;
  const suppliersFromState = navigationState?.suppliers;
  const ordersFromState = navigationState?.orders;

  // Currency state
  const [currency, setCurrency] = useState<Currency>(
    currencyFromState || { symbol: '₩', code: 'KRW' }
  );

  // Selection mode state
  const [selectionMode, setSelectionMode] = useState<SelectionMode>(null);

  // Save states
  const [isSaving, setIsSaving] = useState(false);
  const [saveResult, setSaveResult] = useState<SaveResult>({
    show: false,
    success: false,
    message: '',
  });

  // Shipment details
  const [shipmentTitle, setShipmentTitle] = useState<string>('');
  const [trackingNumber, setTrackingNumber] = useState<string>('');
  const [note, setNote] = useState<string>('');

  // Items hook (needs to be initialized first for clearShipmentItems)
  const itemsHook = useShipmentCreateItems({
    selectedOrder: null, // Will be updated via effect
    allOrders: [],
    orderItems: [],
  });

  // Supplier hook
  const supplierHook = useShipmentCreateSupplier({
    companyId,
    suppliersFromState,
    onSelectionModeChange: setSelectionMode,
    onClearOrderSelection: () => {
      orderHook.clearOrderSelection();
      itemsHook.clearShipmentItems();
    },
  });

  // Order hook
  const orderHook = useShipmentCreateOrder({
    companyId,
    ordersFromState,
    selectedSupplier: supplierHook.selectedSupplier,
    onSelectionModeChange: setSelectionMode,
    onSupplierChange: supplierHook.setSelectedSupplier,
    onClearShipmentItems: itemsHook.clearShipmentItems,
  });

  // Re-initialize items hook with correct dependencies
  const {
    shipmentItems,
    setShipmentItems,
    totalAmount,
    handleAddItem,
    handleAddAllItems,
    handleAddProductFromSearch,
    handleRemoveItem,
    handleQuantityChange,
    handleCostChange,
    clearShipmentItems,
    itemSearchQuery,
    setItemSearchQuery,
    filteredShipmentItems,
  } = useShipmentCreateItems({
    selectedOrder: orderHook.selectedOrder,
    allOrders: orderHook.allOrders,
    orderItems: orderHook.orderItems,
  });

  // Import hook
  const importHook = useShipmentCreateImport({
    companyId,
    storeId,
    shipmentItems,
    setShipmentItems,
  });

  // Search hook
  const searchHook = useShipmentCreateSearch({
    companyId,
    storeId,
    onCurrencyChange: setCurrency,
  });

  // Load base currency if not passed using Repository
  useEffect(() => {
    if (currencyFromState) return;

    const loadBaseCurrency = async () => {
      if (!companyId) return;

      try {
        const result = await repository.getBaseCurrency(companyId);

        if (result.success && result.data) {
          setCurrency(result.data);
        }
      } catch (err) {
        console.error('💰 getBaseCurrency error:', err);
      }
    };

    loadBaseCurrency();
  }, [companyId, currencyFromState, repository]);

  // Handle add product from search (combines search hook and items hook)
  const handleAddProductFromSearchWithClear = useCallback(
    (product: Parameters<typeof handleAddProductFromSearch>[0]) => {
      handleAddProductFromSearch(product);
      searchHook.clearSearch();
    },
    [handleAddProductFromSearch, searchHook]
  );

  // Handle save shipment using Repository
  const handleSave = useCallback(async () => {
    if (shipmentItems.length === 0) {
      setSaveResult({
        show: true,
        success: false,
        message: 'Please add at least one item to the shipment',
      });
      return;
    }

    if (!selectionMode) {
      setSaveResult({
        show: true,
        success: false,
        message: 'Please select an order or enter supplier information',
      });
      return;
    }

    if (selectionMode === 'supplier') {
      if (supplierHook.supplierType === 'existing' && !supplierHook.selectedSupplier) {
        setSaveResult({
          show: true,
          success: false,
          message: 'Please select a supplier',
        });
        return;
      }
      if (supplierHook.supplierType === 'onetime' && !supplierHook.oneTimeSupplier.name.trim()) {
        setSaveResult({
          show: true,
          success: false,
          message: 'Please enter supplier name',
        });
        return;
      }
    }

    if (!companyId) {
      setSaveResult({
        show: true,
        success: false,
        message: 'Company not selected. Please select a company first.',
      });
      return;
    }

    setIsSaving(true);

    try {
      const supabase = supabaseService.getClient();
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        throw new Error('User not authenticated');
      }

      const items = shipmentItems.map((item) => ({
        sku: item.sku,
        quantity_shipped: item.quantity,
        unit_cost: item.unitPrice,
      }));

      // Build supplier info for one-time supplier
      let supplierInfo: Record<string, string> | undefined;
      if (selectionMode === 'supplier' && supplierHook.supplierType === 'onetime') {
        supplierInfo = {};
        if (supplierHook.oneTimeSupplier.name.trim()) {
          supplierInfo.name = supplierHook.oneTimeSupplier.name.trim();
        }
        if (supplierHook.oneTimeSupplier.phone.trim()) {
          supplierInfo.phone = supplierHook.oneTimeSupplier.phone.trim();
        }
        if (supplierHook.oneTimeSupplier.email.trim()) {
          supplierInfo.email = supplierHook.oneTimeSupplier.email.trim();
        }
        if (supplierHook.oneTimeSupplier.address.trim()) {
          supplierInfo.address = supplierHook.oneTimeSupplier.address.trim();
        }
      }

      const result = await repository.createShipment({
        companyId,
        userId: user.id,
        items,
        time: new Date().toISOString(),
        timezone: userTimezone,
        orderIds: selectionMode === 'order' && orderHook.selectedOrder ? [orderHook.selectedOrder] : undefined,
        counterpartyId: selectionMode === 'supplier' && supplierHook.supplierType === 'existing' ? supplierHook.selectedSupplier || undefined : undefined,
        supplierInfo,
        trackingNumber: trackingNumber.trim() || undefined,
        notes: note.trim() || undefined,
        shipmentNumber: shipmentTitle.trim() || undefined,
      });

      if (result.success) {
        setIsSaving(false);
        setSaveResult({
          show: true,
          success: true,
          message: `Shipment ${result.shipment_number} has been created successfully.`,
          shipmentNumber: result.shipment_number,
        });
      } else {
        throw new Error(result.message || 'Failed to create shipment');
      }
    } catch (err) {
      console.error('📦 Create shipment error:', err);
      setIsSaving(false);
      setSaveResult({
        show: true,
        success: false,
        message: err instanceof Error ? err.message : 'Failed to create shipment. Please try again.',
      });
    }
  }, [selectionMode, shipmentItems, supplierHook, orderHook.selectedOrder, companyId, shipmentTitle, trackingNumber, note, repository]);

  // Handle cancel
  const handleCancel = useCallback(() => {
    navigate('/product/shipment');
  }, [navigate]);

  // Handle save result close
  const handleSaveResultClose = useCallback(() => {
    const wasSuccess = saveResult.success;
    setSaveResult({ show: false, success: false, message: '' });
    if (wasSuccess) {
      navigate('/product/shipment', { state: { refresh: true } });
    }
  }, [saveResult.success, navigate]);

  // Format price with currency
  const formatPrice = useCallback(
    (price: number) => {
      return `${currency.symbol}${price.toLocaleString()}`;
    },
    [currency.symbol]
  );

  // Check if save button should be disabled
  const isSaveDisabled = useMemo(() => {
    if (isSaving) return true;
    if (shipmentItems.length === 0) return true;
    if (!selectionMode) return true;

    if (selectionMode === 'order') {
      return !orderHook.selectedOrder;
    }

    if (selectionMode === 'supplier') {
      if (supplierHook.supplierType === 'existing') {
        return !supplierHook.selectedSupplier;
      }
      return !supplierHook.oneTimeSupplier.name.trim();
    }

    return true;
  }, [isSaving, selectionMode, shipmentItems.length, orderHook.selectedOrder, supplierHook]);

  return {
    // Currency
    currency,
    formatPrice,

    // Selection Mode
    selectionMode,

    // Suppliers
    suppliersLoading: supplierHook.suppliersLoading,
    supplierOptions: supplierHook.supplierOptions,
    selectedSupplier: supplierHook.selectedSupplier,

    // Supplier Section
    supplierType: supplierHook.supplierType,
    handleSupplierTypeChange: supplierHook.handleSupplierTypeChange,
    handleSupplierSectionChange: supplierHook.handleSupplierSectionChange,
    handleClearSupplierSelection: supplierHook.handleClearSupplierSelection,
    oneTimeSupplier: supplierHook.oneTimeSupplier,
    handleOneTimeSupplierChange: supplierHook.handleOneTimeSupplierChange,

    // Orders
    ordersLoading: orderHook.ordersLoading,
    orderOptions: orderHook.orderOptions,
    selectedOrder: orderHook.selectedOrder,
    handleOrderChange: orderHook.handleOrderChange,

    // Shipment items
    shipmentItems,
    totalAmount,
    handleRemoveItem,
    handleQuantityChange,
    handleCostChange,

    // Shipment details
    shipmentTitle,
    setShipmentTitle,
    trackingNumber,
    setTrackingNumber,
    note,
    setNote,

    // Save
    isSaving,
    saveResult,
    handleSave,
    handleSaveResultClose,
    isSaveDisabled,
    handleCancel,

    // Import/Export
    fileInputRef: importHook.fileInputRef,
    isImporting: importHook.isImporting,
    importError: importHook.importError,
    handleImportClick: importHook.handleImportClick,
    handleFileChange: importHook.handleFileChange,
    handleExportSample: importHook.handleExportSample,
    handleImportErrorClose: importHook.handleImportErrorClose,

    // Product Search
    searchInputRef: searchHook.searchInputRef,
    dropdownRef: searchHook.dropdownRef,
    searchQuery: searchHook.searchQuery,
    setSearchQuery: searchHook.setSearchQuery,
    searchResults: searchHook.searchResults,
    isSearching: searchHook.isSearching,
    showDropdown: searchHook.showDropdown,
    setShowDropdown: searchHook.setShowDropdown,
    handleAddProductFromSearch: handleAddProductFromSearchWithClear,
  };
};
