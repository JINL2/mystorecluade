/**
 * useShipmentCreateOrder Hook
 * Handles order selection and order items management for shipment creation
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { getShipmentRepository } from '../../data/repositories/ShipmentRepositoryImpl';
import type {
  OrderInfo,
  OrderItem,
  SelectionMode,
} from '../pages/ShipmentCreatePage/ShipmentCreatePage.types';

interface UseShipmentCreateOrderProps {
  companyId: string | undefined;
  ordersFromState: OrderInfo[] | undefined;
  selectedSupplier: string | null;
  onSelectionModeChange: (mode: SelectionMode) => void;
  onSupplierChange: (supplierId: string | null) => void;
  onClearShipmentItems: () => void;
}

export const useShipmentCreateOrder = ({
  companyId,
  ordersFromState,
  selectedSupplier,
  onSelectionModeChange,
  onSupplierChange,
  onClearShipmentItems,
}: UseShipmentCreateOrderProps) => {
  const repository = useMemo(() => getShipmentRepository(), []);

  // Orders state
  const [allOrders, setAllOrders] = useState<OrderInfo[]>(ordersFromState || []);
  const [ordersLoading, setOrdersLoading] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState<string | null>(null);

  // Order items state
  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);
  const [orderItemsLoading, setOrderItemsLoading] = useState(false);

  // Filter orders by selected supplier
  const filteredOrders = selectedSupplier
    ? allOrders.filter((order) => order.supplier_id === selectedSupplier)
    : allOrders;

  // Convert orders to options format
  const orderOptions = filteredOrders.map((order) => ({
    value: order.order_id,
    label: `${order.order_number} - ${order.supplier_name}`,
  }));

  // Load orders if not passed from ShipmentPage using Repository
  useEffect(() => {
    if (ordersFromState && ordersFromState.length > 0) {
      return;
    }

    const loadOrders = async () => {
      if (!companyId) return;

      setOrdersLoading(true);
      try {
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        const result = await repository.getOrders(companyId, userTimezone);

        if (result.success && result.data) {
          setAllOrders(result.data);
        } else {
          setAllOrders([]);
        }
      } catch (err) {
        console.error('📋 getOrders error:', err);
        setAllOrders([]);
      } finally {
        setOrdersLoading(false);
      }
    };

    loadOrders();
  }, [companyId, ordersFromState, repository]);

  // Load order items when order is selected using Repository
  useEffect(() => {
    const loadOrderItems = async () => {
      if (!selectedOrder) {
        setOrderItems([]);
        return;
      }

      setOrderItemsLoading(true);
      try {
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        const result = await repository.getOrderItems(selectedOrder, userTimezone);

        if (result.success && result.data) {
          setOrderItems(result.data);
        } else {
          setOrderItems([]);
        }
      } catch (err) {
        console.error('📦 getOrderItems error:', err);
        setOrderItems([]);
      } finally {
        setOrderItemsLoading(false);
      }
    };

    loadOrderItems();
  }, [selectedOrder, repository]);

  // Handle supplier change - reset order selection if filtered out
  const handleSupplierChange = useCallback((supplierId: string | null) => {
    onSupplierChange(supplierId);

    if (supplierId && selectedOrder) {
      const orderStillValid = allOrders.some(
        (o) => o.order_id === selectedOrder && o.supplier_id === supplierId
      );
      if (!orderStillValid) {
        setSelectedOrder(null);
        setOrderItems([]);
        onClearShipmentItems();
      }
    }
  }, [selectedOrder, allOrders, onSupplierChange, onClearShipmentItems]);

  // Handle order change - set selection mode to 'order' and auto-set supplier
  const handleOrderChange = useCallback((orderId: string | null) => {
    setSelectedOrder(orderId);
    onClearShipmentItems();

    if (orderId) {
      onSelectionModeChange('order');
      const selectedOrderData = allOrders.find((o) => o.order_id === orderId);
      if (selectedOrderData?.supplier_id && selectedOrderData.supplier_id !== selectedSupplier) {
        onSupplierChange(selectedOrderData.supplier_id);
      }
    } else {
      onSelectionModeChange(null);
    }
  }, [allOrders, selectedSupplier, onSelectionModeChange, onSupplierChange, onClearShipmentItems]);

  // Clear order selection (for external use)
  const clearOrderSelection = useCallback(() => {
    setSelectedOrder(null);
    setOrderItems([]);
  }, []);

  return {
    allOrders,
    filteredOrders,
    ordersLoading,
    orderOptions,
    selectedOrder,
    orderItems,
    orderItemsLoading,
    handleSupplierChange,
    handleOrderChange,
    clearOrderSelection,
  };
};
