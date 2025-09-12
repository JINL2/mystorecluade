/**
 * Route Mapping Configuration
 * Maps navbar items to their corresponding routes from the features data
 */

const RouteMapping = {
    // Dashboard route
    'Dashboard': 'homepage',
    
    // Finance routes
    'Balance Sheet': 'balanceSheet',
    'Income Statement': 'incomeStatement',
    'Journal Input': 'journalInput',
    'Transaction History': 'transactionHistory',
    'Cash Ending': 'cashending',
    
    // Employee routes
    'Schedule': 'timetableManage',
    'Employee Setting': 'employeeSetting',
    'Salary': 'editEmployeeSalary',  // Based on feature name "Edit Employee Salary"
    
    // Product routes
    'Inventory': 'inventory',
    'Order': 'order',
    'Invoice': 'invoice',
    'Product Receive': 'productReceive',
    'Tracking': 'tracking',
    
    // Marketing routes
    'Marketing Plan': 'conetentsCreation',  // Note: keeping original spelling from features
    
    // Settings routes
    'Currency': 'cashLocation',
    'Company & Store Setting': 'storeShiftSetting',
    'Account Mapping': 'accountMapping',
    'Counterparty': 'registerCounterparty'
};

/**
 * Get the route for a given menu item
 * @param {string} menuItem - The menu item label
 * @returns {string} The corresponding route or empty string if not found
 */
function getRouteForMenuItem(menuItem) {
    return RouteMapping[menuItem] || '';
}

/**
 * Build the page URL for a given route
 * @param {string} route - The route name
 * @param {string} basePath - The base path for pages (auto-detected if not provided)
 * @returns {string} The full page URL
 */
function buildPageUrl(route, basePath = null) {
    // Auto-detect base path if not provided
    if (!basePath) {
        if (typeof window !== 'undefined' && window.pathResolver) {
            basePath = window.pathResolver.resolvePagePath('').replace(/\/$/, '') + '/';
        } else {
            // Fallback for server-side or when pathResolver not available
            basePath = '/pages/';
        }
    }
    
    // Map routes to actual page paths
    const routeToPath = {
        // Dashboard
        'homepage': 'dashboard',
        'dashboard': 'dashboard',
        
        // Finance pages
        'balanceSheet': 'finance/balance-sheet',
        'incomeStatement': 'finance/income-statement',
        'journalInput': 'finance/journal-input',
        'transactionHistory': 'finance/transaction-history',
        'cashending': 'finance/cash-ending',
        
        // Employee pages
        'timetableManage': 'employee/schedule',
        'employeeSetting': 'employee/employee-setting',
        'editEmployeeSalary': 'employee/salary',
        
        // Product pages
        'inventory': 'product/inventory',
        'order': 'product/order',
        'invoice': 'product/invoice',
        'productReceive': 'product/product recieve',
        'tracking': 'product/tracking',
        
        // Marketing pages
        'conetentsCreation': 'marketing/marketing-plan',
        
        // Settings pages
        'cashLocation': 'settings/currency',
        'storeShiftSetting': 'settings/store-setting',
        'accountMapping': 'settings/account-mapping',
        'registerCounterparty': 'settings/counterparty',
        
        // Other pages
        'dashboard': 'dashboard'
    };
    
    const path = routeToPath[route];
    if (!path) return '#';
    
    return `${basePath}${path}/index.html`;
}

/**
 * Navigate to a feature page with app state data
 * @param {string} route - The route to navigate to
 * @param {Object} options - Navigation options
 */
function navigateToFeature(route, options = {}) {
    // Build the URL
    const url = buildPageUrl(route, options.basePath || '');
    
    if (url === '#') {
        console.warn(`Route not found: ${route}`);
        if (typeof showComingSoon === 'function') {
            showComingSoon(route);
        }
        return;
    }
    
    // Navigate to the page
    if (options.newTab) {
        window.open(url, '_blank');
    } else {
        window.location.href = url;
    }
}

/**
 * Get the relative path prefix based on current location
 * @returns {string} The relative path prefix
 */
function getRelativePathPrefix() {
    const currentPath = window.location.pathname;
    const depth = currentPath.split('/').filter(p => p && p !== 'index.html').length;
    
    // Determine the depth from website root
    let prefix = '';
    
    // If we're in pages/[category]/[page]/
    if (currentPath.includes('/pages/')) {
        const afterPages = currentPath.split('/pages/')[1];
        const segments = afterPages.split('/').filter(p => p && p !== 'index.html');
        
        if (segments.length >= 2) {
            // We're in a page subdirectory (e.g., finance/balance-sheet)
            prefix = '../../../pages/';
        } else if (segments.length === 1) {
            // We're in pages directory (e.g., dashboard)
            prefix = '../../pages/';
        }
    } else if (currentPath.includes('/website/')) {
        // We're at the website root
        prefix = 'pages/';
    }
    
    return prefix;
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        RouteMapping,
        getRouteForMenuItem,
        buildPageUrl,
        navigateToFeature,
        getRelativePathPrefix
    };
}