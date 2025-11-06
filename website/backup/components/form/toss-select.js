/**
 * Toss Select Component
 * Common reusable select/dropdown component following Toss design system
 * 
 * Usage:
 * const select = new TossSelect({
 *     containerId: 'select-container',
 *     options: [...],
 *     value: 'option1',
 *     placeholder: 'Select an option',
 *     onChange: (value, option) => { ... }
 * });
 * select.init();
 */

class TossSelect {
    constructor(options = {}) {
        this.options = {
            containerId: options.containerId || null,
            name: options.name || 'select',
            value: options.value || '',
            placeholder: options.placeholder || 'Select an option',
            label: options.label || '',
            required: options.required || false,
            disabled: options.disabled || false,
            searchable: options.searchable || false,
            multiple: options.multiple || false,
            size: options.size || 'default', // 'sm', 'default', 'lg'
            width: options.width || 'default', // 'default', 'full', 'inline'
            header: options.header || '',
            emptyMessage: options.emptyMessage || 'No options available',
            loadingMessage: options.loadingMessage || 'Loading...',
            isLoading: options.isLoading || false,
            options: options.options || [],
            onChange: options.onChange || null,
            onSearch: options.onSearch || null,
            onOpen: options.onOpen || null,
            onClose: options.onClose || null,
            // New option for custom footer actions (like "+ Add brand")
            footerActions: options.footerActions || [],
            // Brand dropdown specific options
            isBrandDropdown: options.isBrandDropdown || false,
            companyId: options.companyId || null,
            onBrandAdded: options.onBrandAdded || null,
            // Category dropdown specific options
            isCategoryDropdown: options.isCategoryDropdown || false,
            onCategoryAdded: options.onCategoryAdded || null,
            // Allow clearing selected value
            allowClear: options.allowClear || false,
            clearText: options.clearText || '× Clear',
            ...options
        };
        
        this.isOpen = false;
        this.selectedValue = this.options.value;
        this.selectedValues = this.options.multiple ? (Array.isArray(this.options.value) ? this.options.value : []) : [];
        this.searchTerm = '';
        this.filteredOptions = [...this.options.options];
        this.container = null;
        this.selectButton = null;
        this.selectMenu = null;
        this.searchInput = null;
    }
    
    init() {
        if (this.options.containerId) {
            this.container = document.getElementById(this.options.containerId);
            if (this.container) {
                // Ensure selectedValue is set from options.value
                if (this.options.value) {
                    this.selectedValue = this.options.value;
                    console.log(`TossSelect init: Setting selectedValue to ${this.selectedValue}`);
                }
                this.render();
                this.attachEventListeners();
                // Force display update after render
                setTimeout(() => this.updateDisplay(), 50);
            } else {
                console.error(`Container with id "${this.options.containerId}" not found`);
            }
        }
    }
    
    render() {
        const selectedOption = this.getSelectedOption();
        const displayValue = this.getDisplayValue(selectedOption);
        
        const html = `
            <div class="toss-select-group">
                ${this.options.label ? `
                    <label class="toss-select-label ${this.options.required ? 'required' : ''}">
                        ${this.options.label}
                    </label>
                ` : ''}
                
                <div class="toss-select-container ${this.getSizeClass()} ${this.getWidthClass()}">
                    <button 
                        type="button"
                        class="toss-select ${this.getSizeClass()} ${this.isOpen ? 'toss-select-active' : ''}"
                        id="${this.options.name}-button"
                        ${this.options.disabled ? 'disabled' : ''}
                        aria-haspopup="listbox"
                        aria-expanded="${this.isOpen}"
                    >
                        <span class="toss-select-value ${!displayValue ? 'toss-select-placeholder' : ''}">
                            ${displayValue || this.options.placeholder}
                        </span>
                        ${this.options.allowClear && this.selectedValue ? `
                            <span class="toss-select-clear" data-action="clear">×</span>
                        ` : ''}
                        <svg class="toss-select-arrow" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M7 10l5 5 5-5z"/>
                        </svg>
                    </button>
                    
                    <div class="toss-select-menu ${this.isOpen ? 'toss-select-menu-show' : ''}" id="${this.options.name}-menu">
                        ${this.options.header ? `
                            <div class="toss-select-header">${this.options.header}</div>
                        ` : ''}
                        
                        ${this.options.searchable ? `
                            <div class="toss-select-search">
                                <input 
                                    type="text" 
                                    class="toss-select-search-input" 
                                    placeholder="Search..."
                                    id="${this.options.name}-search"
                                    value="${this.searchTerm}"
                                />
                            </div>
                        ` : ''}
                        
                        <div class="toss-select-options" id="${this.options.name}-options">
                            ${this.renderOptions()}
                        </div>
                        
                        ${this.renderFooterActions()}
                    </div>
                </div>
                
                ${this.options.message ? `
                    <div class="toss-select-message ${this.getMessageClass()}">
                        ${this.options.message}
                    </div>
                ` : ''}
            </div>
        `;
        
        this.container.innerHTML = html;
        
        // Cache DOM elements
        this.selectButton = document.getElementById(`${this.options.name}-button`);
        this.selectMenu = document.getElementById(`${this.options.name}-menu`);
        if (this.options.searchable) {
            this.searchInput = document.getElementById(`${this.options.name}-search`);
        }
    }
    
    renderOptions() {
        if (this.options.isLoading) {
            return `
                <div class="toss-select-loading">
                    <div class="toss-select-spinner"></div>
                    <div>${this.options.loadingMessage}</div>
                </div>
            `;
        }
        
        if (this.filteredOptions.length === 0) {
            return `<div class="toss-select-empty">${this.options.emptyMessage}</div>`;
        }
        
        return this.filteredOptions.map(option => {
            const isSelected = this.isOptionSelected(option);
            return `
                <div 
                    class="toss-select-option ${isSelected ? 'toss-select-option-selected' : ''} ${option.disabled ? 'toss-select-option-disabled' : ''}"
                    data-value="${option.value}"
                    role="option"
                    aria-selected="${isSelected}"
                >
                    <div class="toss-select-option-content">
                        <div class="toss-select-option-label">${option.label}</div>
                        ${option.description ? `
                            <div class="toss-select-option-description">${option.description}</div>
                        ` : ''}
                    </div>
                    ${isSelected ? `
                        <svg class="toss-select-option-check" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    ` : ''}
                </div>
            `;
        }).join('');
    }
    
    renderFooterActions() {
        // Auto-add brand option for brand dropdown
        if (this.options.isBrandDropdown) {
            return `
                <div class="toss-select-footer">
                    <div class="toss-select-action" data-action="add-brand">
                        <svg class="toss-select-action-icon" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11h-4v4h-2v-4H7v-2h4V7h2v4h4v2z"/>
                        </svg>
                        <span class="toss-select-action-label">Add brand</span>
                    </div>
                </div>
            `;
        }
        
        // Auto-add category option for category dropdown
        if (this.options.isCategoryDropdown) {
            return `
                <div class="toss-select-footer">
                    <div class="toss-select-action" data-action="add-category">
                        <svg class="toss-select-action-icon" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11h-4v4h-2v-4H7v-2h4V7h2v4h4v2z"/>
                        </svg>
                        <span class="toss-select-action-label">Add category</span>
                    </div>
                </div>
            `;
        }
        
        // Render custom footer actions
        if (this.options.footerActions.length === 0) {
            return '';
        }
        
        const actionsHTML = this.options.footerActions.map((action, index) => `
            <div class="toss-select-action" data-action-index="${index}">
                ${action.icon ? action.icon : ''}
                <span class="toss-select-action-label">${action.label}</span>
            </div>
        `).join('');
        
        return `
            <div class="toss-select-footer">
                ${actionsHTML}
            </div>
        `;
    }
    
    attachEventListeners() {
        // Toggle dropdown
        if (this.selectButton) {
            this.selectButton.addEventListener('click', (event) => {
                // Handle clear button click
                if (event.target.classList.contains('toss-select-clear')) {
                    event.stopPropagation();
                    this.clearSelection();
                    return;
                }
                this.toggle();
            });
        }
        
        // Handle option selection
        document.addEventListener('click', (event) => {
            const option = event.target.closest('.toss-select-option');
            if (option && option.closest(`#${this.options.name}-menu`)) {
                const value = option.dataset.value;
                if (!option.classList.contains('toss-select-option-disabled')) {
                    this.selectOption(value);
                }
                return;
            }
            
            // Handle footer actions
            const action = event.target.closest('.toss-select-action');
            if (action && action.closest(`#${this.options.name}-menu`)) {
                event.stopPropagation();
                this.handleFooterAction(action);
            }
        });
        
        // Handle search
        if (this.searchInput) {
            this.searchInput.addEventListener('input', (event) => {
                this.searchTerm = event.target.value;
                this.filterOptions();
            });
            
            // Prevent closing when clicking on search input
            this.searchInput.addEventListener('click', (event) => {
                event.stopPropagation();
            });
        }
        
        // Close on outside click
        document.addEventListener('click', (event) => {
            if (!event.target.closest(`#${this.options.containerId}`)) {
                this.close();
            }
        });
        
        // Handle keyboard navigation
        document.addEventListener('keydown', (event) => {
            if (this.isOpen) {
                switch(event.key) {
                    case 'Escape':
                        this.close();
                        break;
                    case 'Enter':
                        // Handle enter key for selection
                        break;
                    case 'ArrowDown':
                    case 'ArrowUp':
                        // Handle arrow navigation
                        break;
                }
            }
        });
    }
    
    toggle() {
        if (this.isOpen) {
            this.close();
        } else {
            this.open();
        }
    }
    
    open() {
        if (this.options.disabled) return;
        
        this.isOpen = true;
        this.selectButton.classList.add('toss-select-active');
        this.selectMenu.classList.add('toss-select-menu-show');
        this.selectButton.setAttribute('aria-expanded', 'true');
        
        if (this.searchInput) {
            setTimeout(() => this.searchInput.focus(), 100);
        }
        
        if (this.options.onOpen) {
            this.options.onOpen();
        }
    }
    
    close() {
        this.isOpen = false;
        this.selectButton.classList.remove('toss-select-active');
        this.selectMenu.classList.remove('toss-select-menu-show');
        this.selectButton.setAttribute('aria-expanded', 'false');
        
        // Reset search
        if (this.searchInput) {
            this.searchTerm = '';
            this.searchInput.value = '';
            this.filterOptions();
        }
        
        if (this.options.onClose) {
            this.options.onClose();
        }
    }
    
    selectOption(value) {
        const option = this.options.options.find(opt => String(opt.value) === String(value));
        
        if (this.options.multiple) {
            // Handle multiple selection
            const index = this.selectedValues.indexOf(value);
            if (index > -1) {
                this.selectedValues.splice(index, 1);
            } else {
                this.selectedValues.push(value);
            }
            this.selectedValue = this.selectedValues;
        } else {
            // Handle single selection
            this.selectedValue = value;
            this.close();
        }
        
        // Update display
        this.updateDisplay();
        
        // Trigger change callback
        if (this.options.onChange) {
            this.options.onChange(this.selectedValue, option);
        }
    }
    
    updateDisplay() {
        const selectedOption = this.getSelectedOption();
        const displayValue = this.getDisplayValue(selectedOption);
        
        // Re-query the button element to ensure we have the latest reference
        const button = document.getElementById(`${this.options.name}-button`);
        if (button) {
            const valueElement = button.querySelector('.toss-select-value');
            if (valueElement) {
                valueElement.textContent = displayValue || this.options.placeholder;
                valueElement.classList.toggle('toss-select-placeholder', !displayValue);
            }
        }
        
        // Update options display
        const optionsContainer = document.getElementById(`${this.options.name}-options`);
        if (optionsContainer) {
            optionsContainer.innerHTML = this.renderOptions();
        }
    }
    
    filterOptions() {
        if (!this.searchTerm) {
            this.filteredOptions = [...this.options.options];
        } else {
            const term = this.searchTerm.toLowerCase();
            this.filteredOptions = this.options.options.filter(option => {
                return option.label.toLowerCase().includes(term) ||
                       (option.description && option.description.toLowerCase().includes(term));
            });
        }
        
        // Update options display
        const optionsContainer = document.getElementById(`${this.options.name}-options`);
        if (optionsContainer) {
            optionsContainer.innerHTML = this.renderOptions();
        }
        
        // Trigger search callback
        if (this.options.onSearch) {
            this.options.onSearch(this.searchTerm);
        }
    }
    
    getSelectedOption() {
        if (this.options.multiple) {
            return this.options.options.filter(opt => this.selectedValues.includes(opt.value));
        }
        return this.options.options.find(opt => opt.value === this.selectedValue);
    }
    
    getDisplayValue(selectedOption) {
        if (this.options.multiple) {
            if (Array.isArray(selectedOption) && selectedOption.length > 0) {
                if (selectedOption.length === 1) {
                    return selectedOption[0].label;
                }
                return `${selectedOption.length} selected`;
            }
            return '';
        }
        return selectedOption ? selectedOption.label : '';
    }
    
    isOptionSelected(option) {
        if (this.options.multiple) {
            return this.selectedValues.includes(option.value);
        }
        return option.value === this.selectedValue;
    }
    
    getSizeClass() {
        switch(this.options.size) {
            case 'sm': return 'toss-select-sm';
            case 'lg': return 'toss-select-lg';
            default: return '';
        }
    }
    
    getWidthClass() {
        switch(this.options.width) {
            case 'full': return 'toss-select-full';
            case 'inline': return 'toss-select-inline';
            default: return '';
        }
    }
    
    getMessageClass() {
        if (this.options.messageType === 'error') return 'toss-select-message-error';
        if (this.options.messageType === 'success') return 'toss-select-message-success';
        return 'toss-select-message-info';
    }
    
    // Public methods
    setValue(value) {
        if (this.options.multiple) {
            this.selectedValues = Array.isArray(value) ? value : [];
            this.selectedValue = this.selectedValues;
        } else {
            this.selectedValue = value;
        }
        this.updateDisplay();
    }
    
    getValue() {
        return this.selectedValue;
    }
    
    setOptions(options) {
        this.options.options = options;
        this.filteredOptions = [...options];
        this.updateDisplay();
    }
    
    setLoading(isLoading) {
        this.options.isLoading = isLoading;
        const optionsContainer = document.getElementById(`${this.options.name}-options`);
        if (optionsContainer) {
            optionsContainer.innerHTML = this.renderOptions();
        }
    }
    
    enable() {
        this.options.disabled = false;
        if (this.selectButton) {
            this.selectButton.disabled = false;
        }
    }
    
    disable() {
        this.options.disabled = true;
        if (this.selectButton) {
            this.selectButton.disabled = true;
        }
        this.close();
    }
    
    handleFooterAction(actionElement) {
        const actionType = actionElement.dataset.action;
        const actionIndex = actionElement.dataset.actionIndex;
        
        if (actionType === 'add-brand' && this.options.isBrandDropdown) {
            this.openAddBrandModal();
        } else if (actionType === 'add-category' && this.options.isCategoryDropdown) {
            this.openAddCategoryModal();
        } else if (actionIndex !== undefined) {
            const action = this.options.footerActions[parseInt(actionIndex)];
            if (action && action.onClick) {
                action.onClick(this);
            }
        }
    }
    
    openAddBrandModal() {
        if (!this.options.companyId) {
            console.error('Company ID is required for adding brands');
            return;
        }
        
        // Create and open the add brand modal
        this.addBrandModal = new AddBrandModal({
            companyId: this.options.companyId,
            onBrandAdded: (brandData) => {
                // Close the select dropdown
                this.close();
                
                // Add new brand to options
                const newOption = {
                    value: brandData.brand_id,
                    label: brandData.brand_name,
                    description: brandData.brand_code ? `Code: ${brandData.brand_code}` : null
                };
                
                this.options.options.push(newOption);
                this.filteredOptions = [...this.options.options];
                
                // Select the new brand
                this.setValue(brandData.brand_id);
                
                // Call the external callback if provided
                if (this.options.onBrandAdded) {
                    this.options.onBrandAdded(brandData, this);
                }
                
                this.updateDisplay();
            }
        });
        
        this.addBrandModal.open();
    }
    
    openAddCategoryModal() {
        if (!this.options.companyId) {
            console.error('Company ID is required for adding categories');
            return;
        }
        
        // Create and open the add category modal
        this.addCategoryModal = new AddCategoryModal({
            companyId: this.options.companyId,
            onCategoryAdded: (categoryData) => {
                // Close the select dropdown
                this.close();
                
                // Add new category to options
                const newOption = {
                    value: categoryData.category_id,
                    label: categoryData.category_name,
                    description: categoryData.description || ''
                };
                this.options.options.push(newOption);
                
                // Set the new category as selected
                this.setValue(categoryData.category_id);
                
                // Call the callback if provided
                if (this.options.onCategoryAdded) {
                    this.options.onCategoryAdded(categoryData, this);
                }
                
                this.updateDisplay();
            }
        });
        
        this.addCategoryModal.open();
    }
    
    clearSelection() {
        this.selectedValue = null;
        this.selectedValues = [];
        this.updateDisplay();
        
        // Trigger onChange with null value
        if (this.options.onChange) {
            this.options.onChange(null, null);
        }
    }
    
    destroy() {
        if (this.container) {
            this.container.innerHTML = '';
        }
    }
}

// Make it globally available
window.TossSelect = TossSelect;