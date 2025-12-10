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
  const handleAddProduct = useCallback(
    (product: InventoryProduct) => {
      setOrderItems((prevItems) => {
        const existingIndex = prevItems.findIndex(
          (item) => item.productId === product.product_id
        );

        if (existingIndex >= 0) {
          // Update quantity if already exists
          const updatedItems = [...prevItems];
          updatedItems[existingIndex].quantity += 1;
          return updatedItems;
        } else {
          // Add new item with cost from RPC
          return [
            ...prevItems,
            {
              productId: product.product_id,
              productName: product.product_name,
              sku: product.sku,
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
