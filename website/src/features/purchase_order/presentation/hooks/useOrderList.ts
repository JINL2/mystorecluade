/**
 * useOrderList Hook
 * Custom hook for order list management with filters
 * Handles: currency loading, suppliers loading, orders loading, filtering
 */

import { useState, useEffect, useRef, useCallback } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import type {
  Currency,
  Counterparty,
  PurchaseOrder,
  DatePreset,
} from '../pages/OrderPage/OrderPage.types';

// Helper function to get date range for presets
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

// Format date for display (yyyy/MM/dd)
export const formatDateDisplay = (dateStr: string): string => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}/${month}/${day}`;
};

export const useOrderList = () => {
  const navigate = useNavigate();
  const location = useLocation();

  // Check if we need to refresh data
  const navigationState = location.state as { refresh?: boolean } | null;
  const shouldRefresh = navigationState?.refresh;

  // App state
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id;

  // Currency state
  const [currency, setCurrency] = useState<Currency>({ symbol: '₩', code: 'KRW' });

  // Suppliers state
  const [suppliers, setSuppliers] = useState<Counterparty[]>([]);
  const [suppliersLoading, setSuppliersLoading] = useState(false);

  // Orders state
  const [orders, setOrders] = useState<PurchaseOrder[]>([]);
  const [ordersLoading, setOrdersLoading] = useState(false);
  const [totalCount, setTotalCount] = useState(0);

  // Search state
  const [searchQuery, setSearchQuery] = useState<string>('');

  // Date filter state
  const [datePreset, setDatePreset] = useState<DatePreset>('this_month');
  const [fromDate, setFromDate] = useState<string>('');
  const [toDate, setToDate] = useState<string>('');
  const [showDatePicker, setShowDatePicker] = useState(false);
  const [tempFromDate, setTempFromDate] = useState<string>('');
  const [tempToDate, setTempToDate] = useState<string>('');

  // Status filter states
  const [orderStatusFilter, setOrderStatusFilter] = useState<Set<string>>(new Set());
  const [receivingStatusFilter, setReceivingStatusFilter] = useState<Set<string>>(new Set());

  // Supplier filter state
  const [selectedSupplier, setSelectedSupplier] = useState<string | null>(null);

  // Debounce timer for search
  const searchTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  // Load base currency
  useEffect(() => {
    const loadBaseCurrency = async () => {
      if (!companyId) return;

      try {
        const supabase = supabaseService.getClient();
        const { data, error } = await supabase.rpc('get_base_currency', {
          p_company_id: companyId,
        });

        if (!error && data?.base_currency) {
          setCurrency({
            symbol: data.base_currency.symbol || '₩',
            code: data.base_currency.currency_code || 'KRW',
          });
        }
      } catch {
        // Use default currency on error
      }
    };

    loadBaseCurrency();
  }, [companyId]);

  // Load counterparties
  useEffect(() => {
    const loadCounterparties = async () => {
      if (!companyId) return;

      setSuppliersLoading(true);
      try {
        const supabase = supabaseService.getClient();
        const { data, error } = await supabase.rpc('get_counterparty_info', {
          p_company_id: companyId,
        });

        if (!error && data?.success && data?.data) {
          setSuppliers(data.data);
        }
      } catch {
        // Use empty suppliers on error
      } finally {
        setSuppliersLoading(false);
      }
    };

    loadCounterparties();
  }, [companyId]);

  // Load orders from RPC
  const loadOrders = useCallback(async (
    search?: string,
    startDate?: string,
    endDate?: string,
    orderStatus?: string,
    receivingStatus?: string,
    supplierId?: string
  ) => {
    if (!companyId) return;

    setOrdersLoading(true);
    try {
      const supabase = supabaseService.getClient();
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      const rpcParams: Record<string, unknown> = {
        p_company_id: companyId,
        p_limit: 100,
        p_offset: 0,
        p_timezone: userTimezone,
      };

      if (search?.trim()) rpcParams.p_search = search.trim();
      if (startDate) rpcParams.p_start_date = startDate;
      if (endDate) rpcParams.p_end_date = endDate;
      if (orderStatus) rpcParams.p_order_status = orderStatus;
      if (receivingStatus) rpcParams.p_receiving_status = receivingStatus;
      if (supplierId) rpcParams.p_supplier_id = supplierId;

      const { data, error } = await supabase.rpc('inventory_get_order_list', rpcParams);

      if (!error && data?.success && data?.data) {
        setOrders(data.data);
        setTotalCount(data.total_count || 0);
      } else {
        setOrders([]);
        setTotalCount(0);
      }
    } catch {
      setOrders([]);
      setTotalCount(0);
    } finally {
      setOrdersLoading(false);
    }
  }, [companyId]);

  // Trigger order load when filters change
  useEffect(() => {
    if (!fromDate || !toDate) return;

    const orderStatus = orderStatusFilter.size === 1 ? Array.from(orderStatusFilter)[0] : undefined;
    const receivingStatus = receivingStatusFilter.size === 1 ? Array.from(receivingStatusFilter)[0] : undefined;

    loadOrders(searchQuery, fromDate, toDate, orderStatus, receivingStatus, selectedSupplier || undefined);
  }, [loadOrders, fromDate, toDate, orderStatusFilter, receivingStatusFilter, selectedSupplier]);

  // Handle refresh when coming back from OrderCreatePage
  useEffect(() => {
    if (shouldRefresh && fromDate && toDate) {
      navigate(location.pathname, { replace: true, state: {} });

      const orderStatus = orderStatusFilter.size === 1 ? Array.from(orderStatusFilter)[0] : undefined;
      const receivingStatus = receivingStatusFilter.size === 1 ? Array.from(receivingStatusFilter)[0] : undefined;

      loadOrders(searchQuery, fromDate, toDate, orderStatus, receivingStatus, selectedSupplier || undefined);
    }
  }, [shouldRefresh]);

  // Handle search with debounce
  const handleSearchChange = (value: string) => {
    setSearchQuery(value);

    if (searchTimeoutRef.current) {
      clearTimeout(searchTimeoutRef.current);
    }

    searchTimeoutRef.current = setTimeout(() => {
      const orderStatus = orderStatusFilter.size === 1 ? Array.from(orderStatusFilter)[0] : undefined;
      const receivingStatus = receivingStatusFilter.size === 1 ? Array.from(receivingStatusFilter)[0] : undefined;

      loadOrders(value, fromDate, toDate, orderStatus, receivingStatus, selectedSupplier || undefined);
    }, 300);
  };

  // Cleanup timeout on unmount
  useEffect(() => {
    return () => {
      if (searchTimeoutRef.current) {
        clearTimeout(searchTimeoutRef.current);
      }
    };
  }, []);

  // Toggle status filters
  const toggleOrderStatus = (status: string) => {
    setOrderStatusFilter((prev) => {
      const newSet = new Set(prev);
      if (newSet.has(status)) {
        newSet.delete(status);
      } else {
        newSet.add(status);
      }
      return newSet;
    });
  };

  const toggleReceivingStatus = (status: string) => {
    setReceivingStatusFilter((prev) => {
      const newSet = new Set(prev);
      if (newSet.has(status)) {
        newSet.delete(status);
      } else {
        newSet.add(status);
      }
      return newSet;
    });
  };

  // Clear status filters
  const clearOrderStatusFilter = () => setOrderStatusFilter(new Set());
  const clearReceivingStatusFilter = () => setReceivingStatusFilter(new Set());

  // Initialize dates on mount
  useEffect(() => {
    const range = getDateRangeForPreset('this_month');
    setFromDate(range.from);
    setToDate(range.to);
  }, []);

  // Handle preset change
  const handlePresetChange = (preset: DatePreset) => {
    setDatePreset(preset);
    if (preset !== 'custom') {
      const range = getDateRangeForPreset(preset);
      setFromDate(range.from);
      setToDate(range.to);
      setShowDatePicker(false);
    } else {
      setTempFromDate(fromDate);
      setTempToDate(toDate);
      setShowDatePicker(true);
    }
  };

  // Handle custom date picker
  const handleOpenCustomPicker = () => {
    setTempFromDate(fromDate);
    setTempToDate(toDate);
    setShowDatePicker(true);
  };

  const handleApplyCustomDate = () => {
    setFromDate(tempFromDate);
    setToDate(tempToDate);
    setShowDatePicker(false);
  };

  const handleCancelCustomDate = () => {
    setShowDatePicker(false);
    if (datePreset === 'custom' && !fromDate && !toDate) {
      setDatePreset('this_month');
      const range = getDateRangeForPreset('this_month');
      setFromDate(range.from);
      setToDate(range.to);
    }
  };

  const handleSetTodayDate = () => {
    const today = new Date().toISOString().split('T')[0];
    setTempFromDate(today);
    setTempToDate(today);
  };

  // Get display label for current selection
  const getDateDisplayLabel = (): string => {
    switch (datePreset) {
      case 'this_month':
        return 'This Month';
      case 'last_month':
        return 'Last Month';
      case 'this_year':
        return 'This Year';
      case 'custom':
        if (fromDate && toDate) {
          return `${formatDateDisplay(fromDate)} - ${formatDateDisplay(toDate)}`;
        }
        return 'Custom';
      default:
        return 'Select Date';
    }
  };

  // Convert suppliers to LeftFilter radio options format
  const supplierOptions = suppliers.map((supplier) => ({
    value: supplier.counterparty_id,
    label: supplier.name,
  }));

  // Select supplier filter (radio style - single selection)
  const selectSupplierFilter = (supplierId: string) => {
    setSelectedSupplier(supplierId);
  };

  // Clear supplier filter
  const clearSupplierFilter = () => {
    setSelectedSupplier(null);
  };

  return {
    // State
    currency,
    suppliers,
    suppliersLoading,
    orders,
    ordersLoading,
    totalCount,
    searchQuery,
    datePreset,
    fromDate,
    toDate,
    showDatePicker,
    tempFromDate,
    tempToDate,
    orderStatusFilter,
    receivingStatusFilter,
    selectedSupplier,
    supplierOptions,

    // Actions
    handleSearchChange,
    toggleOrderStatus,
    toggleReceivingStatus,
    clearOrderStatusFilter,
    clearReceivingStatusFilter,
    selectSupplierFilter,
    clearSupplierFilter,
    handlePresetChange,
    handleOpenCustomPicker,
    handleApplyCustomDate,
    handleCancelCustomDate,
    handleSetTodayDate,
    setTempFromDate,
    setTempToDate,
    setSelectedSupplier,
    getDateDisplayLabel,
    formatDateDisplay,
  };
};
