/**
 * useOrderExcel Hook
 * Handles Excel import/export functionality for order creation
 */

import { useState, useRef, useCallback } from 'react';
import ExcelJS from 'exceljs';
import { supabaseService } from '@/core/services/supabase_service';
import type {
  InventoryProduct,
  OrderItem,
  ImportError,
} from '../pages/OrderCreatePage/OrderCreatePage.types';

interface UseOrderExcelProps {
  companyId: string | undefined;
  storeId: string | undefined;
  orderItems: OrderItem[];
  setOrderItems: React.Dispatch<React.SetStateAction<OrderItem[]>>;
}

export const useOrderExcel = ({
  companyId,
  storeId,
  orderItems,
  setOrderItems,
}: UseOrderExcelProps) => {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [isImporting, setIsImporting] = useState(false);
  const [importError, setImportError] = useState<ImportError>({
    show: false,
    notFoundSkus: [],
  });

  // Search product by SKU and variant name (for import)
  // v2: Added variantName parameter for variant product matching
  // v3: Returns error reason for better error messages
  type SearchResult = {
    product: InventoryProduct | null;
    error?: 'not_found' | 'variant_required' | 'variant_not_found' | 'variant_not_applicable';
  };

  const searchProductBySku = useCallback(
    async (sku: string, variantName?: string): Promise<SearchResult> => {
      if (!companyId || !storeId || !sku.trim()) {
        return { product: null, error: 'not_found' };
      }

      try {
        const supabase = supabaseService.getClient();
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        const { data, error } = await supabase.rpc('get_inventory_page_v6', {
          p_company_id: companyId,
          p_store_id: storeId,
          p_page: 1,
          p_limit: 50, // Increased limit to find all variants
          p_search: sku.trim(),
          p_availability: null,
          p_brand_id: null,
          p_category_id: null,
          p_timezone: userTimezone,
        });

        if (error) {
          return { product: null, error: 'not_found' };
        }

        // v6 response structure: data.items instead of data.products
        const response = data as { success?: boolean; data?: { items?: InventoryProduct[] } };
        if (response?.success && response?.data?.items && response.data.items.length > 0) {
          const items = response.data.items;

          // Find exact SKU match (check display_sku, product_sku, and variant_sku)
          const skuMatches = items.filter(
            (p: InventoryProduct) =>
              p.display_sku?.toLowerCase() === sku.trim().toLowerCase() ||
              p.product_sku?.toLowerCase() === sku.trim().toLowerCase() ||
              p.variant_sku?.toLowerCase() === sku.trim().toLowerCase()
          );

          if (skuMatches.length === 0) {
            return { product: null, error: 'not_found' };
          }

          // Check if product has variants
          const hasVariants = skuMatches.some((p: InventoryProduct) => p.variant_id);
          const nonVariantMatch = skuMatches.find((p: InventoryProduct) => !p.variant_id);

          // v3: If variantName is provided
          if (variantName && variantName.trim()) {
            // Check if product has no variants (variant_not_applicable)
            if (!hasVariants) {
              // Product has no variants, but variant name was provided - that's OK, just ignore it
              return { product: nonVariantMatch || skuMatches[0] };
            }

            // Product has variants, find matching variant
            const variantMatch = skuMatches.find(
              (p: InventoryProduct) =>
                p.variant_name?.toLowerCase() === variantName.trim().toLowerCase()
            );

            if (variantMatch) {
              return { product: variantMatch };
            }

            // Variant name provided but not found
            return { product: null, error: 'variant_not_found' };
          }

          // v3: No variantName provided
          if (hasVariants && !nonVariantMatch) {
            // Product only has variants, variant name is required
            return { product: null, error: 'variant_required' };
          }

          // Return non-variant product or first match
          return { product: nonVariantMatch || skuMatches[0] };
        }

        return { product: null, error: 'not_found' };
      } catch {
        return { product: null, error: 'not_found' };
      }
    },
    [companyId, storeId]
  );

  // Handle import click
  const handleImportClick = useCallback(() => {
    fileInputRef.current?.click();
  }, []);

  // Handle file change (import Excel)
  const handleFileChange = useCallback(
    async (e: React.ChangeEvent<HTMLInputElement>) => {
      const file = e.target.files?.[0];
      if (!file) {
        return;
      }

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

      try {
        const workbook = new ExcelJS.Workbook();
        const arrayBuffer = await file.arrayBuffer();
        await workbook.xlsx.load(arrayBuffer);

        const worksheet = workbook.worksheets[0];
        if (!worksheet) {
          throw new Error('No worksheet found in the Excel file');
        }

        // Parse rows (skip header row 1)
        // v2: Added variant_name column (Column B)
        // v3: Added rowNumber for error tracking
        const rowsToProcess: { rowNumber: number; sku: string; variantName: string; cost: number; quantity: number }[] = [];

        worksheet.eachRow((row, rowNumber) => {
          if (rowNumber === 1) return; // Skip header

          const skuCell = row.getCell(1); // Column A = SKU
          const variantNameCell = row.getCell(2); // Column B = Variant Name (v2)
          const costCell = row.getCell(3); // Column C = Cost
          const quantityCell = row.getCell(4); // Column D = Quantity

          const sku = skuCell.value?.toString().trim();
          const variantName = variantNameCell.value?.toString().trim() || '';
          const cost = parseFloat(costCell.value?.toString() || '0') || 0;
          const quantity = parseInt(quantityCell.value?.toString() || '1') || 1;

          if (sku) {
            rowsToProcess.push({ rowNumber, sku, variantName, cost, quantity });
          }
        });

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

        // Search products and add to order items
        // v3: Enhanced error messages with row number and specific error reasons
        const notFoundSkus: string[] = [];
        const newOrderItems: OrderItem[] = [...orderItems];

        for (const row of rowsToProcess) {
          const result = await searchProductBySku(row.sku, row.variantName);

          if (result.product) {
            // Check if product already exists in order items
            // v6: unique key is product_id + variant_id
            const existingIndex = newOrderItems.findIndex(
              (item) =>
                item.productId === result.product!.product_id &&
                item.variantId === (result.product!.variant_id || undefined)
            );

            if (existingIndex >= 0) {
              // Update quantity and cost if already exists
              newOrderItems[existingIndex].quantity += row.quantity;
              newOrderItems[existingIndex].cost = row.cost;
            } else {
              // Add new item with cost and quantity from Excel
              // v6: use display_name/display_sku for display, store variant_sku/product_sku for RPC
              newOrderItems.push({
                productId: result.product.product_id,
                variantId: result.product.variant_id || undefined,
                productName: result.product.display_name || result.product.product_name,
                sku: result.product.display_sku || result.product.product_sku,
                variantSku: result.product.variant_sku || undefined, // v6: for RPC call
                productSku: result.product.product_sku, // v6: for RPC call fallback
                quantity: row.quantity,
                cost: row.cost,
              });
            }
          } else {
            // v3: More descriptive error message with row number and specific error reason
            let errorMsg = `Row ${row.rowNumber}: ${row.sku}`;

            switch (result.error) {
              case 'variant_required':
                errorMsg += ' - Variant Name is required for this product';
                break;
              case 'variant_not_found':
                errorMsg += ` - Variant "${row.variantName}" not found`;
                break;
              case 'not_found':
              default:
                errorMsg += ' - SKU not found';
                break;
            }

            notFoundSkus.push(errorMsg);
          }
        }

        // Update order items
        setOrderItems(newOrderItems);

        // Show error message if some SKUs were not found
        if (notFoundSkus.length > 0) {
          setImportError({
            show: true,
            notFoundSkus,
          });
        }
      } catch (error) {
        setImportError({
          show: true,
          notFoundSkus: [
            `Failed to read Excel file: ${error instanceof Error ? error.message : 'Unknown error'}`,
          ],
        });
      } finally {
        setIsImporting(false);
        // Reset file input
        if (fileInputRef.current) {
          fileInputRef.current.value = '';
        }
      }
    },
    [companyId, storeId, orderItems, searchProductBySku, setOrderItems]
  );

  // Handle export sample
  const handleExportSample = useCallback(async () => {
    try {
      const workbook = new ExcelJS.Workbook();
      workbook.creator = 'Store Base';
      workbook.created = new Date();

      const worksheet = workbook.addWorksheet('Order Items');

      // Define columns (v2: added Variant Name for variant products)
      worksheet.columns = [
        { header: 'SKU', key: 'sku', width: 20 },
        { header: 'Variant Name', key: 'variant_name', width: 20 },
        { header: 'Cost', key: 'cost', width: 15 },
        { header: 'Quantity', key: 'quantity', width: 12 },
      ];

      // Style header row (matching Inventory export style)
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

      // Add sample data rows (with variant_name examples)
      worksheet.addRow({ sku: 'SAMPLE-SKU-001', variant_name: '', cost: 10000, quantity: 5 });
      worksheet.addRow({ sku: 'SAMPLE-SKU-002', variant_name: 'Red / Large', cost: 25000, quantity: 10 });

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
            suggestedName: 'order_items_sample.xlsx',
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
          // Fallback to traditional download if File System Access API fails
        }
      }

      // Fallback: Traditional download
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = 'order_items_sample.xlsx';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      window.URL.revokeObjectURL(url);
    } catch {
      alert('Failed to export sample file');
    }
  }, []);

  // Handle import error close
  const handleImportErrorClose = useCallback(() => {
    setImportError({ show: false, notFoundSkus: [] });
  }, []);

  return {
    fileInputRef,
    isImporting,
    importError,
    handleImportClick,
    handleFileChange,
    handleExportSample,
    handleImportErrorClose,
  };
};
