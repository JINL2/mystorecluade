/**
 * useOrderCreate Hook
 * Custom hook for order creation form management
 * Orchestrates useOrderItems, useProductSearch, and useOrderExcel hooks
 */

import { useState, useEffect, useCallback } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import { useOrderItems } from './useOrderItems';
import { useProductSearch } from './useProductSearch';
import { useOrderExcel } from './useOrderExcel';
import type {
  Counterparty,
  InventoryProduct,
  OneTimeSupplier,
  Currency,
  SaveResult,
} from '../pages/OrderCreatePage/OrderCreatePage.types';

// Navigation state interface
interface NavigationState {
  currency?: Currency;
  suppliers?: Counterparty[];
}

// Supplier option for TossSelector
export interface SupplierOption {
  value: string;
  label: string;
  description?: string;
  descriptionBgColor?: string;
  descriptionColor?: string;
}

export const useOrderCreate = () => {
  const navigate = useNavigate();
  const location = useLocation();

  // App state
  const { currentCompany, currentStore } = useAppState();
  const companyId = currentCompany?.company_id;
  const storeId = currentStore?.store_id;

  // Get currency and suppliers from navigation state (passed from OrderPage)
  const navigationState = location.state as NavigationState | null;
  const currencyFromState = navigationState?.currency;
  const suppliersFromState = navigationState?.suppliers;

  // Currency state
  const [currency, setCurrency] = useState<Currency>(
    currencyFromState || { symbol: '₩', code: 'KRW' }
  );

  // Use order items hook
  const {
    orderItems,
    setOrderItems,
    totalAmount,
    handleAddProduct: addProduct,
    handleQuantityChange,
    handleCostChange,
    handleRemoveItem,
  } = useOrderItems();

  // Use product search hook
  const {
    searchInputRef,
    dropdownRef,
    searchQuery,
    setSearchQuery,
    searchResults,
    isSearching,
    showDropdown,
    setShowDropdown,
    clearSearch,
  } = useProductSearch({
    companyId,
    storeId,
    onCurrencyUpdate: setCurrency,
  });

  // Use order excel hook
  const {
    fileInputRef,
    isImporting,
    importError,
    handleImportClick,
    handleFileChange,
    handleExportSample,
    handleImportErrorClose,
  } = useOrderExcel({
    companyId,
    storeId,
    orderItems,
    setOrderItems,
  });

  // Supplier selection
  const [supplierType, setSupplierType] = useState<'existing' | 'onetime'>('existing');
  const [selectedSupplier, setSelectedSupplier] = useState<string | null>(null);
  const [oneTimeSupplier, setOneTimeSupplier] = useState<OneTimeSupplier>({
    name: '',
    phone: '',
    email: '',
    address: '',
  });

  // Note
  const [note, setNote] = useState<string>('');

  // Save order states
  const [isSaving, setIsSaving] = useState(false);
  const [saveResult, setSaveResult] = useState<SaveResult>({
    show: false,
    success: false,
    message: '',
  });

  // Suppliers state - use from navigation state if available
  const [suppliers, setSuppliers] = useState<Counterparty[]>(suppliersFromState || []);
  const [suppliersLoading, setSuppliersLoading] = useState(false);

  // Convert suppliers to TossSelector options format with INTERNAL/SUPPLIER badges
  const supplierOptions: SupplierOption[] = suppliers.map((supplier) => {
    const isSupplier = supplier.type === 'Suppliers';
    const badges: string[] = [];
    if (supplier.is_internal) badges.push('INTERNAL');
    if (isSupplier) badges.push('SUPPLIER');

    return {
      value: supplier.counterparty_id,
      label: supplier.name,
      description: badges.length > 0 ? badges.join(' · ') : undefined,
      descriptionBgColor: badges.length > 0 ? 'rgba(107, 114, 128, 0.15)' : undefined,
      descriptionColor: badges.length > 0 ? 'rgb(107, 114, 128)' : undefined,
    };
  });

  // Handle add product (combines addProduct with clearSearch)
  const handleAddProduct = useCallback(
    (product: InventoryProduct) => {
      addProduct(product);
      clearSearch();
    },
    [addProduct, clearSearch]
  );

  // Load suppliers if not passed from OrderPage (direct navigation)
  useEffect(() => {
    if (suppliersFromState && suppliersFromState.length > 0) {
      console.log('🏢 Using suppliers from OrderPage:', suppliersFromState.length);
      return;
    }

    const loadCounterparties = async () => {
      if (!companyId) {
        console.log('🏢 get_counterparty_info: companyId not available yet');
        return;
      }

      setSuppliersLoading(true);
      try {
        const supabase = supabaseService.getClient();
        console.log('🏢 Calling get_counterparty_info with p_company_id:', companyId);

        const { data, error } = await supabase.rpc('get_counterparty_info', {
          p_company_id: companyId,
        });

        console.log('🏢 get_counterparty_info response:', { data, error });

        if (error) {
          console.error('🏢 get_counterparty_info error:', error);
          return;
        }

        if (data?.success && data?.data) {
          console.log('🏢 Counterparties found:', data.data.length);
          setSuppliers(data.data);
        } else {
          console.warn('🏢 No counterparties in response:', data);
        }
      } catch (err) {
        console.error('🏢 get_counterparty_info exception:', err);
      } finally {
        setSuppliersLoading(false);
      }
    };

    loadCounterparties();
  }, [companyId, suppliersFromState]);

  // Load base currency if not passed from OrderPage (direct navigation)
  useEffect(() => {
    if (currencyFromState) {
      console.log('💰 Using currency from OrderPage:', currencyFromState);
      return;
    }

    const loadBaseCurrency = async () => {
      if (!companyId) {
        console.log('💰 get_base_currency: companyId not available yet');
        return;
      }

      try {
        const supabase = supabaseService.getClient();
        console.log('💰 Calling get_base_currency with p_company_id:', companyId);

        const { data, error } = await supabase.rpc('get_base_currency', {
          p_company_id: companyId,
        });

        console.log('💰 get_base_currency response:', { data, error });

        if (error) {
          console.error('💰 get_base_currency error:', error);
          return;
        }

        if (data?.base_currency) {
          console.log('💰 Base currency found:', data.base_currency);
          setCurrency({
            symbol: data.base_currency.symbol || '₩',
            code: data.base_currency.currency_code || 'KRW',
          });
        } else {
          console.warn('💰 No base_currency in response:', data);
        }
      } catch (err) {
        console.error('💰 get_base_currency exception:', err);
      }
    };

    loadBaseCurrency();
  }, [companyId, currencyFromState]);

  // Handle one-time supplier change
  const handleOneTimeSupplierChange = useCallback((field: keyof OneTimeSupplier, value: string) => {
    setOneTimeSupplier((prev) => ({ ...prev, [field]: value }));
  }, []);

  // Handle save order
  const handleSave = useCallback(async () => {
    // Validation
    if (orderItems.length === 0) {
      setSaveResult({
        show: true,
        success: false,
        message: 'Please add at least one item',
      });
      return;
    }

    if (supplierType === 'existing' && !selectedSupplier) {
      setSaveResult({
        show: true,
        success: false,
        message: 'Please select a supplier',
      });
      return;
    }

    if (supplierType === 'onetime' && !oneTimeSupplier.name.trim()) {
      setSaveResult({
        show: true,
        success: false,
        message: 'Please enter supplier name',
      });
      return;
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

      // Get current user ID
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        throw new Error('User not authenticated');
      }

      // Build items array for RPC
      const items = orderItems.map((item) => ({
        sku: item.sku,
        quantity: item.quantity,
        unit_price: item.cost,
      }));

      // Build supplier_info for one-time supplier
      const supplierInfo =
        supplierType === 'onetime'
          ? {
              name: oneTimeSupplier.name.trim(),
              phone: oneTimeSupplier.phone.trim() || null,
              email: oneTimeSupplier.email.trim() || null,
              address: oneTimeSupplier.address.trim() || null,
            }
          : null;

      // Get current device local time
      const now = new Date();
      const localTime = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}T${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;

      // Build RPC parameters
      const rpcParams: Record<string, unknown> = {
        p_company_id: companyId,
        p_user_id: user.id,
        p_items: items,
        p_time: localTime,
        p_timezone: userTimezone,
      };

      // Add supplier info based on type
      if (supplierType === 'existing') {
        rpcParams.p_counterparty_id = selectedSupplier;
      } else {
        rpcParams.p_supplier_info = supplierInfo;
      }

      // Add notes if provided
      if (note.trim()) {
        rpcParams.p_notes = note.trim();
      }

      console.log('📦 Creating order with params:', JSON.stringify(rpcParams, null, 2));
      console.log('📦 Order items detail:', JSON.stringify(items, null, 2));
      console.log('📦 Supplier type:', supplierType);
      console.log('📦 Selected supplier:', selectedSupplier);
      console.log('📦 One-time supplier info:', supplierInfo);

      const { data, error } = await supabase.rpc('inventory_create_order_v2', rpcParams);

      console.log('📦 inventory_create_order_v2 response:', { data, error });
      if (error) {
        console.error('📦 RPC Error details:', {
          message: error.message,
          code: error.code,
          details: error.details,
          hint: error.hint,
        });
      }

      if (error) {
        throw error;
      }

      if (data?.success) {
        setIsSaving(false);
        setSaveResult({
          show: true,
          success: true,
          message: `Order ${data.order_number} has been created successfully.`,
          orderNumber: data.order_number,
        });
      } else {
        throw new Error(data?.message || 'Failed to create order');
      }
    } catch (err) {
      console.error('📦 Create order error:', err);
      setIsSaving(false);
      setSaveResult({
        show: true,
        success: false,
        message: err instanceof Error ? err.message : 'Failed to create order. Please try again.',
      });
    }
  }, [orderItems, supplierType, selectedSupplier, oneTimeSupplier, companyId, note]);

  // Handle cancel
  const handleCancel = useCallback(() => {
    navigate('/product/order');
  }, [navigate]);

  // Handle save result close
  const handleSaveResultClose = useCallback(() => {
    const wasSuccess = saveResult.success;
    setSaveResult({ show: false, success: false, message: '' });
    if (wasSuccess) {
      navigate('/product/order', { state: { refresh: true } });
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
  const isSaveDisabled =
    isSaving ||
    orderItems.length === 0 ||
    (supplierType === 'existing' && !selectedSupplier) ||
    (supplierType === 'onetime' && !oneTimeSupplier.name.trim());

  return {
    // Refs
    fileInputRef,
    searchInputRef,
    dropdownRef,

    // Search state
    searchQuery,
    setSearchQuery,
    searchResults,
    isSearching,
    showDropdown,
    setShowDropdown,

    // Order items
    orderItems,
    totalAmount,
    handleAddProduct,
    handleQuantityChange,
    handleCostChange,
    handleRemoveItem,

    // Supplier
    supplierType,
    setSupplierType,
    selectedSupplier,
    setSelectedSupplier,
    oneTimeSupplier,
    handleOneTimeSupplierChange,
    suppliers,
    suppliersLoading,
    supplierOptions,

    // Note
    note,
    setNote,

    // Currency
    currency,
    formatPrice,

    // Import/Export
    isImporting,
    importError,
    handleImportClick,
    handleFileChange,
    handleExportSample,
    handleImportErrorClose,

    // Save
    isSaving,
    saveResult,
    handleSave,
    handleSaveResultClose,
    isSaveDisabled,

    // Navigation
    handleCancel,
  };
};
