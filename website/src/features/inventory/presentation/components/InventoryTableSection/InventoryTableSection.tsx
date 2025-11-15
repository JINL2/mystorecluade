/**
 * InventoryTableSection Component
 * Complete inventory table with empty state and pagination
 *
 * Following ARCHITECTURE.md:
 * - Component ≤ 15KB
 * - Extracted from InventoryPage for size compliance
 */

import React from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import type { InventoryTableSectionProps } from './InventoryTableSection.types';
import styles from './InventoryTableSection.module.css';

export const InventoryTableSection: React.FC<InventoryTableSectionProps> = ({
  items,
  totalFilteredItems,
  searchQuery,
  selectedProducts,
  currencyCode,
  currencySymbol,
  currentPage,
  itemsPerPage,
  totalPages,
  expandedProductId,
  isAllSelected,
  onSelectAll,
  onCheckboxChange,
  onRowClick,
  onEditProduct,
  onPageChange,
  formatCurrency,
  getStatusInfo,
  getQuantityClass,
}) => {
  return (
    <>
      {/* Empty State or Table */}
      {items.length === 0 ? (
        <div className={styles.emptyState}>
          <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
            <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>
            <rect x="35" y="35" width="50" height="50" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>
            <rect x="40" y="40" width="40" height="40" rx="2" fill="#F0F6FF" stroke="#0064FF" strokeWidth="1.5"/>
            <line x1="42" y1="50" x2="78" y2="50" stroke="#0064FF" strokeWidth="2" strokeLinecap="round"/>
            <line x1="42" y1="60" x2="78" y2="60" stroke="#0064FF" strokeWidth="2" strokeLinecap="round"/>
            <line x1="42" y1="70" x2="78" y2="70" stroke="#0064FF" strokeWidth="2" strokeLinecap="round"/>
            <circle cx="70" cy="80" r="12" fill="#0064FF"/>
            <circle cx="70" cy="80" r="5" stroke="white" strokeWidth="2" fill="none"/>
            <line x1="74" y1="84" x2="78" y2="88" stroke="white" strokeWidth="2" strokeLinecap="round"/>
          </svg>
          <h3 className={styles.emptyTitle}>No products found</h3>
          <p className={styles.emptyText}>
            {searchQuery ? 'No items match your search criteria' : 'Add products to start managing inventory'}
          </p>
        </div>
      ) : (
        <>
          <div className={styles.inventoryTableWrapper}>
            <table className={styles.inventoryTable}>
              <thead>
                <tr>
                  <th className={styles.checkboxCell}>
                    <input
                      type="checkbox"
                      className={styles.checkbox}
                      checked={isAllSelected}
                      onChange={onSelectAll}
                    />
                  </th>
                  <th className={styles.imageCell}>Image</th>
                  <th>Product Name</th>
                  <th>Product Code</th>
                  <th>Brand</th>
                  <th className={styles.quantityCell}>Quantity</th>
                  <th className={styles.priceCell}>Price ({currencyCode})</th>
                  <th className={styles.costCell}>Cost ({currencyCode})</th>
                  <th>Move</th>
                </tr>
              </thead>
              <tbody>
                {items.map((item) => {
                  const status = getStatusInfo(item);
                  const quantityClass = getQuantityClass(item.currentStock);
                  const isExpanded = expandedProductId === item.productId;

                  return (
                    <React.Fragment key={item.productId}>
                      <tr
                        className={`${styles.productRow} ${isExpanded ? styles.expandedRow : ''}`}
                        onClick={() => onRowClick(item.productId)}
                        style={{ cursor: 'pointer' }}
                      >
                        <td className={styles.checkboxCell} onClick={(e) => e.stopPropagation()}>
                          <input
                            type="checkbox"
                            className={styles.checkbox}
                            checked={selectedProducts.has(item.productId)}
                            onChange={() => onCheckboxChange(item.productId)}
                          />
                        </td>
                        <td className={styles.imageCell}>
                          {item.imageUrls && item.imageUrls.length > 0 ? (
                            <img
                              src={item.imageUrls[0]}
                              alt={item.productName}
                              className={styles.productThumbnail}
                            />
                          ) : (
                            <div className={styles.noImagePlaceholder}>
                              <svg width="24" height="24" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M21,17H7V3H21M21,1H7A2,2 0 0,0 5,3V17A2,2 0 0,0 7,19H21A2,2 0 0,0 23,17V3A2,2 0 0,0 21,1M3,5H1V21A2,2 0 0,0 3,23H19V21H3M15.96,10.29L13.21,13.83L11.25,11.47L8.5,15H19.5L15.96,10.29Z"/>
                              </svg>
                            </div>
                          )}
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
                        <td className={styles.moveCell} onClick={(e) => e.stopPropagation()}>
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
                      </tr>

                      {/* Expanded Detail Row */}
                      {isExpanded && (
                        <tr className={styles.detailRow}>
                          <td colSpan={9}>
                            <div className={styles.detailContent}>
                              <div className={styles.detailGrid}>
                                {/* Images Section */}
                                {item.imageUrls && item.imageUrls.length > 0 && (
                                  <div className={styles.detailSection}>
                                    <h4 className={styles.detailSectionTitle}>Product Images</h4>
                                    <div className={styles.detailImages}>
                                      {item.imageUrls.map((url, index) => (
                                        <img
                                          key={index}
                                          src={url}
                                          alt={`${item.productName} ${index + 1}`}
                                          className={styles.detailImage}
                                        />
                                      ))}
                                    </div>
                                  </div>
                                )}

                                {/* Product Information */}
                                <div className={styles.detailSection}>
                                  <h4 className={styles.detailSectionTitle}>Product Information</h4>
                                  <div className={styles.detailInfo}>
                                    <div className={styles.detailItem}>
                                      <span className={styles.detailLabel}>Category:</span>
                                      <span className={styles.detailValue}>{item.categoryName}</span>
                                    </div>
                                    <div className={styles.detailItem}>
                                      <span className={styles.detailLabel}>Brand:</span>
                                      <span className={styles.detailValue}>{item.brandName || 'N/A'}</span>
                                    </div>
                                    <div className={styles.detailItem}>
                                      <span className={styles.detailLabel}>SKU:</span>
                                      <span className={styles.detailValue}>{item.sku}</span>
                                    </div>
                                    <div className={styles.detailItem}>
                                      <span className={styles.detailLabel}>Barcode:</span>
                                      <span className={styles.detailValue}>{item.barcode || 'N/A'}</span>
                                    </div>
                                    <div className={styles.detailItem}>
                                      <span className={styles.detailLabel}>Unit:</span>
                                      <span className={styles.detailValue}>{item.unit}</span>
                                    </div>
                                  </div>
                                </div>

                                {/* Stock & Price Information */}
                                <div className={styles.detailSection}>
                                  <h4 className={styles.detailSectionTitle}>Stock & Price</h4>
                                  <div className={styles.detailInfo}>
                                    <div className={styles.detailItem}>
                                      <span className={styles.detailLabel}>Current Stock:</span>
                                      <span className={`${styles.detailValue} ${quantityClass}`}>
                                        {item.currentStock} {item.unit}
                                      </span>
                                    </div>
                                    <div className={styles.detailItem}>
                                      <span className={styles.detailLabel}>Selling Price:</span>
                                      <span className={styles.detailValue}>{formatCurrency(item.unitPrice)}</span>
                                    </div>
                                    <div className={styles.detailItem}>
                                      <span className={styles.detailLabel}>Cost Price:</span>
                                      <span className={styles.detailValue}>{formatCurrency(item.costPrice)}</span>
                                    </div>
                                    <div className={styles.detailItem}>
                                      <span className={styles.detailLabel}>Total Value:</span>
                                      <span className={styles.detailValue}>{formatCurrency(item.totalValue)}</span>
                                    </div>
                                  </div>
                                </div>
                              </div>

                              {/* Action Button */}
                              <div className={styles.detailActions}>
                                <TossButton
                                  variant="primary"
                                  size="md"
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    onEditProduct(item.productId);
                                  }}
                                  icon={
                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                      <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                    </svg>
                                  }
                                  iconPosition="left"
                                >
                                  Update Product
                                </TossButton>
                              </div>
                            </div>
                          </td>
                        </tr>
                      )}
                    </React.Fragment>
                  );
                })}
              </tbody>
            </table>
          </div>

          {/* Pagination */}
          {totalFilteredItems > 0 && (
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
                    onPageChange(newPage);
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
                  const currentGroup = Math.floor((currentPage - 1) / 5);
                  const startPage = currentGroup * 5 + 1;
                  const endPage = Math.min(startPage + 4, totalPages);

                  for (let i = startPage; i <= endPage; i++) {
                    pages.push(
                      <button
                        key={i}
                        className={`${styles.paginationButton} ${currentPage === i ? styles.active : ''}`}
                        onClick={() => onPageChange(i)}
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
                    onPageChange(newPage);
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
        </>
      )}
    </>
  );
};
