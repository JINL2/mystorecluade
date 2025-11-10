/**
 * useProductReceive Hook
 * Manages product receive state and operations
 */

import { useState, useCallback, useEffect } from 'react';
import { Order } from '../../domain/entities/Order';
import { OrderProduct } from '../../domain/entities/OrderProduct';
import { ScannedItemEntity } from '../../domain/entities/ScannedItem';
import { ProductReceiveRepositoryImpl } from '../../data/repositories/ProductReceiveRepositoryImpl';
import { supabaseService } from '@/core/services/supabase_service';

export const useProductReceive = (companyId: string, storeId: string | null) => {
  // Orders
  const [orders, setOrders] = useState<Order[]>([]);
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [orderProducts, setOrderProducts] = useState<OrderProduct[]>([]);
  const [loadingOrders, setLoadingOrders] = useState(false);

  // Scanning
  const [scannedItems, setScannedItems] = useState<Map<string, ScannedItemEntity>>(
    new Map()
  );
  const [skuInput, setSkuInput] = useState('');
  const [autocompleteResults, setAutocompleteResults] = useState<OrderProduct[]>([]);
  const [showAutocomplete, setShowAutocomplete] = useState(false);

  // Search/Filter
  const [productSearchTerm, setProductSearchTerm] = useState('');
  const [filteredProducts, setFilteredProducts] = useState<OrderProduct[]>([]);

  // UI State
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const repository = new ProductReceiveRepositoryImpl();

  // Select an order
  const selectOrder = useCallback((order: Order) => {
    setSelectedOrder(order);
    setScannedItems(new Map());
    setSkuInput('');
    setProductSearchTerm('');
    setError(null);

    // Load products from order.items (already included in the RPC response)
    const products = order.items || [];
    setOrderProducts(products);
  }, []);

  // Load orders for company
  const loadOrders = useCallback(async () => {
    if (!companyId) {
      setOrders([]);
      return;
    }

    setLoadingOrders(true);
    setError(null);

    try {
      const result = await repository.getOrders(companyId);

      if (!result.success) {
        setError(result.error || 'Failed to load orders');
        setOrders([]);
        setLoadingOrders(false);
        return;
      }

      const newOrders = result.data || [];
      setOrders(newOrders);

      // Re-select current order with updated data, or auto-select first order
      if (newOrders.length > 0) {
        // Use a ref or state to check if we have a selected order
        setSelectedOrder(prevSelected => {
          if (prevSelected) {
            // Find and re-select the current order with updated data
            const updatedOrder = newOrders.find(o => o.orderId === prevSelected.orderId);
            if (updatedOrder) {
              // Update order products when re-selecting
              setOrderProducts(updatedOrder.items || []);
              return updatedOrder;
            } else {
              // If current order no longer exists, select first order
              setOrderProducts(newOrders[0].items || []);
              return newOrders[0];
            }
          } else {
            // No order selected yet, auto-select first order
            setOrderProducts(newOrders[0].items || []);
            return newOrders[0];
          }
        });

        // Clear scanned items when switching orders
        setScannedItems(new Map());
        setSkuInput('');
        setProductSearchTerm('');
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setOrders([]);
    } finally {
      setLoadingOrders(false);
    }
  }, [companyId]);

  // Handle SKU input for autocomplete
  const handleSkuInput = useCallback(
    (value: string) => {
      setSkuInput(value);

      const searchTerm = value.trim().toLowerCase();

      if (!searchTerm || searchTerm.length < 1) {
        setShowAutocomplete(false);
        setAutocompleteResults([]);
        return;
      }

      // Filter products based on SKU or product name (matching backup logic)
      let filtered = orderProducts.filter(
        (p) =>
          p.sku.toLowerCase().includes(searchTerm) ||
          p.productName.toLowerCase().includes(searchTerm)
      );

      // Sort results to prioritize SKU matches at the beginning (matching backup)
      filtered.sort((a, b) => {
        const aSkuMatch = a.sku.toLowerCase().startsWith(searchTerm);
        const bSkuMatch = b.sku.toLowerCase().startsWith(searchTerm);

        if (aSkuMatch && !bSkuMatch) return -1;
        if (!aSkuMatch && bSkuMatch) return 1;

        // Then sort by SKU alphabetically
        return a.sku.localeCompare(b.sku);
      });

      // Limit to top 10 results (matching backup)
      filtered = filtered.slice(0, 10);

      setAutocompleteResults(filtered);
      setShowAutocomplete(filtered.length > 0);
    },
    [orderProducts]
  );

  // Add scanned item
  const addScannedItem = useCallback((product: OrderProduct) => {
    setScannedItems((prev) => {
      const newMap = new Map(prev);
      const existing = newMap.get(product.sku);

      if (existing) {
        existing.incrementCount();
      } else {
        newMap.set(
          product.sku,
          new ScannedItemEntity(
            product.sku,
            product.productId,
            product.productName,
            1
          )
        );
      }

      return newMap;
    });

    setSkuInput('');
    setShowAutocomplete(false);
    setError(null);
  }, []);

  // Update scanned item quantity
  const updateScannedQuantity = useCallback((sku: string, quantity: number) => {
    setScannedItems((prev) => {
      const newMap = new Map(prev);
      const item = newMap.get(sku);

      if (item && quantity > 0) {
        item.setCount(quantity);
      } else if (item && quantity === 0) {
        newMap.delete(sku);
      }

      return newMap;
    });
  }, []);

  // Remove scanned item
  const removeScannedItem = useCallback((sku: string) => {
    setScannedItems((prev) => {
      const newMap = new Map(prev);
      newMap.delete(sku);
      return newMap;
    });
  }, []);

  // Clear all scanned items
  const clearAllScanned = useCallback(() => {
    setScannedItems(new Map());
    setSkuInput('');
    setError(null);
  }, []);

  // Filter products in order list
  const filterProducts = useCallback(
    (searchTerm: string) => {
      setProductSearchTerm(searchTerm);

      if (searchTerm.trim().length === 0) {
        setFilteredProducts(orderProducts);
        return;
      }

      const filtered = orderProducts.filter(
        (p) =>
          p.sku.toLowerCase().includes(searchTerm.toLowerCase()) ||
          p.productName.toLowerCase().includes(searchTerm.toLowerCase())
      );

      setFilteredProducts(filtered);
    },
    [orderProducts]
  );

  // Submit receive
  const submitReceive = useCallback(async () => {
    if (!companyId || !storeId || !selectedOrder || scannedItems.size === 0) {
      setError('Missing required data for submission');
      return { success: false };
    }

    setSubmitting(true);
    setError(null);

    try {
      // Get user ID from session
      const {
        data: { session },
        error: sessionError,
      } = await supabaseService.getClient().auth.getSession();

      if (sessionError || !session?.user?.id) {
        throw new Error('User session not found. Please login again.');
      }

      const userId = session.user.id;

      // Build items array
      const items = Array.from(scannedItems.values()).map((item) => ({
        productId: item.productId,
        quantityReceived: item.count,
      }));

      const result = await repository.submitReceive(
        companyId,
        storeId,
        selectedOrder.orderId,
        userId,
        items,
        null
      );

      if (!result.success) {
        setError(result.error || 'Failed to submit receive');
        return { success: false };
      }

      // Clear scanned items on success
      clearAllScanned();

      // Reload orders to get updated data
      await loadOrders();

      return {
        success: true,
        data: result.data,
      };
    } catch (err) {
      const errorMessage =
        err instanceof Error ? err.message : 'An unexpected error occurred';
      setError(errorMessage);
      return { success: false };
    } finally {
      setSubmitting(false);
    }
  }, [companyId, storeId, selectedOrder, scannedItems, clearAllScanned, loadOrders]);

  // Load orders when company changes
  useEffect(() => {
    loadOrders();
  }, [loadOrders]);

  // Update filtered products when order products change
  useEffect(() => {
    setFilteredProducts(orderProducts);
  }, [orderProducts]);

  // Calculate progress
  const totalScannedCount = Array.from(scannedItems.values()).reduce(
    (sum, item) => sum + item.count,
    0
  );

  const scannedItemsArray = Array.from(scannedItems.values());

  return {
    // Orders
    orders,
    selectedOrder,
    selectOrder,
    loadingOrders,

    // Products
    orderProducts,
    filteredProducts,
    productSearchTerm,
    filterProducts,

    // Scanning
    scannedItems: scannedItemsArray,
    totalScannedCount,
    skuInput,
    handleSkuInput,
    autocompleteResults,
    showAutocomplete,
    setShowAutocomplete,
    addScannedItem,
    updateScannedQuantity,
    removeScannedItem,
    clearAllScanned,

    // Submission
    submitReceive,
    submitting,

    // Error
    error,
    setError,
  };
};
