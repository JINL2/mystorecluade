/**
 * useExcelOperations Hook
 * Excel export/import operations for inventory
 *
 * Following ARCHITECTURE.md:
 * - Extract complex logic into hooks (≤ 30KB for TS files)
 * - Separate business logic from components
 */

import { useState, useRef } from 'react';
import { excelExportManager } from '@/core/utils/excel-export-utils';
import { supabaseService } from '@/core/services/supabase_service';
import type { InventoryItem } from '../../domain/entities/InventoryItem';

interface ExcelOperationsProps {
  inventory: InventoryItem[];
  companyId: string;
  selectedStoreId: string | null;
  storeName: string;
  currencyCode: string;
  loadInventory: (companyId: string, storeId: string, searchQuery: string) => Promise<void>;
  importExcel: (
    companyId: string,
    storeId: string,
    userId: string,
    products: any[]
  ) => Promise<{ success: boolean; summary?: any }>;
  showNotification: (variant: 'success' | 'error', message: string) => void;
}

export const useExcelOperations = ({
  inventory,
  companyId,
  selectedStoreId,
  storeName,
  currencyCode,
  loadInventory,
  importExcel,
  showNotification,
}: ExcelOperationsProps) => {
  const [isExporting, setIsExporting] = useState(false);
  const [isImporting, setIsImporting] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  /**
   * Handle export Excel
   */
  const handleExportExcel = async () => {
    // Prevent multiple simultaneous exports
    if (isExporting) {
      return;
    }

    setIsExporting(true);

    try {
      // Export inventory to Excel using the manager
      await excelExportManager.exportInventoryToExcel(
        inventory,
        storeName,
        currencyCode
      );

      // Show success notification
      showNotification('success', `Successfully exported ${inventory.length} products to Excel!`);
    } catch (error) {
      // Don't show error notification if user cancelled
      const errorMessage = error instanceof Error ? error.message : '';
      if (!errorMessage.includes('cancelled')) {
        showNotification('error', 'Failed to export inventory data. Please try again.');
      }
    } finally {
      setIsExporting(false);
    }
  };

  /**
   * Handle import Excel with Batch Processing
   */
  const handleImportExcel = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];

    if (!file) {
      return;
    }

    // Reset file input
    event.target.value = '';

    // Validate file type
    if (!file.name.endsWith('.xlsx') && !file.name.endsWith('.xls')) {
      showNotification('error', 'Please select a valid Excel file (.xlsx or .xls)');
      return;
    }

    try {
      // Parse Excel file first (before showing loading overlay)
      const parsedProducts = await excelExportManager.parseInventoryExcel(file);

      if (!parsedProducts || parsedProducts.length === 0) {
        showNotification('error', 'No valid products found in the Excel file');
        return;
      }

      // Get user ID from Supabase Auth
      const { data: { user }, error: authError } = await supabaseService.auth.getUser();
      if (authError || !user) {
        showNotification('error', 'Failed to get user information. Please log in again.');
        return;
      }

      // ============================================
      // BATCH PROCESSING - 200 rows per batch
      // ============================================
      const BATCH_SIZE = 200;
      const totalProducts = parsedProducts.length;

      // Show loading overlay AFTER parsing and validation complete
      setIsImporting(true);

      // Initialize aggregated results
      let totalCreated = 0;
      let totalUpdated = 0;
      let totalSkipped = 0;
      let totalErrors = 0;

      // Process batches sequentially
      for (let i = 0; i < Math.ceil(totalProducts / BATCH_SIZE); i++) {
        const start = i * BATCH_SIZE;
        const end = Math.min(start + BATCH_SIZE, totalProducts);
        const batch = parsedProducts.slice(start, end);

        try {
          // Import current batch via RPC
          const result = await importExcel(companyId, selectedStoreId!, user.id, batch);

          if (result.success && result.summary) {
            // Aggregate results
            totalCreated += result.summary.created || 0;
            totalUpdated += result.summary.updated || 0;
            totalSkipped += result.summary.skipped || 0;
            totalErrors += result.summary.errors || 0;
          } else {
            totalErrors += batch.length;
          }
        } catch (batchError) {
          totalErrors += batch.length;
        }
      }

      // Show aggregated results
      const total = totalCreated + totalUpdated + totalSkipped + totalErrors;
      let message = `Import completed: ${total} products processed.\n`;
      message += `✅ Created: ${totalCreated}, Updated: ${totalUpdated}, Skipped: ${totalSkipped}`;

      if (totalErrors > 0) {
        message += `, ❌ Errors: ${totalErrors}`;
      }

      showNotification('success', message);

      // Refresh inventory after all batches complete (load ALL products)
      await loadInventory(companyId, selectedStoreId!, '');
    } catch (error) {
      showNotification('error', 'Failed to import Excel file. Please check the file format and try again.');
    } finally {
      setIsImporting(false);
    }
  };

  /**
   * Trigger file picker for import
   */
  const handleImportClick = () => {
    fileInputRef.current?.click();
  };

  return {
    isExporting,
    isImporting,
    fileInputRef,
    handleExportExcel,
    handleImportExcel,
    handleImportClick,
  };
};
