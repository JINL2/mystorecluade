/**
 * TossSelector Component
 * Custom dropdown selector with button+menu approach (not native select)
 * Supports footer actions like "Add category" and "Add brand"
 */

import React, { useState, useEffect, useRef } from 'react';
import type { TossSelectorProps } from './TossSelector.types';
import styles from './TossSelector.module.css';

export const TossSelector: React.FC<TossSelectorProps> = ({
  id,
  name,
  label,
  placeholder = 'Select an option',
  value,
  options,
  onChange,
  showAddButton = false,
  addButtonText = 'Add new',
  onAddClick,
  disabled = false,
  error = false,
  errorMessage,
  helperText,
  required = false,
  fullWidth = false,
  loading = false,
  className = '',
  searchable = false,
  maxHeight = '320px',
  showDescriptions = false,
  emptyMessage = 'No options available',
  showBadges = false,
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const containerRef = useRef<HTMLDivElement>(null);
  const searchInputRef = useRef<HTMLInputElement>(null);

  // Filter options based on search term
  const filteredOptions = searchable && searchTerm
    ? options.filter(option =>
        option.label.toLowerCase().includes(searchTerm.toLowerCase()) ||
        (option.description && option.description.toLowerCase().includes(searchTerm.toLowerCase()))
      )
    : options;

  // Get selected option
  const selectedOption = options.find(opt => opt.value === value);
  const displayValue = selectedOption ? selectedOption.label : '';

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
        setSearchTerm('');
      }
    };

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [isOpen]);

  // Focus search input when dropdown opens
  useEffect(() => {
    if (isOpen && searchable && searchInputRef.current) {
      setTimeout(() => {
        searchInputRef.current?.focus();
      }, 100);
    }
  }, [isOpen, searchable]);

  const handleToggle = () => {
    if (!disabled) {
      setIsOpen(!isOpen);
    }
  };

  const handleOptionClick = (optionValue: string) => {
    const option = options.find(opt => opt.value === optionValue);
    if (option && !option.disabled) {
      onChange(optionValue, option);
      setIsOpen(false);
      setSearchTerm('');
    }
  };

  const handleAddClick = (e: React.MouseEvent) => {
    e.stopPropagation();
    if (onAddClick) {
      onAddClick();
      setIsOpen(false);
    }
  };

  const containerClasses = [
    styles.tossSelectorGroup,
    fullWidth ? styles.fullWidth : '',
    className
  ].filter(Boolean).join(' ');

  const selectClasses = [
    styles.tossSelect,
    isOpen ? styles.tossSelectActive : '',
    error ? styles.tossSelectError : '',
    disabled ? styles.disabled : ''
  ].filter(Boolean).join(' ');

  const menuClasses = [
    styles.tossSelectMenu,
    isOpen ? styles.tossSelectMenuShow : ''
  ].filter(Boolean).join(' ');

  return (
    <div className={containerClasses} ref={containerRef}>
      {label && (
        <label
          htmlFor={id}
          className={`${styles.tossSelectLabel} ${required ? styles.required : ''}`}
        >
          {label}
        </label>
      )}

      <div className={styles.tossSelectContainer}>
        <button
          type="button"
          id={id}
          className={selectClasses}
          onClick={handleToggle}
          disabled={disabled || loading}
          aria-haspopup="listbox"
          aria-expanded={isOpen}
        >
          <span className={`${styles.tossSelectValue} ${!displayValue ? styles.tossSelectPlaceholder : ''}`}>
            {displayValue || placeholder}
          </span>

          {loading ? (
            <div className={styles.tossSelectSpinner} />
          ) : (
            <svg className={styles.tossSelectArrow} viewBox="0 0 24 24" fill="currentColor">
              <path d="M7 10l5 5 5-5z"/>
            </svg>
          )}
        </button>

        <div className={menuClasses} style={{ maxHeight }}>
          {searchable && (
            <div className={styles.tossSelectSearch}>
              <input
                ref={searchInputRef}
                type="text"
                className={styles.tossSelectSearchInput}
                placeholder="Search..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                onClick={(e) => e.stopPropagation()}
              />
            </div>
          )}

          <div className={styles.tossSelectOptions}>
            {loading ? (
              <div className={styles.tossSelectLoading}>
                <div className={styles.tossSelectSpinner} />
                <div>Loading...</div>
              </div>
            ) : filteredOptions.length === 0 ? (
              <div className={styles.tossSelectEmpty}>{emptyMessage}</div>
            ) : (
              filteredOptions.map((option) => {
                const isSelected = option.value === value;
                const optionClasses = [
                  styles.tossSelectOption,
                  isSelected ? styles.tossSelectOptionSelected : '',
                  option.disabled ? styles.tossSelectOptionDisabled : ''
                ].filter(Boolean).join(' ');

                return (
                  <div
                    key={option.value}
                    className={optionClasses}
                    onClick={() => handleOptionClick(option.value)}
                    role="option"
                    aria-selected={isSelected}
                  >
                    {showBadges && option.badge && (
                      <span
                        className={styles.tossSelectOptionBadge}
                        style={option.badgeColor ? { backgroundColor: option.badgeColor } : undefined}
                      >
                        {option.badge}
                      </span>
                    )}
                    <div className={styles.tossSelectOptionContent}>
                      <div className={styles.tossSelectOptionLabel}>{option.label}</div>
                      {showDescriptions && option.description && (
                        <div className={styles.tossSelectOptionDescription}>
                          {option.description}
                        </div>
                      )}
                    </div>
                    {isSelected && (
                      <svg className={styles.tossSelectOptionCheck} viewBox="0 0 24 24" fill="currentColor">
                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                      </svg>
                    )}
                  </div>
                );
              })
            )}
          </div>

          {showAddButton && onAddClick && filteredOptions.length > 0 && (
            <div className={styles.tossSelectFooter}>
              <div className={styles.tossSelectAction} onClick={handleAddClick}>
                <svg className={styles.tossSelectActionIcon} viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11h-4v4h-2v-4H7v-2h4V7h2v4h4v2z"/>
                </svg>
                <span className={styles.tossSelectActionLabel}>{addButtonText}</span>
              </div>
            </div>
          )}
        </div>
      </div>

      {(error && errorMessage) || helperText ? (
        <p className={`${styles.tossSelectMessage} ${error ? styles.tossSelectMessageError : styles.tossSelectMessageInfo}`}>
          {error && errorMessage ? errorMessage : helperText}
        </p>
      ) : null}
    </div>
  );
};

export default TossSelector;
