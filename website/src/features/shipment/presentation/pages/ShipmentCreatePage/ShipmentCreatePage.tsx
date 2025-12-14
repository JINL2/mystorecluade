/**
 * ShipmentCreatePage Component
 * Create new shipment with items from existing orders OR direct supplier selection
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useShipmentCreate } from '../../hooks/useShipmentCreate';
import { OrderSelectionSection } from '../../components/SelectionSection/OrderSelectionSection';
import { SupplierSelectionSection } from '../../components/SelectionSection/SupplierSelectionSection';
import { ShipmentItemsTable } from '../../components/ShipmentItemsTable/ShipmentItemsTable';
import styles from './ShipmentCreatePage.module.css';

export const ShipmentCreatePage: React.FC = () => {
  const {
    currency,
    formatPrice,
    // Selection Mode
    selectionMode,
    // Suppliers
    suppliersLoading,
    supplierOptions,
    selectedSupplier,
    // Supplier Section
    supplierType,
    handleSupplierTypeChange,
    handleSupplierSectionChange,
    handleClearSupplierSelection,
    oneTimeSupplier,
    handleOneTimeSupplierChange,
    // Orders
    ordersLoading,
    orderOptions,
    selectedOrder,
    handleOrderChange,
    // Shipment items
    shipmentItems,
    totalAmount,
    handleRemoveItem,
    handleQuantityChange,
    handleCostChange,
    // Shipment details
    trackingNumber,
    setTrackingNumber,
    note,
    setNote,
    // Save
    isSaving,
    saveResult,
    handleSave,
    handleSaveResultClose,
    isSaveDisabled,
    handleCancel,
    // Import/Export
    fileInputRef,
    isImporting,
    importError,
    handleImportClick,
    handleFileChange,
    handleExportSample,
    handleImportErrorClose,
    // Product Search
    searchInputRef,
    dropdownRef,
    searchQuery,
    setSearchQuery,
    searchResults,
    isSearching,
    showDropdown,
    setShowDropdown,
    handleAddProductFromSearch,
  } = useShipmentCreate();

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          {/* Page Header */}
          <div className={styles.header}>
            <div className={styles.headerLeft}>
              <button className={styles.backButton} onClick={handleCancel}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M19 12H5M12 19l-7-7 7-7" />
                </svg>
              </button>
              <div>
                <h1 className={styles.title}>Create Shipment</h1>
                <p className={styles.subtitle}>Select from existing orders or enter supplier directly</p>
              </div>
            </div>
          </div>

          {/* Main Content */}
          <div className={styles.content}>
            {/* Order Selection Section */}
            <OrderSelectionSection
              selectionMode={selectionMode}
              ordersLoading={ordersLoading}
              orderOptions={orderOptions}
              selectedOrder={selectedOrder}
              onOrderChange={handleOrderChange}
            />

            {/* Supplier Selection Section */}
            <SupplierSelectionSection
              selectionMode={selectionMode}
              suppliersLoading={suppliersLoading}
              supplierOptions={supplierOptions}
              selectedSupplier={selectedSupplier}
              supplierType={supplierType}
              onSupplierTypeChange={handleSupplierTypeChange}
              onSupplierSectionChange={handleSupplierSectionChange}
              onClearSupplierSelection={handleClearSupplierSelection}
              oneTimeSupplier={oneTimeSupplier}
              onOneTimeSupplierChange={handleOneTimeSupplierChange}
            />

            {/* Shipment Items Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                <span className={styles.sectionNumber}>2</span>
                Shipment Items
              </h2>
              <div className={styles.sectionContent}>
                <ShipmentItemsTable
                  items={shipmentItems}
                  currency={currency}
                  totalAmount={totalAmount}
                  onRemoveItem={handleRemoveItem}
                  onQuantityChange={handleQuantityChange}
                  onCostChange={handleCostChange}
                  formatPrice={formatPrice}
                  searchInputRef={searchInputRef}
                  dropdownRef={dropdownRef}
                  searchQuery={searchQuery}
                  onSearchQueryChange={setSearchQuery}
                  searchResults={searchResults}
                  isSearching={isSearching}
                  showDropdown={showDropdown}
                  onShowDropdownChange={setShowDropdown}
                  onAddProductFromSearch={handleAddProductFromSearch}
                  fileInputRef={fileInputRef}
                  isImporting={isImporting}
                  onImportClick={handleImportClick}
                  onFileChange={handleFileChange}
                  onExportSample={handleExportSample}
                />
              </div>
            </div>

            {/* Shipment Details Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                <span className={styles.sectionNumber}>3</span>
                Shipment Details
              </h2>
              <div className={styles.sectionContent}>
                <div className={styles.formGroup}>
                  <label className={styles.label}>Tracking Number</label>
                  <input
                    type="text"
                    className={styles.input}
                    placeholder="Enter tracking number (optional)"
                    value={trackingNumber}
                    onChange={(e) => setTrackingNumber(e.target.value)}
                  />
                </div>
                <div className={styles.formGroup}>
                  <label className={styles.label}>Notes</label>
                  <textarea
                    className={styles.noteTextarea}
                    placeholder="Add any notes for this shipment..."
                    value={note}
                    onChange={(e) => setNote(e.target.value)}
                    rows={3}
                  />
                </div>
              </div>
            </div>

            {/* Footer Actions */}
            <div className={styles.footerActions}>
              <button className={styles.cancelButton} onClick={handleCancel} disabled={isSaving}>
                Cancel
              </button>
              <button
                className={styles.saveButton}
                onClick={handleSave}
                disabled={isSaveDisabled}
              >
                Create Shipment
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Fullscreen Loading Animation */}
      {isSaving && <LoadingAnimation fullscreen size="large" />}

      {/* Import Error Message */}
      <ErrorMessage
        variant="warning"
        title="Import Warning"
        message={
          importError.notFoundSkus.length === 1 &&
          (importError.notFoundSkus[0].includes('Company') ||
            importError.notFoundSkus[0].includes('Failed') ||
            importError.notFoundSkus[0].includes('No valid') ||
            importError.notFoundSkus[0].includes('Please select'))
            ? importError.notFoundSkus[0]
            : `The following SKUs were not found or have no remaining quantity:\n\n${importError.notFoundSkus.join(', ')}`
        }
        isOpen={importError.show}
        onClose={handleImportErrorClose}
        confirmText="OK"
      />

      {/* Save Result Message */}
      <ErrorMessage
        variant={saveResult.success ? 'success' : 'error'}
        title={saveResult.success ? 'Shipment Created' : 'Error'}
        message={saveResult.message}
        isOpen={saveResult.show}
        onClose={handleSaveResultClose}
        confirmText="OK"
      />
    </>
  );
};

export default ShipmentCreatePage;
