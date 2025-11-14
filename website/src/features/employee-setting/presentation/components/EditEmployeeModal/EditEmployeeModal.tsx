/**
 * EditEmployeeModal Component
 * Modal for editing employee salary configuration
 */

import React, { useState, useEffect } from 'react';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector/TossSelector.types';
import type { EditEmployeeModalProps } from './EditEmployeeModal.types';
import { EmployeeRepositoryImpl } from '../../../data/repositories/EmployeeRepositoryImpl';
import type { Currency } from '../../../data/datasources/EmployeeDataSource';
import { EmployeeValidator } from '../../../domain/validators/EmployeeValidator';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import styles from './EditEmployeeModal.module.css';

export const EditEmployeeModal: React.FC<EditEmployeeModalProps> = ({
  isOpen,
  onClose,
  employee,
  onSave,
}) => {
  const [salaryType, setSalaryType] = useState<'monthly' | 'hourly'>('monthly');
  const [currencyId, setCurrencyId] = useState('');
  const [salaryAmount, setSalaryAmount] = useState('');
  const [currencies, setCurrencies] = useState<Currency[]>([]);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<{ title?: string; message: string } | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const repository = new EmployeeRepositoryImpl();

  // Load currencies via Repository pattern
  useEffect(() => {
    const loadCurrencies = async () => {
      try {
        if (!employee?.companyId) return;

        // Use Repository instead of direct Supabase call
        const currencies = await repository.getCurrencies(employee.companyId);
        setCurrencies(currencies);
      } catch (error) {
        console.error('Error loading currencies:', error);
      }
    };

    if (isOpen && employee) {
      loadCurrencies();
    }
  }, [isOpen, employee, repository]);

  // Initialize form when employee changes
  useEffect(() => {
    if (employee && isOpen) {
      setSalaryType(employee.salaryType || 'monthly');
      setCurrencyId(employee.currencyId || '');
      setSalaryAmount(formatSalary(employee.salaryAmount || 0));
    }
  }, [employee, isOpen]);

  const formatSalary = (amount: number): string => {
    return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  };

  const handleSalaryAmountChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value.replace(/,/g, '');
    if (/^\d*$/.test(value)) {
      setSalaryAmount(formatSalary(parseInt(value) || 0));
    }
  };

  const getCurrencySymbol = (): string => {
    const currency = currencies.find((c) => c.currency_id === currencyId);
    return currency?.currency_symbol || '$';
  };

  const getSalaryPeriod = (): string => {
    return salaryType === 'monthly' ? 'per month' : 'per hour';
  };

  const handleSave = async () => {
    if (!employee) return;

    // Parse salary amount
    const amount = parseFloat(salaryAmount.replace(/,/g, '')) || 0;

    // Validate using EmployeeValidator (Domain Layer)
    const validationResult = EmployeeValidator.validateSalaryUpdate(
      amount,
      currencyId,
      salaryType
    );

    if (!validationResult.isValid) {
      setError({
        title: 'Validation Error',
        message: validationResult.error || 'Invalid salary information'
      });
      return;
    }

    // Additional validation: Salary ID
    const salaryIdValidation = EmployeeValidator.validateSalaryId(employee.salaryId);
    if (!salaryIdValidation.isValid) {
      setError({
        title: 'Validation Error',
        message: salaryIdValidation.error || 'Invalid salary ID'
      });
      return;
    }

    setSaving(true);
    try {
      const result = await repository.updateEmployeeSalary(
        employee.salaryId,
        amount,
        salaryType,
        currencyId
      );

      if (!result.success) {
        setError({
          title: 'Update Failed',
          message: result.error || 'Failed to update employee salary. Please try again.'
        });
        return;
      }

      // Show success message
      setSuccess('Employee salary updated successfully!');

      // Close modal after a short delay
      setTimeout(() => {
        setSuccess(null);
        onSave();
        onClose();
      }, 1500);
    } catch (error) {
      console.error('Error updating salary:', error);
      setError({
        title: 'Unexpected Error',
        message: error instanceof Error ? error.message : 'An unexpected error occurred. Please try again.'
      });
    } finally {
      setSaving(false);
    }
  };

  if (!isOpen || !employee) return null;

  return (
    <>
      <div className={styles.overlay} onClick={onClose}>
        <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className={styles.header}>
          <h2 className={styles.title}>Edit Employee</h2>
          <button className={styles.closeButton} onClick={onClose}>
            <svg width="24" height="24" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
            </svg>
          </button>
        </div>

        {/* Body */}
        <div className={styles.body}>
          {/* Employee Info */}
          <div className={styles.employeeInfo}>
            <div className={styles.avatarLarge}>{employee.initials}</div>
            <div className={styles.employeeHeader}>
              <h3 className={styles.employeeName}>{employee.fullName}</h3>
              <p className={styles.employeeEmail}>{employee.email}</p>
            </div>
          </div>

          {/* Employee Details */}
          <div className={styles.infoGrid}>
            <div className={styles.infoItem}>
              <label className={styles.infoLabel}>ROLE</label>
              <div className={styles.infoValue}>{employee.roleName}</div>
            </div>
            <div className={styles.infoItem}>
              <label className={styles.infoLabel}>STORE</label>
              <div className={styles.infoValue}>{employee.storeName}</div>
            </div>
          </div>

          {/* Salary Configuration */}
          <div className={styles.editSection}>
            <h4 className={styles.sectionTitle}>Salary Configuration</h4>

            {/* Salary Type Toggle */}
            <div className={styles.formGroup}>
              <label className={styles.formLabel}>Salary Type</label>
              <div className={styles.salaryTypeToggle}>
                <button
                  className={`${styles.toggleOption} ${salaryType === 'monthly' ? styles.active : ''}`}
                  onClick={() => setSalaryType('monthly')}
                >
                  <svg className={styles.toggleIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M19,3H18V1H16V3H8V1H6V3H5C3.89,3 3,3.89 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5C21,3.89 20.1,3 19,3M19,19H5V8H19V19Z" />
                  </svg>
                  Monthly
                </button>
                <button
                  className={`${styles.toggleOption} ${salaryType === 'hourly' ? styles.active : ''}`}
                  onClick={() => setSalaryType('hourly')}
                >
                  <svg className={styles.toggleIcon} width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22C6.47,22 2,17.5 2,12A10,10 0 0,1 12,2M12.5,7V12.25L17,14.92L16.25,16.15L11,13V7H12.5Z" />
                  </svg>
                  Hourly
                </button>
              </div>
            </div>

            {/* Currency Selection */}
            <TossSelector
              id="currency"
              label="Currency"
              placeholder="Select currency"
              value={currencyId}
              options={currencies.map((currency): TossSelectorOption => ({
                value: currency.currency_id,
                label: `${currency.currency_code} - ${currency.currency_name} (${currency.currency_symbol})`,
              }))}
              onChange={(value) => setCurrencyId(value)}
              fullWidth
              searchable
            />

            {/* Salary Amount */}
            <div className={styles.formGroup}>
              <label className={styles.formLabel} htmlFor="salaryAmount">Salary Amount</label>
              <div className={styles.inputWrapper}>
                <span className={styles.currencySymbol}>{getCurrencySymbol()}</span>
                <input
                  id="salaryAmount"
                  type="text"
                  className={styles.formInput}
                  value={salaryAmount}
                  onChange={handleSalaryAmountChange}
                  placeholder="0"
                />
                <span className={styles.salaryPeriod}>{getSalaryPeriod()}</span>
              </div>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className={styles.footer}>
          <button className={styles.cancelButton} onClick={onClose} disabled={saving}>
            Cancel
          </button>
          <button className={styles.saveButton} onClick={handleSave} disabled={saving}>
            {saving ? (
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px' }}>
                <LoadingAnimation size="small" />
              </div>
            ) : (
              <>
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M17,3H5C3.89,3 3,3.89 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V7.5L18.5,5M19,19H5V5H16.17L19,7.83V19M12,12C10.34,12 9,13.34 9,15C9,16.66 10.34,18 12,18C13.66,18 15,16.66 15,15C15,13.34 13.66,12 12,12M6,6H15V10H6V6Z" />
                </svg>
                Save Changes
              </>
            )}
          </button>
        </div>
      </div>
    </div>

      {/* Error Message */}
      <ErrorMessage
        variant="error"
        title={error?.title}
        message={error?.message || ''}
        isOpen={!!error}
        onClose={() => setError(null)}
        zIndex={10001}
      />

      {/* Success Message */}
      <ErrorMessage
        variant="success"
        title="Success"
        message={success || ''}
        isOpen={!!success}
        onClose={() => setSuccess(null)}
        autoCloseDuration={1500}
        zIndex={10001}
      />
    </>
  );
};
