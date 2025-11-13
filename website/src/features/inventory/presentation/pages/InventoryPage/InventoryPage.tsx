/**
 * InventoryPage Component
 * Inventory management with stock levels and product information
 *
 * Following 2025 Best Practice:
 * - Clean component focusing on UI only
 * - All state managed by Zustand provider
 * - Optimized re-renders with selective subscriptions
 */

import React, { useEffect } from 'react';
import { useInventory } from '../../hooks/useInventory';
import { useInventoryMetadata } from '../../hooks/useInventoryMetadata';
import { Navbar } from '@/shared/components/common/Navbar';
import { TossButton } from '@/shared/components/toss/TossButton';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { ProductDetailsModal } from '../../components/ProductDetailsModal';
import { AddProductModal } from '@/shared/components/modals/AddProductModal';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useAppState } from '@/app/providers/app_state_provider';
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
    selectedStoreId,
    searchQuery,
    selectedProducts,
    isModalOpen,
    selectedProductData,
    isAddProductModalOpen,
    loading,
    error,
    notification,

    setSelectedStoreId,
    setSearchQuery,
    toggleProductSelection,
    selectAllProducts,
    clearSelection,
    openModal,
    closeModal,
    openAddProductModal,
    closeAddProductModal,
    showNotification,
    hideNotification,
    loadInventory,
    updateProduct,
    refresh,
  } = useInventory();

  // Fetch inventory metadata (categories, brands, product types, units)
  const { metadata, loading: metadataLoading, error: metadataError, refresh: refreshMetadata } = useInventoryMetadata(companyId, selectedStoreId || undefined);

  // Initialize with first store when company loads
  useEffect(() => {
    if (currentCompany?.stores && currentCompany.stores.length > 0 && !selectedStoreId) {
      setSelectedStoreId(currentCompany.stores[0].store_id);
    }
  }, [currentCompany, selectedStoreId, setSelectedStoreId]);

  // Load inventory when dependencies change
  useEffect(() => {
    if (companyId && selectedStoreId) {
      loadInventory(companyId, selectedStoreId, searchQuery);
    }
  }, [companyId, selectedStoreId, searchQuery, loadInventory]);

  // Helper function to format currency with strikethrough symbol
  const formatCurrency = (amount: number): string => {
    const formatted = amount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    });
    return `${currencySymbol}${formatted}`;
  };

  // Handle select all checkbox
  const handleSelectAll = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.checked) {
      selectAllProducts();
    } else {
      clearSelection();
    }
  };

  // Handle individual checkbox
  const handleCheckboxChange = (productId: string, checked: boolean) => {
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
  const handleExportExcel = () => {
    // TODO: Implement Excel export
    console.log('Export to Excel');
  };

  // Handle import Excel
  const handleImportExcel = () => {
    // TODO: Open import modal
    console.log('Import from Excel');
  };

  // Handle add product
  const handleAddProduct = () => {
    openAddProductModal();
  };

  // Clear search
  const handleClearSearch = () => {
    setSearchQuery('');
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
          onConfirm={() => loadInventory(companyId, selectedStoreId, searchQuery)}
          closeOnBackdropClick={false}
          closeOnEscape={false}
          zIndex={9999}
        />
      </>
    );
  }

  const isAllSelected = inventory.length > 0 && selectedProducts.size === inventory.length;

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
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
                {searchQuery && (
                  <button className={styles.searchClear} onClick={handleClearSearch}>
                    <svg fill="currentColor" viewBox="0 0 24 24" width="16" height="16">
                      <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
                    </svg>
                  </button>
                )}
              </div>
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
                  icon={
                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z"/>
                    </svg>
                  }
                  iconPosition="left"
                >
                  Export Excel
                </TossButton>
                <TossButton
                  variant="secondary"
                  size="md"
                  onClick={handleImportExcel}
                  icon={
                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M13,13H11V16H9L12,19L15,16H13V13M13,9V3.5L18.5,9H13Z"/>
                    </svg>
                  }
                  iconPosition="left"
                >
                  Import Excel
                </TossButton>
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
                {searchQuery
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
                        checked={inventory.length > 0 && selectedProducts.size === inventory.length}
                        onChange={handleSelectAll}
                      />
                    </th>
                    <th>Product Name</th>
                    <th>Product Code</th>
                    <th>Barcode</th>
                    <th className={styles.quantityCell}>Quantity</th>
                    <th className={styles.priceCell}>Price ({currencyCode})</th>
                    <th className={styles.costCell}>Cost ({currencyCode})</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {inventory.map((item) => {
                    const status = getStatusInfo(item);
                    const quantityClass = getQuantityClass(item.currentStock);

                    return (
                      <tr key={item.productId} className={styles.productRow}>
                        <td className={styles.checkboxCell}>
                          <input
                            type="checkbox"
                            className={styles.checkbox}
                            checked={selectedProducts.has(item.productId)}
                            onChange={(e) => handleCheckboxChange(item.productId, e.target.checked)}
                          />
                        </td>
                        <td className={styles.productNameCell}>
                          <span className={styles.productName}>{item.productName}</span>
                        </td>
                        <td className={styles.productCodeCell}>
                          <span className={styles.productCode}>{item.productCode}</span>
                        </td>
                        <td className={styles.barcodeCell}>
                          <span className={styles.barcode}>{item.barcode || 'N/A'}</span>
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
                        <td className={styles.statusCell}>
                          <span className={`${styles.statusBadge} ${status.class}`}>
                            {status.text}
                          </span>
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
          {inventory.length > 0 && (
            <div className={styles.pagination}>
              <div className={styles.paginationInfo}>
                Showing 1-{inventory.length} of {inventory.length} products
              </div>
              <div className={styles.paginationControls}>
                <button className={`${styles.paginationButton} ${styles.active}`}>
                  1
                </button>
                <button className={styles.paginationButton}>
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
    </>
  );
};

export default InventoryPage;
