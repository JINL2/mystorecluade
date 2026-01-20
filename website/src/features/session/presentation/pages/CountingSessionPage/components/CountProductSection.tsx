/**
 * CountProductSection Component
 * Product search and counting input section
 */

import React from 'react';
import type { SearchProduct, ReceivedEntry } from '../../../hooks/useCountingSessionDetail';

// Import styles from ReceivingSessionPage for the search/entries section
import searchStyles from '../../ReceivingSessionPage/components/SearchBox.module.css';
import entriesStyles from '../../ReceivingSessionPage/components/ReceivedEntries.module.css';

// Merge styles for search section
const styles = { ...searchStyles, ...entriesStyles };

// Currency type (inline in hook)
interface Currency {
  symbol: string;
  code: string;
}

interface CountProductSectionProps {
  // Search state
  searchQuery: string;
  setSearchQuery: (query: string) => void;
  searchResults: SearchProduct[];
  isSearching: boolean;
  currency: Currency;
  searchInputRef: React.RefObject<HTMLInputElement | null>;
  debouncedSearchQuery: string;

  // Received entries
  receivedEntries: ReceivedEntry[];

  // Save state
  isSaving: boolean;
  saveError: string | null;
  saveSuccess: boolean;

  // Permission
  canSubmit: boolean;

  // Actions
  handleSelectProduct: (product: SearchProduct) => void;
  handleSearchKeyDown: (e: React.KeyboardEvent) => void;
  updateEntryQuantity: (entryId: string, delta: number) => void;
  setEntryQuantity: (entryId: string, quantity: number) => void;
  removeEntry: (entryId: string) => void;
  clearSearch: () => void;
  handleSave: () => void;
  handleSubmitClick: () => void;
  dismissSaveError: () => void;
}

export const CountProductSection: React.FC<CountProductSectionProps> = ({
  searchQuery,
  setSearchQuery,
  searchResults,
  isSearching,
  currency,
  searchInputRef,
  debouncedSearchQuery,
  receivedEntries,
  isSaving,
  saveError,
  saveSuccess,
  canSubmit,
  handleSelectProduct,
  handleSearchKeyDown,
  updateEntryQuantity,
  setEntryQuantity,
  removeEntry,
  clearSearch,
  handleSave,
  handleSubmitClick,
  dismissSaveError,
}) => {
  return (
    <div className={styles.receiveSection}>
      <h3 className={styles.receiveSectionTitle}>Count Product</h3>

      <div className={styles.receiveContent}>
        {/* Left: Search and Input */}
        <div className={styles.receiveInputArea}>
          {/* Search Box */}
          <div className={styles.searchBox}>
            <div className={styles.searchInputWrapper}>
              {isSearching ? (
                <div className={styles.searchSpinner} />
              ) : (
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="2">
                  <circle cx="11" cy="11" r="8" />
                  <path d="M21 21l-4.35-4.35" />
                </svg>
              )}
              <input
                ref={searchInputRef}
                type="text"
                className={styles.searchInput}
                placeholder="Search by SKU, barcode, or product name..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                onKeyDown={handleSearchKeyDown}
              />
              {searchQuery && (
                <button
                  className={styles.clearSearchButton}
                  onClick={clearSearch}
                >
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M18 6L6 18M6 6l12 12" />
                  </svg>
                </button>
              )}
            </div>
          </div>

          {/* Search Results Dropdown */}
          {searchResults.length > 0 && (
            <div className={styles.searchResults}>
              {searchResults.map((product) => (
                <div
                  key={product.product_id}
                  className={styles.searchResultItem}
                  onClick={() => handleSelectProduct(product)}
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
                  <div className={styles.resultInfo}>
                    <span className={styles.resultName}>{product.display_name}</span>
                    <span className={styles.resultMeta}>
                      {product.display_sku} • Selling price: {currency.symbol}{product.price.selling.toLocaleString()}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          )}

          {/* No results message */}
          {searchQuery && searchResults.length === 0 && !isSearching && debouncedSearchQuery && (
            <div className={styles.searchResults}>
              <div className={styles.noResults}>
                No products found for "{searchQuery}"
              </div>
            </div>
          )}
        </div>

        {/* Right: Counted Entries Table */}
        <div className={styles.receivedEntriesArea}>
          <div className={styles.entriesHeader}>
            <h4>Counted Items</h4>
            <span className={styles.entriesCount}>{receivedEntries.length} entries</span>
          </div>

          {receivedEntries.length === 0 ? (
            <div className={styles.emptyEntries}>
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#CBD5E1" strokeWidth="1.5">
                <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                <rect x="9" y="3" width="6" height="4" rx="1" />
                <path d="M9 12h6M9 16h6" />
              </svg>
              <p>No items counted yet</p>
              <span>Search and add products to start counting</span>
            </div>
          ) : (
            <div className={styles.entriesTableContainer}>
              <table className={styles.entriesTable}>
                <thead>
                  <tr>
                    <th>Product</th>
                    <th>SKU</th>
                    <th>Qty</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  {receivedEntries.map((entry) => (
                    <tr key={entry.entry_id}>
                      <td className={styles.entryProduct}>{entry.product_name}</td>
                      <td className={styles.entrySku}>{entry.sku}</td>
                      <td className={styles.entryQty}>
                        <div className={styles.qtyControl}>
                          <button
                            className={styles.qtyButton}
                            onClick={() => updateEntryQuantity(entry.entry_id, -1)}
                          >
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                              <path d="M5 12h14" />
                            </svg>
                          </button>
                          <input
                            type="number"
                            className={styles.qtyInput}
                            value={entry.quantity}
                            min="1"
                            onChange={(e) => setEntryQuantity(entry.entry_id, parseInt(e.target.value) || 1)}
                          />
                          <button
                            className={styles.qtyButton}
                            onClick={() => updateEntryQuantity(entry.entry_id, 1)}
                          >
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                              <path d="M12 5v14M5 12h14" />
                            </svg>
                          </button>
                        </div>
                      </td>
                      <td className={styles.entryActions}>
                        <button
                          className={styles.removeEntryButton}
                          onClick={() => removeEntry(entry.entry_id)}
                          title="Remove item"
                        >
                          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M18 6L6 18M6 6l12 12" />
                          </svg>
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>

      {/* Save Status Messages */}
      {saveError && (
        <div className={styles.saveErrorMessage}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <circle cx="12" cy="12" r="10" />
            <path d="M15 9l-6 6M9 9l6 6" />
          </svg>
          {saveError}
          <button onClick={dismissSaveError} className={styles.dismissButton}>×</button>
        </div>
      )}
      {saveSuccess && (
        <div className={styles.saveSuccessMessage}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M20 6L9 17l-5-5" />
          </svg>
          Items saved successfully!
        </div>
      )}

      {/* Action Buttons */}
      <div className={styles.actionButtons}>
        <button
          className={`${styles.saveButton} ${isSaving ? styles.saveButtonLoading : ''}`}
          onClick={handleSave}
          disabled={isSaving || receivedEntries.length === 0}
        >
          {isSaving ? (
            <>
              <div className={styles.buttonSpinner} />
              Saving...
            </>
          ) : (
            <>
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                <polyline points="17 21 17 13 7 13 7 21" />
                <polyline points="7 3 7 8 15 8" />
              </svg>
              Save
            </>
          )}
        </button>
        <button
          className={`${styles.submitButton} ${!canSubmit ? styles.submitButtonDisabled : ''}`}
          onClick={handleSubmitClick}
          disabled={!canSubmit}
          title={!canSubmit ? 'Only the session owner can submit' : ''}
        >
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M22 2L11 13" />
            <path d="M22 2l-7 20-4-9-9-4 20-7z" />
          </svg>
          Submit
        </button>
      </div>
    </div>
  );
};

export default CountProductSection;
