/**
 * ReceivingSessionPage Component
 * Page for receiving items in a session
 * Accessed after creating or joining a receiving session
 */

import React, { useEffect, useState, useCallback, useRef } from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';

// Debounce hook for search
function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);

  return debouncedValue;
}
import type {
  SessionInfo,
  ReceivingItem,
  ReceivingSessionLocationState,
  ShipmentData,
} from './ReceivingSessionPage.types';
import styles from './ReceivingSessionPage.module.css';

export const ReceivingSessionPage: React.FC = () => {
  const { sessionId } = useParams<{ sessionId: string }>();
  const navigate = useNavigate();
  const location = useLocation();
  const { currentCompany, currentUser } = useAppState();

  // Get state from navigation
  const locationState = location.state as ReceivingSessionLocationState | null;

  // State
  const [sessionInfo, setSessionInfo] = useState<SessionInfo | null>(null);
  const [shipmentData, setShipmentData] = useState<ShipmentData | null>(null);
  const [items, setItems] = useState<ReceivingItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Load session data
  useEffect(() => {
    const loadSessionData = async () => {
      if (!sessionId || !currentCompany) return;

      setLoading(true);
      setError(null);

      try {
        console.log('📦 Loading session:', sessionId);
        console.log('📦 Location state:', locationState);

        // If we have data from navigation state, use it
        if (locationState?.sessionData) {
          const sessionData = locationState.sessionData;
          setSessionInfo({
            session_id: sessionData.session_id || sessionId,
            session_type: sessionData.session_type || 'receiving',
            store_id: sessionData.store_id || '',
            store_name: sessionData.store_name || '',
            shipment_id: locationState.shipmentId || sessionData.shipment_id || null,
            shipment_number: locationState.shipmentData?.shipment_number || sessionData.shipment_number || null,
            is_active: sessionData.is_active ?? true,
            is_final: sessionData.is_final ?? false,
            created_by: sessionData.created_by || '',
            created_by_name: sessionData.created_by_name || '',
            created_at: sessionData.created_at || new Date().toISOString(),
            member_count: sessionData.member_count,
          });
        }

        // If we have shipment data from navigation state, use it
        if (locationState?.shipmentData) {
          setShipmentData(locationState.shipmentData);

          // Convert shipment items to receiving items
          if (locationState.shipmentData.items) {
            const receivingItems: ReceivingItem[] = locationState.shipmentData.items.map(item => ({
              item_id: item.item_id,
              product_id: item.product_id,
              product_name: item.product_name,
              sku: item.sku,
              quantity_shipped: item.quantity_shipped,
              quantity_received: item.quantity_received,
              quantity_accepted: item.quantity_accepted,
              quantity_rejected: item.quantity_rejected,
              quantity_remaining: item.quantity_remaining,
              unit_cost: item.unit_cost,
            }));
            setItems(receivingItems);
          }
        }

        // If no navigation state, we need to fetch from API
        if (!locationState?.sessionData || !locationState?.shipmentData) {
          // TODO: Call inventory_get_session_detail RPC when available
          // For now, set placeholder if no data
          if (!locationState?.sessionData) {
            setSessionInfo({
              session_id: sessionId,
              session_type: 'receiving',
              store_id: '',
              store_name: 'Loading...',
              shipment_id: null,
              shipment_number: null,
              is_active: true,
              is_final: false,
              created_by: '',
              created_by_name: '',
              created_at: new Date().toISOString(),
            });
          }
        }

      } catch (err) {
        console.error('📦 Load session error:', err);
        setError(err instanceof Error ? err.message : 'Failed to load session');
      } finally {
        setLoading(false);
      }
    };

    loadSessionData();
  }, [sessionId, currentCompany, locationState]);

  // Handle back navigation
  const handleBack = () => {
    navigate('/product/product-receive');
  };

  // Product search result type (from get_inventory_page_v3 RPC)
  interface SearchProduct {
    product_id: string;
    product_name: string;
    sku: string;
    barcode?: string;
    image_urls?: string[];
    stock: {
      quantity_on_hand: number;
      quantity_available: number;
      quantity_reserved: number;
    };
    price: {
      cost: number;
      selling: number;
      source: string;
    };
  }

  // Product search and receive states
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<SearchProduct[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [currency, setCurrency] = useState<{ symbol: string; code: string }>({ symbol: '₫', code: 'VND' });
  const [selectedProduct, setSelectedProduct] = useState<{
    product_id: string;
    product_name: string;
    sku: string;
    barcode?: string;
  } | null>(null);
  const [receiveQuantity, setReceiveQuantity] = useState<number>(1);
  const [receiveStatus, setReceiveStatus] = useState<'accepted' | 'rejected'>('accepted');
  const [receiveNotes, setReceiveNotes] = useState('');
  const [receivedEntries, setReceivedEntries] = useState<Array<{
    entry_id: string;
    product_name: string;
    sku: string;
    quantity: number;
    status: 'accepted' | 'rejected';
    notes: string;
    created_at: string;
  }>>([]);

  // Debounced search query (300ms delay)
  const debouncedSearchQuery = useDebounce(searchQuery, 300);

  // Search products using RPC
  useEffect(() => {
    const searchProducts = async () => {
      if (!debouncedSearchQuery.trim() || !currentCompany?.company_id || !sessionInfo?.store_id) {
        setSearchResults([]);
        return;
      }

      setIsSearching(true);
      try {
        const client = supabaseService.getClient();
        const { data, error } = await client.rpc('get_inventory_page_v3', {
          p_company_id: currentCompany.company_id,
          p_store_id: sessionInfo.store_id,
          p_page: 1,
          p_limit: 10,
          p_search: debouncedSearchQuery.trim(),
          p_timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        });

        if (error) {
          console.error('Search error:', error);
          setSearchResults([]);
          return;
        }

        console.log('🔍 RPC response:', data);

        // RPC returns { success: true, data: { products: [...], currency: {...} } }
        if (data?.success && data?.data?.products) {
          setSearchResults(data.data.products);
          if (data.data.currency) {
            setCurrency({
              symbol: data.data.currency.symbol || '₫',
              code: data.data.currency.code || 'VND',
            });
          }
        } else {
          console.log('🔍 No products or invalid response:', data);
          setSearchResults([]);
        }
      } catch (err) {
        console.error('Search error:', err);
        setSearchResults([]);
      } finally {
        setIsSearching(false);
      }
    };

    searchProducts();
  }, [debouncedSearchQuery, currentCompany?.company_id, sessionInfo?.store_id]);

  // Handle product selection
  const handleSelectProduct = (product: typeof selectedProduct) => {
    setSelectedProduct(product);
    setSearchResults([]);
    setSearchQuery('');
  };

  // Handle receive submit (mock for now)
  const handleReceiveSubmit = () => {
    if (!selectedProduct || receiveQuantity <= 0) return;

    const newEntry = {
      entry_id: `temp-${Date.now()}`,
      product_name: selectedProduct.product_name,
      sku: selectedProduct.sku,
      quantity: receiveQuantity,
      status: receiveStatus,
      notes: receiveNotes,
      created_at: new Date().toISOString(),
    };

    setReceivedEntries(prev => [newEntry, ...prev]);
    setSelectedProduct(null);
    setReceiveQuantity(1);
    setReceiveStatus('accepted');
    setReceiveNotes('');
  };

  // Calculate totals from items or use shipment summary
  const receivingSummary = shipmentData?.receiving_summary;
  const totalShipped = receivingSummary?.total_shipped ?? items.reduce((sum, item) => sum + item.quantity_shipped, 0);
  const totalReceived = receivingSummary?.total_received ?? items.reduce((sum, item) => sum + item.quantity_received, 0);
  const totalAccepted = receivingSummary?.total_accepted ?? items.reduce((sum, item) => sum + item.quantity_accepted, 0);
  const totalRejected = receivingSummary?.total_rejected ?? items.reduce((sum, item) => sum + item.quantity_rejected, 0);
  const totalRemaining = receivingSummary?.total_remaining ?? items.reduce((sum, item) => sum + item.quantity_remaining, 0);
  const progressPercentage = receivingSummary?.progress_percentage ?? (totalShipped > 0 ? (totalReceived / totalShipped) * 100 : 0);

  if (loading) {
    return (
      <>
        <Navbar activeItem="product" />
        <div className={styles.pageLayout}>
          <div className={styles.loadingContainer}>
            <div className={styles.spinner} />
            <p>Loading session...</p>
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
          <div className={styles.errorContainer}>
            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#DC2626" strokeWidth="1.5">
              <circle cx="12" cy="12" r="10" />
              <path d="M15 9l-6 6M9 9l6 6" />
            </svg>
            <h2>Failed to load session</h2>
            <p>{error}</p>
            <button className={styles.backButton} onClick={handleBack}>
              Back to Receives
            </button>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          {/* Header */}
          <div className={styles.header}>
            <div className={styles.headerLeft}>
              <button className={styles.backButton} onClick={handleBack}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M19 12H5M12 19l-7-7 7-7" />
                </svg>
                Back
              </button>
              <div className={styles.titleSection}>
                <h1 className={styles.title}>Receiving Session</h1>
                <div className={styles.sessionBadge}>
                  <span className={styles.badgeActive}>Active</span>
                  <span className={styles.storeName}>{sessionInfo?.store_name}</span>
                  {shipmentData && (
                    <span className={styles.shipmentBadge}>
                      {shipmentData.shipment_number}
                    </span>
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* Shipment Info Banner */}
          {shipmentData && (
            <div className={styles.shipmentBanner}>
              <div className={styles.shipmentBannerContent}>
                <div className={styles.shipmentBannerLeft}>
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                    <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                    <line x1="12" y1="22.08" x2="12" y2="12" />
                  </svg>
                  <div className={styles.shipmentBannerInfo}>
                    <span className={styles.shipmentBannerLabel}>Shipment</span>
                    <span className={styles.shipmentBannerNumber}>{shipmentData.shipment_number}</span>
                  </div>
                </div>
                <div className={styles.shipmentBannerDetails}>
                  <div className={styles.shipmentBannerItem}>
                    <span className={styles.bannerItemLabel}>Supplier</span>
                    <span className={styles.bannerItemValue}>{shipmentData.supplier_name}</span>
                  </div>
                  <div className={styles.shipmentBannerItem}>
                    <span className={styles.bannerItemLabel}>Items</span>
                    <span className={styles.bannerItemValue}>{shipmentData.item_count}</span>
                  </div>
                  <div className={styles.shipmentBannerItem}>
                    <span className={styles.bannerItemLabel}>Status</span>
                    <span className={`${styles.bannerItemStatus} ${styles[shipmentData.status]}`}>
                      {shipmentData.status}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Items to Receive Card with Progress */}
          <div className={styles.itemsCard}>
            <div className={styles.itemsHeader}>
              <h3>Items to Receive</h3>
              <span className={styles.itemCount}>{items.length} items</span>
            </div>

            {/* Progress Section */}
            <div className={styles.progressSection}>
              <div className={styles.progressRow}>
                <div className={styles.progressBarContainer}>
                  <div
                    className={styles.progressBarFill}
                    style={{ width: `${progressPercentage}%` }}
                  />
                </div>
                <span className={styles.progressPercentage}>{progressPercentage.toFixed(0)}%</span>
              </div>
              <div className={styles.progressStats}>
                <div className={styles.statItem}>
                  <span className={styles.statLabel}>Shipped</span>
                  <span className={styles.statValue}>{totalShipped}</span>
                </div>
                <div className={styles.statItem}>
                  <span className={styles.statLabel}>Received</span>
                  <span className={styles.statValueBlue}>{totalReceived}</span>
                </div>
                <div className={styles.statItem}>
                  <span className={styles.statLabel}>Accepted</span>
                  <span className={styles.statValueGreen}>{totalAccepted}</span>
                </div>
                <div className={styles.statItem}>
                  <span className={styles.statLabel}>Rejected</span>
                  <span className={styles.statValueRed}>{totalRejected}</span>
                </div>
                <div className={styles.statItem}>
                  <span className={styles.statLabel}>Remaining</span>
                  <span className={styles.statValueOrange}>{totalRemaining}</span>
                </div>
              </div>
            </div>

            {/* Items Table */}
            {items.length === 0 ? (
              <div className={styles.emptyItems}>
                <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
                  <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                  <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                  <line x1="12" y1="22.08" x2="12" y2="12" />
                </svg>
                <p>No items to display</p>
                <span>Session data is loading or no items available</span>
              </div>
            ) : (
              <div className={styles.tableContainer}>
                <table className={styles.itemsTable}>
                  <thead>
                    <tr>
                      <th className={styles.thProduct}>Product</th>
                      <th className={styles.thSku}>SKU</th>
                      <th className={styles.thNumber}>Shipped</th>
                      <th className={styles.thNumber}>Received</th>
                      <th className={styles.thNumber}>Accepted</th>
                      <th className={styles.thNumber}>Rejected</th>
                      <th className={styles.thNumber}>Remaining</th>
                    </tr>
                  </thead>
                  <tbody>
                    {items.map((item) => (
                      <tr key={item.item_id}>
                        <td className={styles.tdProduct}>{item.product_name}</td>
                        <td className={styles.tdSku}>{item.sku}</td>
                        <td className={styles.tdNumber}>{item.quantity_shipped}</td>
                        <td className={styles.tdNumberBlue}>{item.quantity_received}</td>
                        <td className={styles.tdNumberGreen}>{item.quantity_accepted}</td>
                        <td className={styles.tdNumberRed}>{item.quantity_rejected}</td>
                        <td className={styles.tdNumberOrange}>{item.quantity_remaining}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>

          {/* Receive Product Section */}
          <div className={styles.receiveSection}>
            <h3 className={styles.receiveSectionTitle}>Receive Product</h3>

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
                      type="text"
                      className={styles.searchInput}
                      placeholder="Search by SKU, barcode, or product name..."
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                    />
                    {searchQuery && (
                      <button
                        className={styles.clearSearchButton}
                        onClick={() => {
                          setSearchQuery('');
                          setSearchResults([]);
                        }}
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
                        onClick={() => handleSelectProduct({
                          product_id: product.product_id,
                          product_name: product.product_name,
                          sku: product.sku,
                          barcode: product.barcode,
                        })}
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
                          <span className={styles.resultName}>{product.product_name}</span>
                          <span className={styles.resultMeta}>
                            {product.sku} • Selling price: {currency.symbol}{product.price.selling.toLocaleString()}
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

                {/* Selected Product Card */}
                {selectedProduct && (
                  <div className={styles.selectedProductCard}>
                    <div className={styles.selectedProductHeader}>
                      <div className={styles.selectedProductInfo}>
                        <span className={styles.selectedProductName}>{selectedProduct.product_name}</span>
                        <span className={styles.selectedProductSku}>{selectedProduct.sku}</span>
                      </div>
                      <button
                        className={styles.removeProductButton}
                        onClick={() => setSelectedProduct(null)}
                      >
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <path d="M18 6L6 18M6 6l12 12" />
                        </svg>
                      </button>
                    </div>

                    <div className={styles.receiveForm}>
                      {/* Quantity Input */}
                      <div className={styles.formField}>
                        <label className={styles.formFieldLabel}>Quantity</label>
                        <div className={styles.quantityInputGroup}>
                          <button
                            className={styles.quantityButton}
                            onClick={() => setReceiveQuantity(Math.max(1, receiveQuantity - 1))}
                          >
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                              <path d="M5 12h14" />
                            </svg>
                          </button>
                          <input
                            type="number"
                            className={styles.quantityInput}
                            value={receiveQuantity}
                            onChange={(e) => setReceiveQuantity(Math.max(1, parseInt(e.target.value) || 1))}
                            min="1"
                          />
                          <button
                            className={styles.quantityButton}
                            onClick={() => setReceiveQuantity(receiveQuantity + 1)}
                          >
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                              <path d="M12 5v14M5 12h14" />
                            </svg>
                          </button>
                        </div>
                      </div>

                      {/* Status Toggle */}
                      <div className={styles.formField}>
                        <label className={styles.formFieldLabel}>Status</label>
                        <div className={styles.statusToggle}>
                          <button
                            className={`${styles.statusButton} ${receiveStatus === 'accepted' ? styles.statusButtonAccepted : ''}`}
                            onClick={() => setReceiveStatus('accepted')}
                          >
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                              <path d="M20 6L9 17l-5-5" />
                            </svg>
                            Accepted
                          </button>
                          <button
                            className={`${styles.statusButton} ${receiveStatus === 'rejected' ? styles.statusButtonRejected : ''}`}
                            onClick={() => setReceiveStatus('rejected')}
                          >
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                              <path d="M18 6L6 18M6 6l12 12" />
                            </svg>
                            Rejected
                          </button>
                        </div>
                      </div>

                      {/* Notes (optional) */}
                      <div className={styles.formField}>
                        <label className={styles.formFieldLabel}>Notes (optional)</label>
                        <input
                          type="text"
                          className={styles.notesInput}
                          placeholder="Add notes..."
                          value={receiveNotes}
                          onChange={(e) => setReceiveNotes(e.target.value)}
                        />
                      </div>

                      {/* Submit Button */}
                      <button
                        className={styles.submitReceiveButton}
                        onClick={handleReceiveSubmit}
                      >
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <path d="M12 5v14M5 12h14" />
                        </svg>
                        Add to Received
                      </button>
                    </div>
                  </div>
                )}
              </div>

              {/* Right: Received Entries Table */}
              <div className={styles.receivedEntriesArea}>
                <div className={styles.entriesHeader}>
                  <h4>Received Items</h4>
                  <span className={styles.entriesCount}>{receivedEntries.length} entries</span>
                </div>

                {receivedEntries.length === 0 ? (
                  <div className={styles.emptyEntries}>
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#CBD5E1" strokeWidth="1.5">
                      <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                      <rect x="9" y="3" width="6" height="4" rx="1" />
                      <path d="M9 12h6M9 16h6" />
                    </svg>
                    <p>No items received yet</p>
                    <span>Search and add products to start receiving</span>
                  </div>
                ) : (
                  <div className={styles.entriesTableContainer}>
                    <table className={styles.entriesTable}>
                      <thead>
                        <tr>
                          <th>Product</th>
                          <th>SKU</th>
                          <th>Qty</th>
                          <th>Status</th>
                          <th>Notes</th>
                        </tr>
                      </thead>
                      <tbody>
                        {receivedEntries.map((entry) => (
                          <tr key={entry.entry_id}>
                            <td className={styles.entryProduct}>{entry.product_name}</td>
                            <td className={styles.entrySku}>{entry.sku}</td>
                            <td className={styles.entryQty}>{entry.quantity}</td>
                            <td>
                              <span className={`${styles.entryStatus} ${entry.status === 'accepted' ? styles.entryStatusAccepted : styles.entryStatusRejected}`}>
                                {entry.status}
                              </span>
                            </td>
                            <td className={styles.entryNotes}>{entry.notes || '-'}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                )}
              </div>
            </div>

            {/* Action Buttons */}
            <div className={styles.actionButtons}>
              <button className={styles.saveButton}>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                  <polyline points="17 21 17 13 7 13 7 21" />
                  <polyline points="7 3 7 8 15 8" />
                </svg>
                Save
              </button>
              <button
                className={`${styles.submitButton} ${sessionInfo?.created_by !== currentUser?.user_id ? styles.submitButtonDisabled : ''}`}
                disabled={sessionInfo?.created_by !== currentUser?.user_id}
                title={sessionInfo?.created_by !== currentUser?.user_id ? 'Only the session owner can submit' : ''}
              >
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M22 2L11 13" />
                  <path d="M22 2l-7 20-4-9-9-4 20-7z" />
                </svg>
                Submit
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default ReceivingSessionPage;
