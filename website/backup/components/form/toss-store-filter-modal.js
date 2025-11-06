/**
 * Toss Store Filter Modal Component
 * A reusable modal component for filtering by store with a clean, modern design
 * Based on the design pattern shown in the employee management interface
 */

class TossStoreFilterModal {
    constructor(options = {}) {
        this.options = {
            containerId: options.containerId || 'store-filter-modal',
            modalTitle: options.modalTitle || 'Filter by Store',
            stores: options.stores || [],
            selectedStores: options.selectedStores || [],
            showAllStoresOption: options.showAllStoresOption !== false, // Default true
            allStoresLabel: options.allStoresLabel || 'All Stores',
            multiSelect: options.multiSelect !== false, // Default true for multi-selection
            showSearch: options.showSearch !== false, // Default true
            searchPlaceholder: options.searchPlaceholder || 'Search stores...',
            confirmButtonText: options.confirmButtonText || 'Apply Filter',
            cancelButtonText: options.cancelButtonText || 'Cancel',
            onApply: options.onApply || null,
            onCancel: options.onCancel || null,
            onStoreToggle: options.onStoreToggle || null,
            maxHeight: options.maxHeight || '400px',
            ...options
        };
        
        this.isVisible = false;
        this.filteredStores = [...this.options.stores];
        this.tempSelectedStores = [...this.options.selectedStores];
        
        this.init();
    }
    
    init() {
        this.createModal();
        this.attachEventListeners();
    }
    
    createModal() {
        // Remove existing modal if it exists
        const existingModal = document.getElementById(this.options.containerId);
        if (existingModal) {
            existingModal.remove();
        }
        
        const modalHTML = `
            <div id="${this.options.containerId}" class="toss-store-filter-modal">
                <div class="toss-store-filter-backdrop"></div>
                <div class="toss-store-filter-content">
                    <div class="toss-store-filter-header">
                        <h3 class="toss-store-filter-title">${this.options.modalTitle}</h3>
                        <button class="toss-store-filter-close" type="button">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                    
                    ${this.options.showSearch ? `
                        <div class="toss-store-filter-search">
                            <div class="toss-search-input-group">
                                <svg class="toss-search-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <path d="m21 21-4.35-4.35"></path>
                                </svg>
                                <input type="text" class="toss-search-input" placeholder="${this.options.searchPlaceholder}">
                            </div>
                        </div>
                    ` : ''}
                    
                    <div class="toss-store-filter-body">
                        <div class="toss-store-list" style="max-height: ${this.options.maxHeight};">
                            ${this.renderStoreList()}
                        </div>
                    </div>
                    
                    <div class="toss-store-filter-footer">
                        <button class="toss-btn toss-btn-ghost toss-store-filter-cancel" type="button">
                            ${this.options.cancelButtonText}
                        </button>
                        <button class="toss-btn toss-btn-primary toss-store-filter-apply" type="button">
                            ${this.options.confirmButtonText}
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.insertAdjacentHTML('beforeend', modalHTML);
    }
    
    renderStoreList() {
        let html = '';
        
        // Add "All Stores" option if enabled
        if (this.options.showAllStoresOption) {
            const isAllSelected = this.tempSelectedStores.length === 0 || 
                                 this.tempSelectedStores.includes('all');
            html += `
                <div class="toss-store-item ${isAllSelected ? 'selected' : ''}" data-store-id="all">
                    <div class="toss-store-info">
                        <div class="toss-store-icon all-stores">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                <polyline points="9,22 9,12 15,12 15,22"></polyline>
                            </svg>
                        </div>
                        <div class="toss-store-details">
                            <div class="toss-store-name">${this.options.allStoresLabel}</div>
                            <div class="toss-store-description">Show data from all locations</div>
                        </div>
                    </div>
                    <div class="toss-store-checkbox">
                        ${isAllSelected ? `
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                <path d="M20 6L9 17l-5-5"/>
                            </svg>
                        ` : ''}
                    </div>
                </div>
            `;
        }
        
        // Add individual stores
        this.filteredStores.forEach(store => {
            const isSelected = this.tempSelectedStores.includes(store.store_id || store.id);
            const storeName = store.store_name || store.name || 'Unnamed Store';
            const storeDescription = store.description || store.address || `Store ID: ${store.store_id || store.id}`;
            const storeId = store.store_id || store.id;
            
            html += `
                <div class="toss-store-item ${isSelected ? 'selected' : ''}" data-store-id="${storeId}">
                    <div class="toss-store-info">
                        <div class="toss-store-icon">
                            <span class="toss-store-initial">${storeName.charAt(0).toUpperCase()}</span>
                        </div>
                        <div class="toss-store-details">
                            <div class="toss-store-name">${storeName}</div>
                            <div class="toss-store-description">${storeDescription}</div>
                        </div>
                    </div>
                    <div class="toss-store-checkbox">
                        ${isSelected ? `
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                <path d="M20 6L9 17l-5-5"/>
                            </svg>
                        ` : ''}
                    </div>
                </div>
            `;
        });
        
        if (this.filteredStores.length === 0) {
            html = `
                <div class="toss-store-empty">
                    <div class="toss-empty-icon">
                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                    </div>
                    <div class="toss-empty-text">No stores found</div>
                </div>
            `;
        }
        
        return html;
    }
    
    attachEventListeners() {
        const modal = document.getElementById(this.options.containerId);
        if (!modal) return;
        
        // Close modal events
        const backdrop = modal.querySelector('.toss-store-filter-backdrop');
        const closeBtn = modal.querySelector('.toss-store-filter-close');
        const cancelBtn = modal.querySelector('.toss-store-filter-cancel');
        
        [backdrop, closeBtn, cancelBtn].forEach(element => {
            if (element) {
                element.addEventListener('click', () => this.hide());
            }
        });
        
        // Apply button
        const applyBtn = modal.querySelector('.toss-store-filter-apply');
        if (applyBtn) {
            applyBtn.addEventListener('click', () => this.applyFilter());
        }
        
        // Search functionality
        if (this.options.showSearch) {
            const searchInput = modal.querySelector('.toss-search-input');
            if (searchInput) {
                searchInput.addEventListener('input', (e) => this.handleSearch(e.target.value));
            }
        }
        
        // Store selection
        modal.addEventListener('click', (e) => {
            const storeItem = e.target.closest('.toss-store-item');
            if (storeItem) {
                this.toggleStore(storeItem.dataset.storeId);
            }
        });
        
        // Prevent modal close when clicking inside content
        const content = modal.querySelector('.toss-store-filter-content');
        if (content) {
            content.addEventListener('click', (e) => e.stopPropagation());
        }
        
        // ESC key to close
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.isVisible) {
                this.hide();
            }
        });
    }
    
    toggleStore(storeId) {
        if (storeId === 'all') {
            // Toggle "All Stores"
            if (this.tempSelectedStores.includes('all') || this.tempSelectedStores.length === 0) {
                this.tempSelectedStores = [];
            } else {
                this.tempSelectedStores = ['all'];
            }
        } else {
            // Toggle individual store
            if (this.options.multiSelect) {
                // Remove "all" if it exists
                this.tempSelectedStores = this.tempSelectedStores.filter(id => id !== 'all');
                
                const index = this.tempSelectedStores.indexOf(storeId);
                if (index > -1) {
                    this.tempSelectedStores.splice(index, 1);
                } else {
                    this.tempSelectedStores.push(storeId);
                }
            } else {
                // Single select mode
                this.tempSelectedStores = [storeId];
            }
        }
        
        // Update UI
        this.updateStoreListUI();
        
        // Trigger callback
        if (this.options.onStoreToggle) {
            this.options.onStoreToggle(storeId, [...this.tempSelectedStores]);
        }
    }
    
    updateStoreListUI() {
        const modal = document.getElementById(this.options.containerId);
        if (!modal) return;
        
        const storeList = modal.querySelector('.toss-store-list');
        if (storeList) {
            storeList.innerHTML = this.renderStoreList();
        }
    }
    
    handleSearch(query) {
        const searchTerm = query.toLowerCase().trim();
        
        if (searchTerm === '') {
            this.filteredStores = [...this.options.stores];
        } else {
            this.filteredStores = this.options.stores.filter(store => {
                const storeName = (store.store_name || store.name || '').toLowerCase();
                const storeDescription = (store.description || store.address || '').toLowerCase();
                return storeName.includes(searchTerm) || storeDescription.includes(searchTerm);
            });
        }
        
        this.updateStoreListUI();
    }
    
    applyFilter() {
        // Update actual selected stores
        this.options.selectedStores = [...this.tempSelectedStores];
        
        // Trigger callback
        if (this.options.onApply) {
            this.options.onApply([...this.tempSelectedStores]);
        }
        
        this.hide();
    }
    
    show() {
        const modal = document.getElementById(this.options.containerId);
        if (modal) {
            // Reset temp selection to current selection
            this.tempSelectedStores = [...this.options.selectedStores];
            this.updateStoreListUI();
            
            modal.classList.add('visible');
            this.isVisible = true;
            
            // Focus on search input if available
            if (this.options.showSearch) {
                const searchInput = modal.querySelector('.toss-search-input');
                if (searchInput) {
                    setTimeout(() => searchInput.focus(), 100);
                }
            }
            
            // Prevent body scroll
            document.body.style.overflow = 'hidden';
        }
    }
    
    hide() {
        const modal = document.getElementById(this.options.containerId);
        if (modal) {
            modal.classList.remove('visible');
            this.isVisible = false;
            
            // Restore body scroll
            document.body.style.overflow = '';
            
            // Reset temp selection
            this.tempSelectedStores = [...this.options.selectedStores];
            
            // Trigger cancel callback
            if (this.options.onCancel) {
                this.options.onCancel();
            }
        }
    }
    
    // Public methods
    updateStores(stores) {
        this.options.stores = stores || [];
        this.filteredStores = [...this.options.stores];
        
        if (this.isVisible) {
            this.updateStoreListUI();
        }
    }
    
    setSelectedStores(selectedStores) {
        this.options.selectedStores = selectedStores || [];
        this.tempSelectedStores = [...this.options.selectedStores];
        
        if (this.isVisible) {
            this.updateStoreListUI();
        }
    }
    
    getSelectedStores() {
        return [...this.options.selectedStores];
    }
    
    destroy() {
        const modal = document.getElementById(this.options.containerId);
        if (modal) {
            modal.remove();
        }
        
        // Restore body scroll
        document.body.style.overflow = '';
    }
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = TossStoreFilterModal;
}

// Make it globally available
window.TossStoreFilterModal = TossStoreFilterModal;