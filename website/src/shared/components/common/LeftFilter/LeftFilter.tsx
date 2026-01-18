/**
 * LeftFilter Component
 * Shared left sidebar filter component for various pages
 * Supports: Sort, Multi-select, Radio, Toggle, Input, Custom content
 */

import React, { useState } from 'react';
import type { LeftFilterProps, FilterSection } from './LeftFilter.types';
import styles from './LeftFilter.module.css';

export const LeftFilter: React.FC<LeftFilterProps> = ({
  sections,
  width = 240,
  topOffset = 64,
  className = '',
  onSectionExpandToggle,
}) => {
  const [expandedSections, setExpandedSections] = useState<Set<string>>(
    new Set(sections.filter((s) => s.defaultExpanded).map((s) => s.id))
  );

  const toggleSection = (sectionId: string) => {
    const newExpanded = new Set(expandedSections);
    const isExpanding = !newExpanded.has(sectionId);

    if (isExpanding) {
      newExpanded.add(sectionId);
    } else {
      newExpanded.delete(sectionId);
    }

    setExpandedSections(newExpanded);
    onSectionExpandToggle?.(sectionId, isExpanding);
  };

  const isExpanded = (sectionId: string) => expandedSections.has(sectionId);

  const renderSortSection = (section: FilterSection) => {
    const selectedValue = typeof section.selectedValues === 'string' ? section.selectedValues : '';

    return (
      <div className={styles.filterOptions}>
        {section.options?.map((option) => (
          <button
            key={option.value}
            className={`${styles.filterButton} ${selectedValue === option.value ? styles.active : ''}`}
            onClick={() => section.onSelect?.(option.value)}
            disabled={option.disabled}
          >
            <span>
              {option.icon && <span className={styles.optionIcon}>{option.icon}</span>}
              {option.label}
            </span>
            {selectedValue === option.value && (
              <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z" />
              </svg>
            )}
          </button>
        ))}
      </div>
    );
  };

  const renderMultiSelectSection = (section: FilterSection) => {
    const selectedSet = section.selectedValues instanceof Set ? section.selectedValues : new Set<string>();

    return (
      <div className={styles.filterOptions}>
        {/* Clear button */}
        {selectedSet.size > 0 && section.onClear && (
          <button className={`${styles.filterButton} ${styles.clearButton}`} onClick={section.onClear}>
            <span>Clear All</span>
            <svg className={styles.clearIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
            </svg>
          </button>
        )}

        {!section.options || section.options.length === 0 ? (
          <div className={styles.emptyState}>{section.emptyMessage || 'No options available'}</div>
        ) : (
          section.options.map((option) => (
            <button
              key={option.value}
              className={`${styles.filterButton} ${selectedSet.has(option.value) ? styles.active : ''}`}
              onClick={() => section.onToggle?.(option.value)}
              disabled={option.disabled}
            >
              <span className={styles.optionContent}>
                {option.icon && <span className={styles.optionIcon}>{option.icon}</span>}
                <span className={styles.optionLabel}>{option.label}</span>
                {option.description && (
                  <span className={styles.optionDescription}>{option.description}</span>
                )}
              </span>
              {selectedSet.has(option.value) && (
                <svg className={styles.checkIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M9,16.17L4.83,12l-1.42,1.41L9,19L21,7l-1.41-1.41L9,16.17z" />
                </svg>
              )}
            </button>
          ))
        )}
      </div>
    );
  };

  const renderRadioSection = (section: FilterSection) => {
    const selectedValue = typeof section.selectedValues === 'string' ? section.selectedValues : '';

    return (
      <div className={styles.filterOptions}>
        {section.options?.map((option) => {
          const isSelected = selectedValue === option.value;
          return (
            <button
              key={option.value}
              type="button"
              className={`${styles.radioOption} ${isSelected ? styles.selected : ''}`}
              onClick={() => section.onSelect?.(option.value)}
              disabled={option.disabled}
            >
              <span className={`${styles.radioCircle} ${isSelected ? styles.checked : ''}`} />
              <span className={styles.radioLabel}>
                {option.icon && <span className={styles.optionIcon}>{option.icon}</span>}
                {option.label}
              </span>
            </button>
          );
        })}
      </div>
    );
  };

  const renderToggleSection = (section: FilterSection) => {
    const selectedValue = typeof section.selectedValues === 'string' ? section.selectedValues : '';

    return (
      <div className={styles.toggleButtons}>
        {section.options?.map((option) => (
          <button
            key={option.value}
            className={`${styles.toggleButton} ${selectedValue === option.value ? styles.active : ''}`}
            onClick={() => section.onSelect?.(option.value)}
            disabled={option.disabled}
          >
            {option.icon && <span className={styles.optionIcon}>{option.icon}</span>}
            {option.label}
          </button>
        ))}
      </div>
    );
  };

  const renderInputSection = (section: FilterSection) => {
    const inputValue = typeof section.selectedValues === 'string' ? section.selectedValues : '';

    return (
      <div className={styles.filterOptions}>
        <input
          type="text"
          className={styles.filterInput}
          value={inputValue}
          onChange={(e) => section.onInputChange?.(e.target.value)}
          placeholder={section.placeholder || 'Enter value...'}
        />
      </div>
    );
  };

  const renderCustomSection = (section: FilterSection) => {
    return <div className={styles.filterOptions}>{section.customContent}</div>;
  };

  const renderSectionContent = (section: FilterSection) => {
    switch (section.type) {
      case 'sort':
        return renderSortSection(section);
      case 'multiselect':
        return renderMultiSelectSection(section);
      case 'radio':
        return renderRadioSection(section);
      case 'toggle':
        return renderToggleSection(section);
      case 'input':
        return renderInputSection(section);
      case 'custom':
        return renderCustomSection(section);
      default:
        return null;
    }
  };

  const getSelectedCount = (section: FilterSection): number => {
    if (section.selectedValues instanceof Set) {
      return section.selectedValues.size;
    }
    return 0;
  };

  return (
    <aside
      className={`${styles.leftFilter} ${className}`}
      style={{
        width: `${width}px`,
        height: `calc(100vh - ${topOffset}px)`,
        top: `${topOffset}px`,
      }}
    >
      {sections.map((section) => {
        const isCollapsible = section.type !== 'sort';
        const sectionExpanded = isExpanded(section.id);
        const selectedCount = getSelectedCount(section);

        return (
          <div key={section.id} className={styles.filterSection}>
            {/* Section Header */}
            {isCollapsible ? (
              <button className={styles.filterSectionHeader} onClick={() => toggleSection(section.id)}>
                <span className={styles.filterSectionTitle}>
                  {section.title}
                  {section.showCount && selectedCount > 0 && (
                    <span className={styles.filterCount}> ({selectedCount})</span>
                  )}
                </span>
                <svg
                  className={`${styles.expandIcon} ${sectionExpanded ? styles.expanded : ''}`}
                  width="20"
                  height="20"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z" />
                </svg>
              </button>
            ) : (
              <div className={styles.filterSectionHeader}>
                <span className={styles.filterSectionTitle}>{section.title}</span>
              </div>
            )}

            {/* Section Content */}
            {(!isCollapsible || sectionExpanded) && renderSectionContent(section)}
          </div>
        );
      })}
    </aside>
  );
};

export default LeftFilter;
