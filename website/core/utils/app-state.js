/**
 * App State Management Utility
 * Manages persistent application state across pages
 * Handles user data from get_user_companies_and_stores RPC
 */

class AppState {
    constructor() {
        this.storageKeys = {
            user: 'user',                    // Complete user data from RPC
            companyChoosen: 'companyChoosen', // Selected company ID
            storeChoosen: 'storeChoosen',     // Selected store ID
            categoryFeatures: 'categoryFeatures' // Category features data from get_categories_with_features
        };
    }

    /**
     * Get user data from localStorage
     * @returns {Object|null} User data object or null if not found
     */
    getUserData() {
        try {
            const userData = localStorage.getItem(this.storageKeys.user);
            return userData ? JSON.parse(userData) : null;
        } catch (error) {
            console.error('Error parsing user data:', error);
            return null;
        }
    }

    /**
     * Set user data in localStorage
     * @param {Object} userData - User data from RPC
     */
    setUserData(userData) {
        try {
            localStorage.setItem(this.storageKeys.user, JSON.stringify(userData));
        } catch (error) {
            console.error('Error storing user data:', error);
        }
    }

    /**
     * Get selected company ID
     * @returns {string|null} Company ID or null if not selected
     */
    getSelectedCompanyId() {
        return localStorage.getItem(this.storageKeys.companyChoosen);
    }

    /**
     * Set selected company ID
     * @param {string} companyId - Company ID (UUID) to select
     */
    setSelectedCompanyId(companyId) {
        localStorage.setItem(this.storageKeys.companyChoosen, companyId);
        
        // Also set the first store for the selected company
        const userData = this.getUserData();
        if (userData && userData.companies) {
            const company = userData.companies.find(c => c.company_id === companyId);
            if (company && company.stores && company.stores.length > 0) {
                this.setSelectedStoreId(company.stores[0].store_id);
            } else {
                localStorage.removeItem(this.storageKeys.storeChoosen);
            }
        }
    }

    /**
     * Get selected company data
     * @returns {Object|null} Selected company object or null
     */
    getSelectedCompany() {
        const userData = this.getUserData();
        const companyId = this.getSelectedCompanyId();
        
        if (!userData || !companyId || !userData.companies) {
            return null;
        }
        
        return userData.companies.find(c => c.company_id === companyId) || null;
    }

    /**
     * Get selected store ID
     * @returns {string|null} Store ID or null if not selected
     */
    getSelectedStoreId() {
        return localStorage.getItem(this.storageKeys.storeChoosen);
    }

    /**
     * Set selected store ID
     * @param {string} storeId - Store ID to select
     */
    setSelectedStoreId(storeId) {
        localStorage.setItem(this.storageKeys.storeChoosen, storeId);
    }

    /**
     * Get selected store data
     * @returns {Object|null} Selected store object or null
     */
    getSelectedStore() {
        const company = this.getSelectedCompany();
        const storeId = this.getSelectedStoreId();
        
        if (!company || !storeId || !company.stores) {
            return null;
        }
        
        return company.stores.find(s => s.store_id === storeId) || null;
    }

    /**
     * Check if user is authenticated
     * @returns {boolean} True if user data exists
     */
    isAuthenticated() {
        return !!this.getUserData();
    }

    /**
     * Clear all app state
     */
    clearState() {
        Object.values(this.storageKeys).forEach(key => {
            localStorage.removeItem(key);
        });
    }

    /**
     * Get user's full name
     * @returns {string} User's full name or 'User'
     */
    getUserName() {
        const userData = this.getUserData();
        if (!userData) return 'User';
        
        const firstName = userData.user_first_name || '';
        const lastName = userData.user_last_name || '';
        return `${firstName} ${lastName}`.trim() || 'User';
    }

    /**
     * Get user's profile image
     * @returns {string|null} Profile image URL or null
     */
    getUserProfileImage() {
        const userData = this.getUserData();
        return userData?.profile_image || null;
    }

    /**
     * Get all companies for the user
     * @returns {Array} Array of company objects
     */
    getUserCompanies() {
        const userData = this.getUserData();
        return userData?.companies || [];
    }

    /**
     * Get stores for selected company
     * @returns {Array} Array of store objects
     */
    getCompanyStores() {
        const company = this.getSelectedCompany();
        return company?.stores || [];
    }

    /**
     * Get user's role for selected company
     * @returns {Object|null} Role object or null
     */
    getUserRole() {
        const company = this.getSelectedCompany();
        return company?.role || null;
    }

    /**
     * Check if data needs refresh
     * @param {number} maxAge - Maximum age in milliseconds (default: 1 hour)
     * @returns {boolean} True if data needs refresh
     */
    needsRefresh(maxAge = 3600000) {
        const lastRefresh = localStorage.getItem('lastDataRefresh');
        if (!lastRefresh) return true;
        
        const age = Date.now() - parseInt(lastRefresh);
        return age > maxAge;
    }

    /**
     * Mark data as refreshed
     */
    markRefreshed() {
        localStorage.setItem('lastDataRefresh', Date.now().toString());
    }

    /**
     * Get category features data from localStorage
     * @returns {Array|null} Category features array or null if not found
     */
    getCategoryFeatures() {
        try {
            const data = localStorage.getItem(this.storageKeys.categoryFeatures);
            return data ? JSON.parse(data) : null;
        } catch (error) {
            console.error('Error parsing category features:', error);
            return null;
        }
    }

    /**
     * Set category features data in localStorage
     * @param {Array} categories - Category features data from RPC
     */
    setCategoryFeatures(categories) {
        try {
            localStorage.setItem(this.storageKeys.categoryFeatures, JSON.stringify(categories));
        } catch (error) {
            console.error('Error storing category features:', error);
        }
    }

    /**
     * Get features for a specific category
     * @param {string} categoryName - Name of the category
     * @returns {Array} Array of features or empty array
     */
    getFeaturesByCategory(categoryName) {
        const categories = this.getCategoryFeatures();
        if (!categories) return [];
        
        const category = categories.find(c => c.category_name === categoryName);
        return category?.features || [];
    }

    /**
     * Get a specific feature by route
     * @param {string} route - Route of the feature
     * @returns {Object|null} Feature object or null
     */
    getFeatureByRoute(route) {
        const categories = this.getCategoryFeatures();
        if (!categories) return null;
        
        for (const category of categories) {
            if (category.features) {
                const feature = category.features.find(f => f.route === route);
                if (feature) return feature;
            }
        }
        return null;
    }

    /**
     * Check if user has access to a feature
     * @param {string} featureId - Feature ID to check
     * @returns {boolean} True if user has access
     */
    hasFeatureAccess(featureId) {
        const categories = this.getCategoryFeatures();
        if (!categories) return false;
        
        for (const category of categories) {
            if (category.features) {
                const feature = category.features.find(f => f.feature_id === featureId);
                if (feature) return true;
            }
        }
        return false;
    }
}

// Create singleton instance
const appState = new AppState();

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = appState;
}