/**
 * Toss Filter Component
 * A reusable filter component with store selector and date range inputs
 * 
 * Usage:
 * const filter = new TossFilter({
 *     container: '#filter-container',
 *     showStoreFilter: true,
 *     showDateFilters: true,
 *     onSearch: (filters) => { console.log('Search with:', filters) },
 *     onClear: () => { console.log('Filters cleared') }
 * });
 */

class TossFilter {
    constructor(options = {}) {
        this.options = {
            container: options.container || '#toss-filter',
            title: options.title || 'Filters',
            showStoreFilter: options.showStoreFilter !== false,
            showDateFilters: options.showDateFilters !== false,
            storeLabel: options.storeLabel || 'Store',
            fromDateLabel: options.fromDateLabel || 'From Date',
            toDateLabel: options.toDateLabel || 'To Date',
            searchButtonText: options.searchButtonText || 'Search',
            clearButtonText: options.clearButtonText || 'Clear All',
            defaultExpanded: options.defaultExpanded !== false,
            onSearch: options.onSearch || (() => {}),
            onClear: options.onClear || (() => {}),
            onFilterChange: options.onFilterChange || (() => {})
        };
        
        this.container = null;
        this.storeFilter = null;
        this.fromDate = null;
        this.toDate = null;
        this.isExpanded = this.options.defaultExpanded;
        
        this.init();
    }
    
    init() {
        const container = document.querySelector(this.options.container);
        if (!container) {
            console.error('TossFilter: Container not found:', this.options.container);
            return;
        }
        
        this.container = container;
        this.render();
        this.attachEventListeners();
        this.setDefaultDates();
        this.loadStores();
    }
    
    render() {
        const html = `
            <div class="toss-filter-container">
                <div class="toss-filter-header">
                    <div class="toss-filter-title">
                        <svg class="toss-filter-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 3H2l8 9.46V19l4 2v-8.54L22 3z"/>
                        </svg>
                        <span>${this.options.title}</span>
                    </div>
                    <button class="toss-filter-toggle ${!this.isExpanded ? 'collapsed' : ''}" id="toss-filter-toggle">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M18 15l-6-6-6 6"/>
                        </svg>
                    </button>
                </div>
                
                <div class="toss-filter-content ${!this.isExpanded ? 'collapsed' : ''}" id="toss-filter-content">
                    <div class="toss-filter-grid">
                        ${this.options.showStoreFilter ? this.renderStoreFilter() : ''}
                        ${this.options.showDateFilters ? this.renderDateFilters() : ''}
                    </div>
                    
                    <div class="toss-filter-actions">
                        <button class="toss-filter-btn toss-filter-btn-clear" id="toss-filter-clear">
                            ${this.options.clearButtonText}
                        </button>
                        <button class="toss-filter-btn toss-filter-btn-search" id="toss-filter-search">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="11" cy="11" r="8"/>
                                <path d="M21 21l-4.35-4.35"/>
                            </svg>
                            <span>${this.options.searchButtonText}</span>
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        this.container.innerHTML = html;
        
        // Get references to filter elements
        if (this.options.showStoreFilter) {
            this.storeFilter = this.container.querySelector('#toss-filter-store');
        }
        if (this.options.showDateFilters) {
            this.fromDate = this.container.querySelector('#toss-filter-from-date');
            this.toDate = this.container.querySelector('#toss-filter-to-date');
        }
    }
    
    renderStoreFilter() {
        return `
            <div class="toss-filter-group">
                <label class="toss-filter-label" for="toss-filter-store">${this.options.storeLabel}</label>
                <div class="toss-filter-input-wrapper">
                    <select class="toss-filter-select" id="toss-filter-store" name="store">
                        <option value="null">All Stores</option>
                    </select>
                </div>
            </div>
        `;
    }
    
    renderDateFilters() {
        return `
            <div class="toss-filter-group">
                <label class="toss-filter-label" for="toss-filter-from-date">${this.options.fromDateLabel}</label>
                <div class="toss-filter-input-wrapper">
                    <input type="date" class="toss-filter-date" id="toss-filter-from-date" name="fromDate">
                </div>
            </div>
            
            <div class="toss-filter-group">
                <label class="toss-filter-label" for="toss-filter-to-date">${this.options.toDateLabel}</label>
                <div class="toss-filter-input-wrapper">
                    <input type="date" class="toss-filter-date" id="toss-filter-to-date" name="toDate">
                </div>
            </div>
        `;
    }
    
    attachEventListeners() {
        // Toggle button
        const toggleBtn = this.container.querySelector('#toss-filter-toggle');
        const filterContent = this.container.querySelector('#toss-filter-content');
        
        if (toggleBtn && filterContent) {
            toggleBtn.addEventListener('click', () => {
                this.isExpanded = !this.isExpanded;
                toggleBtn.classList.toggle('collapsed');
                filterContent.classList.toggle('collapsed');
            });
        }
        
        // Search button
        const searchBtn = this.container.querySelector('#toss-filter-search');
        if (searchBtn) {
            searchBtn.addEventListener('click', () => {
                this.handleSearch();
            });
        }
        
        // Clear button
        const clearBtn = this.container.querySelector('#toss-filter-clear');
        if (clearBtn) {
            clearBtn.addEventListener('click', () => {
                this.handleClear();
            });
        }
        
        // Filter change events
        if (this.storeFilter) {
            this.storeFilter.addEventListener('change', () => {
                this.options.onFilterChange(this.getFilters());
            });
        }
        
        if (this.fromDate) {
            this.fromDate.addEventListener('change', () => {
                this.options.onFilterChange(this.getFilters());
            });
        }
        
        if (this.toDate) {
            this.toDate.addEventListener('change', () => {
                this.options.onFilterChange(this.getFilters());
            });
        }
        
        // Listen for company changes to reload stores
        window.addEventListener('companyChanged', (event) => {
            console.log('🎯 DEBUG: TossFilter received companyChanged event:', event.detail);
            console.log('🎯 DEBUG: Event companyId:', event.detail.companyId);
            console.log('🎯 DEBUG: Event companyName:', event.detail.companyName);
            console.log('🔄 DEBUG: Calling refreshStoresForNewCompany...');
            this.refreshStoresForNewCompany();
        });
    }
    
    setDefaultDates() {
        if (!this.options.showDateFilters) return;
        
        const now = new Date();
        const year = now.getFullYear();
        const month = now.getMonth();
        
        // First day of current month
        const firstDay = new Date(year, month, 1);
        const firstDayFormatted = this.formatDateForInput(firstDay);
        
        // Last day of current month
        const lastDay = new Date(year, month + 1, 0);
        const lastDayFormatted = this.formatDateForInput(lastDay);
        
        // Set the default values
        if (this.fromDate) this.fromDate.value = firstDayFormatted;
        if (this.toDate) this.toDate.value = lastDayFormatted;
    }
    
    formatDateForInput(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }
    
    loadStores() {
        if (!this.options.showStoreFilter || !this.storeFilter) return;
        
        // Get user data from localStorage (correct location)
        const userData = localStorage.getItem('user');
        if (!userData) {
            console.log('TossFilter: No user data found in localStorage');
            return;
        }
        
        // Get selected company ID from localStorage
        // DEBUG: Check storage keys for company selection
        console.log('🔍 DEBUG: TossFilter localStorage keys:', Object.keys(localStorage));
        console.log('🔍 DEBUG: companychoosen (lowercase c):', localStorage.getItem('companychoosen'));
        console.log('🔍 DEBUG: companyChoosen (capital C):', localStorage.getItem('companyChoosen'));
        
        // Use correct storage key that navbar uses (capital 'C')
        const selectedCompanyId = localStorage.getItem('companyChoosen');
        if (!selectedCompanyId) {
            console.log('TossFilter: No company selected');
            return;
        }
        
        try {
            const user = JSON.parse(userData);
            
            // Find the selected company
            const selectedCompany = user.companies?.find(company => 
                company.company_id === selectedCompanyId
            );
            
            if (!selectedCompany) {
                console.log('TossFilter: Selected company not found');
                return;
            }
            
            // Clear and repopulate store options
            this.storeFilter.innerHTML = '<option value="null">All Stores</option>';
            
            if (selectedCompany.stores && Array.isArray(selectedCompany.stores)) {
                selectedCompany.stores.forEach(store => {
                    const option = document.createElement('option');
                    option.value = store.store_id;
                    option.textContent = store.store_name || 'Unnamed Store';
                    this.storeFilter.appendChild(option);
                });
                
                console.log(`✅ DEBUG: TossFilter loaded ${selectedCompany.stores.length} stores for company ${selectedCompany.company_name || selectedCompanyId}`);
            console.log('🏢 DEBUG: Store list:', selectedCompany.stores.map(s => `${s.store_name} (${s.store_id})`));
            }
        } catch (error) {
            console.error('TossFilter: Error loading stores:', error);
        }
    }
    
    // Method to refresh stores when company changes
    refreshStoresForNewCompany() {
        console.log('🔄 DEBUG: TossFilter refreshStoresForNewCompany called');
        console.log('🔍 DEBUG: Current localStorage companyChoosen:', localStorage.getItem('companyChoosen'));
        
        // Reset store selection to "All Stores"
        if (this.storeFilter) {
            this.storeFilter.value = 'null';
        }
        
        // Reload stores for the new company
        console.log('🔄 DEBUG: About to call loadStores()...');
        this.loadStores();
        
        // Trigger filter change event to notify parent component
        console.log('🔄 DEBUG: About to trigger onFilterChange...');
        this.options.onFilterChange(this.getFilters());
        console.log('✅ DEBUG: TossFilter refresh complete');
    }
    
    getFilters() {
        const filters = {};
        
        if (this.storeFilter) {
            // Convert "null" string to actual null for "All Stores"
            filters.store = this.storeFilter.value === 'null' ? null : this.storeFilter.value;
        }
        
        if (this.fromDate) {
            filters.fromDate = this.fromDate.value;
        }
        
        if (this.toDate) {
            filters.toDate = this.toDate.value;
        }
        
        return filters;
    }
    
    setFilters(filters) {
        if (this.storeFilter) {
            // Handle null value for "All Stores"
            if (filters.store === null || filters.store === undefined) {
                this.storeFilter.value = 'null';
            } else {
                this.storeFilter.value = filters.store;
            }
        }
        
        if (filters.fromDate && this.fromDate) {
            this.fromDate.value = filters.fromDate;
        }
        
        if (filters.toDate && this.toDate) {
            this.toDate.value = filters.toDate;
        }
    }
    
    handleSearch() {
        const filters = this.getFilters();
        this.options.onSearch(filters);
    }
    
    handleClear() {
        // Clear store filter (set to null for "All Stores")
        if (this.storeFilter) {
            this.storeFilter.value = 'null';
        }
        
        // Reset dates to defaults
        this.setDefaultDates();
        
        // Trigger clear callback
        this.options.onClear();
        
        // Trigger filter change
        this.options.onFilterChange(this.getFilters());
    }
    
    expand() {
        this.isExpanded = true;
        const toggleBtn = this.container.querySelector('#toss-filter-toggle');
        const filterContent = this.container.querySelector('#toss-filter-content');
        
        if (toggleBtn) toggleBtn.classList.remove('collapsed');
        if (filterContent) filterContent.classList.remove('collapsed');
    }
    
    collapse() {
        this.isExpanded = false;
        const toggleBtn = this.container.querySelector('#toss-filter-toggle');
        const filterContent = this.container.querySelector('#toss-filter-content');
        
        if (toggleBtn) toggleBtn.classList.add('collapsed');
        if (filterContent) filterContent.classList.add('collapsed');
    }
    
    destroy() {
        if (this.container) {
            this.container.innerHTML = '';
        }
    }
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = TossFilter;
}