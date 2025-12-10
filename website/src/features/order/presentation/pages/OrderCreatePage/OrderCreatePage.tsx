/**
 * OrderCreatePage Component
 * Create new purchase order with items, supplier selection, and notes
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useOrderCreate } from '../../hooks/useOrderCreate';
import { ProductSearch } from '../../components/ProductSearch';
import { OrderItemsTable } from '../../components/OrderItemsTable';
import styles from './OrderCreatePage.module.css';

export const OrderCreatePage: React.FC = () => {
  const {
    fileInputRef,
    searchInputRef,
    dropdownRef,
    searchQuery,
    setSearchQuery,
    searchResults,
    isSearching,
    showDropdown,
    setShowDropdown,
    orderItems,
    totalAmount,
    handleAddProduct,
    handleQuantityChange,
    handleCostChange,
    handleRemoveItem,
    supplierType,
    setSupplierType,
    selectedSupplier,
    setSelectedSupplier,
    oneTimeSupplier,
    handleOneTimeSupplierChange,
    suppliersLoading,
    supplierOptions,
    note,
    setNote,
    currency,
    formatPrice,
    isImporting,
    importError,
    handleImportClick,
    handleFileChange,
    handleExportSample,
    handleImportErrorClose,
    isSaving,
    saveResult,
    handleSave,
    handleSaveResultClose,
    isSaveDisabled,
    handleCancel,
  } = useOrderCreate();

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
                <h1 className={styles.title}>Create Purchase Order</h1>
                <p className={styles.subtitle}>Add items and select supplier for your order</p>
              </div>
            </div>
          </div>

          {/* Main Content */}
          <div className={styles.content}>
            {/* Items Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                <span className={styles.sectionNumber}>1</span>
                Order Items
              </h2>
              <div className={styles.sectionContent}>
                {/* Search Bar and Action Buttons */}
                <div className={styles.itemActions}>
                  <ProductSearch
                    searchInputRef={searchInputRef}
                    dropdownRef={dropdownRef}
                    searchQuery={searchQuery}
                    onSearchChange={setSearchQuery}
                    searchResults={searchResults}
                    isSearching={isSearching}
                    showDropdown={showDropdown}
                    onShowDropdown={setShowDropdown}
                    onAddProduct={handleAddProduct}
                    formatPrice={formatPrice}
                  />

                  <div className={styles.importExportButtons}>
                    <button
                      className={styles.importButton}
                      onClick={handleImportClick}
                      disabled={isImporting}
                    >
                      {isImporting ? (
                        <>
                          <div className={styles.buttonSpinner} />
                          Importing...
                        </>
                      ) : (
                        <>
                          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                            <polyline points="17 8 12 3 7 8" />
                            <line x1="12" y1="3" x2="12" y2="15" />
                          </svg>
                          Import Excel
                        </>
                      )}
                    </button>
                    <button className={styles.exportSampleButton} onClick={handleExportSample}>
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                        <polyline points="7 10 12 15 17 10" />
                        <line x1="12" y1="15" x2="12" y2="3" />
                      </svg>
                      Export Sample
                    </button>
                    <input
                      ref={fileInputRef}
                      type="file"
                      accept=".xlsx,.xls"
                      onChange={handleFileChange}
                      style={{ display: 'none' }}
                    />
                  </div>
                </div>

                {/* Items Table */}
                <OrderItemsTable
                  orderItems={orderItems}
                  currency={currency}
                  totalAmount={totalAmount}
                  onQuantityChange={handleQuantityChange}
                  onCostChange={handleCostChange}
                  onRemoveItem={handleRemoveItem}
                  formatPrice={formatPrice}
                />
              </div>
            </div>

            {/* Supplier Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                <span className={styles.sectionNumber}>2</span>
                Supplier Information
              </h2>
              <div className={styles.sectionContent}>
                {/* Supplier Type Toggle */}
                <div className={styles.supplierTypeToggle}>
                  <button
                    className={`${styles.toggleButton} ${supplierType === 'existing' ? styles.active : ''}`}
                    onClick={() => setSupplierType('existing')}
                  >
                    Select Existing Supplier
                  </button>
                  <button
                    className={`${styles.toggleButton} ${supplierType === 'onetime' ? styles.active : ''}`}
                    onClick={() => setSupplierType('onetime')}
                  >
                    One-time Supplier
                  </button>
                </div>

                {supplierType === 'existing' ? (
                  <div className={styles.existingSupplier}>
                    <TossSelector
                      placeholder={suppliersLoading ? 'Loading suppliers...' : 'Select a supplier'}
                      value={selectedSupplier ?? undefined}
                      options={supplierOptions}
                      onChange={(value) => setSelectedSupplier(value || null)}
                      searchable
                      fullWidth
                      disabled={suppliersLoading}
                      showDescriptions
                    />
                  </div>
                ) : (
                  <div className={styles.oneTimeSupplier}>
                    <div className={styles.formGroup}>
                      <label className={styles.label}>
                        Supplier Name <span className={styles.required}>*</span>
                      </label>
                      <input
                        type="text"
                        className={styles.input}
                        placeholder="Enter supplier name"
                        value={oneTimeSupplier.name}
                        onChange={(e) => handleOneTimeSupplierChange('name', e.target.value)}
                      />
                    </div>
                    <div className={styles.formRow}>
                      <div className={styles.formGroup}>
                        <label className={styles.label}>Phone</label>
                        <input
                          type="tel"
                          className={styles.input}
                          placeholder="Enter phone number"
                          value={oneTimeSupplier.phone}
                          onChange={(e) => handleOneTimeSupplierChange('phone', e.target.value)}
                        />
                      </div>
                      <div className={styles.formGroup}>
                        <label className={styles.label}>Email</label>
                        <input
                          type="email"
                          className={styles.input}
                          placeholder="Enter email address"
                          value={oneTimeSupplier.email}
                          onChange={(e) => handleOneTimeSupplierChange('email', e.target.value)}
                        />
                      </div>
                    </div>
                    <div className={styles.formGroup}>
                      <label className={styles.label}>Address</label>
                      <input
                        type="text"
                        className={styles.input}
                        placeholder="Enter address"
                        value={oneTimeSupplier.address}
                        onChange={(e) => handleOneTimeSupplierChange('address', e.target.value)}
                      />
                    </div>
                  </div>
                )}
              </div>
            </div>

            {/* Note Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                <span className={styles.sectionNumber}>3</span>
                Notes
              </h2>
              <div className={styles.sectionContent}>
                <textarea
                  className={styles.noteTextarea}
                  placeholder="Add any notes for this order..."
                  value={note}
                  onChange={(e) => setNote(e.target.value)}
                  rows={4}
                />
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
                Create Order
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
            importError.notFoundSkus[0].includes('No valid'))
            ? importError.notFoundSkus[0]
            : `The following SKUs were not found in your inventory:\n\n${importError.notFoundSkus.join(', ')}`
        }
        isOpen={importError.show}
        onClose={handleImportErrorClose}
        confirmText="OK"
      />

      {/* Save Result Message */}
      <ErrorMessage
        variant={saveResult.success ? 'success' : 'error'}
        title={saveResult.success ? 'Order Created' : 'Error'}
        message={saveResult.message}
        isOpen={saveResult.show}
        onClose={handleSaveResultClose}
        confirmText="OK"
      />
    </>
  );
};

export default OrderCreatePage;
