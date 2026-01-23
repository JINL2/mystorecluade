/**
 * FilterSidebar Component
 * Left sidebar for filtering and sorting inventory list
 * Supports multi-select for Brand and Category
 */

import React, { useState } from 'react';
import type { FilterType } from '../../providers/states/inventory_state';
import styles from './FilterSidebar.module.css';

interface FilterSidebarProps {
  filterType: FilterType;
  selectedBrandFilter: Set<string>;
  selectedCategoryFilter: Set<string>;
  brands: string[];
  categories: string[];
  onFilterChange: (filterType: FilterType) => void;
  onBrandFilterToggle: (brand: string) => void;
  onCategoryFilterToggle: (category: string) => void;
  onClearBrandFilter: () => void;
  onClearCategoryFilter: () => void;
}

export const FilterSidebar: React.FC<FilterSidebarProps> = ({
  filterType,
  selectedBrandFilter,
  selectedCategoryFilter,
  brands,
  categories,
  onFilterChange,
  onBrandFilterToggle,
  onCategoryFilterToggle,
  onClearBrandFilter,
  onClearCategoryFilter,
}) => {
  // Default: Only 'sort' is expanded, 'category' and 'brand' are collapsed
  const [expandedSections, setExpandedSections] = useState<Set<string>>(new Set(['sort']));

  const toggleSection = (section: string) => {
    const newExpanded = new Set(expandedSections);
    if (newExpanded.has(section)) {
      newExpanded.delete(section);
    } else {
      newExpanded.add(section);
    }
    setExpandedSections(newExpanded);
  };

  const handleFilterSelect = (filter: FilterType) => {
    onFilterChange(filter);
  };

  const isSortFilterActive = (filter: FilterType) => {
    return filterType === filter && filter !== 'brand' && filter !== 'category';
  };

  const isBrandFilterActive = (brand: string) => {
    return selectedBrandFilter.has(brand);
  };

  const isCategoryFilterActive = (category: string) => {
    return selectedCategoryFilter.has(category);
  };

  return (
    <aside className={styles.filterSidebar}>
      {/* Sorting section - Always expanded */}
      <div className={styles.filterSection}>
        <div className={styles.filterSectionHeader}>
          <span className={styles.filterSectionTitle}>Sort by</span>
        </div>

        <div className={styles.filterOptions}>
          <button
            className={`${styles.filterButton} ${isSortFilterActive('newest') ? styles.active : ''}`}
            onClick={() => handleFilterSelect('newest')}
          >
            <span>Newest</span>
            {isSortFilterActive('newest') && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <button
            className={`${styles.filterButton} ${isSortFilterActive('oldest') ? styles.active : ''}`}
            onClick={() => handleFilterSelect('oldest')}
          >
            <span>Oldest</span>
            {isSortFilterActive('oldest') && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <button
            className={`${styles.filterButton} ${isSortFilterActive('price_high') ? styles.active : ''}`}
            onClick={() => handleFilterSelect('price_high')}
          >
            <span>Price: High to Low</span>
            {isSortFilterActive('price_high') && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <button
            className={`${styles.filterButton} ${isSortFilterActive('price_low') ? styles.active : ''}`}
            onClick={() => handleFilterSelect('price_low')}
          >
            <span>Price: Low to High</span>
            {isSortFilterActive('price_low') && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <button
            className={`${styles.filterButton} ${isSortFilterActive('cost_high') ? styles.active : ''}`}
            onClick={() => handleFilterSelect('cost_high')}
          >
            <span>Cost: High to Low</span>
            {isSortFilterActive('cost_high') && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <button
            className={`${styles.filterButton} ${isSortFilterActive('cost_low') ? styles.active : ''}`}
            onClick={() => handleFilterSelect('cost_low')}
          >
            <span>Cost: Low to High</span>
            {isSortFilterActive('cost_low') && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>
        </div>
      </div>

      {/* Category filter section - Collapsible, Multi-select */}
      <div className={styles.filterSection}>
        <button
          className={styles.filterSectionHeader}
          onClick={() => toggleSection('category')}
        >
          <span className={styles.filterSectionTitle}>
            Category
            {selectedCategoryFilter.size > 0 && (
              <span className={styles.filterCount}> ({selectedCategoryFilter.size})</span>
            )}
          </span>
          <svg
            className={`${styles.expandIcon} ${expandedSections.has('category') ? styles.expanded : ''}`}
            width="20"
            height="20"
            fill="currentColor"
            viewBox="0 0 24 24"
          >
            <path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z"/>
          </svg>
        </button>

        {expandedSections.has('category') && (
          <div className={styles.filterOptions}>
            {/* Clear button */}
            {selectedCategoryFilter.size > 0 && (
              <button
                className={`${styles.filterButton} ${styles.clearButton}`}
                onClick={onClearCategoryFilter}
              >
                <span>Clear All</span>
                <svg className={styles.clearIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
                </svg>
              </button>
            )}

            {!categories || categories.length === 0 ? (
              <div className={styles.emptyState}>No categories available</div>
            ) : (
              categories.map((category) => (
                <button
                  key={category}
                  className={`${styles.filterButton} ${isCategoryFilterActive(category) ? styles.active : ''}`}
                  onClick={() => onCategoryFilterToggle(category)}
                >
                  <span>{category}</span>
                  {isCategoryFilterActive(category) && (
                    <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
                    </svg>
                  )}
                </button>
              ))
            )}
          </div>
        )}
      </div>

      {/* Brand filter section - Collapsible, Multi-select with None option */}
      <div className={styles.filterSection}>
        <button
          className={styles.filterSectionHeader}
          onClick={() => toggleSection('brand')}
        >
          <span className={styles.filterSectionTitle}>
            Brand
            {selectedBrandFilter.size > 0 && (
              <span className={styles.filterCount}> ({selectedBrandFilter.size})</span>
            )}
          </span>
          <svg
            className={`${styles.expandIcon} ${expandedSections.has('brand') ? styles.expanded : ''}`}
            width="20"
            height="20"
            fill="currentColor"
            viewBox="0 0 24 24"
          >
            <path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z"/>
          </svg>
        </button>

        {expandedSections.has('brand') && (
          <div className={styles.filterOptions}>
            {/* Clear button */}
            {selectedBrandFilter.size > 0 && (
              <button
                className={`${styles.filterButton} ${styles.clearButton}`}
                onClick={onClearBrandFilter}
              >
                <span>Clear All</span>
                <svg className={styles.clearIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
                </svg>
              </button>
            )}

            {!brands || brands.length === 0 ? (
              <div className={styles.emptyState}>No brands available</div>
            ) : (
              brands.map((brand) => (
                <button
                  key={brand}
                  className={`${styles.filterButton} ${isBrandFilterActive(brand) ? styles.active : ''}`}
                  onClick={() => onBrandFilterToggle(brand)}
                >
                  <span>{brand}</span>
                  {isBrandFilterActive(brand) && (
                    <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
                    </svg>
                  )}
                </button>
              ))
            )}
          </div>
        )}
      </div>
    </aside>
  );
};

export default FilterSidebar;
