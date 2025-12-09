/**
 * useShipmentList Hook
 * Custom hook for shipment list management with filters
 * Handles: currency loading, suppliers loading, shipments loading, filtering
 */

import { useState, useEffect, useRef, useCallback } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import type {
  Currency,
  Counterparty,
  Shipment,
  DatePreset,
  OrderInfo,
} from '../pages/ShipmentPage/ShipmentPage.types';

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

export const useShipmentList = () => {
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

  // Shipments state (using mock data for now - RPC not implemented yet)
  const [shipments, setShipments] = useState<Shipment[]>([]);
  const [shipmentsLoading, setShipmentsLoading] = useState(false);
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
  const [shipmentStatusFilter, setShipmentStatusFilter] = useState<Set<string>>(new Set());

  // Supplier filter state (multiselect)
  const [supplierFilter, setSupplierFilter] = useState<Set<string>>(new Set());

  // Orders state (for order filter)
  const [orders, setOrders] = useState<OrderInfo[]>([]);
  const [ordersLoading, setOrdersLoading] = useState(false);

  // Order filter state (multiselect)
  const [orderFilter, setOrderFilter] = useState<Set<string>>(new Set());

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
      } catch (err) {
        console.error('💰 get_base_currency error:', err);
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
      } catch (err) {
        console.error('🏢 get_counterparty_info error:', err);
      } finally {
        setSuppliersLoading(false);
      }
    };

    loadCounterparties();
  }, [companyId]);

  // Load orders (for order filter)
  useEffect(() => {
    const loadOrders = async () => {
      if (!companyId) return;

      setOrdersLoading(true);
      try {
        const supabase = supabaseService.getClient();
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        const { data, error } = await supabase.rpc('inventory_get_order_info', {
          p_company_id: companyId,
          p_timezone: userTimezone,
        });

        console.log('📋 inventory_get_order_info response:', { data, error });

        if (!error && data?.success && data?.data) {
          setOrders(data.data);
        }
      } catch (err) {
        console.error('📋 inventory_get_order_info error:', err);
      } finally {
        setOrdersLoading(false);
      }
    };

    loadOrders();
  }, [companyId]);

  // Load shipments using inventory_get_shipment_list RPC
  const loadShipments = useCallback(async (
    search?: string,
    startDate?: string,
    endDate?: string,
    shipmentStatus?: string,
    supplierId?: string,
    orderId?: string
  ) => {
    if (!companyId) return;

    setShipmentsLoading(true);
    try {
      const supabase = supabaseService.getClient();
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      // Build RPC parameters
      const rpcParams: Record<string, unknown> = {
        p_company_id: companyId,
        p_timezone: userTimezone,
        p_limit: 50,
        p_offset: 0,
      };

      // Add optional filters
      if (search && search.trim()) {
        rpcParams.p_search = search.trim();
      }
      if (shipmentStatus) {
        rpcParams.p_status = shipmentStatus;
      }
      if (supplierId) {
        rpcParams.p_supplier_id = supplierId;
      }
      if (orderId) {
        rpcParams.p_order_id = orderId;
      }
      if (startDate) {
        rpcParams.p_start_date = `${startDate} 00:00:00`;
      }
      if (endDate) {
        rpcParams.p_end_date = `${endDate} 23:59:59`;
      }

      console.log('📦 Calling inventory_get_shipment_list with:', rpcParams);

      const { data, error } = await supabase.rpc('inventory_get_shipment_list', rpcParams);

      console.log('📦 inventory_get_shipment_list response:', { data, error });

      if (error) {
        throw new Error(error.message);
      }

      if (data?.success && data?.data) {
        setShipments(data.data);
        setTotalCount(data.total_count || 0);
      } else {
        console.error('📦 RPC error:', data?.error);
        setShipments([]);
        setTotalCount(0);
      }
    } catch (err) {
      console.error('📦 Load shipments error:', err);
      setShipments([]);
      setTotalCount(0);
    } finally {
      setShipmentsLoading(false);
    }
  }, [companyId]);

  // Trigger shipment load when filters change
  useEffect(() => {
    if (!fromDate || !toDate) return;

    const shipmentStatus = shipmentStatusFilter.size === 1 ? Array.from(shipmentStatusFilter)[0] : undefined;
    const supplierId = supplierFilter.size === 1 ? Array.from(supplierFilter)[0] : undefined;
    const orderId = orderFilter.size === 1 ? Array.from(orderFilter)[0] : undefined;

    loadShipments(searchQuery, fromDate, toDate, shipmentStatus, supplierId, orderId);
  }, [loadShipments, fromDate, toDate, shipmentStatusFilter, supplierFilter, orderFilter]);

  // Handle refresh when coming back from ShipmentCreatePage
  useEffect(() => {
    if (shouldRefresh && fromDate && toDate) {
      navigate(location.pathname, { replace: true, state: {} });

      const shipmentStatus = shipmentStatusFilter.size === 1 ? Array.from(shipmentStatusFilter)[0] : undefined;
      const supplierId = supplierFilter.size === 1 ? Array.from(supplierFilter)[0] : undefined;
      const orderId = orderFilter.size === 1 ? Array.from(orderFilter)[0] : undefined;

      loadShipments(searchQuery, fromDate, toDate, shipmentStatus, supplierId, orderId);
    }
  }, [shouldRefresh]);

  // Handle search with debounce
  const handleSearchChange = (value: string) => {
    setSearchQuery(value);

    if (searchTimeoutRef.current) {
      clearTimeout(searchTimeoutRef.current);
    }

    searchTimeoutRef.current = setTimeout(() => {
      const shipmentStatus = shipmentStatusFilter.size === 1 ? Array.from(shipmentStatusFilter)[0] : undefined;
      const supplierId = supplierFilter.size === 1 ? Array.from(supplierFilter)[0] : undefined;
      const orderId = orderFilter.size === 1 ? Array.from(orderFilter)[0] : undefined;

      loadShipments(value, fromDate, toDate, shipmentStatus, supplierId, orderId);
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
  const toggleShipmentStatus = (status: string) => {
    setShipmentStatusFilter((prev) => {
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
  const clearShipmentStatusFilter = () => setShipmentStatusFilter(new Set());

  // Toggle supplier filter
  const toggleSupplierFilter = (supplierId: string) => {
    setSupplierFilter((prev) => {
      const newSet = new Set(prev);
      if (newSet.has(supplierId)) {
        newSet.delete(supplierId);
      } else {
        newSet.add(supplierId);
      }
      return newSet;
    });
  };

  // Clear supplier filter
  const clearSupplierFilter = () => setSupplierFilter(new Set());

  // Toggle order filter
  const toggleOrderFilter = (orderId: string) => {
    setOrderFilter((prev) => {
      const newSet = new Set(prev);
      if (newSet.has(orderId)) {
        newSet.delete(orderId);
      } else {
        newSet.add(orderId);
      }
      return newSet;
    });
  };

  // Clear order filter
  const clearOrderFilter = () => setOrderFilter(new Set());

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

  // Convert suppliers to multiselect options format
  const supplierOptions = suppliers.map((supplier) => ({
    value: supplier.counterparty_id,
    label: supplier.name,
    description: supplier.is_internal ? 'INTERNAL' : undefined,
  }));

  // Convert orders to multiselect options format
  const orderOptions = orders.map((order) => ({
    value: order.order_id,
    label: order.order_number,
  }));

  return {
    // State
    currency,
    suppliers,
    suppliersLoading,
    orders,
    ordersLoading,
    shipments,
    shipmentsLoading,
    totalCount,
    searchQuery,
    datePreset,
    fromDate,
    toDate,
    showDatePicker,
    tempFromDate,
    tempToDate,
    shipmentStatusFilter,
    supplierFilter,
    orderFilter,
    supplierOptions,
    orderOptions,

    // Actions
    handleSearchChange,
    toggleShipmentStatus,
    clearShipmentStatusFilter,
    toggleSupplierFilter,
    clearSupplierFilter,
    toggleOrderFilter,
    clearOrderFilter,
    handlePresetChange,
    handleOpenCustomPicker,
    handleApplyCustomDate,
    handleCancelCustomDate,
    handleSetTodayDate,
    setTempFromDate,
    setTempToDate,
    getDateDisplayLabel,
    formatDateDisplay,
  };
};
