/**
 * TossSelector Component
 * Custom dropdown selector with button+menu approach (not native select)
 * Supports footer actions like "Add category" and "Add brand"
 *
 * @design Design Specifications (Reference - Account Mapping Implementation)
 *
 * Structure:
 * - Button trigger: Shows selected value with dropdown arrow
 * - Dropdown menu: Positioned below button with search, options, footer
 * - Option layout: [badge?] label [description?] [checkmark?]
 *
 * Typography:
 * - Label (above selector): 14px, font-weight: 600, color: var(--toss-gray-800)
 * - Select button text: 16px, font-weight: 500, color: var(--toss-gray-900)
 * - Placeholder: 16px, font-weight: 500, color: var(--toss-gray-500)
 * - Option label: 16px, font-weight: 600, color: inherit
 * - Option description: 12px, font-weight: 600, letter-spacing: 0.3px
 * - Search input: 14px, color: var(--toss-gray-900)
 *
 * Badge Specifications:
 * - Purpose: Short text (2 letters recommended), icons, or emojis
 * - Size: width: 32px, font-size: 18px
 * - Position: Left side of option
 * - Background: Customizable via badgeColor prop
 * - Visibility: Controlled by showBadges prop (default: false)
 *
 * Description Specifications:
 * - Purpose: Category labels, type tags, secondary information
 * - Typography: 12px, font-weight: 600, letter-spacing: 0.3px
 * - Position: Right-aligned, margin-left: auto
 * - Dimensions: Content-based width (flex-shrink: 0), padding: 4px 8px
 * - Border: border-radius: 4px
 * - Colors: Customizable via descriptionBgColor, descriptionColor props
 * - Visibility: Controlled by showDescriptions prop (default: false)
 *
 * Color Examples (from Account Mapping):
 * - Cash: bg: rgba(34, 197, 94, 0.15), text: rgb(34, 197, 94)
 * - Receivable: bg: rgba(59, 130, 246, 0.15), text: rgb(59, 130, 246)
 * - Payable: bg: rgba(239, 68, 68, 0.15), text: rgb(239, 68, 68)
 * - Fixed Asset: bg: rgba(168, 85, 247, 0.15), text: rgb(168, 85, 247)
 * - Equity: bg: rgba(14, 165, 233, 0.15), text: rgb(14, 165, 233)
 * - Contra Asset: bg: rgba(107, 114, 128, 0.15), text: rgb(107, 114, 128)
 * - General: bg: rgba(107, 114, 128, 0.15), text: rgb(107, 114, 128)
 *
 * States:
 * - Default: border: 1px solid var(--toss-gray-300)
 * - Hover: background: var(--toss-gray-50), border: var(--toss-primary)
 * - Active/Open: border: var(--toss-primary), box-shadow: 0 0 0 3px rgba(0, 100, 255, 0.08)
 * - Disabled: background: var(--toss-gray-100), color: var(--toss-gray-500)
 * - Error: border: var(--toss-error)
 *
 * Option States:
 * - Default: background: transparent
 * - Hover: background: var(--toss-gray-50)
 * - Selected: background: rgba(0, 100, 255, 0.08), color: var(--toss-primary)
 * - Selected + Hover: background: rgba(0, 100, 255, 0.12)
 *
 * @example Usage Pattern (Account Selection)
 * ```tsx
 * // Helper: Get 2-letter initials from name
 * const getInitials = (name: string): string => {
 *   if (!name) return '??';
 *   const words = name.trim().split(' ');
 *   if (words.length === 1) return name.substring(0, 2).toUpperCase();
 *   return words.slice(0, 2).map(w => w[0]).join('').toUpperCase();
 * };
 *
 * // Transform data to TossSelector format
 * const options = useMemo(() => {
 *   return accounts.map(account => ({
 *     value: account.id,
 *     label: account.name,
 *     badge: getInitials(account.name), // Optional: 2-letter initials
 *     description: account.category_tag !== 'general' ? account.category_tag : undefined,
 *     descriptionBgColor: getCategoryBgColor(account.category_tag),
 *     descriptionColor: getCategoryTextColor(account.category_tag),
 *   }));
 * }, [accounts]);
 *
 * // Use TossSelector
 * <TossSelector
 *   label="Account"
 *   placeholder="Select Account"
 *   value={selectedId}
 *   options={options}
 *   onChange={(value) => setSelectedId(value)}
 *   searchable={true}
 *   showBadges={false}        // Hide badges if not needed
 *   showDescriptions={true}    // Show category labels
 *   required={true}
 *   fullWidth={true}
 * />
 * ```
 */

import React, { useState, useEffect, useRef, forwardRef } from 'react';
import type { TossSelectorProps } from './TossSelector.types';
import styles from './TossSelector.module.css';
import { LoadingAnimation } from '../../common/LoadingAnimation';

export const TossSelector = forwardRef<HTMLInputElement, TossSelectorProps>(({
  id,
  name,
  label,
  placeholder = 'Select an option',
  value,
  options,
  onChange,
  onSelect,
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
  inline = false,
  editable = false,
}, ref) => {
  const [isOpen, setIsOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [highlightedIndex, setHighlightedIndex] = useState(-1);
  const containerRef = useRef<HTMLDivElement>(null);
  const searchInputRef = useRef<HTMLInputElement>(null);
  const inlineInputRef = useRef<HTMLInputElement>(null);
  const optionRefs = useRef<{ [key: number]: HTMLDivElement | null }>({});

  // Merge external ref with internal ref for inline mode
  const mergedRef = ref || inlineInputRef;

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
        setIsTyping(false);
        setHighlightedIndex(-1);
      }
    };

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [isOpen]);

  // Focus search input when dropdown opens and reset highlighted index
  useEffect(() => {
    if (isOpen && searchable && searchInputRef.current) {
      setTimeout(() => {
        searchInputRef.current?.focus();
      }, 100);
    }
    if (isOpen) {
      setHighlightedIndex(-1);
    }
  }, [isOpen, searchable]);

  // Scroll highlighted option into view
  useEffect(() => {
    if (highlightedIndex >= 0 && highlightedIndex < filteredOptions.length) {
      const optionEl = optionRefs.current[highlightedIndex];
      if (optionEl) {
        optionEl.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
      }
    }
  }, [highlightedIndex, filteredOptions.length]);

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
      setIsTyping(false);
      setHighlightedIndex(-1);
      // Call onSelect callback after selection is complete
      if (onSelect) {
        onSelect(optionValue, option);
      }
    }
  };

  // Handle input change for inline mode
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchTerm(e.target.value);
    setIsTyping(true);
    if (!isOpen) {
      setIsOpen(true);
    }
  };

  // Handle input focus for inline mode
  const handleInputFocus = () => {
    if (!disabled && inline) {
      setIsOpen(true);
      // Don't set isTyping to true on focus - only on actual typing
    }
  };

  // Handle Enter key in inline input
  const handleInputKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && filteredOptions.length > 0) {
      e.preventDefault();
      // Select highlighted option if available, otherwise select first option
      const targetIndex = highlightedIndex >= 0 ? highlightedIndex : 0;
      const targetOption = filteredOptions[targetIndex];
      if (targetOption && !targetOption.disabled) {
        handleOptionClick(targetOption.value);
      }
    } else if (e.key === 'Escape') {
      setIsOpen(false);
      setSearchTerm('');
      setIsTyping(false);
      setHighlightedIndex(-1);
    } else if (e.key === 'ArrowDown') {
      e.preventDefault();
      setHighlightedIndex((prev) => {
        const nextIndex = prev + 1;
        return nextIndex >= filteredOptions.length ? 0 : nextIndex;
      });
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setHighlightedIndex((prev) => {
        const prevIndex = prev - 1;
        return prevIndex < 0 ? filteredOptions.length - 1 : prevIndex;
      });
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
    inline ? styles.inline : '',
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
      {label && !inline && (
        <label
          htmlFor={id}
          className={`${styles.tossSelectLabel} ${required ? styles.required : ''}`}
        >
          {label}
        </label>
      )}

      <div className={styles.tossSelectContainer}>
        {inline ? (
          // Inline mode: Show input field
          <input
            ref={mergedRef}
            type="text"
            id={id}
            className={selectClasses}
            value={isTyping ? searchTerm : displayValue}
            onChange={handleInputChange}
            onFocus={handleInputFocus}
            onKeyDown={handleInputKeyDown}
            placeholder={placeholder}
            disabled={disabled || loading}
            aria-haspopup="listbox"
            aria-expanded={isOpen}
          />
        ) : (
          // Normal mode: Show button
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
              <LoadingAnimation size="small" />
            ) : (
              <svg className={styles.tossSelectArrow} viewBox="0 0 24 24" fill="currentColor">
                <path d="M7 10l5 5 5-5z"/>
              </svg>
            )}
          </button>
        )}

        <div className={menuClasses} style={{ maxHeight }}>
          {searchable && !inline && (
            <div className={styles.tossSelectSearch}>
              <input
                ref={searchInputRef}
                type="text"
                className={styles.tossSelectSearchInput}
                placeholder="Search..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                onClick={(e) => e.stopPropagation()}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && filteredOptions.length > 0) {
                    e.preventDefault();
                    const targetIndex = highlightedIndex >= 0 ? highlightedIndex : 0;
                    const targetOption = filteredOptions[targetIndex];
                    if (targetOption && !targetOption.disabled) {
                      handleOptionClick(targetOption.value);
                    }
                  } else if (e.key === 'Escape') {
                    setIsOpen(false);
                    setSearchTerm('');
                    setHighlightedIndex(-1);
                  } else if (e.key === 'ArrowDown') {
                    e.preventDefault();
                    setHighlightedIndex((prev) => {
                      const nextIndex = prev + 1;
                      return nextIndex >= filteredOptions.length ? 0 : nextIndex;
                    });
                  } else if (e.key === 'ArrowUp') {
                    e.preventDefault();
                    setHighlightedIndex((prev) => {
                      const prevIndex = prev - 1;
                      return prevIndex < 0 ? filteredOptions.length - 1 : prevIndex;
                    });
                  }
                }}
              />
            </div>
          )}

          <div className={styles.tossSelectOptions}>
            {loading ? (
              <div className={styles.tossSelectLoading}>
                <LoadingAnimation size="medium" />
              </div>
            ) : filteredOptions.length === 0 ? (
              <div className={styles.tossSelectEmpty}>{emptyMessage}</div>
            ) : (
              filteredOptions.map((option, index) => {
                const isSelected = option.value === value;
                const isHighlighted = index === highlightedIndex;
                const optionClasses = [
                  styles.tossSelectOption,
                  isSelected ? styles.tossSelectOptionSelected : '',
                  isHighlighted ? styles.tossSelectOptionHighlighted : '',
                  option.disabled ? styles.tossSelectOptionDisabled : ''
                ].filter(Boolean).join(' ');

                return (
                  <div
                    key={option.value}
                    ref={(el) => (optionRefs.current[index] = el)}
                    className={optionClasses}
                    onClick={() => handleOptionClick(option.value)}
                    onMouseEnter={() => setHighlightedIndex(index)}
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
                        <div
                          className={styles.tossSelectOptionDescription}
                          style={{
                            backgroundColor: option.descriptionBgColor,
                            color: option.descriptionColor
                          }}
                        >
                          {option.description}
                        </div>
                      )}
                    </div>
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
});

TossSelector.displayName = 'TossSelector';

export default TossSelector;
