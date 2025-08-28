    initCompanySelector(companies, selectedId) {
        console.log('🔧 Initializing company selector with', companies.length, 'companies');
        console.log('Selected company ID:', selectedId);
        console.log('Companies data:', companies);
        
        // Check if container exists
        const container = document.getElementById('navbar-company-selector');
        if (!container) {
            console.error('Company selector container not found');
            return;
        }
        
        console.log('Container found:', container);
        
        // Remove duplicates from companies array - IMPORTANT FIX!
        const uniqueCompanies = [];
        const seenIds = new Set();
        
        for (const company of companies) {
            if (!seenIds.has(company.company_id)) {
                seenIds.add(company.company_id);
                uniqueCompanies.push(company);
            }
        }
        
        console.log('Unique companies after deduplication:', uniqueCompanies.length);
        
        // Convert companies to select options format
        const options = uniqueCompanies.map(company => ({
            value: company.company_id,
            label: company.company_name,
            description: company.stores ? `${company.stores.length} store${company.stores.length !== 1 ? 's' : ''}` : '0 stores',
            data: company
        }));
        
        console.log('Generated options:', options);
        console.log('TossSelect available:', typeof TossSelect !== 'undefined');
        
        // Clear any existing content and destroy existing selector
        container.innerHTML = '';
        
        if (this.companySelector) {
            try {
                if (this.companySelector.destroy) {
                    this.companySelector.destroy();
                }
                this.companySelector = null;
                console.log('Previous company selector destroyed');
            } catch (error) {
                console.warn('Error destroying previous selector:', error);
            }
        }
        
        // Check if TossSelect is available
        if (typeof TossSelect === 'undefined') {
            console.error('TossSelect component not loaded, using fallback');
            this.createFallbackSelector(container, options, selectedId);
            return;
        }
        
        // Create company selector using TossSelect component
        try {
            this.companySelector = new TossSelect({
                containerId: 'navbar-company-selector',
                name: 'company-selector',
                value: selectedId,
                placeholder: 'Select Company',
                options: options,
                width: 'inline',
                searchable: options.length > 5,
                onChange: (value, option) => {
                    // Save selected company (UUID)
                    localStorage.setItem('companyChoosen', value);
                    
                    // Also update the first store for the selected company
                    if (option.data && option.data.stores && option.data.stores.length > 0) {
                        localStorage.setItem('storeChoosen', option.data.stores[0].store_id);
                    } else {
                        // Clear store if no stores available
                        localStorage.removeItem('storeChoosen');
                    }
                    
                    // Trigger company change event
                    window.dispatchEvent(new CustomEvent('companyChanged', { 
                        detail: { 
                            companyId: value, 
                            companyName: option.label,
                            company: option.data 
                        } 
                    }));
                    
                    // Optionally reload page data
                    if (typeof window.onCompanyChange === 'function') {
                        window.onCompanyChange(value);
                    }
                }
            });
            
            this.companySelector.init();
            console.log('Company selector initialized successfully');
            
            // Force update display after initialization
            setTimeout(() => {
                if (this.companySelector && this.companySelector.updateDisplay) {
                    this.companySelector.updateDisplay();
                    console.log('✅ Force updated company selector display');
                }
            }, 100);
        } catch (error) {
            console.error('Error initializing TossSelect:', error);
            this.createFallbackSelector(container, options, selectedId);
        }
    }
