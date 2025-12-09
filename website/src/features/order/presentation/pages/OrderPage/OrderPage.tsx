/**
 * OrderPage Component
 * Purchase Orders management with left filter sidebar
 */

import React, { useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { useOrderList, formatDateDisplay } from '../../hooks/useOrderList';
import { ORDER_STATUS_OPTIONS, RECEIVING_STATUS_OPTIONS } from './OrderPage.types';
import styles from './OrderPage.module.css';

export const OrderPage: React.FC = () => {
  const navigate = useNavigate();
  const datePickerRef = useRef<HTMLDivElement>(null);

  const {
    currency,
    suppliers,
    suppliersLoading,
    orders,
    ordersLoading,
    searchQuery,
    datePreset,
    fromDate,
    toDate,
    showDatePicker,
    tempFromDate,
    tempToDate,
    orderStatusFilter,
    receivingStatusFilter,
    selectedSupplier,
    supplierOptions,
    handleSearchChange,
    toggleOrderStatus,
    toggleReceivingStatus,
    clearOrderStatusFilter,
    clearReceivingStatusFilter,
    handlePresetChange,
    handleApplyCustomDate,
    handleCancelCustomDate,
    handleSetTodayDate,
    setTempFromDate,
    setTempToDate,
    setSelectedSupplier,
  } = useOrderList();

  // Click outside to close date picker
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (datePickerRef.current && !datePickerRef.current.contains(event.target as Node)) {
        handleCancelCustomDate();
      }
    };

    if (showDatePicker) {
      document.addEventListener('mousedown', handleClickOutside);
    }
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [showDatePicker, handleCancelCustomDate]);

  // LeftFilter sections configuration
  const filterSections: FilterSection[] = [
    {
      id: 'orderDate',
      title: 'Order Date',
      type: 'custom',
      defaultExpanded: true,
      customContent: (
        <div className={styles.dateFilterContent}>
          <label className={styles.datePresetOption}>
            <input
              type="radio"
              name="datePreset"
              checked={datePreset === 'this_month'}
              onChange={() => handlePresetChange('this_month')}
              className={styles.radioInput}
            />
            <span className={styles.radioLabel}>This Month</span>
          </label>

          <label className={styles.datePresetOption}>
            <input
              type="radio"
              name="datePreset"
              checked={datePreset === 'last_month'}
              onChange={() => handlePresetChange('last_month')}
              className={styles.radioInput}
            />
            <span className={styles.radioLabel}>Last Month</span>
          </label>

          <label className={styles.datePresetOption}>
            <input
              type="radio"
              name="datePreset"
              checked={datePreset === 'this_year'}
              onChange={() => handlePresetChange('this_year')}
              className={styles.radioInput}
            />
            <span className={styles.radioLabel}>This Year</span>
          </label>

          <label className={styles.datePresetOption}>
            <input
              type="radio"
              name="datePreset"
              checked={datePreset === 'custom'}
              onChange={() => handlePresetChange('custom')}
              className={styles.radioInput}
            />
            <div
              className={`${styles.customDateButton} ${datePreset === 'custom' ? styles.active : ''}`}
              onClick={(e) => {
                e.preventDefault();
                handlePresetChange('custom');
              }}
            >
              <span>Custom</span>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                <path d="M19,19H5V8H19M16,1V3H8V1H6V3H5C3.89,3 3,3.89 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5C21,3.89 20.1,3 19,3H18V1M17,12H12V17H17V12Z" />
              </svg>
            </div>
          </label>

          {(fromDate || toDate) && (
            <div className={styles.selectedDateRange}>
              <span className={styles.dateRangeText}>
                {formatDateDisplay(fromDate)} ~ {formatDateDisplay(toDate)}
              </span>
            </div>
          )}
        </div>
      ),
    },
    {
      id: 'orderStatus',
      title: 'Order Status',
      type: 'multiselect',
      defaultExpanded: true,
      showCount: true,
      options: ORDER_STATUS_OPTIONS,
      selectedValues: orderStatusFilter,
      onToggle: toggleOrderStatus,
      onClear: clearOrderStatusFilter,
    },
    {
      id: 'receivingStatus',
      title: 'Receiving Status',
      type: 'multiselect',
      defaultExpanded: true,
      showCount: true,
      options: RECEIVING_STATUS_OPTIONS,
      selectedValues: receivingStatusFilter,
      onToggle: toggleReceivingStatus,
      onClear: clearReceivingStatusFilter,
    },
    {
      id: 'supplier',
      title: 'Supplier',
      type: 'custom',
      defaultExpanded: true,
      customContent: (
        <div className={styles.supplierFilterContent}>
          <TossSelector
            placeholder={suppliersLoading ? 'Loading suppliers...' : 'Select supplier'}
            value={selectedSupplier ?? undefined}
            options={supplierOptions}
            onChange={(value) => setSelectedSupplier(value || null)}
            searchable
            fullWidth
            disabled={suppliersLoading}
            showDescriptions
          />
        </div>
      ),
    },
  ];

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
              <h1 className={styles.title}>Purchase Orders</h1>
              <p className={styles.subtitle}>Manage and track purchase orders</p>
            </div>

            <div className={styles.contentCard}>
              <div className={styles.orderHeader}>
                <div className={styles.orderTitleSection}>
                  <h2 className={styles.orderListTitle}>Orders</h2>
                  <div className={styles.orderSearchWrapper}>
                    <svg className={styles.searchIcon} width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <circle cx="11" cy="11" r="8" />
                      <path d="m21 21-4.35-4.35" />
                    </svg>
                    <input
                      type="text"
                      className={styles.orderSearch}
                      placeholder="Search orders..."
                      value={searchQuery}
                      onChange={(e) => handleSearchChange(e.target.value)}
                    />
                  </div>
                </div>
                <div className={styles.orderActions}>
                  <button
                    className={styles.primaryButton}
                    onClick={() => navigate('/product/order/create', { state: { currency, suppliers } })}
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <line x1="12" y1="5" x2="12" y2="19" />
                      <line x1="5" y1="12" x2="19" y2="12" />
                    </svg>
                    New Order
                  </button>
                </div>
              </div>

              <div className={styles.tableContainer}>
                <table className={styles.ordersTable}>
                  <thead>
                    <tr>
                      <th>Order #</th>
                      <th>Order Date</th>
                      <th>Supplier</th>
                      <th>Total Amount</th>
                      <th>Order Status</th>
                      <th>Receiving Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {ordersLoading ? (
                      <tr>
                        <td colSpan={7}>
                          <div className={styles.loadingState}>
                            <div className={styles.spinner} />
                            <p>Loading orders...</p>
                          </div>
                        </td>
                      </tr>
                    ) : orders.length > 0 ? (
                      orders.map((order) => (
                        <tr key={order.order_id}>
                          <td>
                            <span className={styles.orderNumber}>{order.order_number}</span>
                          </td>
                          <td>{formatDateDisplay(order.order_date.split(' ')[0])}</td>
                          <td>
                            <span className={styles.supplierName}>{order.supplier_name}</span>
                          </td>
                          <td>
                            <span className={styles.currencyAmount}>
                              {currency.symbol}{order.total_amount.toLocaleString()}
                            </span>
                          </td>
                          <td>
                            <span className={`${styles.statusBadge} ${styles[order.order_status]}`}>
                              {order.order_status}
                            </span>
                          </td>
                          <td>
                            <span className={`${styles.statusBadge} ${styles[order.receiving_status]}`}>
                              {order.receiving_status}
                            </span>
                          </td>
                          <td>
                            <button
                              className={styles.viewButton}
                              onClick={() => navigate(`/product/order/${order.order_id}`)}
                            >
                              View
                            </button>
                          </td>
                        </tr>
                      ))
                    ) : (
                      <tr>
                        <td colSpan={7}>
                          <div className={styles.emptyState}>
                            <svg className={styles.emptyIcon} width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
                              <path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2" />
                              <rect x="9" y="3" width="6" height="4" rx="1" />
                              <path d="M9 14h.01" />
                              <path d="M13 14h.01" />
                              <path d="M9 17h.01" />
                              <path d="M13 17h.01" />
                            </svg>
                            <p className={styles.emptyTitle}>No orders found</p>
                            <p className={styles.emptyDescription}>
                              {searchQuery ? 'Try adjusting your search or filters' : 'Create your first purchase order'}
                            </p>
                          </div>
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>

      {showDatePicker && (
        <div className={styles.datePickerOverlay}>
          <div className={styles.datePickerModal} ref={datePickerRef}>
            <div className={styles.datePickerHeader}>
              <span>From date: <strong>{formatDateDisplay(tempFromDate) || 'Select'}</strong></span>
              <span> - </span>
              <span>To date: <strong>{formatDateDisplay(tempToDate) || 'Select'}</strong></span>
            </div>

            <div className={styles.datePickerBody}>
              <div className={styles.calendarContainer}>
                <div className={styles.calendarSection}>
                  <label className={styles.calendarLabel}>From Date</label>
                  <input
                    type="date"
                    className={styles.calendarInput}
                    value={tempFromDate}
                    onChange={(e) => setTempFromDate(e.target.value)}
                  />
                </div>
                <div className={styles.calendarSection}>
                  <label className={styles.calendarLabel}>To Date</label>
                  <input
                    type="date"
                    className={styles.calendarInput}
                    value={tempToDate}
                    onChange={(e) => setTempToDate(e.target.value)}
                  />
                </div>
              </div>
            </div>

            <div className={styles.datePickerFooter}>
              <button className={styles.todayButton} onClick={handleSetTodayDate}>
                Today
              </button>
              <div className={styles.datePickerActions}>
                <button className={styles.cancelButton} onClick={handleCancelCustomDate}>
                  Cancel
                </button>
                <button
                  className={styles.applyButton}
                  onClick={handleApplyCustomDate}
                  disabled={!tempFromDate || !tempToDate}
                >
                  Apply
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default OrderPage;
