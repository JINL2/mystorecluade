/**
 * Common Page Initialization Utility
 * Standardizes navbar and app state initialization across all pages
 */

class PageInitializer {
    constructor(activeItem = 'dashboard') {
        this.activeItem = activeItem;
        // Prevent navbar auto-initialization
        window.skipNavbarAutoInit = true;
    }

    /**
     * Initialize page with authentication, navbar, and app state
     * Uses the same pattern as the working dashboard
     */
    async initialize() {
        try {
            console.log(`🎯 ${this.activeItem} page DOMContentLoaded at:`, new Date().toISOString());

            // Check authentication first
            const { data: { session }, error } = await supabase.auth.getSession();
            if (!session) {
                // Use proper path calculation for login redirect
                const currentPath = window.location.pathname;
                let loginPath;
                
                // Check if we're in the mcparrange-main project
                if (currentPath.includes('/mcparrange-main/')) {
                    // Extract the base path up to mcparrange-main
                    const baseMatch = currentPath.match(/(.*\/mcparrange-main\/)/);
                    if (baseMatch) {
                        // Build the correct absolute path to login
                        loginPath = baseMatch[1] + 'myFinance_claude/website/pages/auth/login.html';
                    } else {
                        // Fallback
                        loginPath = '/mcparrange-main/myFinance_claude/website/pages/auth/login.html';
                    }
                } else {
                    // Calculate relative path for other structures
                    const depth = window.location.pathname.split('/').filter(p => p).length - 2;
                    loginPath = '../'.repeat(depth) + 'pages/auth/login.html';
                }
                
                console.log('PageInitializer redirecting to login:', loginPath);
                window.location.href = loginPath;
                return;
            }

            // Initialize navbar FIRST with correct active item BEFORE loading data
            await this.initializeNavbar(session);
            
            // Load app state if needed (same as dashboard)
            console.log('⏳ Loading app state data at:', new Date().toISOString());
            await this.loadAppStateData(session);
            console.log('✅ App state data loaded, refreshing navbar components at:', new Date().toISOString());

            // Refresh navbar components after data load (same as dashboard)
            await this.refreshNavbarComponents();

            console.log(`✅ ${this.activeItem} page initialized successfully`);

        } catch (error) {
            console.error(`${this.activeItem} initialization error:`, error);
            if (typeof TossAlertUtils !== 'undefined') {
                TossAlertUtils.showError('Failed to initialize page. Please refresh.');
            }
        }
    }

    /**
     * Initialize navbar with correct settings
     */
    async initializeNavbar(session) {
        if (!window.navbarInstance) {
            // Check if NavBar class is available
            if (typeof window.NavBar === 'undefined') {
                console.error('❌ NavBar class not available yet');
                // Wait a bit and try again
                await new Promise(resolve => setTimeout(resolve, 100));
                if (typeof window.NavBar === 'undefined') {
                    console.error('❌ NavBar class still not available');
                    return;
                }
            }
            
            console.log(`🎨 Initializing navbar with activeItem: ${this.activeItem}`);
            
            // Extract user info from session
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
            
            // Initialize navbar with correct active item and user info
            window.navbarInstance = new window.NavBar({
                containerId: 'navbar-container',
                activeItem: this.activeItem,
                user: {
                    name: userName || 'User',
                    email: session.user.email
                }
            });
            window.navbarInstance.init();
            console.log(`✅ Navbar initialized with activeItem: ${this.activeItem}`);
        } else {
            // Navbar already exists, just update the active item
            console.log(`🔄 Updating navbar activeItem to: ${this.activeItem}`);
            window.navbarInstance.setActiveItem(this.activeItem);
        }
    }
    
    /**
     * Refresh navbar components with proper timing
     */
    async refreshNavbarComponents() {
        if (window.navbarInstance) {
            window.navbarInstance.setActiveItem(this.activeItem);

            // Refresh user info with authenticated session
            if (window.refreshNavbarUserInfo) {
                console.log('Refreshing navbar user info after authentication');
                await window.refreshNavbarUserInfo();
            }

            // Refresh company selector immediately after data is loaded
            if (window.refreshNavbarCompanySelector) {
                console.log('🔄 Refreshing company selector immediately after data load');
                // Verify data is actually in localStorage before refresh
                const storedData = localStorage.getItem('user');
                console.log('📦 Data in localStorage before refresh:', !!storedData);
                if (storedData) {
                    const parsed = JSON.parse(storedData);
                    console.log('📊 Companies count before refresh:', parsed.companies?.length || 0);
                }
                window.refreshNavbarCompanySelector();
            }
        } else {
            // If navbar instance doesn't exist yet, wait a moment and try again
            setTimeout(async () => {
                if (window.navbarInstance) {
                    window.navbarInstance.setActiveItem(this.activeItem);

                    if (window.refreshNavbarUserInfo) {
                        await window.refreshNavbarUserInfo();
                    }

                    if (window.refreshNavbarCompanySelector) {
                        window.refreshNavbarCompanySelector();
                    }
                }
            }, 100);
        }
    }

    /**
     * Load app state data from RPCs - same as dashboard
     */
    async loadAppStateData(session) {
        try {
            // Check if data already exists and is fresh
            const existingUserData = appState.getUserData();
            const existingCategories = appState.getCategoryFeatures();

            // Fetch if data doesn't exist, needs refresh, OR has no companies
            const needsData = !existingUserData || 
                             appState.needsRefresh() || 
                             !existingUserData.companies || 
                             existingUserData.companies.length === 0;
            
            if (needsData) {
                console.log('Loading user companies and stores (data missing or incomplete)...');

                // Call get_user_companies_and_stores RPC
                const { data: userData, error: userError } = await supabase.rpc('get_user_companies_and_stores', {
                    p_user_id: session.user.id
                });

                if (userError) {
                    console.error('Error fetching user companies:', userError);
                    return; // Exit early on error
                } else if (userData) {
                    // Store user data
                    console.log(`📥 ${this.activeItem} storing user data:`, userData);
                    console.log('📊 Companies in userData:', userData.companies?.length || 0);
                    appState.setUserData(userData);
                    console.log('✅ User data stored in localStorage');

                    // Set first company as selected if none selected
                    const selectedCompanyId = appState.getSelectedCompanyId();
                    if (!selectedCompanyId && userData.companies && userData.companies.length > 0) {
                        // This will also set the first store
                        appState.setSelectedCompanyId(userData.companies[0].company_id);
                    } else if (selectedCompanyId) {
                        // Ensure store is also set for existing company selection
                        const selectedCompany = userData.companies.find(c => c.company_id === selectedCompanyId);
                        if (selectedCompany && !appState.getSelectedStoreId()) {
                            if (selectedCompany.stores && selectedCompany.stores.length > 0) {
                                appState.setSelectedStoreId(selectedCompany.stores[0].store_id);
                            }
                        }
                    }
                }
            }

            // Load categories with features if not exists
            if (!existingCategories || appState.needsRefresh()) {
                console.log('Loading categories with features...');

                // Call get_categories_with_features RPC
                const { data: categoriesData, error: categoriesError } = await supabase.rpc('get_categories_with_features');

                if (categoriesError) {
                    console.error('Error fetching categories:', categoriesError);
                } else if (categoriesData) {
                    // Store categories data
                    appState.setCategoryFeatures(categoriesData);
                }
            }

            // Mark data as refreshed
            appState.markRefreshed();

        } catch (error) {
            console.error('Error loading app state data:', error);
        }
    }

    /**
     * Set up company change event listener
     */
    setupCompanyChangeListener(callback) {
        window.addEventListener('companyChanged', (event) => {
            console.log('Company changed:', event.detail);
            if (callback) {
                callback(event.detail.companyId, event.detail);
            }
        });
    }
}

// Global utility function for easy use
window.initializePage = function(activeItem, onCompanyChange) {
    // Set this flag IMMEDIATELY to prevent navbar auto-init
    window.skipNavbarAutoInit = true;
    
    const initializer = new PageInitializer(activeItem);
    
    // If DOM is already loaded, initialize immediately
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', async () => {
            await initializer.initialize();
            
            // Set up company change listener if provided
            if (onCompanyChange) {
                initializer.setupCompanyChangeListener(onCompanyChange);
            }
        });
    } else {
        // DOM already loaded, initialize now
        (async () => {
            await initializer.initialize();
            
            // Set up company change listener if provided
            if (onCompanyChange) {
                initializer.setupCompanyChangeListener(onCompanyChange);
            }
        })();
    }
};

// Export for direct use
window.PageInitializer = PageInitializer;