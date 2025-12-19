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

  // Search product by SKU (for import)
  const searchProductBySku = useCallback(
    async (sku: string): Promise<InventoryProduct | null> => {
      if (!companyId || !storeId || !sku.trim()) {
        return null;
      }

      try {
        const supabase = supabaseService.getClient();
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        const { data, error } = await supabase.rpc('get_inventory_page_v4', {
          p_company_id: companyId,
          p_store_id: storeId,
          p_page: 1,
          p_limit: 1,
          p_search: sku.trim(),
          p_availability: null,
          p_brand_id: null,
          p_category_id: null,
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
      console.log('📦 Import file:', file.name);

      try {
        const workbook = new ExcelJS.Workbook();
        const arrayBuffer = await file.arrayBuffer();
        await workbook.xlsx.load(arrayBuffer);

        const worksheet = workbook.worksheets[0];
        if (!worksheet) {
          throw new Error('No worksheet found in the Excel file');
        }

        // Parse rows (skip header row 1)
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

        // Search products and add to order items
        const notFoundSkus: string[] = [];
        const newOrderItems: OrderItem[] = [...orderItems];

        for (const row of rowsToProcess) {
          const product = await searchProductBySku(row.sku);

          if (product) {
            // Check if product already exists in order items
            const existingIndex = newOrderItems.findIndex(
              (item) => item.productId === product.product_id
            );

            if (existingIndex >= 0) {
              // Update quantity and cost if already exists
              newOrderItems[existingIndex].quantity += row.quantity;
              newOrderItems[existingIndex].cost = row.cost;
            } else {
              // Add new item with cost and quantity from Excel
              newOrderItems.push({
                productId: product.product_id,
                productName: product.product_name,
                sku: product.sku,
                quantity: row.quantity,
                cost: row.cost,
              });
            }
          } else {
            notFoundSkus.push(row.sku);
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

      // Define columns
      worksheet.columns = [
        { header: 'SKU', key: 'sku', width: 20 },
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
          console.warn('File System Access API failed, falling back to download:', err);
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
    } catch (error) {
      console.error('Error exporting sample:', error);
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
