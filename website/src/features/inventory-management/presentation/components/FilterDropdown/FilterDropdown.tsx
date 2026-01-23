/**
 * FilterDropdown Component
 * Dropdown for filtering and sorting inventory list
 */

import React, { useState, useRef, useEffect } from 'react';
import type { FilterType } from '../../providers/states/inventory_state';
import styles from './FilterDropdown.module.css';

interface FilterDropdownProps {
  filterType: FilterType;
  selectedBrandFilter: string | null;
  selectedCategoryFilter: string | null;
  brands: string[];
  categories: string[];
  onFilterChange: (filterType: FilterType) => void;
  onBrandFilterChange: (brand: string | null) => void;
  onCategoryFilterChange: (category: string | null) => void;
}

export const FilterDropdown: React.FC<FilterDropdownProps> = ({
  filterType,
  selectedBrandFilter,
  selectedCategoryFilter,
  brands,
  categories,
  onFilterChange,
  onBrandFilterChange,
  onCategoryFilterChange,
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [isBrandSubmenuOpen, setIsBrandSubmenuOpen] = useState(false);
  const [isCategorySubmenuOpen, setIsCategorySubmenuOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
        setIsBrandSubmenuOpen(false);
        setIsCategorySubmenuOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const toggleDropdown = () => {
    setIsOpen(!isOpen);
    if (isOpen) {
      setIsBrandSubmenuOpen(false);
      setIsCategorySubmenuOpen(false);
    }
  };

  const handleFilterSelect = (filter: FilterType) => {
    if (filter === 'brand') {
      setIsBrandSubmenuOpen(true);
      setIsCategorySubmenuOpen(false);
    } else if (filter === 'category') {
      setIsCategorySubmenuOpen(true);
      setIsBrandSubmenuOpen(false);
    } else {
      onFilterChange(filter);
      onBrandFilterChange(null);
      onCategoryFilterChange(null);
      setIsOpen(false);
      setIsBrandSubmenuOpen(false);
      setIsCategorySubmenuOpen(false);
    }
  };

  const handleBrandSelect = (brand: string) => {
    onFilterChange('brand');
    onBrandFilterChange(brand);
    onCategoryFilterChange(null);
    setIsOpen(false);
    setIsBrandSubmenuOpen(false);
    setIsCategorySubmenuOpen(false);
  };

  const handleCategorySelect = (category: string) => {
    onFilterChange('category');
    onCategoryFilterChange(category);
    onBrandFilterChange(null);
    setIsOpen(false);
    setIsBrandSubmenuOpen(false);
    setIsCategorySubmenuOpen(false);
  };

  const getFilterLabel = () => {
    if (filterType === 'brand' && selectedBrandFilter) {
      return `Brand: ${selectedBrandFilter}`;
    }
    if (filterType === 'category' && selectedCategoryFilter) {
      return `Category: ${selectedCategoryFilter}`;
    }

    const labels: Record<FilterType, string> = {
      newest: 'Newest',
      oldest: 'Oldest',
      price_high: 'Price: High to Low',
      price_low: 'Price: Low to High',
      cost_high: 'Cost: High to Low',
      cost_low: 'Cost: Low to High',
      brand: 'Brand',
      category: 'Category',
    };

    return labels[filterType];
  };

  return (
    <div className={styles.filterContainer} ref={dropdownRef}>
      <button
        className={styles.filterButton}
        onClick={toggleDropdown}
        aria-label="Filter products"
      >
        <svg className={styles.filterIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
          <path d="M10,18h4v-2h-4V18z M3,6v2h18V6H3z M6,13h12v-2H6V13z"/>
        </svg>
        <span>{getFilterLabel()}</span>
        <svg
          className={`${styles.dropdownArrow} ${isOpen ? styles.dropdownArrowOpen : ''}`}
          width="12"
          height="12"
          fill="currentColor"
          viewBox="0 0 24 24"
        >
          <path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z"/>
        </svg>
      </button>

      {isOpen && (
        <div className={styles.dropdownMenu}>
          <button
            className={`${styles.dropdownItem} ${filterType === 'newest' ? styles.active : ''}`}
            onClick={() => handleFilterSelect('newest')}
          >
            <span>Newest</span>
            {filterType === 'newest' && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <button
            className={`${styles.dropdownItem} ${filterType === 'oldest' ? styles.active : ''}`}
            onClick={() => handleFilterSelect('oldest')}
          >
            <span>Oldest</span>
            {filterType === 'oldest' && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <div className={styles.divider} />

          <button
            className={`${styles.dropdownItem} ${filterType === 'price_high' ? styles.active : ''}`}
            onClick={() => handleFilterSelect('price_high')}
          >
            <span>Price: High to Low</span>
            {filterType === 'price_high' && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <button
            className={`${styles.dropdownItem} ${filterType === 'price_low' ? styles.active : ''}`}
            onClick={() => handleFilterSelect('price_low')}
          >
            <span>Price: Low to High</span>
            {filterType === 'price_low' && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <div className={styles.divider} />

          <button
            className={`${styles.dropdownItem} ${filterType === 'cost_high' ? styles.active : ''}`}
            onClick={() => handleFilterSelect('cost_high')}
          >
            <span>Cost: High to Low</span>
            {filterType === 'cost_high' && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <button
            className={`${styles.dropdownItem} ${filterType === 'cost_low' ? styles.active : ''}`}
            onClick={() => handleFilterSelect('cost_low')}
          >
            <span>Cost: Low to High</span>
            {filterType === 'cost_low' && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z"/>
              </svg>
            )}
          </button>

          <div className={styles.divider} />

          <div className={styles.brandMenuItem}>
            <button
              className={`${styles.dropdownItem} ${filterType === 'category' ? styles.active : ''}`}
              onClick={() => handleFilterSelect('category')}
            >
              <span>Category</span>
              <svg className={styles.chevronRight} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z"/>
              </svg>
            </button>

            {isCategorySubmenuOpen && (
              <div className={styles.brandSubmenu}>
                {!categories || categories.length === 0 ? (
                  <div className={styles.emptyBrands}>No categories available</div>
                ) : (
                  categories.map((category) => (
                    <button
                      key={category}
                      className={`${styles.dropdownItem} ${
                        filterType === 'category' && selectedCategoryFilter === category ? styles.active : ''
                      }`}
                      onClick={() => handleCategorySelect(category)}
                    >
                      <span>{category}</span>
                      {filterType === 'category' && selectedCategoryFilter === category && (
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

          <div className={styles.brandMenuItem}>
            <button
              className={`${styles.dropdownItem} ${filterType === 'brand' ? styles.active : ''}`}
              onClick={() => handleFilterSelect('brand')}
            >
              <span>Brand</span>
              <svg className={styles.chevronRight} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z"/>
              </svg>
            </button>

            {isBrandSubmenuOpen && (
              <div className={styles.brandSubmenu}>
                {!brands || brands.length === 0 ? (
                  <div className={styles.emptyBrands}>No brands available</div>
                ) : (
                  brands.map((brand) => (
                    <button
                      key={brand}
                      className={`${styles.dropdownItem} ${
                        filterType === 'brand' && selectedBrandFilter === brand ? styles.active : ''
                      }`}
                      onClick={() => handleBrandSelect(brand)}
                    >
                      <span>{brand}</span>
                      {filterType === 'brand' && selectedBrandFilter === brand && (
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
        </div>
      )}
    </div>
  );
};

export default FilterDropdown;
