/**
 * useShipmentCreate Hook
 * Custom hook for shipment creation form management
 */

import { useState, useEffect, useCallback } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import type {
  Counterparty,
  OrderInfo,
  OrderItem,
  ShipmentItem,
  Currency,
  SaveResult,
} from '../pages/ShipmentCreatePage/ShipmentCreatePage.types';

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
}

export const useShipmentCreate = () => {
  const navigate = useNavigate();
  const location = useLocation();

  // App state
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id;

  // Get currency and suppliers from navigation state
  const navigationState = location.state as NavigationState | null;
  const currencyFromState = navigationState?.currency;
  const suppliersFromState = navigationState?.suppliers;

  // Currency state
  const [currency, setCurrency] = useState<Currency>(
    currencyFromState || { symbol: '₩', code: 'KRW' }
  );

  // Suppliers state
  const [suppliers, setSuppliers] = useState<Counterparty[]>(suppliersFromState || []);
  const [suppliersLoading, setSuppliersLoading] = useState(false);
  const [selectedSupplier, setSelectedSupplier] = useState<string | null>(null);

  // Orders state
  const [orders, setOrders] = useState<OrderInfo[]>([]);
  const [ordersLoading, setOrdersLoading] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState<string | null>(null);

  // Order items state (items from selected order)
  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);
  const [orderItemsLoading, setOrderItemsLoading] = useState(false);

  // Shipment items state (items to be shipped)
  const [shipmentItems, setShipmentItems] = useState<ShipmentItem[]>([]);

  // Shipment details
  const [shippedDate, setShippedDate] = useState<string>(
    new Date().toISOString().split('T')[0]
  );
  const [trackingNumber, setTrackingNumber] = useState<string>('');
  const [note, setNote] = useState<string>('');

  // Save states
  const [isSaving, setIsSaving] = useState(false);
  const [saveResult, setSaveResult] = useState<SaveResult>({
    show: false,
    success: false,
    message: '',
  });

  // Convert suppliers to options format
  const supplierOptions: SupplierOption[] = suppliers.map((supplier) => ({
    value: supplier.counterparty_id,
    label: supplier.name,
    description: supplier.is_internal ? 'INTERNAL' : undefined,
  }));

  // Convert orders to options format
  const orderOptions = orders.map((order) => ({
    value: order.order_id,
    label: `${order.order_number} - ${order.supplier_name}`,
  }));

  // Calculate total amount
  const totalAmount = shipmentItems.reduce(
    (sum, item) => sum + item.quantity * item.unitPrice,
    0
  );

  // Load suppliers if not passed from ShipmentPage
  useEffect(() => {
    if (suppliersFromState && suppliersFromState.length > 0) {
      return;
    }

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
  }, [companyId, suppliersFromState]);

  // Load base currency if not passed
  useEffect(() => {
    if (currencyFromState) return;

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
  }, [companyId, currencyFromState]);

  // Load orders when supplier is selected
  useEffect(() => {
    const loadOrders = async () => {
      if (!companyId || !selectedSupplier) {
        setOrders([]);
        return;
      }

      setOrdersLoading(true);
      try {
        const supabase = supabaseService.getClient();
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        const { data, error } = await supabase.rpc('inventory_get_order_info', {
          p_company_id: companyId,
          p_timezone: userTimezone,
          p_supplier_id: selectedSupplier,
        });

        console.log('📋 inventory_get_order_info response:', { data, error });

        if (!error && data?.success && data?.data) {
          // Filter to only pending/process orders
          const filteredOrders = data.data.filter(
            (order: OrderInfo) => order.status === 'pending' || order.status === 'process'
          );
          setOrders(filteredOrders);
        } else {
          setOrders([]);
        }
      } catch (err) {
        console.error('📋 inventory_get_order_info error:', err);
        setOrders([]);
      } finally {
        setOrdersLoading(false);
      }
    };

    loadOrders();
  }, [companyId, selectedSupplier]);

  // Load order items when order is selected
  useEffect(() => {
    const loadOrderItems = async () => {
      if (!selectedOrder) {
        setOrderItems([]);
        return;
      }

      setOrderItemsLoading(true);
      try {
        const supabase = supabaseService.getClient();
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        const { data, error } = await supabase.rpc('inventory_get_order_items', {
          p_order_id: selectedOrder,
          p_timezone: userTimezone,
        });

        console.log('📦 inventory_get_order_items response:', { data, error });

        if (!error && data?.success && data?.data) {
          // Filter items with remaining quantity > 0
          const availableItems = data.data.filter(
            (item: OrderItem) => item.remaining_quantity > 0
          );
          setOrderItems(availableItems);
        } else {
          setOrderItems([]);
        }
      } catch (err) {
        console.error('📦 inventory_get_order_items error:', err);
        setOrderItems([]);
      } finally {
        setOrderItemsLoading(false);
      }
    };

    loadOrderItems();
  }, [selectedOrder]);

  // Handle supplier change - reset order selection
  const handleSupplierChange = useCallback((supplierId: string | null) => {
    setSelectedSupplier(supplierId);
    setSelectedOrder(null);
    setOrderItems([]);
    setShipmentItems([]);
  }, []);

  // Handle order change
  const handleOrderChange = useCallback((orderId: string | null) => {
    setSelectedOrder(orderId);
    setShipmentItems([]);
  }, []);

  // Add item to shipment
  const handleAddItem = useCallback(
    (orderItem: OrderItem) => {
      const selectedOrderData = orders.find((o) => o.order_id === selectedOrder);
      if (!selectedOrderData) return;

      // Check if already added
      const exists = shipmentItems.find((item) => item.orderItemId === orderItem.order_item_id);
      if (exists) return;

      const newItem: ShipmentItem = {
        orderItemId: orderItem.order_item_id,
        orderId: selectedOrder!,
        orderNumber: selectedOrderData.order_number,
        productId: orderItem.product_id,
        productName: orderItem.product_name,
        sku: orderItem.sku,
        quantity: orderItem.remaining_quantity,
        maxQuantity: orderItem.remaining_quantity,
        unitPrice: orderItem.unit_price,
      };

      setShipmentItems((prev) => [...prev, newItem]);
    },
    [selectedOrder, orders, shipmentItems]
  );

  // Add all items from current order
  const handleAddAllItems = useCallback(() => {
    const selectedOrderData = orders.find((o) => o.order_id === selectedOrder);
    if (!selectedOrderData) return;

    const newItems: ShipmentItem[] = orderItems
      .filter((oi) => !shipmentItems.find((si) => si.orderItemId === oi.order_item_id))
      .map((orderItem) => ({
        orderItemId: orderItem.order_item_id,
        orderId: selectedOrder!,
        orderNumber: selectedOrderData.order_number,
        productId: orderItem.product_id,
        productName: orderItem.product_name,
        sku: orderItem.sku,
        quantity: orderItem.remaining_quantity,
        maxQuantity: orderItem.remaining_quantity,
        unitPrice: orderItem.unit_price,
      }));

    setShipmentItems((prev) => [...prev, ...newItems]);
  }, [selectedOrder, orders, orderItems, shipmentItems]);

  // Remove item from shipment
  const handleRemoveItem = useCallback((orderItemId: string) => {
    setShipmentItems((prev) => prev.filter((item) => item.orderItemId !== orderItemId));
  }, []);

  // Update item quantity
  const handleQuantityChange = useCallback((orderItemId: string, quantity: number) => {
    setShipmentItems((prev) =>
      prev.map((item) => {
        if (item.orderItemId === orderItemId) {
          const validQuantity = Math.max(1, Math.min(quantity, item.maxQuantity));
          return { ...item, quantity: validQuantity };
        }
        return item;
      })
    );
  }, []);

  // Handle save shipment
  const handleSave = useCallback(async () => {
    // Validation
    if (shipmentItems.length === 0) {
      setSaveResult({
        show: true,
        success: false,
        message: 'Please add at least one item to the shipment',
      });
      return;
    }

    if (!selectedSupplier) {
      setSaveResult({
        show: true,
        success: false,
        message: 'Please select a supplier',
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
      const items = shipmentItems.map((item) => ({
        order_item_id: item.orderItemId,
        quantity: item.quantity,
      }));

      // Build RPC parameters
      const rpcParams: Record<string, unknown> = {
        p_company_id: companyId,
        p_user_id: user.id,
        p_supplier_id: selectedSupplier,
        p_items: items,
        p_shipped_date: shippedDate,
        p_timezone: userTimezone,
      };

      // Add optional fields
      if (trackingNumber.trim()) {
        rpcParams.p_tracking_number = trackingNumber.trim();
      }
      if (note.trim()) {
        rpcParams.p_notes = note.trim();
      }

      console.log('📦 Creating shipment with params:', rpcParams);

      const { data, error } = await supabase.rpc('inventory_create_shipment', rpcParams);

      console.log('📦 inventory_create_shipment response:', { data, error });

      if (error) {
        throw error;
      }

      if (data?.success) {
        setIsSaving(false);
        setSaveResult({
          show: true,
          success: true,
          message: `Shipment ${data.shipment_number} has been created successfully.`,
          shipmentNumber: data.shipment_number,
        });
      } else {
        throw new Error(data?.message || 'Failed to create shipment');
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
  }, [shipmentItems, selectedSupplier, companyId, shippedDate, trackingNumber, note]);

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
  const isSaveDisabled = isSaving || shipmentItems.length === 0 || !selectedSupplier;

  return {
    // Currency
    currency,
    formatPrice,

    // Suppliers
    suppliers,
    suppliersLoading,
    supplierOptions,
    selectedSupplier,
    handleSupplierChange,

    // Orders
    orders,
    ordersLoading,
    orderOptions,
    selectedOrder,
    handleOrderChange,

    // Order items (available to add)
    orderItems,
    orderItemsLoading,

    // Shipment items (items to ship)
    shipmentItems,
    totalAmount,
    handleAddItem,
    handleAddAllItems,
    handleRemoveItem,
    handleQuantityChange,

    // Shipment details
    shippedDate,
    setShippedDate,
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

    // Navigation
    handleCancel,
  };
};
