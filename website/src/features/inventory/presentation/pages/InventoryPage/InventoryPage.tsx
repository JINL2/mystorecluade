/**
 * InventoryPage Component
 * Inventory management with stock levels and product information
 *
 * Following 2025 Best Practice:
 * - Clean component focusing on UI only
 * - All state managed by Zustand provider
 * - Optimized re-renders with selective subscriptions
 */

import React, { useEffect, useState } from 'react';
import { useInventory } from '../../hooks/useInventory';
import { useInventoryMetadata } from '../../hooks/useInventoryMetadata';
import { Navbar } from '@/shared/components/common/Navbar';
import { TossButton } from '@/shared/components/toss/TossButton';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { ProductDetailsModal } from '../../components/ProductDetailsModal';
import { AddProductModal } from '@/shared/components/modals/AddProductModal';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { FilterDropdown } from '../../components/FilterDropdown/FilterDropdown';
import { useAppState } from '@/app/providers/app_state_provider';
import { excelExportManager } from '@/core/utils/excel-export-utils';
import { supabaseService } from '@/core/services/supabase_service';
import type { InventoryPageProps } from './InventoryPage.types';
import styles from './InventoryPage.module.css';

export const InventoryPage: React.FC<InventoryPageProps> = () => {
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id || '';

  // Get all state and actions from inventory provider
  const {
    inventory,
    currencySymbol,
    currencyCode,
    currentPage,
    itemsPerPage,
    selectedStoreId,
    selectedProducts,
    filterType,
    selectedBrandFilter,
    isModalOpen,
    selectedProductData,
    isAddProductModalOpen,
    loading,
    error,
    notification,

    setSelectedStoreId,
    setCurrentPage,
    toggleProductSelection,
    clearSelection,
    setFilterType,
    setSelectedBrandFilter,
    openModal,
    closeModal,
    openAddProductModal,
    closeAddProductModal,
    showNotification,
    hideNotification,
    loadInventory,
    updateProduct,
    importExcel,
    refresh,
  } = useInventory();

  // Fetch inventory metadata (categories, brands, product types, units)
  const { metadata, loading: metadataLoading, error: metadataError, refresh: refreshMetadata } = useInventoryMetadata(companyId, selectedStoreId || undefined);

  // Local UI state for export/import loading and client-side filtering
  const [isExporting, setIsExporting] = useState(false);
  const [isImporting, setIsImporting] = useState(false);
  const [importProgress, setImportProgress] = useState({ current: 0, total: 0 });
  const [localSearchQuery, setLocalSearchQuery] = useState('');
  const fileInputRef = React.useRef<HTMLInputElement>(null);

  // Reset to page 1 when search query changes
  useEffect(() => {
    setCurrentPage(1);
  }, [localSearchQuery, setCurrentPage]);

  // Initialize with first store when company loads
  useEffect(() => {
    if (currentCompany?.stores && currentCompany.stores.length > 0 && !selectedStoreId) {
      setSelectedStoreId(currentCompany.stores[0].store_id);
    }
  }, [currentCompany, selectedStoreId, setSelectedStoreId]);

  // Load inventory when store changes (NO page or search dependency - load ALL)
  useEffect(() => {
    if (companyId && selectedStoreId) {
      loadInventory(companyId, selectedStoreId, ''); // Always load ALL products
    }
  }, [companyId, selectedStoreId, loadInventory]);

  // Get unique brands from inventory for filter dropdown
  const uniqueBrands = React.useMemo(() => {
    const brands = Array.from(new Set(inventory.map((item) => item.brandName).filter(Boolean)));
    return brands.sort();
  }, [inventory]);

  // Client-side filtering and sorting: filter inventory based on local search query and filter/sort
  const filteredAndSortedInventory = React.useMemo(() => {
    let result = [...inventory];

    // 1. Apply search filter
    if (localSearchQuery.trim()) {
      const query = localSearchQuery.toLowerCase().trim();
      result = result.filter((item) => {
        return (
          item.productName.toLowerCase().includes(query) ||
          item.sku.toLowerCase().includes(query)
        );
      });
    }

    // 2. Apply brand filter
    if (filterType === 'brand' && selectedBrandFilter) {
      result = result.filter((item) => item.brandName === selectedBrandFilter);
    }

    // 3. Apply sorting
    switch (filterType) {
      case 'newest':
        // Already sorted by created_at DESC in provider (newest first)
        break;

      case 'oldest':
        // Reverse order - oldest first
        result = result.reverse();
        break;

      case 'price_high':
        // Sort by selling price (unitPrice) - highest first
        result = result.sort((a, b) => b.unitPrice - a.unitPrice);
        break;

      case 'price_low':
        // Sort by selling price (unitPrice) - lowest first
        result = result.sort((a, b) => a.unitPrice - b.unitPrice);
        break;

      case 'cost_high':
        // Sort by cost price - highest first
        result = result.sort((a, b) => b.costPrice - a.costPrice);
        break;

      case 'cost_low':
        // Sort by cost price - lowest first
        result = result.sort((a, b) => a.costPrice - b.costPrice);
        break;

      case 'brand':
        // When brand filter is active, keep existing order (newest first)
        break;
    }

    return result;
  }, [inventory, localSearchQuery, filterType, selectedBrandFilter]);

  // Client-side pagination: slice filtered results for current page
  const paginatedInventory = React.useMemo(() => {
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    return filteredAndSortedInventory.slice(startIndex, endIndex);
  }, [filteredAndSortedInventory, currentPage, itemsPerPage]);

  // Calculate total items and pages based on filtered results
  const totalFilteredItems = filteredAndSortedInventory.length;
  const totalPages = Math.ceil(totalFilteredItems / itemsPerPage);

  // Helper function to format currency with strikethrough symbol
  const formatCurrency = (amount: number): string => {
    const formatted = amount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    });
    return `${currencySymbol}${formatted}`;
  };

  // Handle select all checkbox (only visible filtered products)
  const handleSelectAll = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.checked) {
      // Select only filtered products, not all products
      clearSelection();
      filteredAndSortedInventory.forEach((item) => {
        toggleProductSelection(item.productId);
      });
    } else {
      clearSelection();
    }
  };

  // Handle individual checkbox
  const handleCheckboxChange = (productId: string) => {
    toggleProductSelection(productId);
  };

  // Handle edit product
  const handleEditProduct = (productId: string) => {
    const product = inventory.find((item) => item.productId === productId);
    if (product) {
      openModal(product);
    }
  };

  // Handle delete products
  const handleDeleteProducts = () => {
    // TODO: Show delete confirmation modal
    console.log('Delete products:', Array.from(selectedProducts));
  };

  // Handle export Excel
  const handleExportExcel = async () => {
    // Prevent multiple simultaneous exports
    if (isExporting) {
      return;
    }

    try {
      setIsExporting(true);

      // Get current store name for filename
      const currentStore = currentCompany?.stores?.find(
        (store) => store.store_id === selectedStoreId
      );
      const storeName = currentStore?.store_name || 'AllStores';

      // Export inventory data to Excel
      await excelExportManager.exportInventoryToExcel(
        inventory,
        storeName,
        currencyCode
      );

      // Show success notification
      showNotification('success', `Successfully exported ${inventory.length} products to Excel!`);
    } catch (error) {
      console.error('Export Excel error:', error);

      // Don't show error notification if user cancelled
      const errorMessage = error instanceof Error ? error.message : '';
      if (!errorMessage.includes('cancelled')) {
        showNotification('error', 'Failed to export inventory data. Please try again.');
      }
    } finally {
      setIsExporting(false);
    }
  };

  // Handle import Excel with Batch Processing
  const handleImportExcel = async (event: React.ChangeEvent<HTMLInputElement>) => {
    console.log('📥 Import Excel handler called');
    const file = event.target.files?.[0];
    console.log('📄 Selected file:', file);

    if (!file) {
      console.log('❌ No file selected');
      return;
    }

    // Reset file input
    event.target.value = '';

    // Validate file type
    if (!file.name.endsWith('.xlsx') && !file.name.endsWith('.xls')) {
      console.log('❌ Invalid file type:', file.name);
      showNotification('error', 'Please select a valid Excel file (.xlsx or .xls)');
      return;
    }

    try {
      console.log('✅ File validation passed, starting import...');

      // Parse Excel file first (before showing loading overlay)
      console.log('📊 Parsing Excel file...');
      const parsedProducts = await excelExportManager.parseInventoryExcel(file);
      console.log('✅ Parsed products:', parsedProducts.length);

      if (!parsedProducts || parsedProducts.length === 0) {
        console.log('❌ No valid products found');
        showNotification('error', 'No valid products found in the Excel file');
        return;
      }

      // Get user ID from Supabase Auth
      console.log('🔐 Getting user from Supabase Auth...');
      const { data: { user }, error: authError } = await supabaseService.auth.getUser();
      console.log('👤 User:', user);
      if (authError || !user) {
        console.log('❌ Auth error:', authError);
        showNotification('error', 'Failed to get user information. Please log in again.');
        return;
      }

      // ============================================
      // BATCH PROCESSING - 200 rows per batch
      // ============================================
      const BATCH_SIZE = 200;
      const totalProducts = parsedProducts.length;
      const totalBatches = Math.ceil(totalProducts / BATCH_SIZE);

      console.log(`📦 Starting batch processing: ${totalProducts} products in ${totalBatches} batches`);

      // Show loading overlay AFTER parsing and validation complete
      setIsImporting(true);
      setImportProgress({ current: 0, total: totalBatches });

      // Initialize aggregated results
      let totalCreated = 0;
      let totalUpdated = 0;
      let totalSkipped = 0;
      let totalErrors = 0;
      const allErrors: Array<{ row: number; error: string; data?: any }> = [];

      // Process batches sequentially
      for (let i = 0; i < totalBatches; i++) {
        const batchNumber = i + 1;
        const start = i * BATCH_SIZE;
        const end = Math.min(start + BATCH_SIZE, totalProducts);
        const batch = parsedProducts.slice(start, end);

        console.log(`📦 Processing batch ${batchNumber}/${totalBatches} (${batch.length} products)`);

        try {
          // Update progress BEFORE processing (smoother UI)
          setImportProgress({ current: batchNumber, total: totalBatches });

          // Import current batch via RPC
          const result = await importExcel(companyId, selectedStoreId!, user.id, batch);

          if (result.success && result.summary) {
            // Aggregate results
            totalCreated += result.summary.created || 0;
            totalUpdated += result.summary.updated || 0;
            totalSkipped += result.summary.skipped || 0;
            totalErrors += result.summary.errors || 0;

            // Collect errors with adjusted row numbers
            if (result.errors && result.errors.length > 0) {
              const adjustedErrors = result.errors.map((err) => ({
                ...err,
                row: err.row + start, // Adjust row number to original position
              }));
              allErrors.push(...adjustedErrors);
            }

            console.log(`✅ Batch ${batchNumber}/${totalBatches} completed:`, result.summary);
          } else {
            console.error(`❌ Batch ${batchNumber}/${totalBatches} failed:`, result.error);
            totalErrors += batch.length;
          }
        } catch (batchError) {
          console.error(`❌ Batch ${batchNumber}/${totalBatches} error:`, batchError);
          totalErrors += batch.length;
        }
      }

      console.log('✅ All batches processed');
      console.log(`📊 Final results: Created=${totalCreated}, Updated=${totalUpdated}, Skipped=${totalSkipped}, Errors=${totalErrors}`);

      // Show aggregated results
      const total = totalCreated + totalUpdated + totalSkipped + totalErrors;
      let message = `Import completed: ${total} products processed.\n`;
      message += `✅ Created: ${totalCreated}, Updated: ${totalUpdated}, Skipped: ${totalSkipped}`;

      if (totalErrors > 0) {
        message += `, ❌ Errors: ${totalErrors}`;
      }

      showNotification('success', message);

      // Refresh inventory after all batches complete (load ALL products)
      console.log('🔄 Refreshing inventory...');
      await loadInventory(companyId, selectedStoreId!, '');
      console.log('✅ Import completed and inventory refreshed');
    } catch (error) {
      console.error('Import Excel error:', error);
      showNotification('error', 'Failed to import Excel file. Please check the file format and try again.');
    } finally {
      setIsImporting(false);
      setImportProgress({ current: 0, total: 0 });
    }
  };

  // Trigger file picker for import
  const handleImportClick = () => {
    console.log('🖱️ Import button clicked');
    console.log('📂 File input ref:', fileInputRef.current);
    fileInputRef.current?.click();
  };

  // Handle add product
  const handleAddProduct = () => {
    openAddProductModal();
  };

  // Clear search (use local state for client-side filtering)
  const handleClearSearch = () => {
    setLocalSearchQuery('');
  };

  // Get status info
  const getStatusInfo = (item: any) => {
    const quantity = item.currentStock;

    if (quantity === 0) {
      return { class: styles.statusOutOfStock, text: 'OUT OF STOCK' };
    } else if (quantity <= 5) {
      return { class: styles.statusLowStock, text: 'LOW STOCK' };
    } else {
      return { class: styles.statusInStock, text: 'IN STOCK' };
    }
  };

  // Get quantity class
  const getQuantityClass = (quantity: number) => {
    if (quantity === 0) {
      return styles.quantityOut;
    } else if (quantity <= 5) {
      return styles.quantityLow;
    }
    return '';
  };

  // Show loading if no company selected yet
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Inventory</h1>
          </div>
          <LoadingAnimation fullscreen={true} size="large" />
        </div>
      </>
    );
  }

  if (loading) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Inventory</h1>
            <p className={styles.subtitle}>Manage product inventory across stores</p>
          </div>

          {/* Store Filter */}
          <div className={styles.controlsCard}>
            <div className={styles.controlSection}>
              <svg className={styles.controlIcon} fill="currentColor" viewBox="0 0 24 24">
                <path d="M19,2H5A3,3 0 0,0 2,5V19A3,3 0 0,0 5,22H19A3,3 0 0,0 22,19V5A3,3 0 0,0 19,2M19,19H5V5H19V19Z"/>
              </svg>
              <span className={styles.controlLabel}>All Stores</span>
            </div>
          </div>

          <div className={styles.contentCard}>
            <LoadingAnimation fullscreen={true} size="large" />
          </div>
        </div>
      </>
    );
  }

  // Show error modal if inventory loading fails
  if (error) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Inventory</h1>
            <p className={styles.subtitle}>Manage product inventory across stores</p>
          </div>

          {/* Store Filter */}
          <div className={styles.controlsCard}>
            <div className={styles.controlSection}>
              <svg className={styles.controlIcon} fill="currentColor" viewBox="0 0 24 24">
                <path d="M19,2H5A3,3 0 0,0 2,5V19A3,3 0 0,0 5,22H19A3,3 0 0,0 22,19V5A3,3 0 0,0 19,2M19,19H5V5H19V19Z"/>
              </svg>
              <span className={styles.controlLabel}>All Stores</span>
            </div>
          </div>

          <div className={styles.contentCard}>
            <LoadingAnimation fullscreen={true} size="large" />
          </div>
        </div>

        {/* Error Message Modal */}
        <ErrorMessage
          isOpen={true}
          variant="error"
          title="Failed to Load Inventory"
          message={error}
          onClose={() => {}}
          confirmText="Try Again"
          onConfirm={() => loadInventory(companyId, selectedStoreId, '')}
          closeOnBackdropClick={false}
          closeOnEscape={false}
          zIndex={9999}
        />
      </>
    );
  }

  // Check if all FILTERED products are selected
  const isAllSelected = filteredAndSortedInventory.length > 0 &&
    filteredAndSortedInventory.every((item) => selectedProducts.has(item.productId));

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.container}>
        <div className={styles.header}>
          <h1 className={styles.title}>Inventory</h1>
          <p className={styles.subtitle}>Manage product inventory across stores</p>
        </div>

        {/* Store Filter Control */}
        <div className={styles.controlsCard}>
          <StoreSelector
            stores={currentCompany?.stores || []}
            selectedStoreId={selectedStoreId}
            onStoreSelect={setSelectedStoreId}
            companyId={currentCompany?.company_id}
            showAllStoresOption={false}
          />
        </div>

        {/* Inventory Content */}
        <div className={styles.contentCard}>
          {/* Inventory Header */}
          <div className={styles.inventoryHeader}>
            <div className={styles.inventoryTitleSection}>
              <h2 className={styles.inventoryTitle}>Products</h2>
              <div className={styles.inventorySearchWrapper}>
                <svg className={styles.searchIcon} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                </svg>
                <input
                  type="text"
                  className={styles.inventorySearch}
                  placeholder="Search products..."
                  value={localSearchQuery}
                  onChange={(e) => setLocalSearchQuery(e.target.value)}
                />
                {localSearchQuery && (
                  <button className={styles.searchClear} onClick={handleClearSearch}>
                    <svg fill="currentColor" viewBox="0 0 24 24" width="16" height="16">
                      <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
                    </svg>
                  </button>
                )}
              </div>
              <FilterDropdown
                filterType={filterType}
                selectedBrandFilter={selectedBrandFilter}
                brands={uniqueBrands}
                onFilterChange={setFilterType}
                onBrandFilterChange={setSelectedBrandFilter}
              />
            </div>
            <div className={styles.inventoryActions}>
              <div className={styles.actionButtons}>
                <TossButton
                  variant="error"
                  size="md"
                  onClick={handleDeleteProducts}
                  disabled={selectedProducts.size === 0}
                  icon={
                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M19,4H15.5L14.5,3H9.5L8.5,4H5V6H19M6,19A2,2 0 0,0 8,21H16A2,2 0 0,0 18,19V7H6V19Z"/>
                    </svg>
                  }
                  iconPosition="left"
                >
                  {selectedProducts.size > 0 ? `Delete ${selectedProducts.size} Product${selectedProducts.size > 1 ? 's' : ''}` : 'Delete Product'}
                </TossButton>
                <TossButton
                  variant="secondary"
                  size="md"
                  onClick={handleExportExcel}
                  disabled={isExporting || inventory.length === 0}
                  icon={
                    isExporting ? (
                      <LoadingAnimation size="small" />
                    ) : (
                      <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z"/>
                      </svg>
                    )
                  }
                  iconPosition="left"
                >
                  {isExporting ? 'Exporting...' : 'Export Excel'}
                </TossButton>
                <TossButton
                  variant="secondary"
                  size="md"
                  onClick={handleImportClick}
                  disabled={isImporting}
                  icon={
                    isImporting ? (
                      <LoadingAnimation size="small" />
                    ) : (
                      <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M13,13H11V16H9L12,19L15,16H13V13M13,9V3.5L18.5,9H13Z"/>
                      </svg>
                    )
                  }
                  iconPosition="left"
                >
                  {isImporting ? 'Importing...' : 'Import Excel'}
                </TossButton>
                {/* Hidden file input for import */}
                <input
                  ref={fileInputRef}
                  type="file"
                  accept=".xlsx,.xls"
                  onChange={handleImportExcel}
                  style={{ display: 'none' }}
                />
                <TossButton
                  variant="primary"
                  size="md"
                  onClick={handleAddProduct}
                  icon={
                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
                    </svg>
                  }
                  iconPosition="left"
                >
                  Add Product
                </TossButton>
              </div>
            </div>
          </div>

          {/* Inventory Table */}
          {inventory.length === 0 ? (
            <div className={styles.emptyState}>
              <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
                {/* Background Circle */}
                <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>
                {/* Box Icon */}
                <rect x="35" y="35" width="50" height="50" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>
                <rect x="40" y="40" width="40" height="40" rx="2" fill="#F0F6FF" stroke="#0064FF" strokeWidth="1.5"/>
                {/* Shelves */}
                <line x1="42" y1="50" x2="78" y2="50" stroke="#0064FF" strokeWidth="2" strokeLinecap="round"/>
                <line x1="42" y1="60" x2="78" y2="60" stroke="#0064FF" strokeWidth="2" strokeLinecap="round"/>
                <line x1="42" y1="70" x2="78" y2="70" stroke="#0064FF" strokeWidth="2" strokeLinecap="round"/>
                {/* Search Symbol */}
                <circle cx="70" cy="80" r="12" fill="#0064FF"/>
                <circle cx="70" cy="80" r="5" stroke="white" strokeWidth="2" fill="none"/>
                <line x1="74" y1="84" x2="78" y2="88" stroke="white" strokeWidth="2" strokeLinecap="round"/>
              </svg>
              <h3 className={styles.emptyTitle}>No products found</h3>
              <p className={styles.emptyText}>
                {localSearchQuery
                  ? 'No items match your search criteria'
                  : 'Add products to start managing inventory'}
              </p>
            </div>
          ) : (
            <div className={styles.inventoryTableWrapper}>
              <table className={styles.inventoryTable}>
                <thead>
                  <tr>
                    <th className={styles.checkboxCell}>
                      <input
                        type="checkbox"
                        className={styles.checkbox}
                        checked={isAllSelected}
                        onChange={handleSelectAll}
                      />
                    </th>
                    <th>Product Name</th>
                    <th>Product Code</th>
                    <th>Brand</th>
                    <th className={styles.quantityCell}>Quantity</th>
                    <th className={styles.priceCell}>Price ({currencyCode})</th>
                    <th className={styles.costCell}>Cost ({currencyCode})</th>
                    <th>Move</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {paginatedInventory.map((item) => {
                    const status = getStatusInfo(item);
                    const quantityClass = getQuantityClass(item.currentStock);

                    return (
                      <tr key={item.productId} className={styles.productRow}>
                        <td className={styles.checkboxCell}>
                          <input
                            type="checkbox"
                            className={styles.checkbox}
                            checked={selectedProducts.has(item.productId)}
                            onChange={() => handleCheckboxChange(item.productId)}
                          />
                        </td>
                        <td className={styles.productNameCell}>
                          <span className={styles.productName}>{item.productName}</span>
                        </td>
                        <td className={styles.productCodeCell}>
                          <span className={styles.productCode}>{item.productCode}</span>
                        </td>
                        <td className={styles.barcodeCell}>
                          <span className={styles.barcode}>{item.brandName || 'N/A'}</span>
                        </td>
                        <td className={styles.quantityCell}>
                          <span className={`${styles.quantityValue} ${quantityClass}`}>
                            {item.currentStock}
                          </span>
                        </td>
                        <td className={styles.priceCell}>
                          <div className={styles.priceValue}>{formatCurrency(item.unitPrice)}</div>
                        </td>
                        <td className={styles.costCell}>
                          <div className={styles.costValue}>{formatCurrency(item.costPrice)}</div>
                        </td>
                        <td className={styles.moveCell}>
                          <TossButton
                            variant="outline"
                            size="sm"
                            onClick={() => {}}
                            disabled={item.currentStock === 0}
                            icon={
                              <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M6,13H14L10.5,16.5L11.92,17.92L17.84,12L11.92,6.08L10.5,7.5L14,11H6V13M20,6V18H11V20H20A2,2 0 0,0 22,18V6A2,2 0 0,0 20,4H11V6H20Z"/>
                              </svg>
                            }
                            iconPosition="left"
                            customStyles={{
                              backgroundColor: item.currentStock === 0 ? '#F8F9FA' : 'white',
                              color: item.currentStock === 0 ? '#ADB5BD' : '#0064FF',
                              borderColor: item.currentStock === 0 ? '#DEE2E6' : '#0064FF',
                              borderWidth: '1.5px',
                              borderRadius: '8px',
                              padding: '6px 12px',
                              fontSize: '13px',
                              cursor: item.currentStock === 0 ? 'not-allowed' : 'pointer',
                            }}
                          >
                            Move
                          </TossButton>
                        </td>
                        <td className={styles.actionsCell}>
                          <TossButton
                            variant="outline"
                            size="sm"
                            onClick={() => handleEditProduct(item.productId)}
                            icon={
                              <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                              </svg>
                            }
                            iconPosition="left"
                            customStyles={{
                              backgroundColor: 'white',
                              color: '#0064FF',
                              borderColor: '#0064FF',
                              borderWidth: '1.5px',
                              borderRadius: '8px',
                              padding: '6px 12px',
                              fontSize: '13px',
                            }}
                          >
                            Edit
                          </TossButton>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}

          {/* Pagination */}
          {filteredAndSortedInventory.length > 0 && (
            <div className={styles.pagination}>
              <div className={styles.paginationInfo}>
                Showing {(currentPage - 1) * itemsPerPage + 1}-{Math.min(currentPage * itemsPerPage, totalFilteredItems)} of {totalFilteredItems} products
              </div>
              <div className={styles.paginationControls}>
                {/* Previous Button (5 pages back) */}
                <button
                  className={styles.paginationButton}
                  onClick={() => {
                    const currentGroup = Math.floor((currentPage - 1) / 5);
                    const newPage = Math.max(1, currentGroup * 5);
                    setCurrentPage(newPage);
                  }}
                  disabled={currentPage <= 5}
                  style={{ opacity: currentPage <= 5 ? 0.4 : 1, cursor: currentPage <= 5 ? 'not-allowed' : 'pointer' }}
                >
                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M15.41,16.58L10.83,12L15.41,7.41L14,6L8,12L14,18L15.41,16.58Z"/>
                  </svg>
                </button>

                {/* Page Numbers - Show only existing pages (up to 5 per group) */}
                {(() => {
                  const pages = [];

                  // Calculate current group (0-based: 0 = pages 1-5, 1 = pages 6-10, etc.)
                  const currentGroup = Math.floor((currentPage - 1) / 5);
                  const startPage = currentGroup * 5 + 1;
                  const endPage = Math.min(startPage + 4, totalPages); // Only show existing pages

                  // Generate page buttons for current group
                  for (let i = startPage; i <= endPage; i++) {
                    pages.push(
                      <button
                        key={i}
                        className={`${styles.paginationButton} ${currentPage === i ? styles.active : ''}`}
                        onClick={() => setCurrentPage(i)}
                      >
                        {i}
                      </button>
                    );
                  }

                  return pages;
                })()}

                {/* Next Button (5 pages forward) */}
                <button
                  className={styles.paginationButton}
                  onClick={() => {
                    const currentGroup = Math.floor((currentPage - 1) / 5);
                    const nextGroupStart = (currentGroup + 1) * 5 + 1;
                    const newPage = Math.min(nextGroupStart, totalPages);
                    setCurrentPage(newPage);
                  }}
                  disabled={(() => {
                    const currentGroup = Math.floor((currentPage - 1) / 5);
                    const nextGroupStart = (currentGroup + 1) * 5 + 1;
                    return nextGroupStart > totalPages;
                  })()}
                  style={{
                    opacity: (() => {
                      const currentGroup = Math.floor((currentPage - 1) / 5);
                      const nextGroupStart = (currentGroup + 1) * 5 + 1;
                      return nextGroupStart > totalPages ? 0.4 : 1;
                    })(),
                    cursor: (() => {
                      const currentGroup = Math.floor((currentPage - 1) / 5);
                      const nextGroupStart = (currentGroup + 1) * 5 + 1;
                      return nextGroupStart > totalPages ? 'not-allowed' : 'pointer';
                    })()
                  }}
                >
                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z"/>
                  </svg>
                </button>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Product Details Modal */}
      <ProductDetailsModal
        isOpen={isModalOpen}
        onClose={closeModal}
        productId={selectedProductData?.productId || ''}
        companyId={companyId}
        productData={selectedProductData}
        metadata={metadata}
        onSave={async (updatedData) => {
          const result = await updateProduct(
            selectedProductData?.productId || '',
            companyId,
            selectedStoreId || '',
            updatedData
          );

          if (result.success) {
            showNotification('success', 'Product updated successfully!');
          } else {
            showNotification('error', result.error || 'Failed to update product');
          }
        }}
        onMetadataRefresh={refreshMetadata}
      />

      {/* Add Product Modal */}
      <AddProductModal
        isOpen={isAddProductModalOpen}
        onClose={closeAddProductModal}
        companyId={companyId}
        storeId={selectedStoreId}
        metadata={metadata}
        onProductAdded={() => {
          // Refresh inventory list to show new product
          refresh();
        }}
        onMetadataRefresh={refreshMetadata}
      />

      {/* Notification Message */}
      <ErrorMessage
        isOpen={notification.isOpen}
        variant={notification.variant}
        message={notification.message}
        onClose={hideNotification}
        autoCloseDuration={2000}
        zIndex={9999}
      />

      {/* Metadata Error Message */}
      {metadataError && (
        <ErrorMessage
          isOpen={true}
          variant="warning"
          title="Failed to Load Metadata"
          message={metadataError}
          onClose={() => {}}
          confirmText="Retry"
          onConfirm={refreshMetadata}
          showCancelButton={true}
          cancelText="Dismiss"
          zIndex={9998}
        />
      )}

      {/* Import Loading Overlay - Only LoadingAnimation */}
      {isImporting && <LoadingAnimation size="large" fullscreen={true} />}
    </>
  );
};

export default InventoryPage;
