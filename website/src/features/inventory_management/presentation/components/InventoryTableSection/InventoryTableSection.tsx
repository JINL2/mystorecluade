/**
 * InventoryTableSection Component
 * Complete inventory table with empty state and pagination
 *
 * Following ARCHITECTURE.md:
 * - Component ≤ 15KB
 * - Extracted from InventoryPage for size compliance
 */

import React, { useState, useEffect, useCallback } from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { ImageHoverPreview } from '@/shared/components/common/ImageHoverPreview';
import type { InventoryTableSectionProps } from './InventoryTableSection.types';
import type { InventoryItem } from '../../../domain/entities/InventoryItem';
import { InventoryDataSource, type ProductHistoryItem } from '../../../data/datasources/InventoryDataSource';
import { InvoiceDataSource, type InvoiceDetailResponse } from '@/features/sales_invoice/data/datasources/InvoiceDataSource';
import styles from './InventoryTableSection.module.css';

type DetailTab = 'detail' | 'history';

interface ExpandedDetailRowProps {
  item: InventoryItem;
  quantityClass: string;
  formatCurrency: (value: number) => string;
  onEditProduct: (uniqueId: string) => void;
  companyId: string;
  storeId: string;
}

// Invoice Detail Modal Component
interface InvoiceDetailModalProps {
  isOpen: boolean;
  onClose: () => void;
  invoiceDetail: InvoiceDetailResponse['data'] | null;
  loading: boolean;
  formatCurrency: (value: number) => string;
}

const InvoiceDetailModal: React.FC<InvoiceDetailModalProps> = ({
  isOpen,
  onClose,
  invoiceDetail,
  loading,
  formatCurrency,
}) => {
  if (!isOpen) return null;

  return (
    <div className={styles.modalOverlay} onClick={onClose}>
      <div className={styles.modalContent} onClick={(e) => e.stopPropagation()}>
        {/* Modal Header */}
        <div className={styles.modalHeader}>
          <h3 className={styles.modalTitle}>
            Invoice Detail
            {invoiceDetail?.invoice?.invoice_number && (
              <span className={styles.invoiceNumber}> - {invoiceDetail.invoice.invoice_number}</span>
            )}
          </h3>
          <button className={styles.modalCloseBtn} onClick={onClose}>
            <svg width="24" height="24" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        {/* Modal Body */}
        <div className={styles.modalBody}>
          {loading ? (
            <div className={styles.modalLoading}>
              <LoadingAnimation size="medium" />
            </div>
          ) : !invoiceDetail ? (
            <div className={styles.modalError}>
              <p>Failed to load invoice details</p>
            </div>
          ) : (
            <>
              {/* Items Table */}
              <div className={styles.invoiceSection}>
                <h4 className={styles.invoiceSectionTitle}>Items ({invoiceDetail.items.length})</h4>
                <div className={styles.invoiceItemsTable}>
                  <table>
                    <thead>
                      <tr>
                        <th>Product</th>
                        <th>SKU</th>
                        <th>Qty</th>
                        <th>Unit Price</th>
                        <th>Discount</th>
                        <th>Total</th>
                      </tr>
                    </thead>
                    <tbody>
                      {invoiceDetail.items.map((item) => (
                        <tr key={item.item_id}>
                          <td>{item.product_name}</td>
                          <td>{item.sku}</td>
                          <td>{item.quantity_sold}</td>
                          <td>{formatCurrency(item.unit_price)}</td>
                          <td>{formatCurrency(item.discount_amount)}</td>
                          <td><strong>{formatCurrency(item.total_amount)}</strong></td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Store & Amount Info */}
              <div className={styles.invoiceBottomGrid}>
                {/* Store Information */}
                <div className={styles.invoiceSection}>
                  <h4 className={styles.invoiceSectionTitle}>Store & Date</h4>
                  <div className={styles.invoiceInfo}>
                    <div className={styles.invoiceInfoItem}>
                      <span className={styles.invoiceInfoLabel}>Store:</span>
                      <span className={styles.invoiceInfoValue}>{invoiceDetail.invoice.store_name}</span>
                    </div>
                    <div className={styles.invoiceInfoItem}>
                      <span className={styles.invoiceInfoLabel}>Sale Date:</span>
                      <span className={styles.invoiceInfoValue}>
                        {new Date(invoiceDetail.invoice.sale_date).toLocaleString('en-US')}
                      </span>
                    </div>
                    <div className={styles.invoiceInfoItem}>
                      <span className={styles.invoiceInfoLabel}>Status:</span>
                      <span className={`${styles.invoiceInfoValue} ${styles.invoiceStatus}`}>
                        {invoiceDetail.invoice.status}
                      </span>
                    </div>
                  </div>
                </div>

                {/* Amount Summary */}
                <div className={styles.invoiceSection}>
                  <h4 className={styles.invoiceSectionTitle}>Amount Summary</h4>
                  <div className={styles.invoiceInfo}>
                    <div className={styles.invoiceInfoItem}>
                      <span className={styles.invoiceInfoLabel}>Subtotal:</span>
                      <span className={styles.invoiceInfoValue}>{formatCurrency(invoiceDetail.amounts.subtotal)}</span>
                    </div>
                    <div className={styles.invoiceInfoItem}>
                      <span className={styles.invoiceInfoLabel}>Tax:</span>
                      <span className={styles.invoiceInfoValue}>{formatCurrency(invoiceDetail.amounts.tax_amount)}</span>
                    </div>
                    <div className={styles.invoiceInfoItem}>
                      <span className={styles.invoiceInfoLabel}>Discount:</span>
                      <span className={styles.invoiceInfoValue}>{formatCurrency(invoiceDetail.amounts.discount_amount)}</span>
                    </div>
                    <div className={`${styles.invoiceInfoItem} ${styles.invoiceTotalRow}`}>
                      <span className={styles.invoiceTotalLabel}>Total:</span>
                      <span className={styles.invoiceTotalValue}>
                        {formatCurrency(invoiceDetail.amounts.total_amount)}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
};

// Helper function to get event type display info
const getEventTypeInfo = (eventType: string): { label: string; color: string; bgColor: string } => {
  const eventMap: Record<string, { label: string; color: string; bgColor: string }> = {
    stock_sale: { label: 'Sale', color: '#dc2626', bgColor: '#fef2f2' },
    stock_refund: { label: 'Refund', color: '#16a34a', bgColor: '#f0fdf4' },
    stock_receipt: { label: 'Receipt', color: '#2563eb', bgColor: '#eff6ff' },
    stock_transfer_out: { label: 'Transfer Out', color: '#ea580c', bgColor: '#fff7ed' },
    stock_transfer_in: { label: 'Transfer In', color: '#0891b2', bgColor: '#ecfeff' },
    stock_adjustment_increase: { label: 'Adjustment +', color: '#16a34a', bgColor: '#f0fdf4' },
    stock_adjustment_decrease: { label: 'Adjustment -', color: '#dc2626', bgColor: '#fef2f2' },
    default_cost_changed: { label: 'Cost Changed', color: '#7c3aed', bgColor: '#faf5ff' },
    default_selling_changed: { label: 'Price Changed', color: '#7c3aed', bgColor: '#faf5ff' },
    default_min_price_changed: { label: 'Min Price Changed', color: '#7c3aed', bgColor: '#faf5ff' },
    store_cost_changed: { label: 'Store Cost Changed', color: '#7c3aed', bgColor: '#faf5ff' },
    store_selling_changed: { label: 'Store Price Changed', color: '#7c3aed', bgColor: '#faf5ff' },
    store_min_price_changed: { label: 'Store Min Price', color: '#7c3aed', bgColor: '#faf5ff' },
    product_created: { label: 'Created', color: '#059669', bgColor: '#ecfdf5' },
    product_name_changed: { label: 'Name Changed', color: '#6366f1', bgColor: '#eef2ff' },
    product_sku_changed: { label: 'SKU Changed', color: '#6366f1', bgColor: '#eef2ff' },
    product_brand_changed: { label: 'Brand Changed', color: '#6366f1', bgColor: '#eef2ff' },
    product_category_changed: { label: 'Category Changed', color: '#6366f1', bgColor: '#eef2ff' },
    product_weight_changed: { label: 'Weight Changed', color: '#6366f1', bgColor: '#eef2ff' },
    product_deleted: { label: 'Deleted', color: '#dc2626', bgColor: '#fef2f2' },
    product_restored: { label: 'Restored', color: '#16a34a', bgColor: '#f0fdf4' },
  };
  return eventMap[eventType] || { label: eventType.replace(/_/g, ' '), color: '#6b7280', bgColor: '#f9fafb' };
};

// Helper function to format history item description based on event type
const getHistoryDescription = (item: ProductHistoryItem, formatCurrency: (value: number) => string): string => {
  switch (item.event_type) {
    case 'stock_sale':
      return item.invoice_number || 'Sale';
    case 'stock_refund':
      return item.invoice_number ? `Refund: ${item.invoice_number}` : 'Refund';
    case 'stock_receipt':
      return item.notes || 'Stock receipt';
    case 'stock_transfer_out':
      return `To: ${item.to_store_name || 'Unknown'}`;
    case 'stock_transfer_in':
      return `From: ${item.from_store_name || 'Unknown'}`;
    case 'stock_adjustment_increase':
    case 'stock_adjustment_decrease':
      return item.reason || item.notes || 'Adjustment';
    case 'default_cost_changed':
    case 'store_cost_changed':
      return `${formatCurrency(item.cost_before || 0)} → ${formatCurrency(item.cost_after || 0)}`;
    case 'default_selling_changed':
    case 'store_selling_changed':
      return `${formatCurrency(item.selling_price_before || 0)} → ${formatCurrency(item.selling_price_after || 0)}`;
    case 'default_min_price_changed':
    case 'store_min_price_changed':
      return `${formatCurrency(item.min_price_before || 0)} → ${formatCurrency(item.min_price_after || 0)}`;
    case 'product_created':
      return item.notes || 'Product created';
    case 'product_name_changed':
      return `"${item.name_before}" → "${item.name_after}"`;
    case 'product_sku_changed':
      return `"${item.sku_before}" → "${item.sku_after}"`;
    case 'product_brand_changed':
      return `${item.brand_name_before || 'None'} → ${item.brand_name_after || 'None'}`;
    case 'product_category_changed':
      return `${item.category_name_before || 'None'} → ${item.category_name_after || 'None'}`;
    case 'product_weight_changed':
      return `${item.weight_before || 0} → ${item.weight_after || 0}`;
    case 'product_deleted':
      return item.notes || 'Deleted';
    case 'product_restored':
      return item.notes || 'Restored';
    default:
      return item.notes || '-';
  }
};

const ExpandedDetailRow: React.FC<ExpandedDetailRowProps> = ({
  item,
  quantityClass,
  formatCurrency,
  onEditProduct,
  companyId,
  storeId,
}) => {
  const [activeTab, setActiveTab] = useState<DetailTab>('detail');
  const [historyData, setHistoryData] = useState<ProductHistoryItem[]>([]);
  const [historyLoading, setHistoryLoading] = useState(false);
  const [historyError, setHistoryError] = useState<string | null>(null);
  const [historyPage, setHistoryPage] = useState(1);
  const [historyTotalPages, setHistoryTotalPages] = useState(0);
  const [historyTotalCount, setHistoryTotalCount] = useState(0);
  const [historyLoaded, setHistoryLoaded] = useState(false);

  // Invoice Detail Modal state
  const [showInvoiceModal, setShowInvoiceModal] = useState(false);
  const [invoiceDetail, setInvoiceDetail] = useState<InvoiceDetailResponse['data'] | null>(null);
  const [invoiceDetailLoading, setInvoiceDetailLoading] = useState(false);

  // Handle click on Sale/Refund history item
  const handleSaleItemClick = useCallback(async (invoiceId: string) => {
    if (!invoiceId) return;

    setShowInvoiceModal(true);
    setInvoiceDetailLoading(true);
    setInvoiceDetail(null);

    try {
      const dataSource = new InvoiceDataSource();
      const response = await dataSource.getInvoiceDetail(invoiceId);

      if (response.success && response.data) {
        setInvoiceDetail(response.data);
      }
    } catch (err) {
      console.error('Failed to load invoice detail:', err);
    } finally {
      setInvoiceDetailLoading(false);
    }
  }, []);

  const loadHistory = useCallback(async (page: number = 1) => {
    if (!companyId || !storeId) {
      setHistoryError('Company or store not selected');
      return;
    }

    setHistoryLoading(true);
    setHistoryError(null);

    try {
      const dataSource = new InventoryDataSource();
      const response = await dataSource.getProductHistory(
        companyId,
        storeId,
        item.productId,
        page,
        10,
        item.variantId // v2: filter by variant
      );

      if (response.success) {
        setHistoryData(response.data);
        setHistoryPage(response.page);
        setHistoryTotalPages(response.total_pages);
        setHistoryTotalCount(response.total_count);
        setHistoryLoaded(true);
      } else {
        setHistoryError(response.message || 'Failed to load history');
      }
    } catch (err) {
      setHistoryError(err instanceof Error ? err.message : 'Failed to load history');
    } finally {
      setHistoryLoading(false);
    }
  }, [companyId, storeId, item.productId, item.variantId]);

  // Load history when switching to history tab for the first time
  useEffect(() => {
    if (activeTab === 'history' && !historyLoaded && !historyLoading) {
      loadHistory(1);
    }
  }, [activeTab, historyLoaded, historyLoading, loadHistory]);

  const handleHistoryPageChange = (newPage: number) => {
    loadHistory(newPage);
  };

  return (
    <tr className={styles.detailRow}>
      <td colSpan={9}>
        <div className={styles.detailContent}>
          {/* Tab Navigation */}
          <div className={styles.detailTabs}>
            <button
              className={`${styles.detailTab} ${activeTab === 'detail' ? styles.detailTabActive : ''}`}
              onClick={(e) => {
                e.stopPropagation();
                setActiveTab('detail');
              }}
            >
              Detail
            </button>
            <button
              className={`${styles.detailTab} ${activeTab === 'history' ? styles.detailTabActive : ''}`}
              onClick={(e) => {
                e.stopPropagation();
                setActiveTab('history');
              }}
            >
              History
            </button>
          </div>

          {/* Tab Content */}
          <div className={styles.detailTabContent}>
            {activeTab === 'detail' && (
              <>
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
                      onEditProduct(item.uniqueId);
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
              </>
            )}

            {activeTab === 'history' && (
              <div className={styles.historyTabContent}>
                {historyLoading ? (
                  <div className={styles.historyLoading}>
                    <LoadingAnimation size="medium" />
                  </div>
                ) : historyError ? (
                  <div className={styles.historyError}>
                    <svg width="48" height="48" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
                    <p>{historyError}</p>
                    <button onClick={() => loadHistory(1)} className={styles.retryButton}>
                      Retry
                    </button>
                  </div>
                ) : historyData.length === 0 ? (
                  <div className={styles.historyEmpty}>
                    <svg width="48" height="48" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <p>No history available</p>
                  </div>
                ) : (
                  <>
                    {/* History Table - Excel Style (no thead/th, all tbody/td) */}
                    <div className={styles.historyTableWrapper}>
                      <table className={styles.historyTable}>
                        <tbody>
                          {/* Header Row */}
                          <tr className={styles.historyHeaderRow}>
                            <td className={`${styles.historyColTime} ${styles.historyHeader}`}>Time</td>
                            <td className={`${styles.historyColType} ${styles.historyHeader}`}>Type</td>
                            <td className={`${styles.historyColDesc} ${styles.historyHeader}`}>Description</td>
                            <td className={`${styles.historyColUser} ${styles.historyHeader}`}>User</td>
                            <td className={`${styles.historyColQty} ${styles.historyHeader}`}>Quantity</td>
                            <td className={`${styles.historyColStock} ${styles.historyHeader}`}>On Hand</td>
                          </tr>
                          {/* Data Rows */}
                          {historyData.map((historyItem) => {
                            const eventInfo = getEventTypeInfo(historyItem.event_type);
                            const hasQuantity = historyItem.quantity_change !== undefined && historyItem.quantity_change !== null;
                            const quantityDisplay = hasQuantity
                              ? (historyItem.quantity_change! > 0 ? `+${historyItem.quantity_change}` : `${historyItem.quantity_change}`)
                              : '-';
                            const quantityColorClass = hasQuantity
                              ? (historyItem.quantity_change! > 0 ? styles.quantityPositive : historyItem.quantity_change! < 0 ? styles.quantityNegativeHistory : '')
                              : '';

                            // Check if this is a sale/refund event that can be clicked
                            const isSaleEvent = historyItem.event_type === 'stock_sale' || historyItem.event_type === 'stock_refund';
                            const hasInvoiceId = !!historyItem.invoice_id;
                            const isClickable = isSaleEvent && hasInvoiceId;

                            return (
                              <tr
                                key={historyItem.log_id}
                                className={`${styles.historyTableRow} ${isClickable ? styles.historyClickableRow : ''}`}
                                onClick={isClickable ? () => handleSaleItemClick(historyItem.invoice_id!) : undefined}
                                style={isClickable ? { cursor: 'pointer' } : undefined}
                              >
                                <td className={styles.historyColTime}>
                                  {historyItem.created_at}
                                </td>
                                <td className={styles.historyColType}>
                                  {eventInfo.label}
                                </td>
                                <td className={styles.historyColDesc}>
                                  {getHistoryDescription(historyItem, formatCurrency)}
                                  {isClickable && (
                                    <svg
                                      width="12"
                                      height="12"
                                      fill="currentColor"
                                      viewBox="0 0 24 24"
                                      style={{ marginLeft: '6px', color: '#0064FF', verticalAlign: 'middle' }}
                                    >
                                      <path d="M10,6V8H5V19H16V14H18V20A1,1 0 0,1 17,21H4A1,1 0 0,1 3,20V7A1,1 0 0,1 4,6H10M21,3V11H19L19,6.41L9.17,16.24L7.76,14.83L17.59,5H13V3H21Z"/>
                                    </svg>
                                  )}
                                </td>
                                <td className={styles.historyColUser}>
                                  {historyItem.created_user || '-'}
                                </td>
                                <td className={`${styles.historyColQty} ${quantityColorClass}`}>
                                  {quantityDisplay}
                                </td>
                                <td className={styles.historyColStock}>
                                  {historyItem.quantity_after !== undefined ? historyItem.quantity_after : '-'}
                                </td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>

                    {/* History Pagination - Always visible */}
                    <div className={styles.historyPagination}>
                      <span className={styles.historyPaginationInfo}>
                        Page {historyPage} of {Math.max(1, historyTotalPages)} ({historyTotalCount} total)
                      </span>
                      <div className={styles.historyPaginationControls}>
                        {/* Previous Button */}
                        <button
                          className={styles.historyPaginationButton}
                          onClick={(e) => {
                            e.stopPropagation();
                            const currentGroup = Math.floor((historyPage - 1) / 5);
                            const newPage = Math.max(1, currentGroup * 5);
                            handleHistoryPageChange(newPage);
                          }}
                          disabled={historyPage <= 5}
                        >
                          <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M15.41,16.58L10.83,12L15.41,7.41L14,6L8,12L14,18L15.41,16.58Z"/>
                          </svg>
                        </button>

                        {/* Page Numbers */}
                        {(() => {
                          const pages = [];
                          const totalPagesDisplay = Math.max(1, historyTotalPages);
                          const currentGroup = Math.floor((historyPage - 1) / 5);
                          const startPage = currentGroup * 5 + 1;
                          const endPage = Math.min(startPage + 4, totalPagesDisplay);

                          for (let i = startPage; i <= endPage; i++) {
                            pages.push(
                              <button
                                key={i}
                                className={`${styles.historyPaginationButton} ${historyPage === i ? styles.historyPaginationActive : ''}`}
                                onClick={(e) => {
                                  e.stopPropagation();
                                  handleHistoryPageChange(i);
                                }}
                              >
                                {i}
                              </button>
                            );
                          }

                          return pages;
                        })()}

                        {/* Next Button */}
                        <button
                          className={styles.historyPaginationButton}
                          onClick={(e) => {
                            e.stopPropagation();
                            const currentGroup = Math.floor((historyPage - 1) / 5);
                            const nextGroupStart = (currentGroup + 1) * 5 + 1;
                            const newPage = Math.min(nextGroupStart, historyTotalPages);
                            handleHistoryPageChange(newPage);
                          }}
                          disabled={(() => {
                            const currentGroup = Math.floor((historyPage - 1) / 5);
                            const nextGroupStart = (currentGroup + 1) * 5 + 1;
                            return nextGroupStart > historyTotalPages || historyTotalPages <= 1;
                          })()}
                        >
                          <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z"/>
                          </svg>
                        </button>
                      </div>
                    </div>
                  </>
                )}
              </div>
            )}
          </div>
        </div>
      </td>

      {/* Invoice Detail Modal */}
      <InvoiceDetailModal
        isOpen={showInvoiceModal}
        onClose={() => setShowInvoiceModal(false)}
        invoiceDetail={invoiceDetail}
        loading={invoiceDetailLoading}
        formatCurrency={formatCurrency}
      />
    </tr>
  );
};

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
  loading = false,
  companyId,
  storeId,
  onSelectAll,
  onCheckboxChange,
  onRowClick,
  onEditProduct,
  onMoveProduct,
  onPageChange,
  formatCurrency,
  getStatusInfo,
  getQuantityClass,
}) => {
  return (
    <>
      {/* Loading State */}
      {loading ? (
        <div className={styles.loadingOverlay}>
          <LoadingAnimation size="large" />
        </div>
      ) : items.length === 0 ? (
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
                  const isExpanded = expandedProductId === item.uniqueId;

                  // Determine quantity class - only negative numbers are red
                  let quantityClass = '';
                  if (item.currentStock < 0) {
                    quantityClass = styles.quantityNegative;
                  }

                  // v6: Use variantId for unique key when available (variant products have same productId)
                  const itemKey = item.variantId ? `${item.productId}-${item.variantId}` : item.productId;

                  return (
                    <React.Fragment key={itemKey}>
                      <tr
                        className={`${styles.productRow} ${isExpanded ? styles.expandedRow : ''}`}
                        onClick={() => onRowClick(item.uniqueId)}
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
                            <ImageHoverPreview
                              src={item.imageUrls[0]}
                              alt={item.productName}
                              thumbnailClassName={styles.productThumbnail}
                              previewSize={200}
                              position="right"
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
                          <span className={styles.productName}>{item.name}</span>
                        </td>
                        <td className={styles.productCodeCell}>
                          <span className={styles.productCode}>{item.effectiveSku}</span>
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
                            onClick={() => onMoveProduct(item.uniqueId)}
                            icon={
                              <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M6,13H14L10.5,16.5L11.92,17.92L17.84,12L11.92,6.08L10.5,7.5L14,11H6V13M20,6V18H11V20H20A2,2 0 0,0 22,18V6A2,2 0 0,0 20,4H11V6H20Z"/>
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
                              cursor: 'pointer',
                            }}
                          >
                            Move
                          </TossButton>
                        </td>
                      </tr>

                      {/* Expanded Detail Row with Tabs */}
                      {isExpanded && (
                        <ExpandedDetailRow
                          item={item}
                          quantityClass={quantityClass}
                          formatCurrency={formatCurrency}
                          onEditProduct={onEditProduct}
                          companyId={companyId}
                          storeId={storeId}
                        />
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
