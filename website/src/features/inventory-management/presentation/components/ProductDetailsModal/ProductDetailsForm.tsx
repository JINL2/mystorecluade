/**
 * ProductDetailsForm Component
 * Product information form with four sections: Product Info, Attributes, Stock Info, Price Info
 */

import React from 'react';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import type { ProductDetailsFormProps } from './ProductDetailsForm.types';
import styles from './ProductDetailsModal.module.css';

/**
 * Format number with thousand separators (e.g., 1234567 -> "1,234,567")
 */
const formatNumberWithCommas = (value: string | number): string => {
  const numStr = String(value).replace(/[^\d]/g, '');
  if (!numStr) return '';
  return numStr.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
};

/**
 * Parse formatted number back to raw number string (e.g., "1,234,567" -> "1234567")
 */
const parseFormattedNumber = (value: string): string => {
  return value.replace(/,/g, '');
};

export const ProductDetailsForm: React.FC<ProductDetailsFormProps> = ({
  formData,
  metadata,
  onInputChange,
  onAttributeChange,
  onAddBrand,
  onAddCategory,
  onAddAttribute,
  hasVariants,
  variantName,
}) => {
  // Get attributes from metadata
  const allAttributes = metadata?.attributes || [];

  // For products with variants, find the attribute that matches the variant
  const getVariantAttributeId = (): string | null => {
    if (!hasVariants || !variantName) return null;

    for (const attribute of allAttributes) {
      for (const option of attribute.options) {
        if (option.option_value === variantName) {
          return attribute.attribute_id;
        }
      }
    }
    return null;
  };

  const variantAttributeId = getVariantAttributeId();

  // Track selected attribute for checkbox (only 1 allowed for products without variants)
  const selectedAttributeId = Object.keys(formData.selectedAttributes || {})[0] || null;

  // Handle checkbox click for attribute selection
  const handleAttributeCheckboxClick = (attributeId: string) => {
    if (hasVariants) return; // Don't allow changes for products with variants

    if (onAttributeChange) {
      if (selectedAttributeId === attributeId) {
        // Deselect - pass empty string to clear
        onAttributeChange(attributeId, '');
      } else {
        // Clear previous selection and select new one
        if (selectedAttributeId) {
          onAttributeChange(selectedAttributeId, '');
        }
        // Select new attribute (mark as selected without option)
        onAttributeChange(attributeId, '__selected__');
      }
    }
  };

  return (
    <>
      {/* Product Information Section */}
      <div className={styles.section}>
        <h3 className={styles.sectionTitle}>Product Information</h3>
        <div className={styles.formGrid}>
          <div className={`${styles.formGroup} ${styles.formGroupFull}`}>
            <label className={styles.label}>Product Name</label>
            <input
              type="text"
              className={styles.input}
              value={formData.productName}
              onChange={(e) => onInputChange('productName', e.target.value)}
              placeholder="Enter product name"
            />
          </div>

          <div className={styles.formGroup}>
            <TossSelector
              label="Category"
              placeholder="Select category"
              value={formData.category}
              options={metadata?.categories.map((cat) => ({
                value: cat.category_id,
                label: cat.category_name,
                description: cat.description,
              })) || []}
              onChange={(value) => onInputChange('category', value)}
              showAddButton={true}
              addButtonText="Add category"
              onAddClick={onAddCategory}
              showDescriptions={true}
              fullWidth={true}
            />
          </div>

          <div className={styles.formGroup}>
            <TossSelector
              label="Brand"
              placeholder="Select brand"
              value={formData.brand}
              options={metadata?.brands.map((brand) => ({
                value: brand.brand_id,
                label: brand.brand_name,
                description: brand.description,
              })) || []}
              onChange={(value) => onInputChange('brand', value)}
              showAddButton={true}
              addButtonText="Add brand"
              onAddClick={onAddBrand}
              showDescriptions={true}
              fullWidth={true}
            />
          </div>

          <div className={styles.formGroup}>
            <TossSelector
              label="Product Type"
              placeholder="Select product type"
              value={formData.productType}
              options={metadata?.product_types.map((type) => {
                let englishLabel = type.label;
                if (type.value === 'commodity') englishLabel = 'Commodity';
                if (type.value === 'bundle') englishLabel = 'Bundle/Set';
                if (type.value === 'service') englishLabel = 'Service';

                return {
                  value: type.value,
                  label: englishLabel,
                  description: type.description,
                };
              }) || []}
              onChange={(value) => onInputChange('productType', value)}
              showDescriptions={true}
              fullWidth={true}
            />
          </div>

          <div className={styles.formGroup}>
            <label className={styles.label}>Barcode</label>
            <input
              type="text"
              className={styles.input}
              value={formData.barcode}
              onChange={(e) => onInputChange('barcode', e.target.value)}
              placeholder="Enter barcode"
            />
          </div>

          <div className={styles.formGroup}>
            <label className={styles.label}>SKU</label>
            <input
              type="text"
              className={styles.input}
              value={formData.sku}
              onChange={(e) => onInputChange('sku', e.target.value)}
              placeholder="Enter SKU"
            />
          </div>
        </div>
      </div>

      {/* Variant Attributes Section - Only show if attributes exist */}
      {allAttributes.length > 0 && (
        <div className={styles.section}>
          <h3 className={styles.sectionTitle}>
            Variant Attributes
            {variantName && (
              <span className={styles.variantBadge}>{variantName}</span>
            )}
            {onAddAttribute && !hasVariants && (
              <button
                type="button"
                className={styles.addAttributeButton}
                onClick={onAddAttribute}
                title="Add new attribute"
              >
                <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                </svg>
              </button>
            )}
          </h3>
          {/* Subtitle for attribute selection */}
          <p className={styles.attributeSubtitle}>
            {hasVariants
              ? 'This product has variants. Attribute cannot be changed.'
              : 'Select variant attribute (optional, only 1 allowed)'}
          </p>
          {/* Checkbox list for attributes */}
          <div className={styles.attributeCheckboxList}>
            {allAttributes.map((attribute) => {
              // For products with variants: check if this is the variant's attribute
              const isSelected = hasVariants
                ? variantAttributeId === attribute.attribute_id
                : selectedAttributeId === attribute.attribute_id;
              const isDisabled = hasVariants;

              return (
                <div
                  key={attribute.attribute_id}
                  className={`${styles.attributeCheckboxRow} ${isDisabled ? styles.attributeCheckboxDisabled : ''}`}
                  onClick={() => !isDisabled && handleAttributeCheckboxClick(attribute.attribute_id)}
                >
                  <div
                    className={`${styles.attributeCheckbox} ${isSelected ? styles.attributeCheckboxSelected : ''} ${isDisabled ? styles.attributeCheckboxDisabledBox : ''}`}
                  >
                    {isSelected && (
                      <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                      </svg>
                    )}
                  </div>
                  <span className={`${styles.attributeCheckboxLabel} ${isDisabled ? styles.attributeCheckboxLabelDisabled : ''}`}>
                    {attribute.attribute_name}
                  </span>
                  <span className={styles.attributeOptionCount}>
                    {attribute.options.length} options
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Stock Information Section */}
      <div className={styles.section}>
        <h3 className={styles.sectionTitle}>Stock Information</h3>
        <div className={styles.formGrid}>
          <div className={styles.formGroup}>
            <label className={styles.label}>Current Quantity</label>
            <input
              type="number"
              className={styles.input}
              value={formData.currentStock}
              onChange={(e) => onInputChange('currentStock', e.target.value)}
              placeholder="0"
            />
          </div>

          <div className={styles.formGroup}>
            <TossSelector
              label="Unit"
              placeholder="Select unit"
              value={formData.unit}
              options={metadata?.units.map((unit) => ({
                value: unit.value,
                label: `${unit.value} (${unit.symbol})`,
                description: `${unit.value} - ${unit.symbol}`,
              })) || []}
              onChange={(value) => onInputChange('unit', value)}
              fullWidth={true}
            />
          </div>
        </div>
      </div>

      {/* Price Information Section */}
      <div className={styles.section}>
        <h3 className={styles.sectionTitle}>Price Information</h3>
        <div className={styles.formGrid}>
          <div className={styles.formGroup}>
            <label className={styles.label}>Cost Price</label>
            <input
              type="text"
              className={styles.input}
              value={formatNumberWithCommas(formData.costPrice)}
              onChange={(e) => onInputChange('costPrice', parseFormattedNumber(e.target.value))}
              placeholder="0"
            />
          </div>

          <div className={styles.formGroup}>
            <label className={styles.label}>Selling Price</label>
            <input
              type="text"
              className={styles.input}
              value={formatNumberWithCommas(formData.sellingPrice)}
              onChange={(e) => onInputChange('sellingPrice', parseFormattedNumber(e.target.value))}
              placeholder="0"
            />
          </div>
        </div>
      </div>
    </>
  );
};
