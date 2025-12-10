/**
 * useShipmentCreateImport Hook
 * Handles Excel import/export functionality for shipment creation
 */

import { useState, useCallback, useRef, useMemo } from 'react';
import ExcelJS from 'exceljs';
import { getShipmentRepository } from '../../data/repositories/ShipmentRepositoryImpl';
import type {
  ShipmentItem,
  ImportError,
  InventoryProduct,
} from '../pages/ShipmentCreatePage/ShipmentCreatePage.types';

interface UseShipmentCreateImportProps {
  companyId: string | undefined;
  storeId: string | undefined;
  shipmentItems: ShipmentItem[];
  setShipmentItems: React.Dispatch<React.SetStateAction<ShipmentItem[]>>;
}

export const useShipmentCreateImport = ({
  companyId,
  storeId,
  shipmentItems,
  setShipmentItems,
}: UseShipmentCreateImportProps) => {
  const repository = useMemo(() => getShipmentRepository(), []);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [isImporting, setIsImporting] = useState(false);
  const [importError, setImportError] = useState<ImportError>({
    show: false,
    notFoundSkus: [],
  });

  // Search product by SKU using Repository
  const searchProductBySku = useCallback(
    async (sku: string): Promise<InventoryProduct | null> => {
      if (!companyId || !storeId || !sku.trim()) {
        return null;
      }

      try {
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        const result = await repository.searchProductBySku(
          companyId,
          storeId,
          sku.trim(),
          userTimezone
        );

        if (!result.success) {
          console.error('📦 Search by SKU error:', result.error);
          return null;
        }

        return result.data || null;
      } catch (err) {
        console.error('📦 Search by SKU exception:', err);
        return null;
      }
    },
    [companyId, storeId, repository]
  );

  // Handle import click
  const handleImportClick = useCallback(() => {
    fileInputRef.current?.click();
  }, []);

  // Handle file change (import Excel)
  const handleFileChange = useCallback(
    async (e: React.ChangeEvent<HTMLInputElement>) => {
      const file = e.target.files?.[0];
      if (!file) return;

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

        const rowsToProcess: { sku: string; cost: number; quantity: number }[] = [];

        worksheet.eachRow((row, rowNumber) => {
          if (rowNumber === 1) return;

          const skuCell = row.getCell(1);
          const costCell = row.getCell(2);
          const quantityCell = row.getCell(3);

          const sku = skuCell.value?.toString().trim();
          const cost = parseFloat(costCell.value?.toString() || '0') || 0;
          const quantity = parseInt(quantityCell.value?.toString() || '1') || 1;

          if (sku) {
            rowsToProcess.push({ sku, cost, quantity });
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

        const notFoundSkus: string[] = [];
        const newShipmentItems: ShipmentItem[] = [...shipmentItems];

        for (const row of rowsToProcess) {
          const product = await searchProductBySku(row.sku);

          if (product) {
            const existingIndex = newShipmentItems.findIndex(
              (item) => item.productId === product.product_id
            );

            if (existingIndex >= 0) {
              newShipmentItems[existingIndex].quantity += row.quantity;
              newShipmentItems[existingIndex].unitPrice = row.cost;
            } else {
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

        setShipmentItems(newShipmentItems);

        if (notFoundSkus.length > 0) {
          setImportError({
            show: true,
            notFoundSkus,
          });
        }
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
    [companyId, storeId, shipmentItems, setShipmentItems, searchProductBySku]
  );

  // Handle export sample
  const handleExportSample = useCallback(async () => {
    try {
      const workbook = new ExcelJS.Workbook();
      workbook.creator = 'Store Base';
      workbook.created = new Date();

      const worksheet = workbook.addWorksheet('Shipment Items');

      worksheet.columns = [
        { header: 'SKU', key: 'sku', width: 20 },
        { header: 'Cost', key: 'cost', width: 15 },
        { header: 'Quantity', key: 'quantity', width: 12 },
      ];

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

      headerRow.eachCell((cell) => {
        cell.border = {
          top: { style: 'thin', color: { argb: 'FF000000' } },
          left: { style: 'thin', color: { argb: 'FF000000' } },
          bottom: { style: 'thin', color: { argb: 'FF000000' } },
          right: { style: 'thin', color: { argb: 'FF000000' } },
        };
      });

      worksheet.addRow({ sku: 'SAMPLE-SKU-001', cost: 10000, quantity: 5 });
      worksheet.addRow({ sku: 'SAMPLE-SKU-002', cost: 25000, quantity: 10 });

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

      const buffer = await workbook.xlsx.writeBuffer();

      const blob = new Blob([buffer], {
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      });

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
        }
      }

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
