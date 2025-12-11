/**
 * useProductReceiveList Hook
 * Custom hook for product receive list management with filters
 * Uses Repository pattern for data access
 */

import { useState, useEffect, useRef, useCallback, useMemo } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { productReceiveRepository } from '../../data/repositories/ProductReceiveRepositoryImpl';
import type {
  Currency,
  Counterparty,
  Shipment,
  ShipmentDetail,
  DatePreset,
} from '../pages/ProductReceivePage/ProductReceivePage.types';

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

export const useProductReceiveList = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const repository = useMemo(() => productReceiveRepository, []);

  // Check if we need to refresh data
  const navigationState = location.state as { refresh?: boolean; refreshData?: boolean; submitSuccess?: boolean } | null;
  const shouldRefresh = navigationState?.refresh || navigationState?.refreshData || navigationState?.submitSuccess;

  // App state
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id;

  // Currency state
  const [currency, setCurrency] = useState<Currency>({ symbol: '₩', code: 'KRW', name: 'Korean Won' });

  // Suppliers state
  const [suppliers, setSuppliers] = useState<Counterparty[]>([]);
  const [suppliersLoading, setSuppliersLoading] = useState(false);

  // Shipments state (from inventory_get_shipment_list)
  const [shipments, setShipments] = useState<Shipment[]>([]);
  const [shipmentsLoading, setShipmentsLoading] = useState(false);
  const [totalCount, setTotalCount] = useState(0);

  // Selected shipment detail state
  const [selectedShipmentId, setSelectedShipmentId] = useState<string | null>(null);
  const [shipmentDetail, setShipmentDetail] = useState<ShipmentDetail | null>(null);
  const [detailLoading, setDetailLoading] = useState(false);

  // Search state
  const [searchQuery, setSearchQuery] = useState<string>('');

  // Date filter state
  const [datePreset, setDatePreset] = useState<DatePreset>('this_year');
  const [fromDate, setFromDate] = useState<string>('');
  const [toDate, setToDate] = useState<string>('');
  const [showDatePicker, setShowDatePicker] = useState(false);
  const [tempFromDate, setTempFromDate] = useState<string>('');
  const [tempToDate, setTempToDate] = useState<string>('');

  // Status filter states (single select)
  const [shipmentStatusFilter, setShipmentStatusFilter] = useState<string | null>(null);

  // Supplier filter state (single select)
  const [supplierFilter, setSupplierFilter] = useState<string | null>(null);

  // Debounce timer for search
  const searchTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  // Load base currency using Repository
  useEffect(() => {
    const loadBaseCurrency = async () => {
      if (!companyId) return;

      try {
        const result = await repository.getBaseCurrency(companyId);
        setCurrency({
          symbol: result.symbol || '₩',
          code: result.code || 'KRW',
          name: 'Korean Won',
        });
      } catch (err) {
        console.error('💰 getBaseCurrency error:', err);
      }
    };

    loadBaseCurrency();
  }, [companyId, repository]);

  // Load counterparties (suppliers) using Repository
  useEffect(() => {
    const loadCounterparties = async () => {
      if (!companyId) return;

      setSuppliersLoading(true);
      try {
        const result = await repository.getCounterparties(companyId);
        // Map domain entity to presentation format
        const mappedSuppliers: Counterparty[] = result.map(c => ({
          counterparty_id: c.counterpartyId,
          name: c.name,
          type: '',
          email: null,
          phone: null,
          address: null,
          notes: null,
          is_internal: c.isInternal ?? false,
        }));
        setSuppliers(mappedSuppliers);
      } catch (err) {
        console.error('🏢 getCounterparties error:', err);
      } finally {
        setSuppliersLoading(false);
      }
    };

    loadCounterparties();
  }, [companyId, repository]);

  // Load shipments using Repository
  const loadShipments = useCallback(async (
    search?: string,
    startDate?: string,
    endDate?: string,
    shipmentStatus?: string,
    supplierId?: string
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
      });

      // Map domain entity to presentation format
      const mappedShipments: Shipment[] = result.shipments.map(s => ({
        shipment_id: s.shipmentId,
        shipment_number: s.shipmentNumber,
        tracking_number: null,
        shipped_date: s.shippedDate,
        supplier_id: null,
        supplier_name: s.supplierName,
        status: s.status as Shipment['status'],
        item_count: s.totalItems,
        has_orders: false,
        linked_order_count: 0,
        notes: null,
        created_at: s.shippedDate,
        created_by: null,
      }));

      setShipments(mappedShipments);
      setTotalCount(result.totalCount);
    } catch (err) {
      console.error('📦 Load shipments error:', err);
      setShipments([]);
      setTotalCount(0);
    } finally {
      setShipmentsLoading(false);
    }
  }, [companyId, repository]);

  // Load shipment detail using Repository
  const loadShipmentDetail = useCallback(async (shipmentId: string) => {
    if (!companyId || !shipmentId) return;

    setDetailLoading(true);
    try {
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

      const result = await repository.getShipmentDetail({
        shipmentId,
        companyId,
        timezone: userTimezone,
      });

      // Map domain entity to presentation format
      const mappedDetail: ShipmentDetail = {
        shipment_id: result.shipmentId,
        shipment_number: result.shipmentNumber,
        tracking_number: result.trackingNumber || null,
        shipped_date: result.shippedDate,
        status: result.status as ShipmentDetail['status'],
        total_amount: 0,
        notes: result.notes || null,
        created_by: null,
        created_at: result.shippedDate,
        supplier_id: result.supplierId || null,
        supplier_name: result.supplierName,
        supplier_phone: null,
        supplier_email: null,
        supplier_address: null,
        is_registered_supplier: !!result.supplierId,
        items: result.items.map(item => ({
          item_id: item.itemId,
          product_id: item.productId,
          product_name: item.productName,
          sku: item.sku,
          quantity_shipped: item.quantityShipped,
          quantity_received: item.quantityReceived,
          quantity_accepted: item.quantityAccepted,
          quantity_rejected: item.quantityRejected,
          quantity_remaining: item.quantityRemaining,
          unit_cost: item.unitCost,
          total_amount: item.quantityShipped * item.unitCost,
        })),
        receiving_summary: result.receivingSummary ? {
          total_shipped: result.receivingSummary.totalShipped,
          total_received: result.receivingSummary.totalReceived,
          total_accepted: result.receivingSummary.totalAccepted,
          total_rejected: result.receivingSummary.totalRejected,
          total_remaining: result.receivingSummary.totalRemaining,
          progress_percentage: result.receivingSummary.progressPercentage,
        } : {
          total_shipped: 0,
          total_received: 0,
          total_accepted: 0,
          total_rejected: 0,
          total_remaining: 0,
          progress_percentage: 0,
        },
        has_orders: false,
        order_count: 0,
        orders: [],
        can_cancel: false,
      };

      setShipmentDetail(mappedDetail);
      setSelectedShipmentId(shipmentId);
    } catch (err) {
      console.error('📦 Load shipment detail error:', err);
      setShipmentDetail(null);
    } finally {
      setDetailLoading(false);
    }
  }, [companyId, repository]);

  // Clear selected shipment
  const clearSelectedShipment = useCallback(() => {
    setSelectedShipmentId(null);
    setShipmentDetail(null);
  }, []);

  // Trigger shipment load when filters change
  useEffect(() => {
    if (!fromDate || !toDate) return;

    loadShipments(
      searchQuery,
      fromDate,
      toDate,
      shipmentStatusFilter || undefined,
      supplierFilter || undefined
    );
  }, [loadShipments, fromDate, toDate, shipmentStatusFilter, supplierFilter]);

  // Handle refresh when coming back
  useEffect(() => {
    if (shouldRefresh && fromDate && toDate) {
      navigate(location.pathname, { replace: true, state: {} });

      loadShipments(
        searchQuery,
        fromDate,
        toDate,
        shipmentStatusFilter || undefined,
        supplierFilter || undefined
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
        supplierFilter || undefined
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

  // Initialize dates on mount
  useEffect(() => {
    const range = getDateRangeForPreset('this_year');
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
      setDatePreset('this_year');
      const range = getDateRangeForPreset('this_year');
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

  return {
    // State
    currency,
    suppliers,
    suppliersLoading,
    shipments,
    shipmentsLoading,
    totalCount,
    selectedShipmentId,
    shipmentDetail,
    detailLoading,
    searchQuery,
    datePreset,
    fromDate,
    toDate,
    showDatePicker,
    tempFromDate,
    tempToDate,
    shipmentStatusFilter,
    supplierFilter,
    supplierOptions,

    // Actions
    handleSearchChange,
    selectShipmentStatus,
    clearShipmentStatusFilter,
    selectSupplierFilter,
    clearSupplierFilter,
    handlePresetChange,
    handleOpenCustomPicker,
    handleApplyCustomDate,
    handleCancelCustomDate,
    handleSetTodayDate,
    setTempFromDate,
    setTempToDate,
    getDateDisplayLabel,
    formatDateDisplay,
    loadShipmentDetail,
    clearSelectedShipment,
  };
};
