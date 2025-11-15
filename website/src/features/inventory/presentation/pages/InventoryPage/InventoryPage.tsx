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
import { AddProductModal } from '@/shared/components/modals/AddProductModal';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { FilterSidebar } from '../../components/FilterSidebar/FilterSidebar';
import { InventoryHeader } from '../../components/InventoryHeader';
import { InventoryTableSection } from '../../components/InventoryTableSection';
import { useAppState } from '@/app/providers/app_state_provider';
import type { InventoryPageProps } from './InventoryPage.types';
import styles from './InventoryPage.module.css';

export const InventoryPage: React.FC<InventoryPageProps> = () => {
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id || '';

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
    selectedCategoryFilter,
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
    toggleBrandFilter,
    toggleCategoryFilter,
    clearBrandFilter,
    clearCategoryFilter,
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

  const { metadata, error: metadataError, refresh: refreshMetadata } = useInventoryMetadata(companyId, selectedStoreId || undefined);

  const [localSearchQuery, setLocalSearchQuery] = useState('');
  const [expandedProductId, setExpandedProductId] = useState<string | null>(null);

  const {
    isExporting,
    isImporting,
    fileInputRef,
    handleExportExcel,
    handleImportExcel,
    handleImportClick,
  } = useExcelOperations({
    inventory,
    companyId,
    selectedStoreId,
    storeName: currentCompany?.stores?.find((s) => s.store_id === selectedStoreId)?.store_name || 'Store',
    currencyCode,
    loadInventory,
    importExcel,
    showNotification,
  });

  useEffect(() => {
    setCurrentPage(1);
  }, [localSearchQuery, setCurrentPage]);

  useEffect(() => {
    if (currentCompany?.stores && currentCompany.stores.length > 0 && !selectedStoreId) {
      setSelectedStoreId(currentCompany.stores[0].store_id);
    }
  }, [currentCompany, selectedStoreId, setSelectedStoreId]);

  useEffect(() => {
    if (companyId && selectedStoreId) {
      loadInventory(companyId, selectedStoreId, '');
    }
  }, [companyId, selectedStoreId, loadInventory]);

  const { uniqueBrands, uniqueCategories, filteredAndSortedInventory } = useInventoryFilters({
    inventory,
    searchQuery: localSearchQuery,
    filterType,
    selectedBrandFilter,
    selectedCategoryFilter,
  });

  const { paginatedInventory, totalFilteredItems, totalPages } = useInventoryPagination({
    filteredInventory: filteredAndSortedInventory,
    currentPage,
    itemsPerPage,
  });

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
    toggleProductSelection,
    clearSelection,
    openModal,
    openAddProductModal,
    showNotification,
    statusStyles: {
      statusOutOfStock: styles.statusOutOfStock,
      statusLowStock: styles.statusLowStock,
      statusInStock: styles.statusInStock,
      quantityOut: styles.quantityOut,
      quantityLow: styles.quantityLow,
    },
  });
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
        <div className={styles.pageLayout}>
          {/* Left Sidebar - Desktop only */}
          <div className={styles.sidebarWrapper}>
            <FilterSidebar
              filterType={filterType}
              selectedBrandFilter={selectedBrandFilter}
              selectedCategoryFilter={selectedCategoryFilter}
              brands={[]}
              categories={[]}
              onFilterChange={setFilterType}
              onBrandFilterToggle={toggleBrandFilter}
              onCategoryFilterToggle={toggleCategoryFilter}
              onClearBrandFilter={clearBrandFilter}
              onClearCategoryFilter={clearCategoryFilter}
            />
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
      </>
    );
  }

  if (error) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          {/* Left Sidebar - Desktop only */}
          <div className={styles.sidebarWrapper}>
            <FilterSidebar
              filterType={filterType}
              selectedBrandFilter={selectedBrandFilter}
              selectedCategoryFilter={selectedCategoryFilter}
              brands={[]}
              categories={[]}
              onFilterChange={setFilterType}
              onBrandFilterToggle={toggleBrandFilter}
              onCategoryFilterToggle={toggleCategoryFilter}
              onClearBrandFilter={clearBrandFilter}
              onClearCategoryFilter={clearCategoryFilter}
            />
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
          <FilterSidebar
            filterType={filterType}
            selectedBrandFilter={selectedBrandFilter}
            selectedCategoryFilter={selectedCategoryFilter}
            brands={uniqueBrands}
            categories={uniqueCategories}
            onFilterChange={setFilterType}
            onBrandFilterToggle={toggleBrandFilter}
            onCategoryFilterToggle={toggleCategoryFilter}
            onClearBrandFilter={clearBrandFilter}
            onClearCategoryFilter={clearCategoryFilter}
          />
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
                onStoreSelect={setSelectedStoreId}
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
                onSelectAll={handleSelectAll}
                onCheckboxChange={handleCheckboxChange}
                onRowClick={(productId) => setExpandedProductId(expandedProductId === productId ? null : productId)}
                onEditProduct={handleEditProduct}
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

      <AddProductModal
        isOpen={isAddProductModalOpen}
        onClose={closeAddProductModal}
        companyId={companyId}
        storeId={selectedStoreId}
        metadata={metadata}
        onProductAdded={() => loadInventory(companyId, selectedStoreId)}
        onMetadataRefresh={refreshMetadata}
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
    </>
  );
};

export default InventoryPage;
