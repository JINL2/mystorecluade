/**
 * useShipmentList Hook
 * Custom hook for shipment list management with filters
 * Handles: currency loading, suppliers loading, shipments loading, filtering
 */

import { useState, useEffect, useRef, useCallback, useMemo } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { getShipmentRepository } from '../../data/repositories/ShipmentRepositoryImpl';
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
  const repository = useMemo(() => getShipmentRepository(), []);

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

  // Shipments state
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

  // Status filter states (single select)
  const [shipmentStatusFilter, setShipmentStatusFilter] = useState<string | null>(null);

  // Supplier filter state (single select)
  const [supplierFilter, setSupplierFilter] = useState<string | null>(null);

  // Orders state (for order filter)
  const [orders, setOrders] = useState<OrderInfo[]>([]);
  const [ordersLoading, setOrdersLoading] = useState(false);

  // Order filter state (single select)
  const [orderFilter, setOrderFilter] = useState<string | null>(null);

  // Debounce timer for search
  const searchTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  // Load base currency using Repository
  useEffect(() => {
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
  }, [companyId, repository]);

  // Load counterparties using Repository
  useEffect(() => {
    const loadCounterparties = async () => {
      if (!companyId) return;

      setSuppliersLoading(true);
      try {
        const result = await repository.getCounterparties(companyId);

        if (result.success && result.data) {
          setSuppliers(result.data);
        }
      } catch (err) {
        console.error('🏢 getCounterparties error:', err);
      } finally {
        setSuppliersLoading(false);
      }
    };

    loadCounterparties();
  }, [companyId, repository]);

  // Load orders (for order filter) using Repository
  useEffect(() => {
    const loadOrders = async () => {
      if (!companyId) return;

      setOrdersLoading(true);
      try {
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        const result = await repository.getOrders(companyId, userTimezone);

        if (result.success && result.data) {
          setOrders(result.data);
        }
      } catch (err) {
        console.error('📋 getOrders error:', err);
      } finally {
        setOrdersLoading(false);
      }
    };

    loadOrders();
  }, [companyId, repository]);

  // Load shipments using Repository
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
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      const result = await repository.getShipmentList({
        companyId,
        timezone: userTimezone,
        searchQuery: search,
        fromDate: startDate,
        toDate: endDate,
        statusFilter: shipmentStatus,
        supplierFilter: supplierId,
        orderFilter: orderId,
      });

      if (result.success && result.data) {
        setShipments(result.data as Shipment[]);
        setTotalCount(result.data.length);
      } else {
        console.error('📦 getShipmentList error:', result.error);
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
  }, [companyId, repository]);

  // Trigger shipment load when filters change
  useEffect(() => {
    if (!fromDate || !toDate) return;

    loadShipments(
      searchQuery,
      fromDate,
      toDate,
      shipmentStatusFilter || undefined,
      supplierFilter || undefined,
      orderFilter || undefined
    );
  }, [loadShipments, fromDate, toDate, shipmentStatusFilter, supplierFilter, orderFilter]);

  // Handle refresh when coming back from ShipmentCreatePage
  useEffect(() => {
    if (shouldRefresh && fromDate && toDate) {
      navigate(location.pathname, { replace: true, state: {} });

      loadShipments(
        searchQuery,
        fromDate,
        toDate,
        shipmentStatusFilter || undefined,
        supplierFilter || undefined,
        orderFilter || undefined
      );
    }
  }, [shouldRefresh]);

  // Handle search with debounce
  const handleSearchChange = (value: string) => {
    setSearchQuery(value);

    if (searchTimeoutRef.current) {
      clearTimeout(searchTimeoutRef.current);
    }

    searchTimeoutRef.current = setTimeout(() => {
      loadShipments(
        value,
        fromDate,
        toDate,
        shipmentStatusFilter || undefined,
        supplierFilter || undefined,
        orderFilter || undefined
      );
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

  // Select status filter (single select - same value clears)
  const selectShipmentStatus = (status: string) => {
    setShipmentStatusFilter((prev) => (prev === status ? null : status));
  };

  // Clear status filter
  const clearShipmentStatusFilter = () => setShipmentStatusFilter(null);

  // Select supplier filter (single select - same value clears)
  const selectSupplierFilter = (supplierId: string) => {
    setSupplierFilter((prev) => (prev === supplierId ? null : supplierId));
  };

  // Clear supplier filter
  const clearSupplierFilter = () => setSupplierFilter(null);

  // Select order filter (single select - same value clears)
  const selectOrderFilter = (orderId: string) => {
    setOrderFilter((prev) => (prev === orderId ? null : orderId));
  };

  // Clear order filter
  const clearOrderFilter = () => setOrderFilter(null);

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
    selectShipmentStatus,
    clearShipmentStatusFilter,
    selectSupplierFilter,
    clearSupplierFilter,
    selectOrderFilter,
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
