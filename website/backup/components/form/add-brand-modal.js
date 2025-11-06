/**
 * Add Brand Modal Component
 * Modal for adding new brands from within brand dropdown
 * Integrates with TossSelect component for seamless UX
 */

class AddBrandModal {
    constructor(options = {}) {
        this.options = {
            companyId: options.companyId || null,
            onBrandAdded: options.onBrandAdded || null,
            onError: options.onError || null,
            ...options
        };
        
        this.modal = null;
        this.isSubmitting = false;
        this.brandNameInput = null;
        this.brandCodeInput = null;
        this.addButton = null;
        
        this.init();
    }
    
    init() {
        this.createModal();
    }
    
    createModal() {
        this.modal = new TossModal({
            id: 'add-brand-modal',
            title: 'Add New Brand',
            subtitle: 'Create a new brand for your inventory',
            size: 'sm',
            showClose: true,
            closeOnOverlay: true,
            closeOnEsc: true,
            content: this.buildModalContent(),
            buttons: [
                {
                    id: 'add-brand-cancel-btn',
                    label: 'Cancel',
                    class: 'toss-btn toss-btn-secondary',
                    onClick: (modal) => {
                        modal.close();
                    }
                },
                {
                    id: 'add-brand-submit-btn',
                    label: 'Add Brand',
                    class: 'toss-btn toss-btn-primary',
                    disabled: true,
                    onClick: (modal) => {
                        this.submitBrand();
                    }
                }
            ],
            onOpen: () => {
                this.setupForm();
                this.focusFirstInput();
            },
            onClose: () => {
                this.cleanup();
            }
        });
        
        // Store reference for button access
        window['add-brand-modal_instance'] = this.modal;
    }
    
    buildModalContent() {
        return `
            <div class="add-brand-form">
                <div class="toss-input-group">
                    <label class="toss-label required">Brand Name</label>
                    <div class="toss-input-wrapper">
                        <input 
                            type="text" 
                            id="brand-name-input"
                            class="toss-input" 
                            placeholder="Enter brand name"
                            required
                            maxlength="100"
                        />
                    </div>
                    <span class="toss-input-message" id="brand-name-message"></span>
                </div>
                
                <div class="toss-input-group">
                    <label class="toss-label">Brand Code</label>
                    <div class="toss-input-wrapper">
                        <input 
                            type="text" 
                            id="brand-code-input"
                            class="toss-input" 
                            placeholder="Optional - auto-generated if empty"
                            maxlength="50"
                        />
                    </div>
                    <span class="toss-input-message" id="brand-code-message">
                        Leave empty to auto-generate from brand name
                    </span>
                </div>
                
                <div id="add-brand-error" class="toss-alert toss-alert-error" style="display: none;">
                    <div class="toss-alert-content">
                        <div class="toss-alert-title">Error</div>
                        <div class="toss-alert-message" id="add-brand-error-message"></div>
                    </div>
                </div>
            </div>
        `;
    }
    
    setupForm() {
        // Get form elements
        this.brandNameInput = document.getElementById('brand-name-input');
        this.brandCodeInput = document.getElementById('brand-code-input');
        this.addButton = document.getElementById('add-brand-submit-btn');
        this.errorAlert = document.getElementById('add-brand-error');
        this.errorMessage = document.getElementById('add-brand-error-message');
        
        // Initialize Toss inputs
        if (this.brandNameInput) {
            this.brandNameInput._tossInput = new TossInput(this.brandNameInput, {
                validateOnInput: true,
                validateOnBlur: true
            });
        }
        
        if (this.brandCodeInput) {
            this.brandCodeInput._tossInput = new TossInput(this.brandCodeInput, {
                validateOnInput: false,
                validateOnBlur: true
            });
        }
        
        // Setup validation
        this.setupValidation();
    }
    
    setupValidation() {
        if (!this.brandNameInput || !this.addButton) return;
        
        // Real-time validation for brand name
        this.brandNameInput.addEventListener('input', () => {
            this.validateForm();
            this.hideError();
        });
        
        // Optional validation for brand code
        if (this.brandCodeInput) {
            this.brandCodeInput.addEventListener('input', () => {
                this.hideError();
            });
        }
        
        // Enter key submission
        this.brandNameInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && this.isFormValid()) {
                e.preventDefault();
                this.submitBrand();
            }
        });
        
        if (this.brandCodeInput) {
            this.brandCodeInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' && this.isFormValid()) {
                    e.preventDefault();
                    this.submitBrand();
                }
            });
        }
    }
    
    validateForm() {
        const isValid = this.isFormValid();
        
        if (this.addButton) {
            this.addButton.disabled = !isValid;
            this.addButton.classList.toggle('toss-btn-disabled', !isValid);
        }
        
        return isValid;
    }
    
    isFormValid() {
        const brandName = this.brandNameInput?.value?.trim() || '';
        return brandName.length > 0 && brandName.length <= 100;
    }
    
    focusFirstInput() {
        setTimeout(() => {
            if (this.brandNameInput) {
                this.brandNameInput.focus();
            }
        }, 100);
    }
    
    async submitBrand() {
        if (this.isSubmitting || !this.isFormValid()) {
            return;
        }
        
        const brandName = this.brandNameInput.value.trim();
        const brandCode = this.brandCodeInput?.value?.trim() || null;
        
        this.setSubmittingState(true);
        this.hideError();
        
        try {
            // Call the inventory_create_brand RPC
            const result = await this.callCreateBrandRPC({
                p_company_id: this.options.companyId,
                p_brand_name: brandName,
                p_brand_code: brandCode
            });
            
            if (result.success) {
                // Success - call the callback and close modal
                if (this.options.onBrandAdded) {
                    this.options.onBrandAdded(result.data);
                }
                
                this.modal.close();
            } else {
                // Handle RPC error
                this.showError(result.message || 'Failed to create brand');
            }
            
        } catch (error) {
            console.error('Error creating brand:', error);
            this.showError('An unexpected error occurred. Please try again.');
            
            if (this.options.onError) {
                this.options.onError(error);
            }
        } finally {
            this.setSubmittingState(false);
        }
    }
    
    async callCreateBrandRPC(params) {
        try {
            // Check if Supabase is available
            if (typeof supabase === 'undefined') {
                throw new Error('Supabase client not available');
            }
            
            // Call the inventory_create_brand RPC function
            const { data, error } = await supabase.rpc('inventory_create_brand', params);
            
            if (error) {
                console.error('Supabase RPC error:', error);
                
                // Handle specific error codes
                if (error.code === 'P0001' || error.message.includes('DUPLICATE_BRAND')) {
                    return {
                        success: false,
                        error_code: 'DUPLICATE_BRAND',
                        message: 'A brand with this name already exists'
                    };
                }
                
                return {
                    success: false,
                    error_code: error.code || 'RPC_ERROR',
                    message: error.message || 'Failed to create brand'
                };
            }
            
            // Success case
            return {
                success: true,
                data: data
            };
            
        } catch (error) {
            console.error('Error calling create brand RPC:', error);
            
            // Fallback to mock for development/testing
            if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
                console.warn('Using mock response for development');
                return this.mockCreateBrandResponse(params);
            }
            
            return {
                success: false,
                error_code: 'NETWORK_ERROR',
                message: 'Network error occurred. Please try again.'
            };
        }
    }
    
    // Mock response for development/testing
    mockCreateBrandResponse(params) {
        // Simulate duplicate brand error sometimes
        if (params.p_brand_name.toLowerCase() === 'test duplicate') {
            return {
                success: false,
                error_code: 'DUPLICATE_BRAND',
                message: 'A brand with this name already exists'
            };
        }
        
        // Simulate success
        const mockBrandId = Date.now();
        const mockBrandCode = params.p_brand_code || 
            params.p_brand_name.replace(/\s+/g, '_').toUpperCase().substring(0, 10);
            
        return {
            success: true,
            data: {
                brand_id: mockBrandId,
                brand_name: params.p_brand_name,
                brand_code: mockBrandCode,
                company_id: params.p_company_id,
                created_at: new Date().toISOString()
            }
        };
    }
    
    setSubmittingState(isSubmitting) {
        this.isSubmitting = isSubmitting;
        
        if (this.addButton) {
            this.addButton.disabled = isSubmitting || !this.isFormValid();
            this.addButton.innerHTML = isSubmitting ? 
                '<div class="toss-spinner toss-spinner-sm"></div> Adding...' : 
                'Add Brand';
        }
        
        // Disable inputs during submission
        if (this.brandNameInput) {
            this.brandNameInput.disabled = isSubmitting;
        }
        
        if (this.brandCodeInput) {
            this.brandCodeInput.disabled = isSubmitting;
        }
    }
    
    showError(message) {
        if (this.errorAlert && this.errorMessage) {
            this.errorMessage.textContent = message;
            this.errorAlert.style.display = 'block';
            
            // Scroll to error if needed
            this.errorAlert.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    }
    
    hideError() {
        if (this.errorAlert) {
            this.errorAlert.style.display = 'none';
        }
    }
    
    cleanup() {
        // Clean up Toss input instances
        if (this.brandNameInput?._tossInput) {
            this.brandNameInput._tossInput.destroy();
            this.brandNameInput._tossInput = null;
        }
        
        if (this.brandCodeInput?._tossInput) {
            this.brandCodeInput._tossInput.destroy();
            this.brandCodeInput._tossInput = null;
        }
        
        // Reset state
        this.isSubmitting = false;
        this.brandNameInput = null;
        this.brandCodeInput = null;
        this.addButton = null;
    }
    
    // Public API
    open() {
        if (this.modal) {
            this.modal.open();
        }
    }
    
    close() {
        if (this.modal) {
            this.modal.close();
        }
    }
    
    destroy() {
        this.cleanup();
        if (this.modal) {
            this.modal.destroy();
            this.modal = null;
        }
        
        // Clean up global reference
        delete window['add-brand-modal_instance'];
    }
}

// Make it globally available
window.AddBrandModal = AddBrandModal;