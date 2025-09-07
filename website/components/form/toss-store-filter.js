/**
 * Toss Store Filter Component
 * A simplified filter component with only store selector
 * Based on TossFilter but without date range inputs
 * 
 * Usage:
 * const filter = new TossStoreFilter({
 *     container: '#filter-container',
 *     onSearch: (filters) => { console.log('Search with:', filters) },
 *     onClear: () => { console.log('Filter cleared') }
 * });
 */

class TossStoreFilter {
    constructor(options = {}) {
        this.options = {
            container: options.container || '#toss-store-filter',
            title: options.title || 'Store Filter',
            storeLabel: options.storeLabel || 'Store',
            searchButtonText: options.searchButtonText || 'Search',
            clearButtonText: options.clearButtonText || 'Clear',
            defaultExpanded: options.defaultExpanded !== false,
            showSearchButton: options.showSearchButton !== false,
            showClearButton: options.showClearButton !== false,
            onSearch: options.onSearch || (() => {}),
            onClear: options.onClear || (() => {}),
            onStoreChange: options.onStoreChange || (() => {})
        };
        
        this.container = null;
        this.storeFilter = null;
        this.isExpanded = this.options.defaultExpanded;
        
        this.init();
    }
    
    init() {
        const container = document.querySelector(this.options.container);
        if (!container) {
            console.error('TossStoreFilter: Container not found:', this.options.container);
            return;
        }
        
        this.container = container;
        this.render();
        this.attachEventListeners();
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
                    <button class="toss-filter-toggle ${!this.isExpanded ? 'collapsed' : ''}" id="toss-store-filter-toggle">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M18 15l-6-6-6 6"/>
                        </svg>
                    </button>
                </div>
                
                <div class="toss-filter-content ${!this.isExpanded ? 'collapsed' : ''}" id="toss-store-filter-content">
                    <div class="toss-filter-grid toss-filter-grid-single">
                        <div class="toss-filter-group">
                            <label class="toss-filter-label" for="toss-store-filter-store">${this.options.storeLabel}</label>
                            <div class="toss-filter-input-wrapper">
                                <select class="toss-filter-select" id="toss-store-filter-store" name="store">
                                    <option value="null">All Stores</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    ${this.renderActionButtons()}
                </div>
            </div>
        `;
        
        this.container.innerHTML = html;
        
        // Get reference to store filter element
        this.storeFilter = this.container.querySelector('#toss-store-filter-store');
    }
    
    renderActionButtons() {
        // Only show buttons if at least one is enabled
        if (!this.options.showSearchButton && !this.options.showClearButton) {
            return '';
        }
        
        let buttonsHtml = '<div class="toss-filter-actions">';
        
        if (this.options.showClearButton) {
            buttonsHtml += `
                <button class="toss-filter-btn toss-filter-btn-clear" id="toss-store-filter-clear">
                    ${this.options.clearButtonText}
                </button>
            `;
        }
        
        if (this.options.showSearchButton) {
            buttonsHtml += `
                <button class="toss-filter-btn toss-filter-btn-search" id="toss-store-filter-search">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"/>
                        <path d="M21 21l-4.35-4.35"/>
                    </svg>
                    <span>${this.options.searchButtonText}</span>
                </button>
            `;
        }
        
        buttonsHtml += '</div>';
        return buttonsHtml;
    }
    
    attachEventListeners() {
        // Toggle button
        const toggleBtn = this.container.querySelector('#toss-store-filter-toggle');
        const filterContent = this.container.querySelector('#toss-store-filter-content');
        
        if (toggleBtn && filterContent) {
            toggleBtn.addEventListener('click', () => {
                this.isExpanded = !this.isExpanded;
                toggleBtn.classList.toggle('collapsed');
                filterContent.classList.toggle('collapsed');
            });
        }
        
        // Search button
        if (this.options.showSearchButton) {
            const searchBtn = this.container.querySelector('#toss-store-filter-search');
            if (searchBtn) {
                searchBtn.addEventListener('click', () => {
                    this.handleSearch();
                });
            }
        }
        
        // Clear button
        if (this.options.showClearButton) {
            const clearBtn = this.container.querySelector('#toss-store-filter-clear');
            if (clearBtn) {
                clearBtn.addEventListener('click', () => {
                    this.handleClear();
                });
            }
        }
        
        // Store change event
        if (this.storeFilter) {
            this.storeFilter.addEventListener('change', () => {
                // Save selection to both localStorage and sessionStorage
                const selectedValue = this.storeFilter.value;
                if (selectedValue !== 'null') {
                    localStorage.setItem('storeChoosen', selectedValue);
                    sessionStorage.setItem('storeChoosen', selectedValue);
                    console.log('TossStoreFilter: Saved store selection:', selectedValue);
                } else {
                    // Clear store selection for "All Stores"
                    localStorage.removeItem('storeChoosen');
                    sessionStorage.removeItem('storeChoosen');
                    console.log('TossStoreFilter: Cleared store selection (All Stores)');
                }
                
                this.options.onStoreChange(this.getFilters());
                // Auto-trigger search if search button is hidden
                if (!this.options.showSearchButton) {
                    this.handleSearch();
                }
            });
        }
        
        // Listen for company changes to reload stores
        window.addEventListener('companyChanged', () => {
            this.loadStores();
        });
    }
    
    loadStores() {
        if (!this.storeFilter) return;
        
        console.log('TossStoreFilter: loadStores() called');
        
        // Get user data from localStorage
        const userData = localStorage.getItem('user');
        if (!userData) {
            console.log('TossStoreFilter: No user data found - will retry');
            // Retry after a delay if no data yet
            if (!this.retryAttempts) this.retryAttempts = 0;
            if (this.retryAttempts < 5) {
                this.retryAttempts++;
                setTimeout(() => this.loadStores(), 500 * this.retryAttempts);
            }
            return;
        }
        
        try {
            const user = JSON.parse(userData);
            const selectedCompanyId = localStorage.getItem('companyChoosen');
            
            if (!selectedCompanyId) {
                console.log('TossStoreFilter: No company selected');
                // Set to loading state
                this.storeFilter.innerHTML = '<option value="null">Loading stores...</option>';
                return;
            }
            
            // Find the selected company
            const selectedCompany = user.companies?.find(company => 
                company.company_id === selectedCompanyId
            );
            
            if (!selectedCompany) {
                console.log('TossStoreFilter: Selected company not found in user data');
                console.log('Available companies:', user.companies?.map(c => c.company_id));
                console.log('Looking for:', selectedCompanyId);
                // Show error state
                this.storeFilter.innerHTML = '<option value="null">No stores available</option>';
                return;
            }
            
            // Clear and repopulate store options
            this.storeFilter.innerHTML = '<option value="null">All Stores</option>';
            
            // Track if we successfully loaded stores
            let storesLoaded = false;
            
            if (selectedCompany.stores && Array.isArray(selectedCompany.stores)) {
                console.log('TossStoreFilter: Loading stores:', selectedCompany.stores.length, 'stores found');
                console.log('TossStoreFilter: Full store data:', JSON.stringify(selectedCompany.stores));
                
                selectedCompany.stores.forEach(store => {
                    // CRITICAL: Ensure store_id exists and is valid
                    if (!store.store_id) {
                        console.error(`TossStoreFilter: Store missing store_id:`, store);
                        return;
                    }
                    
                    console.log(`TossStoreFilter: Adding store - ID: "${store.store_id}", Name: "${store.store_name}"`);
                    const option = document.createElement('option');
                    option.value = store.store_id;
                    option.textContent = store.store_name || 'Unnamed Store';
                    this.storeFilter.appendChild(option);
                    storesLoaded = true;
                });
                
                // Reset retry attempts on success
                this.retryAttempts = 0;
            } else {
                console.log('TossStoreFilter: No stores array in company data');
            }
            
            // Restore previously selected store if any
            // Check both localStorage and sessionStorage for better persistence
            const previousStoreLocal = localStorage.getItem('storeChoosen');
            const previousStoreSession = sessionStorage.getItem('storeChoosen');
            const previousStore = previousStoreLocal || previousStoreSession;
            
            if (previousStore && this.storeFilter.querySelector(`option[value="${previousStore}"]`)) {
                this.storeFilter.value = previousStore;
                console.log('TossStoreFilter: Restored previous store selection:', previousStore);
                // Sync storage
                localStorage.setItem('storeChoosen', previousStore);
                sessionStorage.setItem('storeChoosen', previousStore);
            } else if (previousStore) {
                console.log('TossStoreFilter: Previous store not found in list:', previousStore);
            }
            
            // Dispatch event that stores are loaded
            if (storesLoaded) {
                const event = new CustomEvent('storesLoaded', { 
                    detail: { 
                        companyId: selectedCompanyId,
                        storeCount: selectedCompany.stores.length 
                    }
                });
                window.dispatchEvent(event);
            }
            
        } catch (error) {
            console.error('TossStoreFilter: Error loading stores:', error);
            // Show error state
            this.storeFilter.innerHTML = '<option value="null">Error loading stores</option>';
        }
    }
    
    getFilters() {
        const filters = {};
        
        if (this.storeFilter) {
            // CRITICAL: Return correct value format for RPC
            // "null" string (All Stores) → null
            // Valid UUID → UUID string
            const selectedValue = this.storeFilter.value;
            
            if (selectedValue === 'null' || selectedValue === '' || selectedValue === 'undefined') {
                filters.store = null;
            } else {
                filters.store = selectedValue;
            }
            
            console.log('TossStoreFilter getFilters() called:');
            console.log('- DOM select value:', this.storeFilter.value);
            console.log('- Selected text:', this.storeFilter.options[this.storeFilter.selectedIndex]?.text);
            console.log('- Returning store filter:', filters.store);
            console.log('- Full filters object:', JSON.stringify(filters));
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
        
        // Trigger clear callback
        this.options.onClear();
        
        // Trigger store change
        this.options.onStoreChange(this.getFilters());
    }
    
    expand() {
        this.isExpanded = true;
        const toggleBtn = this.container.querySelector('#toss-store-filter-toggle');
        const filterContent = this.container.querySelector('#toss-store-filter-content');
        
        if (toggleBtn) toggleBtn.classList.remove('collapsed');
        if (filterContent) filterContent.classList.remove('collapsed');
    }
    
    collapse() {
        this.isExpanded = false;
        const toggleBtn = this.container.querySelector('#toss-store-filter-toggle');
        const filterContent = this.container.querySelector('#toss-store-filter-content');
        
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
    module.exports = TossStoreFilter;
}