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
import { useExcelOperations } from '../../hooks/useExcelOperations';
import { useInventoryFilters } from '../../hooks/useInventoryFilters';
import { useInventoryPagination } from '../../hooks/useInventoryPagination';
import { useInventoryHandlers } from '../../hooks/useInventoryHandlers';
import { Navbar } from '@/shared/components/common/Navbar';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { ProductDetailsModal } from '../../components/ProductDetailsModal';
import { MoveProductModal } from '../../components/MoveProductModal';
import { BulkMoveProductModal } from '../../components/BulkMoveProductModal';
import { AddProductModal } from '@/shared/components/modals/AddProductModal';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { InventoryHeader } from '../../components/InventoryHeader';
import { InventoryTableSection } from '../../components/InventoryTableSection';
import { useAppState } from '@/app/providers/app_state_provider';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import type { InventoryPageProps } from './InventoryPage.types';
import styles from './InventoryPage.module.css';

export const InventoryPage: React.FC<InventoryPageProps> = () => {
  const { currentCompany, currentUser, currentStore, setCurrentStore } = useAppState();
  const companyId = currentCompany?.company_id || '';
  const userId = currentUser?.user_id || '';

  const {
    inventory,
    currencySymbol,
    currencyCode,
    currentPage,
    itemsPerPage,
    totalItems,
    selectedProducts,
    filterType,
    selectedBrandFilter,
    selectedCategoryFilter,
    isModalOpen,
    selectedProductData,
    isAddProductModalOpen,
    isDeleteConfirmModalOpen,
    productsToDelete,
    loading,
    error,
    notification,
    selectedStoreId,
    searchQuery,
    setSelectedStoreId: setInventoryStoreId,
    setCurrentPage,
    toggleProductSelection,
    clearSelection,
    setFilterType,
    toggleBrandFilter,
    toggleCategoryFilter,
    clearBrandFilter,
    clearCategoryFilter,
    openModal,
    closeModal,
    openAddProductModal,
    closeAddProductModal,
    openDeleteConfirmModal,
    closeDeleteConfirmModal,
    showNotification,
    hideNotification,
    loadBaseCurrency,
    loadInventory,
    getAllInventoryForExport,
    updateProduct,
    importExcel,
    moveProduct,
    deleteProducts,
    refresh,
  } = useInventory();

  // Get all stores from current company
  const stores = currentCompany?.stores || [];

  // Sync App State's currentStore to Inventory provider on mount and when currentStore changes
  useEffect(() => {
    const appStateStoreId = currentStore?.store_id || null;
    if (appStateStoreId !== selectedStoreId) {
      setInventoryStoreId(appStateStoreId);
    }
  }, [currentStore, selectedStoreId, setInventoryStoreId]);

  // Handler to select store - sync with App State
  const handleStoreSelect = (storeId: string | null) => {
    // Find the store object
    const selectedStore = stores.find((s) => s.store_id === storeId) || null;

    // Update App State (this will also update localStorage)
    setCurrentStore(selectedStore);

    // Update Inventory provider state
    setInventoryStoreId(storeId);
  };

  const { metadata, error: metadataError, refresh: refreshMetadata } = useInventoryMetadata(companyId, selectedStoreId || undefined);

  const [localSearchQuery, setLocalSearchQuery] = useState('');
  const [expandedProductId, setExpandedProductId] = useState<string | null>(null);
  const [isMoveModalOpen, setIsMoveModalOpen] = useState(false);
  const [isBulkMoveModalOpen, setIsBulkMoveModalOpen] = useState(false);
  const [selectedProductForMove, setSelectedProductForMove] = useState<{
    productId: string;
    productName: string;
    currentStock: number;
  } | null>(null);

  const {
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
  } = useExcelOperations({
    inventory,
    companyId,
    selectedStoreId,
    storeName: currentCompany?.stores?.find((s) => s.store_id === selectedStoreId)?.store_name || 'Store',
    currencyCode,
    searchQuery,
    loadInventory,
    getAllInventoryForExport,
    importExcel,
    showNotification,
  });

  // Debounced search with 300ms delay
  useEffect(() => {
    const timer = setTimeout(() => {
      if (companyId && selectedStoreId) {
        setCurrentPage(1); // Reset to page 1 on search
        loadInventory(companyId, selectedStoreId, localSearchQuery);
      }
    }, 300);

    return () => clearTimeout(timer);
  }, [localSearchQuery]);

  // Only set default store on initial mount if no store is selected in App State
  // This handles the edge case where user navigates directly to Inventory page
  useEffect(() => {
    if (currentCompany?.stores && currentCompany.stores.length > 0 && !currentStore && !selectedStoreId) {
      // Only set default if both App State and Inventory provider have no store selected
      handleStoreSelect(currentCompany.stores[0].store_id);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []); // Run only once on mount

  useEffect(() => {
    if (companyId) {
      loadBaseCurrency(companyId);
    }
  }, [companyId, loadBaseCurrency]);

  // Initial load when company or store changes
  useEffect(() => {
    if (companyId && selectedStoreId) {
      setCurrentPage(1);
      loadInventory(companyId, selectedStoreId, '');
    }
  }, [companyId, selectedStoreId, loadInventory]);

  // Reload inventory when page changes (server-side pagination)
  useEffect(() => {
    if (companyId && selectedStoreId && currentPage > 1) {
      loadInventory(companyId, selectedStoreId, localSearchQuery);
    }
  }, [currentPage]);

  const { uniqueBrands, uniqueCategories, filteredAndSortedInventory } = useInventoryFilters({
    inventory,
    searchQuery: localSearchQuery,
    filterType,
    selectedBrandFilter,
    selectedCategoryFilter,
  });

  // Use server-side pagination - inventory from store is already paginated
  const paginatedInventory = inventory;
  const totalFilteredItems = totalItems;
  const totalPages = Math.ceil(totalItems / itemsPerPage);

  const {
    formatCurrency,
    handleSelectAll,
    handleCheckboxChange,
    handleEditProduct,
    handleDeleteProducts,
    handleAddProduct,
    getStatusInfo,
    getQuantityClass,
  } = useInventoryHandlers({
    inventory,
    filteredAndSortedInventory,
    currencySymbol,
    selectedProducts,
    toggleProductSelection,
    clearSelection,
    openModal,
    openAddProductModal,
    openDeleteConfirmModal,
    showNotification,
    statusStyles: {
      statusOutOfStock: styles.statusOutOfStock,
      statusLowStock: styles.statusLowStock,
      statusInStock: styles.statusInStock,
      quantityOut: styles.quantityOut,
      quantityLow: styles.quantityLow,
      quantityNegative: styles.quantityNegative,
    },
  });

  // LeftFilter sections configuration
  const filterSections: FilterSection[] = [
    {
      id: 'sort',
      title: 'Sort by',
      type: 'sort',
      defaultExpanded: true,
      selectedValues: filterType,
      options: [
        { value: 'newest', label: 'Newest' },
        { value: 'oldest', label: 'Oldest' },
        { value: 'price_high', label: 'Price: High to Low' },
        { value: 'price_low', label: 'Price: Low to High' },
        { value: 'cost_high', label: 'Cost: High to Low' },
        { value: 'cost_low', label: 'Cost: Low to High' },
      ],
      onSelect: (value) => setFilterType(value as any),
    },
    {
      id: 'category',
      title: 'Category',
      type: 'multiselect',
      defaultExpanded: false,
      showCount: true,
      selectedValues: selectedCategoryFilter,
      options: uniqueCategories.map((cat) => ({ value: cat, label: cat })),
      emptyMessage: 'No categories available',
      onToggle: toggleCategoryFilter,
      onClear: clearCategoryFilter,
    },
    {
      id: 'brand',
      title: 'Brand',
      type: 'multiselect',
      defaultExpanded: false,
      showCount: true,
      selectedValues: selectedBrandFilter,
      options: uniqueBrands.map((brand) => ({ value: brand, label: brand })),
      emptyMessage: 'No brands available',
      onToggle: toggleBrandFilter,
      onClear: clearBrandFilter,
    },
  ];

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

  // Remove full-page loading, will show loading in table area instead

  if (error) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          {/* Left Sidebar - Desktop only */}
          <div className={styles.sidebarWrapper}>
            <LeftFilter sections={filterSections} width={240} topOffset={64} />
          </div>

          {/* Main Content Area */}
          <div className={styles.mainContent}>
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
          </div>
        </div>

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

  const isAllSelected = filteredAndSortedInventory.length > 0 &&
    filteredAndSortedInventory.every((item) => selectedProducts.has(item.productId));

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        <div className={styles.sidebarWrapper}>
          <LeftFilter sections={filterSections} width={240} topOffset={64} />
        </div>

        <div className={styles.mainContent}>
          <div className={styles.container}>
            <div className={styles.header}>
              <h1 className={styles.title}>Inventory</h1>
              <p className={styles.subtitle}>Manage product inventory across stores</p>
            </div>

            <div className={styles.controlsCard}>
              <StoreSelector
                stores={currentCompany?.stores || []}
                selectedStoreId={selectedStoreId}
                onStoreSelect={handleStoreSelect}
                companyId={currentCompany?.company_id}
                showAllStoresOption={false}
              />
            </div>

            <div className={styles.contentCard}>
              <InventoryHeader
                searchQuery={localSearchQuery}
                onSearchChange={setLocalSearchQuery}
                selectedCount={selectedProducts.size}
                isExporting={isExporting}
                isImporting={isImporting}
                totalItems={inventory.length}
                filterType={filterType}
                selectedBrandFilter={selectedBrandFilter}
                selectedCategoryFilter={selectedCategoryFilter}
                brands={uniqueBrands}
                categories={uniqueCategories}
                onDelete={handleDeleteProducts}
                onMoveSelected={() => {
                  setIsBulkMoveModalOpen(true);
                }}
                onExport={handleExportExcel}
                onImport={handleImportClick}
                onAddProduct={handleAddProduct}
                onFilterChange={setFilterType}
                onBrandFilterToggle={toggleBrandFilter}
                onCategoryFilterToggle={toggleCategoryFilter}
                onClearBrandFilter={clearBrandFilter}
                onClearCategoryFilter={clearCategoryFilter}
                fileInputRef={fileInputRef}
                onFileChange={handleImportExcel}
              />

              <InventoryTableSection
                items={paginatedInventory}
                totalFilteredItems={totalFilteredItems}
                searchQuery={localSearchQuery}
                selectedProducts={selectedProducts}
                currencyCode={currencyCode}
                currencySymbol={currencySymbol}
                currentPage={currentPage}
                itemsPerPage={itemsPerPage}
                totalPages={totalPages}
                expandedProductId={expandedProductId}
                isAllSelected={isAllSelected}
                loading={loading}
                companyId={companyId}
                storeId={selectedStoreId || ''}
                onSelectAll={handleSelectAll}
                onCheckboxChange={handleCheckboxChange}
                onRowClick={(productId) => setExpandedProductId(expandedProductId === productId ? null : productId)}
                onEditProduct={handleEditProduct}
                onMoveProduct={(productId) => {
                  const product = inventory.find((p) => p.productId === productId);
                  if (product) {
                    setSelectedProductForMove({
                      productId: product.productId,
                      productName: product.productName,
                      currentStock: product.currentStock,
                    });
                    setIsMoveModalOpen(true);
                  }
                }}
                onPageChange={setCurrentPage}
                formatCurrency={formatCurrency}
                getStatusInfo={getStatusInfo}
                getQuantityClass={getQuantityClass}
              />
            </div>
          </div>
        </div>
      </div>

      <ProductDetailsModal
        isOpen={isModalOpen}
        onClose={closeModal}
        productId={selectedProductData?.productId || ''}
        companyId={companyId}
        productData={selectedProductData}
        metadata={metadata}
        onSave={async (updatedData, originalData) => {
          const result = await updateProduct(
            selectedProductData?.productId || '',
            companyId,
            selectedStoreId || '',
            updatedData,
            originalData
          );

          if (result.success) {
            showNotification('success', 'Product updated successfully!');
          } else {
            showNotification('error', result.error || 'Failed to update product');
          }
        }}
        onMetadataRefresh={refreshMetadata}
      />

      <AddProductModal
        isOpen={isAddProductModalOpen}
        onClose={closeAddProductModal}
        companyId={companyId}
        storeId={selectedStoreId}
        metadata={metadata}
        onProductAdded={() => loadInventory(companyId, selectedStoreId)}
        onMetadataRefresh={refreshMetadata}
      />

      <MoveProductModal
        isOpen={isMoveModalOpen}
        onClose={() => {
          setIsMoveModalOpen(false);
          setSelectedProductForMove(null);
        }}
        productId={selectedProductForMove?.productId || ''}
        productName={selectedProductForMove?.productName || ''}
        currentStock={selectedProductForMove?.currentStock || 0}
        sourceStoreId={selectedStoreId || ''}
        companyId={companyId}
        onMove={async (targetStoreId, quantity, notes) => {
          console.log('Move Debug:', {
            selectedProductForMove,
            selectedStoreId,
            companyId,
            userId,
            targetStoreId,
            quantity,
            notes
          });

          if (!selectedProductForMove?.productId || !selectedStoreId || !companyId || !userId) {
            console.error('Missing values:', {
              hasProductId: !!selectedProductForMove?.productId,
              hasSelectedStoreId: !!selectedStoreId,
              hasCompanyId: !!companyId,
              hasUserId: !!userId
            });
            showNotification('error', 'Missing required information');
            return;
          }

          const result = await moveProduct(
            companyId,
            selectedStoreId,
            targetStoreId,
            selectedProductForMove.productId,
            quantity,
            notes,
            DateTimeUtils.nowUtc(),
            userId
          );

          if (result.success) {
            showNotification('success', 'Product moved successfully!');
            setIsMoveModalOpen(false);
            setSelectedProductForMove(null);
          } else {
            showNotification('error', result.error || 'Failed to move product');
          }
        }}
      />

      <BulkMoveProductModal
        isOpen={isBulkMoveModalOpen}
        onClose={() => {
          setIsBulkMoveModalOpen(false);
        }}
        products={Array.from(selectedProducts).map(productId => {
          const product = inventory.find(p => p.productId === productId);
          return {
            productId,
            productName: product?.productName || '',
            productCode: product?.productCode || '',
            currentStock: product?.currentStock || 0
          };
        })}
        sourceStoreId={selectedStoreId || ''}
        companyId={companyId}
        onMove={async (targetStoreId, items, notes) => {
          console.log('Bulk Move Debug:', {
            selectedStoreId,
            companyId,
            userId,
            targetStoreId,
            items,
            notes
          });

          if (!selectedStoreId || !companyId || !userId) {
            console.error('Missing values:', {
              hasSelectedStoreId: !!selectedStoreId,
              hasCompanyId: !!companyId,
              hasUserId: !!userId
            });
            showNotification('error', 'Missing required information');
            return;
          }

          // Move each product
          let successCount = 0;
          let errorCount = 0;

          for (const item of items) {
            const result = await moveProduct(
              companyId,
              selectedStoreId,
              targetStoreId,
              item.productId,
              item.quantity,
              notes,
              DateTimeUtils.nowUtc(),
              userId
            );

            if (result.success) {
              successCount++;
            } else {
              errorCount++;
            }
          }

          if (errorCount === 0) {
            showNotification('success', `Successfully moved ${successCount} product${successCount > 1 ? 's' : ''}!`);
            setIsBulkMoveModalOpen(false);
            clearSelection();
          } else if (successCount > 0) {
            showNotification('warning', `Moved ${successCount} product${successCount > 1 ? 's' : ''}, ${errorCount} failed`);
            setIsBulkMoveModalOpen(false);
            clearSelection();
          } else {
            showNotification('error', 'Failed to move products');
          }
        }}
      />

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

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={isDeleteConfirmModalOpen}
        onClose={closeDeleteConfirmModal}
        onConfirm={async () => {
          const productIds = productsToDelete.map((p) => p.productId);
          const result = await deleteProducts(productIds, companyId);

          if (result.success) {
            showNotification(
              'success',
              result.message || `Successfully deleted ${result.deletedCount || productIds.length} product${(result.deletedCount || productIds.length) > 1 ? 's' : ''}`
            );
            closeDeleteConfirmModal();
            clearSelection();
            // Refresh inventory to reflect changes
            loadInventory(companyId, selectedStoreId, localSearchQuery);
          } else {
            showNotification('error', result.error || 'Failed to delete products');
          }
        }}
        variant="error"
        title="Delete Products"
        message={`Are you sure you want to delete ${productsToDelete.length} product${productsToDelete.length > 1 ? 's' : ''}? This action cannot be undone.`}
        confirmText="Delete"
        cancelText="Cancel"
        confirmButtonVariant="error"
        width="550px"
        zIndex={10000}
      >
        {/* Product List */}
        <div style={{ maxHeight: '300px', overflowY: 'auto' }}>
          {productsToDelete.map((product, index) => (
            <div
              key={product.productId}
              style={{
                display: 'flex',
                alignItems: 'center',
                padding: '12px',
                borderBottom: index < productsToDelete.length - 1 ? '1px solid #f0f0f0' : 'none',
                gap: '12px',
              }}
            >
              {/* Product Image */}
              <div
                style={{
                  width: '48px',
                  height: '48px',
                  borderRadius: '8px',
                  overflow: 'hidden',
                  flexShrink: 0,
                  backgroundColor: '#f5f5f5',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                {product.imageUrls && product.imageUrls.length > 0 ? (
                  <img
                    src={product.imageUrls[0]}
                    alt={product.productName}
                    style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                  />
                ) : (
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="#ccc">
                    <path d="M21,16.5C21,16.88 20.79,17.21 20.47,17.38L12.57,21.82C12.41,21.94 12.21,22 12,22C11.79,22 11.59,21.94 11.43,21.82L3.53,17.38C3.21,17.21 3,16.88 3,16.5V7.5C3,7.12 3.21,6.79 3.53,6.62L11.43,2.18C11.59,2.06 11.79,2 12,2C12.21,2 12.41,2.06 12.57,2.18L20.47,6.62C20.79,6.79 21,7.12 21,7.5V16.5Z" />
                  </svg>
                )}
              </div>

              {/* Product Info */}
              <div style={{ flex: 1, minWidth: 0 }}>
                <div
                  style={{
                    fontSize: '14px',
                    fontWeight: 600,
                    color: '#191f28',
                    marginBottom: '4px',
                    overflow: 'hidden',
                    textOverflow: 'ellipsis',
                    whiteSpace: 'nowrap',
                  }}
                >
                  {product.productName}
                </div>
                <div style={{ fontSize: '12px', color: '#8b95a1' }}>
                  SKU: {product.sku || 'N/A'} • Stock: {product.currentStock}
                </div>
              </div>

              {/* Price */}
              <div
                style={{
                  fontSize: '14px',
                  fontWeight: 600,
                  color: '#191f28',
                  flexShrink: 0,
                }}
              >
                {currencySymbol}{product.unitPrice.toLocaleString()}
              </div>
            </div>
          ))}
        </div>
      </ConfirmModal>

      {/* Price Type Selection Modal for Import */}
      {showPriceTypeModal && (
        <div
          style={{
            position: 'fixed',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            backgroundColor: 'rgba(0, 0, 0, 0.5)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            zIndex: 10001,
          }}
          onClick={closePriceTypeModal}
        >
          <div
            style={{
              backgroundColor: 'white',
              borderRadius: '16px',
              width: '100%',
              maxWidth: '480px',
              overflow: 'hidden',
              boxShadow: '0 20px 60px rgba(0, 0, 0, 0.2)',
            }}
            onClick={(e) => e.stopPropagation()}
          >
            {/* Header */}
            <div
              style={{
                background: '#4169E1',
                padding: '24px',
                color: 'white',
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
              }}
            >
              <svg width="28" height="28" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12,2A7,7 0 0,1 19,9C19,11.38 17.81,13.47 16,14.74V17A1,1 0 0,1 15,18H9A1,1 0 0,1 8,17V14.74C6.19,13.47 5,11.38 5,9A7,7 0 0,1 12,2M9,21V20H15V21A1,1 0 0,1 14,22H10A1,1 0 0,1 9,21Z" />
              </svg>
              <h2 style={{ margin: 0, fontSize: '20px', fontWeight: 600 }}>
                Select Price Type
              </h2>
            </div>

            {/* Body */}
            <div style={{ padding: '24px' }}>
              {/* Info Section */}
              <div
                style={{
                  background: '#F0F6FF',
                  border: '1px solid #C5D9FF',
                  borderRadius: '12px',
                  padding: '16px',
                  marginBottom: '24px',
                }}
              >
                <div style={{ display: 'flex', gap: '12px', alignItems: 'flex-start' }}>
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="#4169E1" style={{ flexShrink: 0, marginTop: '2px' }}>
                    <path d="M13,9H11V7H13M13,17H11V11H13M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z" />
                  </svg>
                  <div>
                    <div style={{ fontWeight: 600, color: '#191f28', marginBottom: '4px' }}>
                      Which price would you like to update?
                    </div>
                    <div style={{ fontSize: '14px', color: '#6B7280', lineHeight: 1.5 }}>
                      For existing products, choose to update the store-specific price or the default (company-wide) price. After selecting, you will be prompted to choose an Excel file.
                    </div>
                  </div>
                </div>
              </div>

              {/* Buttons */}
              <div style={{ display: 'flex', gap: '12px' }}>
                {/* Store Price Button - Primary/Recommended */}
                <button
                  onClick={handleStorePrice}
                  style={{
                    flex: 1,
                    padding: '16px 20px',
                    borderRadius: '12px',
                    border: '2px solid #4169E1',
                    background: '#4169E1',
                    color: 'white',
                    fontSize: '15px',
                    fontWeight: 600,
                    cursor: 'pointer',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                    gap: '8px',
                    transition: 'all 0.2s ease',
                  }}
                  onMouseOver={(e) => {
                    e.currentTarget.style.background = '#3558c0';
                    e.currentTarget.style.borderColor = '#3558c0';
                  }}
                  onMouseOut={(e) => {
                    e.currentTarget.style.background = '#4169E1';
                    e.currentTarget.style.borderColor = '#4169E1';
                  }}
                >
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12,18H6V14H12M21,14V12L20,7H4L3,12V14H4V20H14V14H18V20H20V14M20,4H4V6H20V4Z" />
                  </svg>
                  <span>Store Price</span>
                  <span style={{ fontSize: '11px', fontWeight: 400, opacity: 0.85 }}>
                    Recommended
                  </span>
                </button>

                {/* Default Price Button - Secondary/Gray */}
                <button
                  onClick={handleDefaultPrice}
                  style={{
                    flex: 1,
                    padding: '16px 20px',
                    borderRadius: '12px',
                    border: '2px solid #D1D5DB',
                    background: '#F9FAFB',
                    color: '#6B7280',
                    fontSize: '15px',
                    fontWeight: 600,
                    cursor: 'pointer',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                    gap: '8px',
                    transition: 'all 0.2s ease',
                  }}
                  onMouseOver={(e) => {
                    e.currentTarget.style.background = '#F3F4F6';
                    e.currentTarget.style.borderColor = '#9CA3AF';
                  }}
                  onMouseOut={(e) => {
                    e.currentTarget.style.background = '#F9FAFB';
                    e.currentTarget.style.borderColor = '#D1D5DB';
                  }}
                >
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12,3L2,12H5V20H19V12H22L12,3M12,8.75A2.25,2.25 0 0,1 14.25,11A2.25,2.25 0 0,1 12,13.25A2.25,2.25 0 0,1 9.75,11A2.25,2.25 0 0,1 12,8.75M12,15C13.5,15 16.5,15.75 16.5,17.25V18H7.5V17.25C7.5,15.75 10.5,15 12,15Z" />
                  </svg>
                  <span>Default Price</span>
                  <span style={{ fontSize: '11px', fontWeight: 400 }}>
                    Company-wide
                  </span>
                </button>
              </div>

              {/* Cancel Button */}
              <button
                onClick={closePriceTypeModal}
                style={{
                  width: '100%',
                  marginTop: '16px',
                  padding: '12px',
                  borderRadius: '8px',
                  border: 'none',
                  background: 'transparent',
                  color: '#6B7280',
                  fontSize: '14px',
                  fontWeight: 500,
                  cursor: 'pointer',
                  transition: 'all 0.2s ease',
                }}
                onMouseOver={(e) => {
                  e.currentTarget.style.background = '#F3F4F6';
                }}
                onMouseOut={(e) => {
                  e.currentTarget.style.background = 'transparent';
                }}
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default InventoryPage;
