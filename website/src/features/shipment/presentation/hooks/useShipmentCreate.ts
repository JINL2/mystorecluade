/**
 * useShipmentCreate Hook
 * Custom hook for shipment creation form management
 */

import { useState, useEffect, useCallback, useRef, useMemo } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import ExcelJS from 'exceljs';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import type {
  Counterparty,
  OrderInfo,
  OrderItem,
  ShipmentItem,
  Currency,
  SaveResult,
  ImportError,
  OneTimeSupplier,
  SelectionMode,
  InventoryProduct,
} from '../pages/ShipmentCreatePage/ShipmentCreatePage.types';

// Navigation state interface
interface NavigationState {
  currency?: Currency;
  suppliers?: Counterparty[];
  orders?: OrderInfo[];
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
  const { currentCompany, currentStore } = useAppState();
  const companyId = currentCompany?.company_id;
  const storeId = currentStore?.store_id;

  // Get currency, suppliers, and orders from navigation state
  const navigationState = location.state as NavigationState | null;
  const currencyFromState = navigationState?.currency;
  const suppliersFromState = navigationState?.suppliers;
  const ordersFromState = navigationState?.orders;

  // Currency state
  const [currency, setCurrency] = useState<Currency>(
    currencyFromState || { symbol: '₩', code: 'KRW' }
  );

  // Selection mode state - 'order' or 'supplier'
  const [selectionMode, setSelectionMode] = useState<SelectionMode>(null);

  // Suppliers state
  const [suppliers, setSuppliers] = useState<Counterparty[]>(suppliersFromState || []);
  const [suppliersLoading, setSuppliersLoading] = useState(false);
  const [selectedSupplier, setSelectedSupplier] = useState<string | null>(null);

  // Supplier type toggle - 'existing' or 'onetime'
  const [supplierType, setSupplierType] = useState<'existing' | 'onetime'>('existing');
  const [oneTimeSupplier, setOneTimeSupplier] = useState<OneTimeSupplier>({
    name: '',
    phone: '',
    email: '',
    address: '',
  });

  // Orders state (initialized from navigation or empty)
  const [allOrders, setAllOrders] = useState<OrderInfo[]>(ordersFromState || []);
  const [ordersLoading, setOrdersLoading] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState<string | null>(null);

  // Order items state (items from selected order)
  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);
  const [orderItemsLoading, setOrderItemsLoading] = useState(false);

  // Shipment items state (items to be shipped)
  const [shipmentItems, setShipmentItems] = useState<ShipmentItem[]>([]);

  // Shipment details
  const [trackingNumber, setTrackingNumber] = useState<string>('');
  const [note, setNote] = useState<string>('');

  // Save states
  const [isSaving, setIsSaving] = useState(false);
  const [saveResult, setSaveResult] = useState<SaveResult>({
    show: false,
    success: false,
    message: '',
  });

  // Import/Export states
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [isImporting, setIsImporting] = useState(false);
  const [importError, setImportError] = useState<ImportError>({
    show: false,
    notFoundSkus: [],
  });

  // Product search state
  const searchInputRef = useRef<HTMLInputElement>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [searchResults, setSearchResults] = useState<InventoryProduct[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);

  // Item search state (for filtering added items)
  const [itemSearchQuery, setItemSearchQuery] = useState<string>('');

  // Convert suppliers to options format
  const supplierOptions: SupplierOption[] = suppliers.map((supplier) => ({
    value: supplier.counterparty_id,
    label: supplier.name,
    description: supplier.is_internal ? 'INTERNAL' : undefined,
  }));

  // Filter orders by selected supplier (if any)
  const filteredOrders = selectedSupplier
    ? allOrders.filter((order) => order.supplier_id === selectedSupplier)
    : allOrders;

  // Convert orders to options format
  const orderOptions = filteredOrders.map((order) => ({
    value: order.order_id,
    label: `${order.order_number} - ${order.supplier_name}`,
  }));

  // Calculate total amount
  const totalAmount = shipmentItems.reduce(
    (sum, item) => sum + item.quantity * item.unitPrice,
    0
  );

  // Search products using RPC
  const searchProducts = useCallback(
    async (query: string) => {
      if (!query.trim()) {
        setSearchResults([]);
        setShowDropdown(false);
        return;
      }

      if (!companyId || !storeId) {
        setSearchResults([]);
        setShowDropdown(false);
        return;
      }

      setIsSearching(true);
      try {
        const supabase = supabaseService.getClient();
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        const { data, error } = await supabase.rpc('get_inventory_page_v3', {
          p_company_id: companyId,
          p_store_id: storeId,
          p_page: 1,
          p_limit: 10,
          p_search: query.trim(),
          p_timezone: userTimezone,
        });

        if (error) {
          console.error('🔍 Product search error:', error);
          setSearchResults([]);
          return;
        }

        if (data?.success && data?.data?.products) {
          setSearchResults(data.data.products);
          if (data.data.currency) {
            setCurrency(data.data.currency);
          }
          setShowDropdown(true);
        } else {
          setSearchResults([]);
          setShowDropdown(true);
        }
      } catch (err) {
        console.error('🔍 Product search error:', err);
        setSearchResults([]);
      } finally {
        setIsSearching(false);
      }
    },
    [companyId, storeId]
  );

  // Debounced search effect
  useEffect(() => {
    const timer = setTimeout(() => {
      if (searchQuery.trim()) {
        searchProducts(searchQuery);
      } else {
        setSearchResults([]);
        setShowDropdown(false);
      }
    }, 300);

    return () => clearTimeout(timer);
  }, [searchQuery, searchProducts]);

  // Close dropdown on click outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(event.target as Node) &&
        searchInputRef.current &&
        !searchInputRef.current.contains(event.target as Node)
      ) {
        setShowDropdown(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Clear search after product is added
  const clearSearch = useCallback(() => {
    setSearchQuery('');
    setSearchResults([]);
    setShowDropdown(false);
  }, []);

  // Handle add product from search
  const handleAddProductFromSearch = useCallback(
    (product: InventoryProduct) => {
      // Check if product already exists in shipment items
      const existingItem = shipmentItems.find((item) => item.productId === product.product_id);
      if (existingItem) {
        // Increase quantity
        setShipmentItems((prev) =>
          prev.map((item) =>
            item.productId === product.product_id
              ? { ...item, quantity: item.quantity + 1 }
              : item
          )
        );
      } else {
        // Add new item
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
      clearSearch();
    },
    [shipmentItems, clearSearch]
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

  // Load orders if not passed from ShipmentPage
  useEffect(() => {
    if (ordersFromState && ordersFromState.length > 0) {
      return;
    }

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
          setAllOrders(data.data);
        } else {
          setAllOrders([]);
        }
      } catch (err) {
        console.error('📋 inventory_get_order_info error:', err);
        setAllOrders([]);
      } finally {
        setOrdersLoading(false);
      }
    };

    loadOrders();
  }, [companyId, ordersFromState]);

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

  // Handle supplier change - reset order selection if filtered out
  const handleSupplierChange = useCallback((supplierId: string | null) => {
    setSelectedSupplier(supplierId);
    // Clear order selection if it's not in the filtered list
    if (supplierId && selectedOrder) {
      const orderStillValid = allOrders.some(
        (o) => o.order_id === selectedOrder && o.supplier_id === supplierId
      );
      if (!orderStillValid) {
        setSelectedOrder(null);
        setOrderItems([]);
        setShipmentItems([]);
      }
    }
  }, [selectedOrder, allOrders]);

  // Handle order change - set selection mode to 'order' and auto-set supplier
  const handleOrderChange = useCallback((orderId: string | null) => {
    setSelectedOrder(orderId);
    setShipmentItems([]);

    // Set selection mode to 'order' when order is selected
    if (orderId) {
      setSelectionMode('order');
      const selectedOrderData = allOrders.find((o) => o.order_id === orderId);
      if (selectedOrderData?.supplier_id && selectedOrderData.supplier_id !== selectedSupplier) {
        setSelectedSupplier(selectedOrderData.supplier_id);
      }
    } else {
      // Clear selection mode when order is deselected
      setSelectionMode(null);
    }
  }, [allOrders, selectedSupplier]);

  // Handle supplier selection in Supplier section (not filter)
  const handleSupplierSectionChange = useCallback((supplierId: string | null) => {
    setSelectedSupplier(supplierId);

    // Set selection mode to 'supplier' when supplier is selected in Supplier section
    if (supplierId) {
      setSelectionMode('supplier');
      // Clear order selection when supplier is selected directly
      setSelectedOrder(null);
      setOrderItems([]);
      setShipmentItems([]);
    } else {
      // Clear selection mode when supplier is deselected
      setSelectionMode(null);
    }
  }, []);

  // Handle one-time supplier field change
  const handleOneTimeSupplierChange = useCallback(
    (field: keyof OneTimeSupplier, value: string) => {
      const newSupplier = { ...oneTimeSupplier, [field]: value };
      setOneTimeSupplier(newSupplier);

      // Check if all fields are empty
      const allFieldsEmpty =
        !newSupplier.name.trim() &&
        !newSupplier.phone.trim() &&
        !newSupplier.email.trim() &&
        !newSupplier.address.trim();

      if (allFieldsEmpty) {
        // Clear selection mode when all fields are empty
        setSelectionMode(null);
      } else {
        // Set selection mode to 'supplier' when one-time supplier is being entered
        setSelectionMode('supplier');
        // Clear order selection
        setSelectedOrder(null);
        setOrderItems([]);
        setShipmentItems([]);
      }
    },
    [oneTimeSupplier]
  );

  // Handle clear supplier selection
  const handleClearSupplierSelection = useCallback(() => {
    setSelectedSupplier(null);
    setOneTimeSupplier({ name: '', phone: '', email: '', address: '' });
    setSelectionMode(null);
  }, []);

  // Handle supplier type toggle
  const handleSupplierTypeChange = useCallback((type: 'existing' | 'onetime') => {
    setSupplierType(type);
    // Clear selections when switching
    if (type === 'existing') {
      setOneTimeSupplier({ name: '', phone: '', email: '', address: '' });
    } else {
      // When switching to one-time, clear selected supplier and reset selection mode
      setSelectedSupplier(null);
      setSelectionMode(null);
    }
  }, []);

  // Add item to shipment
  const handleAddItem = useCallback(
    (orderItem: OrderItem) => {
      const selectedOrderData = allOrders.find((o) => o.order_id === selectedOrder);
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

  // Handle import click
  const handleImportClick = useCallback(() => {
    fileInputRef.current?.click();
  }, []);

  // Search product by SKU using inventory RPC (same as Order page)
  const searchProductBySku = useCallback(
    async (sku: string): Promise<InventoryProduct | null> => {
      if (!companyId || !storeId || !sku.trim()) {
        return null;
      }

      try {
        const supabase = supabaseService.getClient();
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        const { data, error } = await supabase.rpc('get_inventory_page_v3', {
          p_company_id: companyId,
          p_store_id: storeId,
          p_page: 1,
          p_limit: 1,
          p_search: sku.trim(),
          p_timezone: userTimezone,
        });

        if (error) {
          console.error('📦 Search by SKU error:', error);
          return null;
        }

        if (data?.success && data?.data?.products && data.data.products.length > 0) {
          // Find exact SKU match
          const exactMatch = data.data.products.find(
            (p: InventoryProduct) => p.sku.toLowerCase() === sku.trim().toLowerCase()
          );
          return exactMatch || null;
        }

        return null;
      } catch (err) {
        console.error('📦 Search by SKU exception:', err);
        return null;
      }
    },
    [companyId, storeId]
  );

  // Handle file change (import Excel - same logic as Order page)
  const handleFileChange = useCallback(
    async (e: React.ChangeEvent<HTMLInputElement>) => {
      const file = e.target.files?.[0];
      if (!file) return;

      // Check if companyId and storeId are available
      if (!companyId || !storeId) {
        setImportError({
          show: true,
          notFoundSkus: ['Company or Store not selected. Please select a company and store first.'],
        });
        if (fileInputRef.current) {
          fileInputRef.current.value = '';
        }
        return;
      }

      setIsImporting(true);
      console.log('📦 Import shipment file:', file.name);

      try {
        const workbook = new ExcelJS.Workbook();
        const arrayBuffer = await file.arrayBuffer();
        await workbook.xlsx.load(arrayBuffer);

        const worksheet = workbook.worksheets[0];
        if (!worksheet) {
          throw new Error('No worksheet found in the Excel file');
        }

        // Parse rows (skip header row 1) - same format as Order page: SKU, Cost, Quantity
        const rowsToProcess: { sku: string; cost: number; quantity: number }[] = [];

        worksheet.eachRow((row, rowNumber) => {
          if (rowNumber === 1) return; // Skip header

          const skuCell = row.getCell(1); // Column A = SKU
          const costCell = row.getCell(2); // Column B = Cost
          const quantityCell = row.getCell(3); // Column C = Quantity

          const sku = skuCell.value?.toString().trim();
          const cost = parseFloat(costCell.value?.toString() || '0') || 0;
          const quantity = parseInt(quantityCell.value?.toString() || '1') || 1;

          if (sku) {
            rowsToProcess.push({ sku, cost, quantity });
          }
        });

        console.log('📦 Rows to process:', rowsToProcess);

        if (rowsToProcess.length === 0) {
          setImportError({
            show: true,
            notFoundSkus: ['No valid SKUs found in the Excel file. Please check the file format.'],
          });
          setIsImporting(false);
          if (fileInputRef.current) {
            fileInputRef.current.value = '';
          }
          return;
        }

        // Search products and add to shipment items (same logic as Order page)
        const notFoundSkus: string[] = [];
        const newShipmentItems: ShipmentItem[] = [...shipmentItems];

        for (const row of rowsToProcess) {
          const product = await searchProductBySku(row.sku);

          if (product) {
            // Check if product already exists in shipment items
            const existingIndex = newShipmentItems.findIndex(
              (item) => item.productId === product.product_id
            );

            if (existingIndex >= 0) {
              // Update quantity and cost if already exists
              newShipmentItems[existingIndex].quantity += row.quantity;
              newShipmentItems[existingIndex].unitPrice = row.cost;
            } else {
              // Add new item with cost and quantity from Excel
              newShipmentItems.push({
                orderItemId: `import-${product.product_id}-${Date.now()}`,
                orderId: '',
                orderNumber: '-',
                productId: product.product_id,
                productName: product.product_name,
                sku: product.sku,
                quantity: row.quantity,
                maxQuantity: product.stock.quantity_on_hand,
                unitPrice: row.cost,
              });
            }
          } else {
            notFoundSkus.push(row.sku);
          }
        }

        // Update shipment items
        setShipmentItems(newShipmentItems);

        // Show error message if some SKUs were not found
        if (notFoundSkus.length > 0) {
          setImportError({
            show: true,
            notFoundSkus,
          });
        }

        console.log('📦 Import complete:', {
          processed: rowsToProcess.length,
          added: rowsToProcess.length - notFoundSkus.length,
          notFound: notFoundSkus.length,
        });
      } catch (error) {
        console.error('📦 Import error:', error);
        setImportError({
          show: true,
          notFoundSkus: [
            `Failed to read Excel file: ${error instanceof Error ? error.message : 'Unknown error'}`,
          ],
        });
      } finally {
        setIsImporting(false);
        if (fileInputRef.current) {
          fileInputRef.current.value = '';
        }
      }
    },
    [companyId, storeId, shipmentItems, searchProductBySku]
  );

  // Handle export sample (same format as Order page: SKU, Cost, Quantity)
  const handleExportSample = useCallback(async () => {
    try {
      const workbook = new ExcelJS.Workbook();
      workbook.creator = 'Store Base';
      workbook.created = new Date();

      const worksheet = workbook.addWorksheet('Shipment Items');

      // Define columns (same as Order page)
      worksheet.columns = [
        { header: 'SKU', key: 'sku', width: 20 },
        { header: 'Cost', key: 'cost', width: 15 },
        { header: 'Quantity', key: 'quantity', width: 12 },
      ];

      // Style header row
      const headerRow = worksheet.getRow(1);
      headerRow.font = {
        name: 'Arial',
        size: 11,
        bold: true,
        color: { argb: 'FFFFFFFF' },
      };
      headerRow.fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: 'FF4472C4' },
      };
      headerRow.alignment = {
        vertical: 'middle',
        horizontal: 'center',
        wrapText: false,
      };
      headerRow.height = 25;

      // Add border to header cells
      headerRow.eachCell((cell) => {
        cell.border = {
          top: { style: 'thin', color: { argb: 'FF000000' } },
          left: { style: 'thin', color: { argb: 'FF000000' } },
          bottom: { style: 'thin', color: { argb: 'FF000000' } },
          right: { style: 'thin', color: { argb: 'FF000000' } },
        };
      });

      // Add sample data rows
      worksheet.addRow({ sku: 'SAMPLE-SKU-001', cost: 10000, quantity: 5 });
      worksheet.addRow({ sku: 'SAMPLE-SKU-002', cost: 25000, quantity: 10 });

      // Style sample data rows
      [2, 3].forEach((rowNum) => {
        const row = worksheet.getRow(rowNum);
        row.font = { color: { argb: 'FF6C757D' }, italic: true };
        row.alignment = { vertical: 'middle', horizontal: 'center' };
        row.eachCell((cell) => {
          cell.border = {
            top: { style: 'thin', color: { argb: 'FFD3D3D3' } },
            left: { style: 'thin', color: { argb: 'FFD3D3D3' } },
            bottom: { style: 'thin', color: { argb: 'FFD3D3D3' } },
            right: { style: 'thin', color: { argb: 'FFD3D3D3' } },
          };
        });
      });

      // Generate buffer
      const buffer = await workbook.xlsx.writeBuffer();

      // Create blob
      const blob = new Blob([buffer], {
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      });

      // Try to use File System Access API
      if ('showSaveFilePicker' in window) {
        try {
          const handle = await (
            window as unknown as {
              showSaveFilePicker: (options: unknown) => Promise<FileSystemFileHandle>;
            }
          ).showSaveFilePicker({
            suggestedName: 'shipment_items_sample.xlsx',
            types: [
              {
                description: 'Excel Files',
                accept: {
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': ['.xlsx'],
                },
              },
            ],
          });
          const writable = await handle.createWritable();
          await writable.write(blob);
          await writable.close();
          return;
        } catch (err: unknown) {
          if ((err as Error).name === 'AbortError') {
            return;
          }
          console.warn('File System Access API failed, falling back to download:', err);
        }
      }

      // Fallback: Traditional download
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = 'shipment_items_sample.xlsx';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      window.URL.revokeObjectURL(url);
    } catch (error) {
      console.error('Error exporting sample:', error);
      alert('Failed to export sample file');
    }
  }, []);

  // Handle import error close
  const handleImportErrorClose = useCallback(() => {
    setImportError({ show: false, notFoundSkus: [] });
  }, []);

  // Determine if supplier is valid based on selection mode
  const isSupplierValid = useMemo(() => {
    if (selectionMode === 'order') {
      // When order is selected, supplier is auto-set from order
      return !!selectedSupplier;
    }
    if (selectionMode === 'supplier') {
      if (supplierType === 'existing') {
        return !!selectedSupplier;
      } else {
        // One-time supplier needs at least a name
        return !!oneTimeSupplier.name.trim();
      }
    }
    return false;
  }, [selectionMode, supplierType, selectedSupplier, oneTimeSupplier.name]);

  // Handle save shipment
  const handleSave = useCallback(async () => {
    // Validation: Must have at least 1 item
    if (shipmentItems.length === 0) {
      setSaveResult({
        show: true,
        success: false,
        message: 'Please add at least one item to the shipment',
      });
      return;
    }

    // Validation: Must have either order or supplier selected
    if (!selectionMode) {
      setSaveResult({
        show: true,
        success: false,
        message: 'Please select an order or enter supplier information',
      });
      return;
    }

    if (selectionMode === 'supplier') {
      if (supplierType === 'existing' && !selectedSupplier) {
        setSaveResult({
          show: true,
          success: false,
          message: 'Please select a supplier',
        });
        return;
      }
      if (supplierType === 'onetime' && !oneTimeSupplier.name.trim()) {
        setSaveResult({
          show: true,
          success: false,
          message: 'Please enter supplier name',
        });
        return;
      }
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

      // Build items array for RPC: { sku, quantity_shipped, unit_cost }
      const items = shipmentItems.map((item) => ({
        sku: item.sku,
        quantity_shipped: item.quantity,
        unit_cost: item.unitPrice,
      }));

      // Build RPC parameters based on new inventory_create_shipment spec
      const rpcParams: Record<string, unknown> = {
        p_company_id: companyId,
        p_user_id: user.id,
        p_items: items,
        p_time: new Date().toISOString(), // User device local time
        p_timezone: userTimezone,
      };

      // Handle order linkage or supplier info
      if (selectionMode === 'order' && selectedOrder) {
        // Link to order - supplier info taken from order
        rpcParams.p_order_ids = [selectedOrder];
      } else if (selectionMode === 'supplier') {
        // No order linkage - provide supplier info
        if (supplierType === 'existing') {
          rpcParams.p_counterparty_id = selectedSupplier;
        } else {
          // One-time supplier info
          const supplierInfo: Record<string, string> = {};
          if (oneTimeSupplier.name.trim()) {
            supplierInfo.name = oneTimeSupplier.name.trim();
          }
          if (oneTimeSupplier.phone.trim()) {
            supplierInfo.phone = oneTimeSupplier.phone.trim();
          }
          if (oneTimeSupplier.email.trim()) {
            supplierInfo.email = oneTimeSupplier.email.trim();
          }
          if (oneTimeSupplier.address.trim()) {
            supplierInfo.address = oneTimeSupplier.address.trim();
          }
          rpcParams.p_supplier_info = supplierInfo;
        }
      }

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
  }, [selectionMode, shipmentItems, supplierType, selectedSupplier, selectedOrder, oneTimeSupplier, companyId, trackingNumber, note]);

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
  // Required: (Order OR Supplier selection) AND at least 1 item
  const isSaveDisabled = useMemo(() => {
    if (isSaving) return true;

    // Must have at least 1 item
    if (shipmentItems.length === 0) return true;

    // Must have either order selected OR supplier selected
    if (!selectionMode) return true;

    if (selectionMode === 'order') {
      return !selectedOrder;
    }

    if (selectionMode === 'supplier') {
      if (supplierType === 'existing') {
        return !selectedSupplier;
      }
      return !oneTimeSupplier.name.trim();
    }

    return true;
  }, [isSaving, selectionMode, shipmentItems.length, selectedOrder, selectedSupplier, supplierType, oneTimeSupplier.name]);

  return {
    // Currency
    currency,
    formatPrice,

    // Selection Mode
    selectionMode,

    // Suppliers (for filter in Order section)
    suppliers,
    suppliersLoading,
    supplierOptions,
    selectedSupplier,
    handleSupplierChange,

    // Supplier Section (for direct supplier selection)
    supplierType,
    handleSupplierTypeChange,
    handleSupplierSectionChange,
    handleClearSupplierSelection,
    oneTimeSupplier,
    handleOneTimeSupplierChange,

    // Orders
    orders: filteredOrders,
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
    handleCostChange,

    // Shipment details
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

    // Import/Export
    fileInputRef,
    isImporting,
    importError,
    handleImportClick,
    handleFileChange,
    handleExportSample,
    handleImportErrorClose,

    // Product Search
    searchInputRef,
    dropdownRef,
    searchQuery,
    setSearchQuery,
    searchResults,
    isSearching,
    showDropdown,
    setShowDropdown,
    handleAddProductFromSearch,

    // Item filter (for filtering added items)
    itemSearchQuery,
    setItemSearchQuery,
    filteredShipmentItems,
  };
};
