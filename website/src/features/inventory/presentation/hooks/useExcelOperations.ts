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
    console.log('📥 [Import Excel] handleImportExcel triggered');
    const file = event.target.files?.[0];

    if (!file) {
      console.log('📥 [Import Excel] No file selected');
      // Reset price type if no file selected
      setSelectedPriceType(null);
      return;
    }

    console.log('📥 [Import Excel] File selected:', file.name);
    console.log('📥 [Import Excel] selectedPriceType:', selectedPriceType);

    // Reset file input
    event.target.value = '';

    // Check if price type was selected
    if (!selectedPriceType) {
      console.log('📥 [Import Excel] ERROR: No price type selected');
      showNotification('error', 'Please select a price type first');
      return;
    }

    // Validate file type
    if (!file.name.endsWith('.xlsx') && !file.name.endsWith('.xls')) {
      console.log('📥 [Import Excel] ERROR: Invalid file type');
      showNotification('error', 'Please select a valid Excel file (.xlsx or .xls)');
      setSelectedPriceType(null);
      return;
    }

    const defaultPrice = selectedPriceType === 'default';
    console.log('📥 [Import Excel] defaultPrice (true=default, false=store):', defaultPrice);

    // Reset price type after capturing it
    setSelectedPriceType(null);

    try {
      // Parse Excel file first (before showing loading overlay)
      console.log('📥 [Import Excel] Parsing Excel file...');
      const parsedProducts = await excelExportManager.parseInventoryExcel(file);
      console.log('📥 [Import Excel] Parsed products count:', parsedProducts?.length);
      console.log('📥 [Import Excel] First parsed product:', parsedProducts?.[0]);

      if (!parsedProducts || parsedProducts.length === 0) {
        console.log('📥 [Import Excel] ERROR: No valid products found');
        showNotification('error', 'No valid products found in the Excel file');
        return;
      }

      // Get user ID from Supabase Auth
      console.log('📥 [Import Excel] Getting user from Supabase Auth...');
      const { data: { user }, error: authError } = await supabaseService.auth.getUser();
      if (authError || !user) {
        console.log('📥 [Import Excel] ERROR: Auth error:', authError);
        showNotification('error', 'Failed to get user information. Please log in again.');
        return;
      }
      console.log('📥 [Import Excel] User ID:', user.id);

      // ============================================
      // BATCH PROCESSING - 200 rows per batch
      // ============================================
      const BATCH_SIZE = 200;
      const totalProducts = parsedProducts.length;

      console.log('📥 [Import Excel] Starting batch processing...');
      console.log('📥 [Import Excel] companyId:', companyId);
      console.log('📥 [Import Excel] selectedStoreId:', selectedStoreId);
      console.log('📥 [Import Excel] totalProducts:', totalProducts);

      // Show loading overlay
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

        console.log(`📥 [Import Excel] Processing batch ${i + 1}/${Math.ceil(totalProducts / BATCH_SIZE)}, rows ${start + 1}-${end}`);

        try {
          // Import current batch via RPC with price type
          console.log('📥 [Import Excel] Calling importExcel RPC with params:', {
            companyId,
            storeId: selectedStoreId,
            userId: user.id,
            batchLength: batch.length,
            defaultPrice,
          });
          const result = await importExcel(companyId, selectedStoreId!, user.id, batch, defaultPrice);
          console.log('📥 [Import Excel] RPC result:', result);

          if (result.success && result.summary) {
            // Aggregate results
            totalCreated += result.summary.created || 0;
            totalUpdated += result.summary.updated || 0;
            totalSkipped += result.summary.skipped || 0;
            totalErrors += result.summary.errors || 0;
            console.log('📥 [Import Excel] Batch success:', result.summary);
          } else {
            totalErrors += batch.length;
            console.log('📥 [Import Excel] Batch failed (no success/summary):', result);
          }
        } catch (batchError) {
          totalErrors += batch.length;
          console.error('📥 [Import Excel] Batch error:', batchError);
        }
      }

      // Show aggregated results
      const total = totalCreated + totalUpdated + totalSkipped + totalErrors;
      let message = `Import completed: ${total} products processed.\n`;
      message += `✅ Created: ${totalCreated}, Updated: ${totalUpdated}, Skipped: ${totalSkipped}`;

      if (totalErrors > 0) {
        message += `, ❌ Errors: ${totalErrors}`;
      }

      console.log('📥 [Import Excel] Final results:', { totalCreated, totalUpdated, totalSkipped, totalErrors });
      showNotification('success', message);

      // Reset to page 1 and refresh inventory after all batches complete
      console.log('📥 [Import Excel] Refreshing inventory...');
      setCurrentPage(1);
      await loadInventory(companyId, selectedStoreId!, '');
      console.log('📥 [Import Excel] Import complete!');
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
