/**
 * useShipmentCreateItems Hook
 * Handles shipment items management for shipment creation
 */

import { useState, useCallback, useMemo } from 'react';
import type {
  OrderInfo,
  OrderItem,
  ShipmentItem,
  InventoryProduct,
} from '../pages/ShipmentCreatePage/ShipmentCreatePage.types';

interface UseShipmentCreateItemsProps {
  selectedOrder: string | null;
  allOrders: OrderInfo[];
  orderItems: OrderItem[];
}

export const useShipmentCreateItems = ({
  selectedOrder,
  allOrders,
  orderItems,
}: UseShipmentCreateItemsProps) => {
  // Shipment items state
  const [shipmentItems, setShipmentItems] = useState<ShipmentItem[]>([]);

  // Item search state (for filtering added items)
  const [itemSearchQuery, setItemSearchQuery] = useState<string>('');

  // Calculate total amount
  const totalAmount = shipmentItems.reduce(
    (sum, item) => sum + item.quantity * item.unitPrice,
    0
  );

  // Add item to shipment from order items
  const handleAddItem = useCallback(
    (orderItem: OrderItem) => {
      const selectedOrderData = allOrders.find((o) => o.order_id === selectedOrder);
      if (!selectedOrderData) return;

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
    [selectedOrder, allOrders, shipmentItems]
  );

  // Add all items from current order
  const handleAddAllItems = useCallback(() => {
    const selectedOrderData = allOrders.find((o) => o.order_id === selectedOrder);
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
  }, [selectedOrder, allOrders, orderItems, shipmentItems]);

  // Add product from search
  const handleAddProductFromSearch = useCallback(
    (product: InventoryProduct) => {
      const existingItem = shipmentItems.find((item) => item.productId === product.product_id);
      if (existingItem) {
        setShipmentItems((prev) =>
          prev.map((item) =>
            item.productId === product.product_id
              ? { ...item, quantity: item.quantity + 1 }
              : item
          )
        );
      } else {
        const newItem: ShipmentItem = {
          orderItemId: `search-${product.product_id}-${Date.now()}`,
          orderId: '',
          orderNumber: '-',
          productId: product.product_id,
          productName: product.product_name,
          sku: product.sku,
          quantity: 1,
          maxQuantity: product.stock.quantity_on_hand,
          unitPrice: product.price.cost,
        };
        setShipmentItems((prev) => [...prev, newItem]);
      }
    },
    [shipmentItems]
  );

  // Remove item from shipment
  const handleRemoveItem = useCallback((orderItemId: string) => {
    setShipmentItems((prev) => prev.filter((item) => item.orderItemId !== orderItemId));
  }, []);

  // Update item quantity
  const handleQuantityChange = useCallback((orderItemId: string, quantity: number) => {
    setShipmentItems((prev) =>
      prev.map((item) => {
        if (item.orderItemId === orderItemId) {
          return { ...item, quantity: Math.max(0, quantity) };
        }
        return item;
      })
    );
  }, []);

  // Update item cost (by index)
  const handleCostChange = useCallback((index: number, cost: number) => {
    setShipmentItems((prev) =>
      prev.map((item, i) => {
        if (i === index) {
          return { ...item, unitPrice: cost };
        }
        return item;
      })
    );
  }, []);

  // Clear all shipment items
  const clearShipmentItems = useCallback(() => {
    setShipmentItems([]);
  }, []);

  // Filter shipment items by search query
  const filteredShipmentItems = useMemo(() => {
    if (!itemSearchQuery.trim()) return shipmentItems;
    const query = itemSearchQuery.toLowerCase().trim();
    return shipmentItems.filter(
      (item) =>
        item.productName.toLowerCase().includes(query) ||
        item.sku.toLowerCase().includes(query) ||
        item.orderNumber.toLowerCase().includes(query)
    );
  }, [shipmentItems, itemSearchQuery]);

  return {
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
  };
};
