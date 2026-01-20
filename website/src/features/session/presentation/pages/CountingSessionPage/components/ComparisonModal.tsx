/**
 * ComparisonModal Component
 * Modal for displaying session comparison results and merge functionality
 */

import React from 'react';
import type { SessionComparisonResult } from '../../../hooks/useCountingSessionDetail';
import styles from '../CountingSessionPage.module.css';

interface ComparisonModalProps {
  isOpen: boolean;
  comparisonResult: SessionComparisonResult | null;
  comparisonError: string | null;
  isMerging: boolean;
  mergeError: string | null;
  onClose: () => void;
  onMerge: () => void;
}

export const ComparisonModal: React.FC<ComparisonModalProps> = ({
  isOpen,
  comparisonResult,
  comparisonError,
  isMerging,
  mergeError,
  onClose,
  onMerge,
}) => {
  if (!isOpen || !comparisonResult) return null;

  return (
    <div className={styles.modalBackdrop} onClick={onClose}>
      <div className={styles.comparisonModal} onClick={(e) => e.stopPropagation()}>
        <div className={styles.modalHeader}>
          <h3>Session Comparison</h3>
          <button className={styles.modalCloseButton} onClick={onClose}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M18 6L6 18M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div className={styles.comparisonContent}>
          {/* Session Info Header */}
          <div className={styles.comparisonSessions}>
            <div className={styles.comparisonSessionInfo}>
              <span className={styles.comparisonSessionLabel}>Current Session (A)</span>
              <span className={styles.comparisonSessionName}>{comparisonResult.sessionA.sessionName}</span>
              <span className={styles.comparisonSessionMeta}>
                {comparisonResult.sessionA.totalProducts} products • {comparisonResult.sessionA.totalQuantity} items
              </span>
            </div>
            <div className={styles.comparisonVs}>vs</div>
            <div className={styles.comparisonSessionInfo}>
              <span className={styles.comparisonSessionLabel}>Selected Session (B)</span>
              <span className={styles.comparisonSessionName}>{comparisonResult.sessionB.sessionName}</span>
              <span className={styles.comparisonSessionMeta}>
                {comparisonResult.sessionB.totalProducts} products • {comparisonResult.sessionB.totalQuantity} items
              </span>
            </div>
          </div>

          {comparisonError && (
            <div className={styles.comparisonError}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <circle cx="12" cy="12" r="10" />
                <path d="M15 9l-6 6M9 9l6 6" />
              </svg>
              {comparisonError}
            </div>
          )}

          {/* Two Column Comparison Layout */}
          <div className={styles.comparisonTwoColumnLayout}>
            {/* Column A - Current Session */}
            <div className={styles.comparisonColumn}>
              <div className={`${styles.comparisonColumnHeader} ${styles.columnHeaderBlue}`}>
                <span className={styles.columnSessionName}>{comparisonResult.sessionA.sessionName}</span>
                <span className={styles.columnItemCount}>{comparisonResult.onlyInA.length} unique products</span>
              </div>
              <div className={styles.comparisonColumnContent}>
                {comparisonResult.onlyInA.length > 0 ? (
                  <table className={styles.comparisonColumnTable}>
                    <thead>
                      <tr>
                        <th>SKU</th>
                        <th>Product</th>
                        <th className={styles.thNumber}>Qty</th>
                      </tr>
                    </thead>
                    <tbody>
                      {comparisonResult.onlyInA.map((item) => (
                        <tr key={item.productId}>
                          <td className={styles.comparisonSku}>{item.sku}</td>
                          <td className={styles.comparisonProduct}>{item.productName}</td>
                          <td className={styles.comparisonNumber}>
                            <span className={styles.quantityBlue}>{item.quantity}</span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                ) : (
                  <div className={styles.columnEmptyState}>
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="1.5">
                      <path d="M20 6L9 17l-5-5" />
                    </svg>
                    <p>No unique products</p>
                  </div>
                )}
              </div>
            </div>

            {/* Column B - Selected Session */}
            <div className={styles.comparisonColumn}>
              <div className={`${styles.comparisonColumnHeader} ${styles.columnHeaderOrange}`}>
                <span className={styles.columnSessionName}>{comparisonResult.sessionB.sessionName}</span>
                <span className={styles.columnItemCount}>{comparisonResult.onlyInB.length} unique products</span>
              </div>
              <div className={styles.comparisonColumnContent}>
                {comparisonResult.onlyInB.length > 0 ? (
                  <table className={styles.comparisonColumnTable}>
                    <thead>
                      <tr>
                        <th>SKU</th>
                        <th>Product</th>
                        <th className={styles.thNumber}>Qty</th>
                      </tr>
                    </thead>
                    <tbody>
                      {comparisonResult.onlyInB.map((item) => (
                        <tr key={item.productId}>
                          <td className={styles.comparisonSku}>{item.sku}</td>
                          <td className={styles.comparisonProduct}>{item.productName}</td>
                          <td className={styles.comparisonNumber}>
                            <span className={styles.quantityOrange}>{item.quantity}</span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                ) : (
                  <div className={styles.columnEmptyState}>
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="1.5">
                      <path d="M20 6L9 17l-5-5" />
                    </svg>
                    <p>No unique products</p>
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* Matched Products Section - Collapsed by default */}
          {comparisonResult.matched.length > 0 && (
            <details className={styles.matchedProductsDetails}>
              <summary className={styles.matchedProductsSummary}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M20 6L9 17l-5-5" />
                </svg>
                Matched Products ({comparisonResult.matched.length})
                <span className={styles.matchedSummaryInfo}>
                  {comparisonResult.summary.quantitySameCount} same, {comparisonResult.summary.quantityDiffCount} different
                </span>
              </summary>
              <div className={styles.comparisonTableContainer}>
                <table className={styles.comparisonTable}>
                  <thead>
                    <tr>
                      <th>SKU</th>
                      <th>Product</th>
                      <th className={styles.thNumber}>{comparisonResult.sessionA.sessionName}</th>
                      <th className={styles.thNumber}>{comparisonResult.sessionB.sessionName}</th>
                      <th className={styles.thNumber}>Diff</th>
                      <th className={styles.thNumber}>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {comparisonResult.matched.map((item) => (
                      <tr key={item.productId} className={item.isMatch ? styles.rowMatch : styles.rowMismatch}>
                        <td className={styles.comparisonSku}>{item.sku}</td>
                        <td className={styles.comparisonProduct}>{item.productName}</td>
                        <td className={styles.comparisonNumber}>
                          <span className={styles.quantityBlue}>{item.quantityA}</span>
                        </td>
                        <td className={styles.comparisonNumber}>
                          <span className={styles.quantityOrange}>{item.quantityB}</span>
                        </td>
                        <td className={styles.comparisonNumber}>
                          {item.quantityDiff !== 0 ? (
                            <span className={item.quantityDiff > 0 ? styles.quantityDiffPositive : styles.quantityDiffNegative}>
                              {item.quantityDiff > 0 ? '+' : ''}{item.quantityDiff}
                            </span>
                          ) : (
                            <span className={styles.quantityEmpty}>0</span>
                          )}
                        </td>
                        <td className={styles.comparisonNumber}>
                          {item.isMatch ? (
                            <span className={styles.statusMatch}>Match</span>
                          ) : (
                            <span className={styles.statusMismatch}>Diff</span>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </details>
          )}

          {/* Empty State */}
          {comparisonResult.matched.length === 0 &&
           comparisonResult.onlyInA.length === 0 &&
           comparisonResult.onlyInB.length === 0 && !comparisonError && (
            <div className={styles.noComparisonItems}>
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="1.5">
                <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                <rect x="9" y="3" width="6" height="4" rx="1" />
              </svg>
              <p>No items in either session</p>
            </div>
          )}
        </div>

        {/* Merge Error */}
        {mergeError && (
          <div className={styles.mergeError}>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="10" />
              <path d="M15 9l-6 6M9 9l6 6" />
            </svg>
            {mergeError}
          </div>
        )}

        <div className={styles.comparisonActions}>
          <button className={styles.closeComparisonButton} onClick={onClose}>
            Close
          </button>
          <button
            className={`${styles.mergeButton} ${isMerging ? styles.mergeButtonLoading : ''}`}
            onClick={onMerge}
            disabled={isMerging || (comparisonResult.matched.length === 0 && comparisonResult.onlyInB.length === 0)}
          >
            {isMerging ? (
              <>
                <div className={styles.buttonSpinner} />
                Merging...
              </>
            ) : (
              <>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01" />
                </svg>
                Merge
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default ComparisonModal;
