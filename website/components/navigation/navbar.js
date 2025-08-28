/**
 * Common Navigation Bar Component
 * Reusable across all pages
 */

class NavBar {
    constructor(options = {}) {
        this.options = {
            containerId: options.containerId || 'navbar-container',
            activeItem: options.activeItem || 'dashboard',
            user: options.user || null,
            onSignOut: options.onSignOut || null,
            ...options
        };
        
        this.navItems = [
            {
                id: 'dashboard',
                label: 'Dashboard',
                href: '#',
                active: false
            },
            {
                id: 'product',
                label: 'Product',
                href: '#',
                dropdown: [
                    {
                        section: 'Product Management',
                        items: [
                            { label: 'Inventory', href: '#', action: 'Inventory' }
                        ]
                    }
                ]
            },
            {
                id: 'marketing',
                label: 'Marketing',
                href: '#',
                dropdown: [
                    {
                        section: 'Marketing Tools',
                        items: [
                            { label: 'Marketing Plan', href: '#', action: 'Marketing Plan' }
                        ]
                    }
                ]
            },
            {
                id: 'finance',
                label: 'Finance',
                href: '#',
                dropdown: [
                    {
                        section: 'Financial Reports',
                        items: [
                            { label: 'Balance Sheet', href: '#', action: 'Balance Sheet' },
                            { label: 'Income Statement', href: '#', action: 'Income Statement' }
                        ]
                    },
                    {
                        section: 'Transactions',
                        items: [
                            { label: 'Journal Input', href: '#', action: 'Journal Input' },
                            { label: 'Transaction History', href: '#', action: 'Transaction History' },
                            { label: 'Cash Ending', href: '#', action: 'Cash Ending' }
                        ]
                    }
                ]
            },
            {
                id: 'employee',
                label: 'Employee',
                href: '#',
                dropdown: [
                    {
                        section: 'Employee Management',
                        items: [
                            { label: 'Schedule', href: '#', action: 'Schedule' },
                            { label: 'Employee Setting', href: '#', action: 'Employee Setting' },
                            { label: 'Salary', href: '#', action: 'Salary' }
                        ]
                    }
                ]
            },
            {
                id: 'setting',
                label: 'Setting',
                href: '#',
                dropdown: [
                    {
                        section: 'General Settings',
                        items: [
                            { label: 'Currency', href: '#', action: 'Currency' },
                            { label: 'Company & Store Setting', href: '#', action: 'Company & Store Setting' }
                        ]
                    },
                    {
                        section: 'Financial Settings',
                        items: [
                            { label: 'Account Mapping', href: '#', action: 'Account Mapping' },
                            { label: 'Counterparty', href: '#', action: 'Counterparty' }
                        ]
                    }
                ]
            }
        ];
    }
    
    init() {
        this.render();
        this.attachEventListeners();
        this.updateUserInfo();
        // Load companies after render to ensure DOM is ready
        // Use multiple attempts to ensure data is loaded
        this.loadCompaniesWithRetry();
    }
    
    loadCompaniesWithRetry(attempts = 0, maxAttempts = 5) {
        const delay = attempts * 200; // Increase delay with each attempt
        
        setTimeout(async () => {
            console.log(`Attempt ${attempts + 1} to load companies`);
            
            // Check if we have user data
            const userData = localStorage.getItem('user');
            
            if (userData) {
                console.log('User data found, loading companies');
                await this.loadUserCompanies();
            } else if (attempts < maxAttempts) {
                console.log(`No user data found, retrying in ${delay + 200}ms...`);
                this.loadCompaniesWithRetry(attempts + 1, maxAttempts);
            } else {
                console.log('Max attempts reached, company selector may not be available');
            }
        }, delay);
    }
    
    render() {
        const container = document.getElementById(this.options.containerId);
        if (!container) {
            console.error(`Container with id "${this.options.containerId}" not found`);
            return;
        }
        
        const navHTML = `
            <nav class="navbar-component">
                <div class="navbar-inner">
                    <!-- Logo -->
                    <a href="#" class="navbar-brand">
                        <div class="navbar-logo" id="navbar-logo"></div>
                        <h1 class="navbar-title">MyFinance</h1>
                    </a>
                    
                    <!-- Navigation Menu -->
                    <div class="navbar-menu">
                        ${this.renderNavItems()}
                    </div>
                    
                    <!-- User Section -->
                    <div class="navbar-user">
                        <!-- Company Selector (positioned left of user info) -->
                        <div id="navbar-company-selector"></div>
                        
                        <div class="navbar-user-profile" onclick="NavBar.toggleUserMenu()">
                            <div class="navbar-user-avatar" id="navbar-user-avatar">U</div>
                            <div class="navbar-user-info">
                                <h4 id="navbar-user-name">Loading...</h4>
                                <p id="navbar-user-email">Loading...</p>
                            </div>
                        </div>
                        
                        <button class="navbar-btn-signout" onclick="NavBar.handleSignOut()">
                            Sign Out
                        </button>
                    </div>
                </div>
            </nav>
        `;
        
        container.innerHTML = navHTML;
        
        // Set logo using AppIcons
        this.setLogo();
        
        // Show loading state immediately, then auto-load company selector
        this.showCompanySelectorLoading();
        this.autoInitializeCompanySelector();
    }
    
    renderNavItems() {
        return this.navItems.map(item => {
            const isActive = item.id === this.options.activeItem;
            const hasDropdown = item.dropdown && item.dropdown.length > 0;
            
            let navItemHTML = `
                <div class="navbar-nav-item">
                    <a href="${item.href}" 
                       class="navbar-nav-link ${isActive ? 'active' : ''}"
                       ${!hasDropdown ? `onclick="NavBar.handleNavClick('${item.id}', '${item.label}')"` : ''}
                       data-nav-id="${item.id}">
                        ${item.label}
                    </a>
            `;
            
            if (hasDropdown) {
                navItemHTML += `
                    <div class="navbar-dropdown-menu">
                        ${this.renderDropdown(item.dropdown)}
                    </div>
                `;
            }
            
            navItemHTML += '</div>';
            return navItemHTML;
        }).join('');
    }
    
    renderDropdown(dropdown) {
        return dropdown.map(section => `
            <div class="navbar-dropdown-section">
                <div class="navbar-dropdown-title">${section.section}</div>
                ${section.items.map(item => `
                    <a href="${item.href}" 
                       class="navbar-dropdown-link" 
                       onclick="NavBar.handleDropdownClick('${item.action}')">
                        ${item.label}
                    </a>
                `).join('')}
            </div>
        `).join('');
    }
    
    autoInitializeCompanySelector() {
        // Automatically initialize company selector with multiple attempts
        console.log('🔄 autoInitializeCompanySelector called');
        let attempts = 0;
        const maxAttempts = 20; // Increased for RPC loading time
        const baseDelay = 200; // Increased delay to allow for data loading
        
        const tryInitialize = () => {
            attempts++;
            console.log(`Auto-initializing company selector - attempt ${attempts}`);
            
            // Check if container exists
            const container = document.getElementById('navbar-company-selector');
            if (!container) {
                console.log('Company selector container not found yet');
                if (attempts < maxAttempts) {
                    setTimeout(tryInitialize, baseDelay * attempts);
                }
                return;
            }
            
            // Check for user data
            const userData = localStorage.getItem('user');
            console.log('🔍 User data check - attempt', attempts);
            console.log('userData exists:', !!userData);
            
            if (userData) {
                try {
                    const parsedData = JSON.parse(userData);
                    console.log('📊 Parsed data:', parsedData);
                    console.log('Companies exist:', !!parsedData.companies);
                    console.log('Companies count:', parsedData.companies?.length || 0);
                    
                    if (parsedData.companies && parsedData.companies.length > 0) {
                        console.log('User data with companies found, initializing selector');
                        
                        // Clear any existing loading state
                        container.innerHTML = '';
                        
                        // Get or set default company selection
                        let selectedCompanyId = localStorage.getItem('companyChoosen');
                        if (!selectedCompanyId) {
                            selectedCompanyId = parsedData.companies[0].company_id;
                            localStorage.setItem('companyChoosen', selectedCompanyId);
                            
                            // Set first store as default
                            const firstCompany = parsedData.companies[0];
                            if (firstCompany.stores && firstCompany.stores.length > 0) {
                                localStorage.setItem('storeChoosen', firstCompany.stores[0].store_id);
                            }
                        }
                        
                        // Initialize the company selector
                        console.log('Calling initCompanySelector with:', parsedData.companies.length, 'companies');
                        try {
                            this.initCompanySelector(parsedData.companies, selectedCompanyId);
                            console.log('✅ Company selector initialized successfully');
                            return; // Success - stop trying
                        } catch (error) {
                            console.error('❌ Error in initCompanySelector:', error);
                        }
                    } else {
                        console.log('❌ No companies found in user data or companies array is empty');
                        console.log('parsedData.companies:', parsedData.companies);
                        // Show no companies message
                        container.innerHTML = `
                            <div style="
                                padding: 8px 12px;
                                border: 1px solid #ffc107;
                                border-radius: 8px;
                                background: #fff3cd;
                                color: #856404;
                                font-size: 14px;
                                min-width: 200px;
                                text-align: center;
                            ">
                                No companies found
                            </div>
                        `;
                        return; // Stop trying if no companies
                    }
                } catch (error) {
                    console.error('❌ Error parsing user data:', error);
                }
            } else {
                console.log('❌ No user data found in localStorage');
            }
            
            // Retry if we haven't reached max attempts
            if (attempts < maxAttempts) {
                console.log(`⏳ Retrying in ${baseDelay * attempts}ms... (attempt ${attempts}/${maxAttempts})`);
                setTimeout(tryInitialize, baseDelay * attempts);
            } else {
                console.log('🚨 Max attempts reached - company selector initialization failed');
                console.log('Final localStorage check:', localStorage.getItem('user'));
                // Create a placeholder or fallback
                this.createPlaceholderSelector();
            }
        };
        
        // Start the initialization attempts
        tryInitialize();
    }
    
    createPlaceholderSelector() {
        console.log('🔧 Creating placeholder selector (retry button)');
        console.log('📦 localStorage user data when placeholder created:', localStorage.getItem('user'));
        
        const container = document.getElementById('navbar-company-selector');
        if (container) {
            container.innerHTML = `
                <button onclick="window.refreshNavbarCompanySelector()" class="company-selector-retry" style="
                    padding: 8px 12px;
                    background: white;
                    border: 1px solid #6c757d;
                    border-radius: 8px;
                    color: #6c757d;
                    font-size: 14px;
                    min-width: 200px;
                    cursor: pointer;
                    text-align: center;
                " onmouseover="this.style.background='#f8f9fa'" onmouseout="this.style.background='white'">
                    Retry Company Load
                </button>
            `;
        }
    }
    
    setLogo() {
        const logoElement = document.getElementById('navbar-logo');
        if (logoElement && typeof AppIcons !== 'undefined') {
            // Use the Won sign from AppIcons
            logoElement.innerHTML = AppIcons.getSVG('wonSign', { 
                size: 20, 
                color: 'white' 
            });
        } else if (logoElement) {
            // Fallback if AppIcons is not loaded
            logoElement.textContent = '₩';
        }
    }
    
    showCompanySelectorLoading() {
        const container = document.getElementById('navbar-company-selector');
        if (container) {
            container.innerHTML = `
                <div class="company-selector-loading" style="
                    padding: 8px 12px;
                    border: 1px solid #dee2e6;
                    border-radius: 8px;
                    background: white;
                    color: #6c757d;
                    font-size: 14px;
                    min-width: 200px;
                    text-align: center;
                ">
                    Loading companies...
                </div>
            `;
        }
    }
    
    updateUserInfo() {
        if (this.options.user) {
            const nameElement = document.getElementById('navbar-user-name');
            const emailElement = document.getElementById('navbar-user-email');
            const avatarElement = document.getElementById('navbar-user-avatar');
            
            if (nameElement) {
                nameElement.textContent = this.options.user.name || 'User';
            }
            if (emailElement) {
                emailElement.textContent = this.options.user.email || '';
            }
            if (avatarElement && this.options.user.name) {
                avatarElement.textContent = this.options.user.name.charAt(0).toUpperCase();
            }
        }
    }
    
    // Method to update user info from current session
    async updateUserFromSession() {
        try {
            if (typeof supabase !== 'undefined') {
                const { data: { session } } = await supabase.auth.getSession();
                if (session && session.user) {
                    console.log('Updating navbar with session user:', session.user);
                    console.log('User metadata:', session.user.user_metadata);
                    
                    // Extract user name from various possible sources
                    let userName = session.user.user_metadata?.full_name || 
                                   session.user.user_metadata?.name ||
                                   session.user.user_metadata?.display_name;
                    
                    // If no name in metadata, try to create from email
                    if (!userName && session.user.email) {
                        const emailName = session.user.email.split('@')[0];
                        // Capitalize first letter and replace dots/underscores with spaces
                        userName = emailName.replace(/[._]/g, ' ')
                                          .split(' ')
                                          .map(word => word.charAt(0).toUpperCase() + word.slice(1))
                                          .join(' ');
                    }
                    
                    // Final fallback
                    if (!userName) {
                        userName = 'User';
                    }
                    
                    console.log('Extracted user name:', userName);
                    
                    this.options.user = {
                        name: userName,
                        email: session.user.email
                    };
                    
                    // Update the UI
                    this.updateUserInfo();
                    
                    return true;
                }
            }
        } catch (error) {
            console.error('Error updating user from session:', error);
        }
        return false;
    }
    
    attachEventListeners() {
        // Close dropdowns when clicking outside
        document.addEventListener('click', (event) => {
            if (!event.target.closest('.navbar-nav-item')) {
                this.closeAllDropdowns();
            }
        });
    }
    
    closeAllDropdowns() {
        document.querySelectorAll('.navbar-dropdown-menu').forEach(menu => {
            menu.classList.remove('show');
        });
    }
    
    setActiveItem(itemId) {
        // Remove active class from all items
        document.querySelectorAll('.navbar-nav-link').forEach(link => {
            link.classList.remove('active');
        });
        
        // Add active class to specified item
        const activeLink = document.querySelector(`[data-nav-id="${itemId}"]`);
        if (activeLink) {
            activeLink.classList.add('active');
        }
        
        this.options.activeItem = itemId;
    }
    
    updateUser(user) {
        this.options.user = user;
        this.updateUserInfo();
    }
    
    async loadUserCompanies() {
        try {
            console.log('💼 Loading user companies...');
            console.log('⏰ Called at:', new Date().toISOString());
            
            // First check if we have user data in localStorage
            const storedUserData = localStorage.getItem('user');
            console.log('📦 Stored user data exists:', !!storedUserData);
            
            if (storedUserData) {
                console.log('Found stored user data');
                const userData = JSON.parse(storedUserData);
                console.log('User data parsed:', userData);
                console.log('Companies in data:', userData.companies);
                
                // Get previously selected company
                let selectedCompanyId = localStorage.getItem('companyChoosen') || '';
                console.log('Previously selected company ID:', selectedCompanyId);
                
                if (userData && userData.companies && userData.companies.length > 0) {
                    console.log('Found', userData.companies.length, 'companies');
                    
                    // If no company selected or selected company not in list, use first
                    const companyExists = userData.companies.some(c => c.company_id === selectedCompanyId);
                    if (!selectedCompanyId || !companyExists) {
                        selectedCompanyId = userData.companies[0].company_id;
                        localStorage.setItem('companyChoosen', selectedCompanyId);
                        console.log('Set default company:', selectedCompanyId);
                        
                        // Also set the first store for the selected company
                        const selectedCompany = userData.companies[0];
                        if (selectedCompany.stores && selectedCompany.stores.length > 0) {
                            localStorage.setItem('storeChoosen', selectedCompany.stores[0].store_id);
                            console.log('Set default store:', selectedCompany.stores[0].store_id);
                        }
                    }
                    
                    // Initialize company selector using cached data
                    this.initCompanySelector(userData.companies, selectedCompanyId);
                } else {
                    console.log('No companies found in user data');
                }
                return;
            }
            
            // If no cached data, fetch from RPC
            const { data: { session }, error } = await supabase.auth.getSession();
            if (!session) {
                console.error('No active session');
                return;
            }
            
            // Call RPC to get user companies and stores
            const { data, error: rpcError } = await supabase.rpc('get_user_companies_and_stores', {
                p_user_id: session.user.id
            });
            
            if (rpcError) {
                console.error('Error fetching companies:', rpcError);
                return;
            }
            
            // Store user data in localStorage
            localStorage.setItem('user', JSON.stringify(data));
            
            // Get previously selected company or use first available
            let selectedCompanyId = localStorage.getItem('companyChoosen') || '';
            
            if (data && data.companies && data.companies.length > 0) {
                // If no company selected or selected company not in list, use first
                const companyExists = data.companies.some(c => c.company_id === selectedCompanyId);
                if (!selectedCompanyId || !companyExists) {
                    selectedCompanyId = data.companies[0].company_id;
                    localStorage.setItem('companyChoosen', selectedCompanyId);
                    
                    // Also set the first store for the selected company
                    const selectedCompany = data.companies[0];
                    if (selectedCompany.stores && selectedCompany.stores.length > 0) {
                        localStorage.setItem('storeChoosen', selectedCompany.stores[0].store_id);
                    }
                }
                
                // Initialize company selector
                this.initCompanySelector(data.companies, selectedCompanyId);
            }
        } catch (error) {
            console.error('Error loading companies:', error);
        }
    }
    
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
    
    createFallbackSelector(container, options, selectedId) {
        // Create a simple fallback selector
        const selectedOption = options.find(opt => opt.value === selectedId);
        
        container.innerHTML = `
            <div class="company-fallback-selector">
                <select id="company-fallback" style="
                    padding: 8px 12px;
                    border: 1px solid #dee2e6;
                    border-radius: 8px;
                    background: white;
                    color: #212529;
                    font-size: 14px;
                    min-width: 200px;
                ">
                    ${options.map(option => `
                        <option value="${option.value}" ${option.value === selectedId ? 'selected' : ''}>
                            ${option.label} (${option.description})
                        </option>
                    `).join('')}
                </select>
            </div>
        `;
        
        // Add event listener for fallback selector
        const fallbackSelect = container.querySelector('#company-fallback');
        if (fallbackSelect) {
            fallbackSelect.addEventListener('change', (e) => {
                const selectedValue = e.target.value;
                const selectedOption = options.find(opt => opt.value === selectedValue);
                
                if (selectedOption) {
                    // Save selected company (UUID)
                    localStorage.setItem('companyChoosen', selectedValue);
                    
                    // Also update the first store for the selected company
                    if (selectedOption.data && selectedOption.data.stores && selectedOption.data.stores.length > 0) {
                        localStorage.setItem('storeChoosen', selectedOption.data.stores[0].store_id);
                    } else {
                        localStorage.removeItem('storeChoosen');
                    }
                    
                    // Trigger company change event
                    window.dispatchEvent(new CustomEvent('companyChanged', { 
                        detail: { 
                            companyId: selectedValue, 
                            companyName: selectedOption.label,
                            company: selectedOption.data 
                        } 
                    }));
                }
            });
        }
        console.log('Fallback company selector created');
    }
    
    // Method to manually refresh company selector (can be called from any page)
    refreshCompanySelector() {
        console.log('Manually refreshing company selector');
        this.loadUserCompanies();
    }
    
    updateCompanySelector(companies) {
        if (this.companySelector) {
            // Convert companies to select options format
            const options = companies.map(company => ({
                value: company.company_id,
                label: company.company_name,
                description: company.stores ? `${company.stores.length} store${company.stores.length !== 1 ? 's' : ''}` : '0 stores',
                data: company
            }));
            
            // Update the selector options
            this.companySelector.setOptions(options);
        }
    }
    
    // Static methods for global access
    static handleNavClick(navId, label) {
        console.log(`Navigation clicked: ${label}`);
        
        // For main nav items, navigate directly
        if (navId === 'dashboard') {
            // Navigate to dashboard/homepage
            NavBar.navigateToPage('Dashboard');
        } else {
            // For items with dropdowns, don't navigate
            // The dropdown will handle navigation
            console.log(`Dropdown menu for: ${label}`);
        }
        
        // Prevent default navigation
        event.preventDefault();
    }
    
    static handleDropdownClick(action) {
        console.log(`Dropdown action: ${action}`);
        
        // Navigate to the appropriate page based on the action
        NavBar.navigateToPage(action);
        
        // Prevent default navigation
        event.preventDefault();
    }
    
    // Navigate to a page based on the menu item
    static navigateToPage(menuItem) {
        // Load route mapping if available
        if (typeof getRouteForMenuItem !== 'undefined') {
            const route = getRouteForMenuItem(menuItem);
            if (route) {
                const basePath = NavBar.getRelativePathPrefix();
                const url = buildPageUrl(route, basePath);
                if (url !== '#') {
                    window.location.href = url;
                    return;
                }
            }
        }
        
        // Fallback to coming soon if route not found
        if (typeof showComingSoon === 'function') {
            showComingSoon(menuItem);
        }
    }
    
    // Get the absolute path prefix for XAMPP environment consistency
    static getRelativePathPrefix() {
        // Always return absolute path to pages directory for XAMPP environment
        return '/mcparrange-main/myFinance_claude/website/pages/';
    }
    
    static toggleUserMenu() {
        console.log('User menu toggled');
        if (typeof showComingSoon === 'function') {
            showComingSoon('User Menu');
        }
    }
    
    /**
     * Navigate to login page with proper path calculation
     */
    static navigateToLogin() {
        const currentPath = window.location.pathname;
        
        console.log('🔄 NavBar navigating from path:', currentPath);
        
        // Use absolute path for XAMPP environment consistency
        const loginPath = '/mcparrange-main/myFinance_claude/website/pages/auth/login.html';
        
        console.log('✅ Using absolute login path:', loginPath);
        
        // Use replace to prevent back button issues
        window.location.replace(loginPath);
    }
    
    static async handleSignOut() {
        console.log('Sign out requested');
        
        try {
            // Clear all local storage data first
            NavBar.clearUserData();
            
            // Check if Supabase is available and try to sign out
            if (typeof SupabaseAuth !== 'undefined') {
                try {
                    const result = await SupabaseAuth.signOut();
                    
                    if (result.success) {
                        if (typeof TossAlertUtils !== 'undefined') {
                            TossAlertUtils.showSuccess('Signing out...');
                        }
                        setTimeout(() => {
                            // Navigate to login page with proper path calculation
                            NavBar.navigateToLogin();
                        }, 1000);
                    } else {
                        // Even if Supabase fails, still redirect (data is already cleared)
                        console.warn('Supabase signout failed but continuing logout');
                        setTimeout(() => {
                            NavBar.navigateToLogin();
                        }, 1000);
                    }
                } catch (supabaseError) {
                    console.warn('Supabase signout error:', supabaseError);
                    // Continue with logout anyway
                    setTimeout(() => {
                        NavBar.navigateToLogin();
                    }, 1000);
                }
            } else {
                // Fallback if Supabase is not loaded - just navigate
                setTimeout(() => {
                    NavBar.navigateToLogin();
                }, 500);
            }
        } catch (error) {
            console.error('Critical sign out error:', error);
            // Force navigation even if everything fails
            NavBar.clearUserData();
            NavBar.navigateToLogin();
        }
    }
    
    /**
     * Clear all user data and cached information
     */
    static clearUserData() {
        try {
            // Clear localStorage
            localStorage.removeItem('user');
            localStorage.removeItem('session');
            localStorage.removeItem('companyChoosen');
            localStorage.removeItem('storeChoosen');
            
            // Clear sessionStorage
            sessionStorage.clear();
            
            // Clear any app-specific data
            if (typeof appState !== 'undefined' && appState.clear) {
                appState.clear();
            }
            
            // Clear window-level caches if they exist
            if (window.navbarInstance && window.navbarInstance.companySelector) {
                try {
                    if (window.navbarInstance.companySelector.destroy) {
                        window.navbarInstance.companySelector.destroy();
                    }
                    window.navbarInstance.companySelector = null;
                } catch (e) {
                    console.warn('Error clearing company selector:', e);
                }
            }
            
            console.log('User data cleared successfully');
        } catch (error) {
            console.error('Error clearing user data:', error);
            // Try to clear individual items even if the bulk clear failed
            try {
                localStorage.clear();
                sessionStorage.clear();
            } catch (clearError) {
                console.error('Failed to clear storage:', clearError);
            }
        }
    }
}

// Auto-initialize if DOM is ready
async function autoInitNavbar() {
    // Skip auto-init if page uses PageInitializer
    if (window.skipNavbarAutoInit) {
        console.log('⏭️ Skipping navbar auto-init (handled by PageInitializer)');
        return;
    }
    
    if (document.getElementById('navbar-container') && !window.navbarInstance) {
        console.log('🚀 Auto-initializing navbar...');
        console.log('⏰ Time:', new Date().toISOString());
        
        // Try to get user info immediately
        let userInfo = { name: 'Loading...', email: 'Loading...' };
        
        try {
            if (typeof supabase !== 'undefined') {
                const { data: { session } } = await supabase.auth.getSession();
                if (session && session.user) {
                    console.log('Found authenticated user:', session.user.email);
                    
                    // Extract user name
                    let userName = session.user.user_metadata?.full_name || 
                                   session.user.user_metadata?.name ||
                                   session.user.user_metadata?.display_name;
                    
                    if (!userName && session.user.email) {
                        const emailName = session.user.email.split('@')[0];
                        userName = emailName.replace(/[._]/g, ' ')
                                          .split(' ')
                                          .map(word => word.charAt(0).toUpperCase() + word.slice(1))
                                          .join(' ');
                    }
                    
                    userInfo = {
                        name: userName || 'User',
                        email: session.user.email
                    };
                }
            }
        } catch (error) {
            console.error('Could not load user info for auto-init:', error);
        }
        
        // Initialize navbar with user info
        window.navbarInstance = new NavBar({
            user: userInfo
        });
        window.navbarInstance.init();
        
        console.log('Navbar initialized with user:', userInfo.name, userInfo.email);
    }
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', autoInitNavbar);
} else {
    // DOM already loaded
    autoInitNavbar();
}

// Global function to refresh company selector (can be called from any page)
window.refreshNavbarCompanySelector = function() {
    console.log('🔄 refreshNavbarCompanySelector called');
    console.log('navbar instance exists:', !!window.navbarInstance);
    
    const userData = localStorage.getItem('user');
    console.log('localStorage user data exists:', !!userData);
    
    if (userData) {
        try {
            const parsedData = JSON.parse(userData);
            console.log('User data companies count:', parsedData.companies?.length || 0);
        } catch (e) {
            console.error('Error parsing user data:', e);
        }
    }
    
    if (window.navbarInstance) {
        // Always try loadUserCompanies first since it's more direct
        if (window.navbarInstance.loadUserCompanies) {
            console.log('✨ Using loadUserCompanies method for refresh');
            window.navbarInstance.loadUserCompanies();
        } else {
            console.log('⚠️ loadUserCompanies not available, falling back to autoInitializeCompanySelector');
            window.navbarInstance.autoInitializeCompanySelector();
        }
    } else {
        console.log('❌ Navbar instance not found, attempting auto-init');
        autoInitNavbar();
    }
};

// Global function to refresh user info (can be called from any page)
window.refreshNavbarUserInfo = async function() {
    if (window.navbarInstance && window.navbarInstance.updateUserFromSession) {
        console.log('Refreshing navbar user info...');
        const updated = await window.navbarInstance.updateUserFromSession();
        if (updated) {
            console.log('User info refreshed successfully');
        } else {
            console.log('Failed to refresh user info');
        }
        return updated;
    } else {
        console.log('Navbar instance not found, attempting auto-init');
        autoInitNavbar();
        return false;
    }
};

// Make NavBar class available globally
window.NavBar = NavBar;