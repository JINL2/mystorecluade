/**
 * useShipmentCreateItems Hook
 * Handles shipment items management for shipment creation
 */

import { useState, useCallback, useMemo } from 'react';
import type {
  OrderInfo,
  ShipmentItem,
  InventoryProduct,
} from '../pages/ShipmentCreatePage/ShipmentCreatePage.types';

interface UseShipmentCreateItemsProps {
  selectedOrder: string | null;
  allOrders: OrderInfo[];
}

export const useShipmentCreateItems = ({
  selectedOrder,
  allOrders,
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

  // Add product from search (v6: variant support)
  const handleAddProductFromSearch = useCallback(
    (product: InventoryProduct) => {
      // v6: unique key is product_id + variant_id (if exists)
      const existingItem = shipmentItems.find(
        (item) =>
          item.productId === product.product_id &&
          item.variantId === (product.variant_id || undefined)
      );
      if (existingItem) {
        setShipmentItems((prev) =>
          prev.map((item) =>
            item.productId === product.product_id &&
            item.variantId === (product.variant_id || undefined)
              ? { ...item, quantity: item.quantity + 1 }
              : item
          )
        );
      } else {
        // v6: use display_name/display_sku for display
        const newItem: ShipmentItem = {
          orderItemId: `search-${product.product_id}-${product.variant_id || 'base'}-${Date.now()}`,
          orderId: '',
          orderNumber: '-',
          productId: product.product_id,
          variantId: product.variant_id || undefined,
          productName: product.display_name || product.product_name,
          sku: product.display_sku || product.product_sku,
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
