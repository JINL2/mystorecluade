/**
 * useOrderItems Hook
 * Manages order items state and operations
 */

import { useState, useCallback } from 'react';
import type { OrderItem, InventoryProduct } from '../pages/OrderCreatePage/OrderCreatePage.types';

export const useOrderItems = () => {
  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);

  // Calculate total amount
  const totalAmount = orderItems.reduce((sum, item) => sum + item.cost * item.quantity, 0);

  // Handle add product from search
  // v6: Uses display_sku and considers variant_id for uniqueness
  const handleAddProduct = useCallback(
    (product: InventoryProduct) => {
      setOrderItems((prevItems) => {
        // For v6: unique key is product_id + variant_id (if exists)
        const existingIndex = prevItems.findIndex(
          (item) =>
            item.productId === product.product_id &&
            item.variantId === (product.variant_id || undefined)
        );

        if (existingIndex >= 0) {
          // Update quantity if already exists
          const updatedItems = [...prevItems];
          updatedItems[existingIndex].quantity += 1;
          return updatedItems;
        } else {
          // Add new item with cost from RPC
          // v6: use display_name/display_sku for display, store variant_sku/product_sku for RPC
          return [
            ...prevItems,
            {
              productId: product.product_id,
              variantId: product.variant_id || undefined,
              productName: product.display_name || product.product_name,
              sku: product.display_sku || product.product_sku,
              variantSku: product.variant_sku || undefined, // v6: for RPC call
              productSku: product.product_sku, // v6: for RPC call fallback
              quantity: 1,
              cost: product.price.cost || 0,
            },
          ];
        }
      });
    },
    []
  );

  // Handle quantity change
  const handleQuantityChange = useCallback((index: number, value: string) => {
    setOrderItems((prevItems) => {
      const updatedItems = [...prevItems];
      // Allow empty value (will be stored as 0, but displayed as empty)
      updatedItems[index].quantity = value === '' ? 0 : parseInt(value) || 0;
      return updatedItems;
    });
  }, []);

  // Handle cost change
  const handleCostChange = useCallback((index: number, cost: number) => {
    if (cost < 0) return;
    setOrderItems((prevItems) => {
      const updatedItems = [...prevItems];
      updatedItems[index].cost = cost;
      return updatedItems;
    });
  }, []);

  // Handle remove item
  const handleRemoveItem = useCallback((index: number) => {
    setOrderItems((prevItems) => prevItems.filter((_, i) => i !== index));
  }, []);

  return {
    orderItems,
    setOrderItems,
    totalAmount,
    handleAddProduct,
    handleQuantityChange,
    handleCostChange,
    handleRemoveItem,
  };
};
