/**
 * CompanySelector Component
 * Searchable dropdown for company selection
 */

import React, { useState, useRef, useEffect } from 'react';
import type { CompanySelectorProps, Company } from './CompanySelector.types';
import styles from './CompanySelector.module.css';

export const CompanySelector: React.FC<CompanySelectorProps> = ({
  companies,
  selectedCompanyId,
  onChange,
  className = '',
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const containerRef = useRef<HTMLDivElement>(null);
  const searchInputRef = useRef<HTMLInputElement>(null);

  // Get selected company
  const selectedCompany = companies.find((c) => c.company_id === selectedCompanyId);

  // Filter companies based on search term
  const filteredCompanies = companies.filter((company) =>
    company.company_name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
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
    if (isOpen && searchInputRef.current) {
      searchInputRef.current.focus();
    }
  }, [isOpen]);

  const handleToggle = () => {
    setIsOpen(!isOpen);
    setSearchTerm(''); // Reset search when opening
  };

  const handleSelectCompany = (company: Company) => {
    onChange(company.company_id, company);
    setIsOpen(false);
    setSearchTerm('');
  };

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchTerm(e.target.value);
  };

  const displayValue = selectedCompany ? selectedCompany.company_name : 'Select Company';

  return (
    <div ref={containerRef} className={`${styles.container} ${className}`}>
      {/* Select Button */}
      <button
        type="button"
        className={`${styles.selectButton} ${isOpen ? styles.active : ''}`}
        onClick={handleToggle}
        aria-haspopup="listbox"
        aria-expanded={isOpen}
      >
        <span className={styles.selectValue}>{displayValue}</span>
        <svg className={styles.arrow} viewBox="0 0 24 24" fill="currentColor">
          <path d="M7 10l5 5 5-5z" />
        </svg>
      </button>

      {/* Dropdown Menu */}
      <div className={`${styles.menu} ${isOpen ? styles.show : ''}`}>
        {/* Search Input */}
        {companies.length > 5 && (
          <div className={styles.searchWrapper}>
            <input
              ref={searchInputRef}
              type="text"
              className={styles.searchInput}
              placeholder="Search companies..."
              value={searchTerm}
              onChange={handleSearchChange}
            />
          </div>
        )}

        {/* Options List */}
        <div className={styles.optionsList}>
          {filteredCompanies.length > 0 ? (
            filteredCompanies.map((company) => (
              <div
                key={company.company_id}
                className={`${styles.option} ${
                  company.company_id === selectedCompanyId ? styles.selected : ''
                }`}
                onClick={() => handleSelectCompany(company)}
                role="option"
                aria-selected={company.company_id === selectedCompanyId}
              >
                <div className={styles.optionLabel}>{company.company_name}</div>
                <div className={styles.optionDescription}>
                  {company.stores?.length || 0} store{company.stores?.length !== 1 ? 's' : ''}
                </div>
              </div>
            ))
          ) : (
            <div className={styles.emptyState}>No companies found</div>
          )}
        </div>
      </div>
    </div>
  );
};

export default CompanySelector;
