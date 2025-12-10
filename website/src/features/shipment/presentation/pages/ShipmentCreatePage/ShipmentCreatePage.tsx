/**
 * ShipmentCreatePage Component
 * Create new shipment with items from existing orders OR direct supplier selection
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useShipmentCreate } from '../../hooks/useShipmentCreate';
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
    // Item filter
    itemSearchQuery,
    setItemSearchQuery,
    filteredShipmentItems,
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
            <div className={`${styles.selectionSection} ${selectionMode === 'order' ? styles.active : ''} ${selectionMode === 'supplier' ? styles.disabled : ''}`}>
              <div className={styles.sectionHeader}>
                <div className={styles.sectionTitleWithBadge}>
                  <h2 className={styles.sectionTitle}>
                    <span className={styles.sectionNumber}>1</span>
                    Select Order
                  </h2>
                  <span className={styles.orBadge}>Option A</span>
                </div>
                {selectionMode === 'order' && (
                  <div className={styles.selectionActions}>
                    <div className={styles.selectionIndicator}>
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <polyline points="20 6 9 17 4 12" />
                      </svg>
                      Selected
                    </div>
                    <button
                      className={styles.clearSelectionButton}
                      onClick={() => handleOrderChange(null)}
                      title="Clear selection"
                    >
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <line x1="18" y1="6" x2="6" y2="18" />
                        <line x1="6" y1="6" x2="18" y2="18" />
                      </svg>
                    </button>
                  </div>
                )}
              </div>
              <div className={styles.sectionContent}>
                <div className={styles.selectGroup}>
                  <label className={styles.label}>
                    Order <span className={styles.required}>*</span>
                  </label>
                  <TossSelector
                    placeholder={ordersLoading ? 'Loading orders...' : 'Select an order'}
                    value={selectedOrder ?? undefined}
                    options={orderOptions}
                    onChange={(value) => handleOrderChange(value || null)}
                    searchable
                    fullWidth
                    disabled={ordersLoading || selectionMode === 'supplier'}
                  />
                </div>
              </div>
            </div>

            {/* Supplier Selection Section */}
            <div className={`${styles.selectionSection} ${selectionMode === 'supplier' ? styles.active : ''} ${selectionMode === 'order' ? styles.disabled : ''}`}>
              <div className={styles.sectionHeader}>
                <div className={styles.sectionTitleWithBadge}>
                  <h2 className={styles.sectionTitle}>
                    <span className={styles.sectionNumber}>1</span>
                    Select Supplier
                  </h2>
                  <span className={styles.orBadge}>Option B</span>
                </div>
                {selectionMode === 'supplier' && (
                  <div className={styles.selectionActions}>
                    <div className={styles.selectionIndicator}>
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <polyline points="20 6 9 17 4 12" />
                      </svg>
                      Selected
                    </div>
                    <button
                      className={styles.clearSelectionButton}
                      onClick={handleClearSupplierSelection}
                      title="Clear selection"
                    >
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <line x1="18" y1="6" x2="6" y2="18" />
                        <line x1="6" y1="6" x2="18" y2="18" />
                      </svg>
                    </button>
                  </div>
                )}
              </div>
              <div className={styles.sectionContent}>
                {/* Supplier Type Toggle */}
                <div className={styles.supplierTypeToggle}>
                  <button
                    className={`${styles.toggleButton} ${supplierType === 'existing' ? styles.active : ''}`}
                    onClick={() => handleSupplierTypeChange('existing')}
                    disabled={selectionMode === 'order'}
                  >
                    Select Existing Supplier
                  </button>
                  <button
                    className={`${styles.toggleButton} ${supplierType === 'onetime' ? styles.active : ''}`}
                    onClick={() => handleSupplierTypeChange('onetime')}
                    disabled={selectionMode === 'order'}
                  >
                    One-time Supplier
                  </button>
                </div>

                {supplierType === 'existing' ? (
                  <div className={styles.existingSupplier}>
                    <TossSelector
                      placeholder={suppliersLoading ? 'Loading suppliers...' : 'Select a supplier'}
                      value={selectionMode === 'supplier' ? selectedSupplier ?? undefined : undefined}
                      options={supplierOptions}
                      onChange={(value) => handleSupplierSectionChange(value || null)}
                      searchable
                      fullWidth
                      disabled={suppliersLoading || selectionMode === 'order'}
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
                        disabled={selectionMode === 'order'}
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
                          disabled={selectionMode === 'order'}
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
                          disabled={selectionMode === 'order'}
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
                        disabled={selectionMode === 'order'}
                      />
                    </div>
                  </div>
                )}
              </div>
            </div>

            {/* Shipment Items Section */}
            <div className={styles.section}>
              <h2 className={styles.sectionTitle}>
                <span className={styles.sectionNumber}>2</span>
                Shipment Items
              </h2>
              <div className={styles.sectionContent}>
                {/* Search Bar and Action Buttons */}
                <div className={styles.itemActions}>
                  <div className={styles.productSearchContainer}>
                    <div className={styles.productSearchWrapper}>
                      <svg className={styles.searchIcon} width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <circle cx="11" cy="11" r="8" />
                        <path d="m21 21-4.35-4.35" />
                      </svg>
                      <input
                        ref={searchInputRef}
                        type="text"
                        className={styles.productSearchInput}
                        placeholder="Search products by name, SKU, or barcode..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        onFocus={() => searchQuery && searchResults.length > 0 && setShowDropdown(true)}
                      />
                      {isSearching && <div className={styles.searchSpinner} />}
                    </div>

                    {/* Search Results Dropdown */}
                    {showDropdown && searchResults.length > 0 && (
                      <div ref={dropdownRef} className={styles.searchDropdown}>
                        {searchResults.map((product) => (
                          <div
                            key={product.product_id}
                            className={styles.searchResultItem}
                            onClick={() => handleAddProductFromSearch(product)}
                          >
                            <div className={styles.searchResultImage}>
                              {product.image_urls && product.image_urls.length > 0 ? (
                                <img src={product.image_urls[0]} alt={product.product_name} />
                              ) : (
                                <div className={styles.noImage}>
                                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                    <polyline points="21 15 16 10 5 21" />
                                  </svg>
                                </div>
                              )}
                            </div>
                            <div className={styles.searchResultInfo}>
                              <span className={styles.searchResultName}>{product.product_name}</span>
                              <span className={styles.searchResultMeta}>
                                {product.sku} • Cost: {formatPrice(product.price.cost)}
                              </span>
                              <span className={styles.searchResultStock}>
                                OnHand: {product.stock.quantity_on_hand} • Available: {product.stock.quantity_available}
                              </span>
                            </div>
                          </div>
                        ))}
                      </div>
                    )}

                    {/* No results message */}
                    {showDropdown && searchQuery && searchResults.length === 0 && !isSearching && (
                      <div ref={dropdownRef} className={styles.searchDropdown}>
                        <div className={styles.noResults}>
                          No products found for "{searchQuery}"
                        </div>
                      </div>
                    )}
                  </div>

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

                {shipmentItems.length === 0 ? (
                  <div className={styles.emptyItems}>
                    <svg className={styles.emptyIcon} width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                      <path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                    </svg>
                    <p>No items added yet</p>
                    <span>Search for products above or use "Import Excel" to add items</span>
                  </div>
                ) : (
                  <div className={styles.tableContainer}>
                    <table className={styles.itemsTable}>
                      <thead>
                        <tr>
                          <th>Product Name</th>
                          <th>SKU</th>
                          <th>Cost</th>
                          <th>Quantity</th>
                          <th></th>
                        </tr>
                      </thead>
                      <tbody>
                        {shipmentItems.map((item, index) => (
                          <tr key={item.orderItemId}>
                            <td className={styles.productName}>{item.productName}</td>
                            <td className={styles.sku}>{item.sku}</td>
                            <td>
                              <div className={styles.costInputWrapper}>
                                <input
                                  type="number"
                                  className={styles.costInput}
                                  value={item.unitPrice}
                                  onChange={(e) => handleCostChange(index, parseFloat(e.target.value) || 0)}
                                  min="0"
                                  step="100"
                                />
                                <span className={styles.currencySymbol}>{currency.symbol}</span>
                              </div>
                            </td>
                            <td>
                              <input
                                type="number"
                                className={styles.quantityInputCell}
                                value={item.quantity || ''}
                                onChange={(e) => handleQuantityChange(item.orderItemId, parseInt(e.target.value) || 0)}
                                min="0"
                              />
                            </td>
                            <td>
                              <button
                                className={styles.removeButton}
                                onClick={() => handleRemoveItem(item.orderItemId)}
                              >
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                  <line x1="18" y1="6" x2="6" y2="18" />
                                  <line x1="6" y1="6" x2="18" y2="18" />
                                </svg>
                              </button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                      <tfoot>
                        <tr>
                          <td colSpan={2} className={styles.totalLabel}>Total Amount</td>
                          <td className={styles.grandTotal}>{formatPrice(totalAmount)}</td>
                          <td colSpan={2}></td>
                        </tr>
                      </tfoot>
                    </table>
                  </div>
                )}
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
