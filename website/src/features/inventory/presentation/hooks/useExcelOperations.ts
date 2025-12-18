/**
 * useExcelOperations Hook
 * Excel export/import operations for inventory
 *
 * Following ARCHITECTURE.md:
 * - Extract complex logic into hooks (≤ 30KB for TS files)
 * - Separate business logic from components
 */

import { useState, useRef, useCallback } from 'react';
import { excelExportManager } from '@/core/utils/excel-export-utils';
import { supabaseService } from '@/core/services/supabase_service';
import type { InventoryItem } from '../../domain/entities/InventoryItem';

interface ExcelOperationsProps {
  inventory: InventoryItem[];
  companyId: string;
  selectedStoreId: string | null;
  storeName: string;
  currencyCode: string;
  searchQuery: string;
  loadInventory: (companyId: string, storeId: string, searchQuery: string) => Promise<void>;
  getAllInventoryForExport: (companyId: string, storeId: string | null, searchQuery?: string) => Promise<InventoryItem[]>;
  importExcel: (
    companyId: string,
    storeId: string,
    userId: string,
    products: any[],
    defaultPrice?: boolean
  ) => Promise<{ success: boolean; summary?: any }>;
  showNotification: (variant: 'success' | 'error', message: string) => void;
  setCurrentPage: (page: number) => void;
}

// Selected price type for import
type PriceType = 'store' | 'default' | null;

export const useExcelOperations = ({
  inventory,
  companyId,
  selectedStoreId,
  storeName,
  currencyCode,
  searchQuery,
  loadInventory,
  getAllInventoryForExport,
  importExcel,
  showNotification,
  setCurrentPage,
}: ExcelOperationsProps) => {
  const [isExporting, setIsExporting] = useState(false);
  const [isImporting, setIsImporting] = useState(false);
  const [showPriceTypeModal, setShowPriceTypeModal] = useState(false);
  const [selectedPriceType, setSelectedPriceType] = useState<PriceType>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  /**
   * Handle export Excel
   * Fetches all products (without pagination) before exporting
   */
  const handleExportExcel = async () => {
    // Prevent multiple simultaneous exports
    if (isExporting) {
      return;
    }

    setIsExporting(true);

    try {
      // Fetch all inventory data for export (with current filters applied)
      const allProducts = await getAllInventoryForExport(
        companyId,
        selectedStoreId,
        searchQuery
      );

      // Export all inventory to Excel using the manager
      await excelExportManager.exportInventoryToExcel(
        allProducts,
        storeName,
        currencyCode
      );

      // Show success notification
      showNotification('success', `Successfully exported ${allProducts.length} products to Excel!`);
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
   * Handle import Excel - Process file with selected price type
   */
  const handleImportExcel = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];

    if (!file) {
      setSelectedPriceType(null);
      return;
    }

    // Reset file input
    event.target.value = '';

    // Check if price type was selected
    if (!selectedPriceType) {
      showNotification('error', 'Please select a price type first');
      return;
    }

    // Validate file type
    if (!file.name.endsWith('.xlsx') && !file.name.endsWith('.xls')) {
      showNotification('error', 'Please select a valid Excel file (.xlsx or .xls)');
      setSelectedPriceType(null);
      return;
    }

    const defaultPrice = selectedPriceType === 'default';

    // Reset price type after capturing it
    setSelectedPriceType(null);

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

      // Show loading overlay
      setIsImporting(true);

      // Initialize aggregated results
      let totalCreated = 0;
      let totalUpdated = 0;
      let totalSkipped = 0;
      let totalErrors = 0;
      const allErrors: any[] = [];

      // Process batches sequentially
      for (let i = 0; i < Math.ceil(totalProducts / BATCH_SIZE); i++) {
        const start = i * BATCH_SIZE;
        const end = Math.min(start + BATCH_SIZE, totalProducts);
        const batch = parsedProducts.slice(start, end);

        try {
          // Import current batch via RPC with price type
          const result = await importExcel(companyId, selectedStoreId!, user.id, batch, defaultPrice);

          if (result.success && result.summary) {
            // Aggregate results
            totalCreated += result.summary.created || 0;
            totalUpdated += result.summary.updated || 0;
            totalSkipped += result.summary.skipped || 0;
            totalErrors += result.summary.errors || 0;

            // Collect errors for debugging
            if (result.errors && result.errors.length > 0) {
              allErrors.push(...result.errors);
            }
          } else {
            totalErrors += batch.length;
          }
        } catch (batchError) {
          totalErrors += batch.length;
          console.error('📥 [Import Excel] Batch error:', batchError);
        }
      }

      // Debug log - only for import results
      console.log('📥 [Import Excel] Results:', {
        totalProducts,
        created: totalCreated,
        updated: totalUpdated,
        skipped: totalSkipped,
        errors: totalErrors,
        errorDetails: allErrors,
        parsedData: parsedProducts.slice(0, 3), // First 3 products for debugging
      });

      // Show aggregated results
      const total = totalCreated + totalUpdated + totalSkipped + totalErrors;
      let message = `Import completed: ${total} products processed.\n`;
      message += `✅ Created: ${totalCreated}, Updated: ${totalUpdated}, Skipped: ${totalSkipped}`;

      if (totalErrors > 0) {
        message += `, ❌ Errors: ${totalErrors}`;
      }

      showNotification('success', message);

      // Reset to page 1 and refresh inventory after all batches complete
      setCurrentPage(1);
      await loadInventory(companyId, selectedStoreId!, '');
    } catch (error) {
      console.error('📥 [Import Excel] ERROR:', error);
      showNotification('error', 'Failed to import Excel file. Please check the file format and try again.');
    } finally {
      setIsImporting(false);
    }
  };

  /**
   * Handle store price selection - opens file picker
   */
  const handleStorePrice = useCallback(() => {
    setSelectedPriceType('store');
    setShowPriceTypeModal(false);
    // Trigger file picker after state update
    setTimeout(() => {
      fileInputRef.current?.click();
    }, 100);
  }, []);

  /**
   * Handle default price selection - opens file picker
   */
  const handleDefaultPrice = useCallback(() => {
    setSelectedPriceType('default');
    setShowPriceTypeModal(false);
    // Trigger file picker after state update
    setTimeout(() => {
      fileInputRef.current?.click();
    }, 100);
  }, []);

  /**
   * Close price type modal without importing
   */
  const closePriceTypeModal = useCallback(() => {
    setShowPriceTypeModal(false);
    setSelectedPriceType(null);
  }, []);

  /**
   * Show price type modal when Import Excel button is clicked
   */
  const handleImportClick = () => {
    setShowPriceTypeModal(true);
  };

  return {
    isExporting,
    isImporting,
    fileInputRef,
    handleExportExcel,
    handleImportExcel,
    handleImportClick,
    // Price type modal
    showPriceTypeModal,
    handleStorePrice,
    handleDefaultPrice,
    closePriceTypeModal,
  };
};
